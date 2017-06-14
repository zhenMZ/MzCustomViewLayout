//
//  CRCacher.m
//  XilianApp
//
//  Created by Abyss on 2017/2/18.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRCacher.h"
#import "CRMemoryCacher.h"
#import "CRDiskCacher.h"
#import "CRLogger.h"

@implementation CRCacher

- (instancetype) init
{
    return [self initWithName:@"" path:@""];
}

- (instancetype)initWithName:(NSString *)name
{
    if (name.length == 0) return nil;
    
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:name];
    
    return [self initWithName:name path:path];
}

- (instancetype)initWithName:(NSString *)name path:(NSString *)path
{
    self = [super init];
    
    if (self)
    {
        if (name.length == 0) return nil;
        if (path.length == 0) return nil;
        
        CRDiskCacher *diskCacher = [CRDiskCacher diskCacherInPath:path];
        if (!diskCacher) return nil;
        
        CRMemoryCacher *memoryCacher = [[CRMemoryCacher alloc] init];
        memoryCacher.name = name;
        
        _name = name;
        _diskCacher = diskCacher;
        _memoryCacher = memoryCacher;
        
        NSLog(@"%@",[self welcomeWithDic:@{@"位置":path}]);
    }
    return self;
}

+ (nullable instancetype)cacherDefault
{
    static CRCacher* cacher;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cacher = [CRCacher cacherNamed:key_cacher_default];
    });
    
    return cacher;
}

+ (instancetype)cacherNamed:(NSString *)name
{
    return [[self alloc] initWithName:name];
}

+ (instancetype)cacherNamed:(NSString *)name inPath:(NSString *)fullPath
{
    return [[self alloc] initWithName:name path:fullPath];
}


- (BOOL)containsObjectForKey:(NSString *)key
{
    return [_memoryCacher containsObjectForKey:key] || [_diskCacher containsObjectForKey:key];
}

- (id<NSCoding>)objectForKey:(NSString *)key
{
    id<NSCoding> object = [_memoryCacher objectForKey:key];
    if (!object) {
        object = [_diskCacher objectForKey:key];
        if (object) {
            [_memoryCacher setObject:object forKey:key];
        }
    }
    return object;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    [_memoryCacher setObject:object forKey:key];
    [_diskCacher setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    [_memoryCacher removeObjectForKey:key];
    [_diskCacher removeObjectForKey:key];
}

- (void)removeAllObjectsWithProgressBlock:(void(^)(int removedCount, int totalCount))progress
                                 endBlock:(void(^)(BOOL error))end
{
    [_memoryCacher removeAllObjects];
    [_diskCacher removeAllObjectsWithProgressBlock:progress endBlock:end];
}

- (NSString *)description
{
    return [self descriptionWithDes:[NSString stringWithFormat:@"<%@: %p> (%@)", self.class, self, _name?:@""]];
}

@end
