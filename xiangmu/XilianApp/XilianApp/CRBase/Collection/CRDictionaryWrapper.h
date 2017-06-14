/**
 *  ============CRDictionaryWrapper============
 *  Safely Useages of NSDictionary
 *  ===========================================
 *
 *  # NSArray,NSString,NSDictionary,CRDictionaryWrapper never is nil
 *  # Automatic convertion of data 
 *
 *  Copyright@2015 RogerAbyss
 */

#import <Foundation/Foundation.h>

@interface CRDictionaryWrapper : NSObject <NSCoding>

@property (strong, nonatomic) NSDictionary* dictionary;

/** 取得NSArray,如果没有取 @[] */
- (NSArray *)getArray:(NSString *)name;

/** 取得NSInteger,如果没有取 0 */
- (NSInteger)getInteger:(NSString *)name;

/** 取得NSString,如果没有取 @“” */
- (NSString *)getString:(NSString *)name;

/** 取得NSDictionary,如果没有取 @{} */
- (NSDictionary *)getDictionary:(NSString *)name;

/** 取得CRDictionaryWrapper,如果没有取 @{}.wrapper */
- (CRDictionaryWrapper *)getDictionaryWrapper:(NSString *)name;

/** 取得int,如果没有取 (int)0 */
- (int)getInt:(NSString *)name;

/** 取得long,如果没有取 (long)0 */
- (long)getLong:(NSString *)name;

/** 取得BOOL,如果没有取 (BOOL)NO */
- (BOOL)getBool:(NSString *)name;

/** 取得float,如果没有取 (float)0.00 */
- (float)getFloat:(NSString *)name;

/** 取得double,如果没有取 (double)0.000000 */
- (double)getDouble:(NSString *)name;

/** 初始化CRDictionaryWrapper */
- (instancetype)initWith:(NSDictionary *)dictionary;

/** 初始化CRDictionaryWrapper */
+ (instancetype)wrapperFromDictionary:(NSDictionary *)dictionary;

/** 取得id,如果没有取 nil,不安全的方法不建议使用 */
- (id)get:(NSString *)name;

@end

@interface NSDictionary (Wrapper)

- (CRDictionaryWrapper *)wrapper;

@end
