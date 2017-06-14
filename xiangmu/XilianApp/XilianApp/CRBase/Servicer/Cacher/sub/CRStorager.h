//
//  CRStorager.h
//  XilianApp
//
//  Created by Abyss on 2017/2/18.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 存储的对象 */
@interface CRStoragerItem : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSData *value;
@property (nullable, nonatomic, strong) NSString *filename;
@property (nonatomic) int size;
@property (nonatomic) int modTime;
@property (nonatomic) int accessTime;
@property (nullable, nonatomic, strong) NSData *extendedData;
@end

typedef NS_ENUM(NSUInteger, CRStoragerType)
{
    CRStoragerTypeFile = 0,
    CRStoragerTypeSQLite = 1,
    CRStoragerTypeMixed = 2,
};

/** 储存器 */
@interface CRStorager : NSObject

#pragma mark - Attribute

/** 储存器路径 */
@property (nonatomic, readonly) NSString *path;
/** 储存类型 */
@property (nonatomic, readonly) CRStoragerType type;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/** 创建一个储存器 */
- (nullable instancetype)initWithPath:(NSString *)path type:(CRStoragerType)type NS_DESIGNATED_INITIALIZER;

/** 创建一个储存器 */
+ (nullable instancetype)storagerInPath:(NSString *)path type:(CRStoragerType)type;

/** 储存器里添加/更新一个对象 */
- (BOOL)saveItem:(CRStoragerItem *)item;

/** 储存器里添加/更新一个数据 */
- (BOOL)saveItemWithKey:(NSString *)key value:(NSData *)value;

/** 储存器里添加/更新一个数据 */
- (BOOL)saveItemWithKey:(NSString *)key
                  value:(NSData *)value
               filename:(nullable NSString *)filename
           extendedData:(nullable NSData *)extendedData;

/** 从储存器里移除一个数据 */
- (BOOL)removeItemForKey:(NSString *)key;

/** 从储存器里移除一系列数据 */
- (BOOL)removeItemForKeys:(NSArray<NSString *> *)keys;

/** 从储存器里移除数据限制大小 */
- (BOOL)removeItemsLargerThanSize:(int)size;

/** 从储存器里移除数据限制时间 */
- (BOOL)removeItemsEarlierThanTime:(int)time;

/** 从储存器里移除数据限制大小,优先删除使用最少的 */
- (BOOL)removeItemsToFitSize:(int)maxSize;

/** 从储存器里移除数据限制数量,优先删除使用最少的 */
- (BOOL)removeItemsToFitCount:(int)maxCount;

/** 从储存器里移除所有数据 */
- (void)removeAllItemsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                               endBlock:(nullable void(^)(BOOL error))end;


/** 从储存器里取一个数据 */
- (nullable NSData *)getItemValueForKey:(NSString *)key;

/** 从储存器里取一组数据 */
- (nullable NSDictionary<NSString *, NSData *> *)getItemValueForKeys:(NSArray<NSString *> *)keys;

/** 从储存器里取一个对象 */
- (nullable CRStoragerItem *)getItemForKey:(NSString *)key;

/** 从储存器里取一个对象的详情(不包括对象本身) */
- (nullable CRStoragerItem *)getItemInfoForKey:(NSString *)key;

/** 从储存器里取一组对象 */
- (nullable NSArray<CRStoragerItem *> *)getItemForKeys:(NSArray<NSString *> *)keys;

/** 从储存器里取一组对象的详情(不包括对象本身) */
- (nullable NSArray<CRStoragerItem *> *)getItemInfoForKeys:(NSArray<NSString *> *)keys;

/** 储存器中是否存在(key)数据/对象 */
- (BOOL)itemExistsForKey:(NSString *)key;

/** 获取储存器储存数量 */
- (int)getItemsCount;

/** 获取储存器储存大小 */
- (int)getItemsSize;

@end

NS_ASSUME_NONNULL_END
