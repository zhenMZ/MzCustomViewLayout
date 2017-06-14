//
//  CRCacher.h
//  XilianApp
//
//  Created by Abyss on 2017/2/18.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "CRMemoryCacher.h"
#import "CRDiskCacher.h"
#import "CRStorager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Cacher
 
 优势:
 1.key-value方式存取,性能卓越
 2.结合文件存储与sqlite数据库存储，编译最新的sqlite取代xcode自带性能更快
 
 用法:
 单表设计,用于存储一些简单数据
 
 */

/** 缓存器数据库名字 */
static NSString* key_cacher_default = @"com.abyss.cacher.default";

@interface CRCacher : NSObject

/** 缓存器名字 */
@property (copy, readonly) NSString *name;

@property (strong, readonly) CRDiskCacher *diskCacher;
@property (strong, readonly) CRMemoryCacher *memoryCacher;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/** 创建一个缓存器 */
- (instancetype)initWithName:(NSString *)name path:(NSString *)path NS_DESIGNATED_INITIALIZER;

/** 默认缓存器 */
+ (nullable instancetype)cacherDefault;

/** 创建一个缓存器 */
+ (nullable instancetype)cacherNamed:(NSString *)name;

/** 创建一个缓存器 */
+ (nullable instancetype)cacherNamed:(NSString *)name inPath:(NSString *)fullPath;

/** 是否包含(key)缓存 */
- (BOOL)containsObjectForKey:(NSString *)key;

/** 取出(key)缓存 */
- (nullable id<NSCoding>)objectForKey:(NSString *)key;

/** 存一个(key)缓存 */
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;

/** 清除(key)缓存 */
- (void)removeObjectForKey:(NSString *)key;

/** 清除所有缓存 */
- (void)removeAllObjectsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                                 endBlock:(nullable void(^)(BOOL error))end;
@end

NS_ASSUME_NONNULL_END
