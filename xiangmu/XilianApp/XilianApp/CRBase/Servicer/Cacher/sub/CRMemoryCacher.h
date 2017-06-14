//
//  CRMemoryCacher.h
//  XilianApp
//
//  Created by Abyss on 2017/2/18.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface CRMemoryCacher : NSObject

/** 缓存器名字 */
@property (nullable, copy) NSString *name;

/** 缓存文件数量 */
@property (readonly) NSUInteger totalCount;

/** 缓存文件大小 */
@property (readonly) NSUInteger totalCost;


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
 最大处理时间
 默认: 60
 */
@property NSTimeInterval autoTrimInterval;



/**
 如果设定为YES
 当收到内存警告将会删除缓存
 默认:YES
 */
@property BOOL shouldRemoveAllObjectsOnMemoryWarning;

/**
 如果设定为YES
 程序进入后台将会删除缓存
 默认:YES
 */
@property BOOL shouldRemoveAllObjectsWhenEnteringBackground;


@property (nullable, copy) void(^didReceiveMemoryWarningBlock)(CRMemoryCacher *cache);
@property (nullable, copy) void(^didEnterBackgroundBlock)(CRMemoryCacher *cache);

/**
 如果设定为YES
 缓存释放将会在主进程的进行
 默认:NO
 */
@property BOOL releaseOnMainThread;

/**
 如果设定为YES
 缓存释放将会异步进行
 默认:YES
 */
@property BOOL releaseAsynchronously;


#pragma mark - Method

/** 是否包含(key)缓存 */
- (BOOL)containsObjectForKey:(NSString *)key;

/** 取出(key)缓存 */
- (nullable id<NSCoding>)objectForKey:(NSString *)key;

/** 存一个(key)缓存 */
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;

/** 清除(key)缓存 */
- (void)removeObjectForKey:(NSString *)key;

/** 清除所有缓存 */
- (void)removeAllObjects;


/** 释放缓存限制文件数量 */
- (void)trimToCount:(NSUInteger)count;

/** 释放缓存限制缓存大小 */
- (void)trimToCost:(NSUInteger)cost;

/** 释放缓存限制缓存保存时间 */
- (void)trimToAge:(NSTimeInterval)age;

@end

NS_ASSUME_NONNULL_END
