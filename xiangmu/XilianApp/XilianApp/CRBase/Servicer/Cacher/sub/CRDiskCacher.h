//
//  CRDiskCacher.h
//  XilianApp
//
//  Created by Abyss on 2017/2/18.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef DEBUG
    #define DEBUG 1
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CRDiskCacher : NSObject

#pragma mark - Properties

/** 缓存器名字 */
@property (nullable, copy) NSString *name;

/** 缓存器路径 */
@property (readonly) NSString *path;

/**
 如果:
 缓存文件的大小 > inlineThreshold    --> 保存文件
 缓存文件的大小 < inlineThreshold    --> 保存数据库
 默认大小: 20480 (20KB).
 */
@property (readonly) NSUInteger inlineThreshold;

/**
 自定义打包
 传统打包自定义类必须支持NSCoding协议
 默认: nil
 */
@property (nullable, copy) NSData *(^customArchiveBlock)(id object);

/**
 自定义解包
 传统解包自定义类必须支持NSCoding协议
 默认: nil
 */
@property (nullable, copy) id (^customUnarchiveBlock)(NSData *data);

/**
 打包名生成
 默认: md5
 */
@property (nullable, copy) NSString *(^customFileNameBlock)(NSString *key);


/**
 缓存最大数量
 默认: MAX
 */
@property NSUInteger countLimit;

/**
 缓存最大大小
 默认: MAX
 */
@property NSUInteger costLimit;

/**
 缓存最大时间
 默认: MAX
 */
@property NSTimeInterval ageLimit;

/**
 最小空闲空间
 默认: 0
 */
@property NSUInteger freeDiskSpaceLimit;

/**
 最大处理时间
 默认: 60
 */
@property NSTimeInterval autoTrimInterval;


#pragma mark - Method

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithPath:(NSString *)path;
- (nullable instancetype)initWithPath:(NSString *)path
                      inlineThreshold:(NSUInteger)threshold NS_DESIGNATED_INITIALIZER;

/** 创建一个Disk缓存器,无法重构,全局共享一个磁盘存储 */
+ (nullable instancetype)diskCacherInPath:(NSString *)path;

/** 创建一个Disk缓存器,无法重构,全局共享一个磁盘存储 */
+ (nullable instancetype)diskCacherInPath:(NSString *)path inlineThreshold:(NSUInteger)threshold;

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


/** 缓存文件数量 */
- (NSInteger)totalCount;

/** 缓存文件大小 */
- (NSInteger)totalCost;

/** 释放缓存限制文件数量 */
- (void)trimToCount:(NSUInteger)count;

/** 释放缓存限制缓存大小 */
- (void)trimToCost:(NSUInteger)cost;

/** 释放缓存限制缓存保存时间 */
- (void)trimToAge:(NSTimeInterval)age;

/** 取出对象的额外信息 */
+ (nullable NSData *)getExtendedDataFromObject:(id)object;

/** 为对象添加额外信息 */
+ (void)setExtendedData:(nullable NSData *)extendedData toObject:(id)object;

@end

NS_ASSUME_NONNULL_END
