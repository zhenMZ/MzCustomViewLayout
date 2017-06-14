//
//  CRDiskCacher.m
//  XilianApp
//
//  Created by Abyss on 2017/2/18.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRDiskCacher.h"
#import "CRStorager.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>
#import <time.h>

#import "CRDefines.h"

static const int extended_data_key;

/// Free disk space in bytes.
static int64_t _CRDiskSpaceFree()
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

/// String's md5 hash.
static NSString *_md5ForCRDiskCacher(NSString *string)
{
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/// weak reference for all instances
static NSMapTable *_globalInstances;
static dispatch_semaphore_t _globalInstancesLock;
static NSUInteger _inlineThreshold = 1024 * 20;

static void _CRDiskCacherInitGlobal() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _globalInstancesLock = dispatch_semaphore_create(1);
        _globalInstances = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
    });
}

static CRDiskCacher *_CRDiskCacherGetGlobal(NSString *path)
{
    if (path.length == 0) return nil;
    
    _CRDiskCacherInitGlobal();
    dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER);
    id cache = [_globalInstances objectForKey:path];
    dispatch_semaphore_signal(_globalInstancesLock);
    return cache;
}

static void _CRDiskCacherSetGlobal(CRDiskCacher *cache)
{
    if (cache.path.length == 0) return;
    _CRDiskCacherInitGlobal();
    dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER);
    [_globalInstances setObject:cache forKey:cache.path];
    dispatch_semaphore_signal(_globalInstancesLock);
}



@implementation CRDiskCacher
{
    CRStorager *_storager;
    dispatch_semaphore_t _lock;
    dispatch_queue_t _queue;
}

- (void)_trimRecursively
{
    __weak typeof(self) _self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_autoTrimInterval * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __strong typeof(_self) self = _self;
        if (!self) return;
        [self _trimInBackground];
        [self _trimRecursively];
    });
}

- (void)_trimInBackground
{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        if (!self) return;
        Lock();
        [self _trimToCost:self.costLimit];
        [self _trimToCount:self.countLimit];
        [self _trimToAge:self.ageLimit];
        [self _trimToFreeDiskSpace:self.freeDiskSpaceLimit];
        Unlock();
    });
}

- (void)_trimToCost:(NSUInteger)costLimit
{
    if (costLimit >= INT_MAX) return;
    [_storager removeItemsToFitSize:(int)costLimit];
    
}

- (void)_trimToCount:(NSUInteger)countLimit
{
    if (countLimit >= INT_MAX) return;
    [_storager removeItemsToFitCount:(int)countLimit];
}

- (void)_trimToAge:(NSTimeInterval)ageLimit
{
    if (ageLimit <= 0)
    {
        [_storager removeAllItemsWithProgressBlock:NULL endBlock:NULL];
        return;
    }
    
    long timestamp = time(NULL);
    if (timestamp <= ageLimit) return;
    long age = timestamp - ageLimit;
    if (age >= INT_MAX) return;
    [_storager removeItemsEarlierThanTime:(int)age];
}

- (void)_trimToFreeDiskSpace:(NSUInteger)targetFreeDiskSpace
{
    if (targetFreeDiskSpace == 0) return;
    int64_t totalBytes = [_storager getItemsSize];
    if (totalBytes <= 0) return;
    int64_t diskFreeBytes = _CRDiskSpaceFree();
    if (diskFreeBytes < 0) return;
    int64_t needTrimBytes = targetFreeDiskSpace - diskFreeBytes;
    if (needTrimBytes <= 0) return;
    int64_t costLimit = totalBytes - needTrimBytes;
    if (costLimit < 0) costLimit = 0;
    [self _trimToCost:(int)costLimit];
}

- (NSString *)_filenameForKey:(NSString *)key
{
    NSString *filename = nil;
    if (_customFileNameBlock) filename = _customFileNameBlock(key);
    if (!filename) filename = _md5ForCRDiskCacher(key);
    return filename;
}

- (void)_appWillBeTerminated
{
    Lock();
    _storager = nil;
    Unlock();
}

#pragma mark - public

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

- (instancetype)init
{
    return [self initWithPath:@"" inlineThreshold:_inlineThreshold];
}

- (nullable instancetype)initWithPath:(NSString *)path
{
    return [self initWithPath:path inlineThreshold:_inlineThreshold];
}

