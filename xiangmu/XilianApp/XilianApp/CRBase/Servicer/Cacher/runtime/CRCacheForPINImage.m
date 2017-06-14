//
//  CRCacheForPINImage.m
//  XilianApp
//
//  Created by Abyss on 2017/2/18.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRCacheForPINImage.h"

@implementation CRCacheForPINImage

+ (instancetype)cacherNamed:(NSString *)name
{
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:name];
    
    NSLog(@"\n\n 缓存器开启\n 位置:\n %@\n\n",path);
    
    return [[CRCacheForPINImage alloc] initWithName:name path:path];
}

- (nullable id)objectFromMemoryForKey:(NSString *)key
{
    return [self.memoryCacher objectForKey:key];
}

-(void)setObjectInMemory:(id)object forKey:(NSString *)key withCost:(NSUInteger)cost
{
    [self.memoryCacher setObject:object forKey:key];
}

- (void)removeObjectForKeyFromMemory:(NSString *)key
{
    [self.memoryCacher removeObjectForKey:key];
}

- (nullable id)objectFromDiskForKey:(NSString *)key
{
    return [self.diskCacher objectForKey:key];
}

-(void)objectFromDiskForKey:(NSString *)key completion:(PINRemoteImageCachingObjectBlock)completion
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (completion) {
            typeof(self) strongSelf = weakSelf;
            completion(strongSelf, key, [strongSelf.diskCacher objectForKey:key]);
        }
    });
}

- (void)setObjectOnDisk:(id)object forKey:(NSString *)key
{
    [self.diskCacher setObject:object forKey:key];
}

- (BOOL)objectExistsForKey:(NSString *)key
{
    return [self.diskCacher objectForKey:key] != nil;
}

//******************************************************************************************************
// Common methods, should apply to both in-memory and disk storage
//******************************************************************************************************
- (void)removeObjectForKey:(NSString *)key
{
    [self removeObjectForKey:key];
}
- (void)removeObjectForKey:(NSString *)key completion:(PINRemoteImageCachingObjectBlock)completion
{
    __weak typeof(self) weakSelf = self;
    id object = [self objectForKey:key];
    [self removeObjectForKey:key];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (completion) {
            typeof(self) strongSelf = weakSelf;
            completion(strongSelf, key, object);
        }
    });
}

- (void)removeAllObjects
{
    [self removeAllObjects];
}

@end