- (nullable instancetype)initWithPath:(NSString *)path
                      inlineThreshold:(NSUInteger)threshold
{
    self = [super init];
    if (!self) return nil;
    
    CRDiskCacher *globalCache = _CRDiskCacherGetGlobal(path);
    if (globalCache) return globalCache;
    
    CRStoragerType type;
    
    if (threshold == 0)
    {
        type = CRStoragerTypeFile;
    }
    else if (threshold == NSUIntegerMax)
    {
        type = CRStoragerTypeSQLite;
    }
    else
    {
        type = CRStoragerTypeMixed;
    }
    
    CRStorager *storager = [CRStorager storagerInPath:path type:type];
    if (!storager) return nil;
    
    _storager = storager;
    _path = path;
    _lock = dispatch_semaphore_create(1);
    _queue = dispatch_queue_create("Com.RogerAbyss.Cache.Disk", DISPATCH_QUEUE_CONCURRENT);
    _inlineThreshold = threshold;
    _countLimit = NSUIntegerMax;
    _costLimit = NSUIntegerMax;
    _ageLimit = DBL_MAX;
    _freeDiskSpaceLimit = 0;
    _autoTrimInterval = 60;
    
    [self _trimRecursively];
    _CRDiskCacherSetGlobal(self);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appWillBeTerminated) name:UIApplicationWillTerminateNotification object:nil];
    
    return self;
}

/** 创建一个Disk缓存器 */
+ (nullable instancetype)diskCacherInPath:(NSString *)path
{
    return [CRDiskCacher diskCacherInPath:path inlineThreshold:_inlineThreshold];
}

/** 创建一个Disk缓存器 */
+ (nullable instancetype)diskCacherInPath:(NSString *)path inlineThreshold:(NSUInteger)threshold
{
    return [[self alloc] initWithPath:path inlineThreshold:threshold];
}

- (BOOL)containsObjectForKey:(NSString *)key {
    if (!key) return NO;
    Lock();
    BOOL contains = [_storager itemExistsForKey:key];
    Unlock();
    return contains;
}

- (id<NSCoding>)objectForKey:(NSString *)key
{
    if (!key) return nil;
    Lock();
    CRStoragerItem *item = [_storager getItemForKey:key];
    Unlock();
    
    if (!item.value) return nil;
    
    id object = nil;
    if (_customUnarchiveBlock)
    {
        object = _customUnarchiveBlock(item.value);
    }
    else
    {
        @try
        {
            object = [NSKeyedUnarchiver unarchiveObjectWithData:item.value];
        }
        @catch (NSException *exception) {
            // nothing to do...
        }
    }
    
    if (object && item.extendedData)
    {
        [CRDiskCacher setExtendedData:item.extendedData toObject:object];
    }
    
    return object;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    if (!key) return;
    
    if (!object)
    {
        [self removeObjectForKey:key];
        return;
    }
    
    NSData *extendedData = [CRDiskCacher getExtendedDataFromObject:object];
    NSData *value = nil;
    if (_customArchiveBlock)
    {
        value = _customArchiveBlock(object);
    }
    else
    {
        @try
        {
            value = [NSKeyedArchiver archivedDataWithRootObject:object];
        }
        @catch (NSException *exception) {
            // nothing to do...
        }
    }
    
    if (!value) return;
    NSString *filename = nil;
    if (_storager.type != CRStoragerTypeSQLite)
    {
        if (value.length > _inlineThreshold)
        {
            filename = [self _filenameForKey:key];
        }
    }
    
    Lock();
    [_storager saveItemWithKey:key value:value filename:filename extendedData:extendedData];
    Unlock();
}

- (void)removeObjectForKey:(NSString *)key
{
    if (!key) return;
    Lock();
    [_storager removeItemForKey:key];
    Unlock();
}

- (void)removeAllObjectsWithProgressBlock:(void(^)(int removedCount, int totalCount))progress
                                 endBlock:(void(^)(BOOL error))end
{
    __weak typeof(self) _self = self;
    dispatch_async(_queue, ^{
        __strong typeof(_self) self = _self;
        if (!self) {
            if (end) end(YES);
            return;
        }
        Lock();
        [_storager removeAllItemsWithProgressBlock:progress endBlock:end];
        Unlock();
    });
}

- (NSInteger)totalCount
{
    Lock();
    int count = [_storager getItemsCount];
    Unlock();
    return count;
}

- (NSInteger)totalCost
{
    Lock();
    int count = [_storager getItemsSize];
    Unlock();
    return count;
}


- (void)trimToCount:(NSUInteger)count {
    Lock();
    [self _trimToCount:count];
    Unlock();
}


- (void)trimToCost:(NSUInteger)cost {
    Lock();
    [self _trimToCost:cost];
    Unlock();
}

- (void)trimToAge:(NSTimeInterval)age {
    Lock();
    [self _trimToAge:age];
    Unlock();
}

+ (NSData *)getExtendedDataFromObject:(id)object
{
    if (!object) return nil;
    return (NSData *)objc_getAssociatedObject(object, &extended_data_key);
}

+ (void)setExtendedData:(NSData *)extendedData toObject:(id)object
{
    if (!object) return;
    objc_setAssociatedObject(object, &extended_data_key, extendedData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)description
{
    if (_name) return [NSString stringWithFormat:@"<%@: %p> (%@:%@)", self.class, self, _name, _path];
    else return [NSString stringWithFormat:@"<%@: %p> (%@)", self.class, self, _path];
}

@end
