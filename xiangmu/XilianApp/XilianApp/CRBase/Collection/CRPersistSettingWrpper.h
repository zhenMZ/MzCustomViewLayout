/**
 *  ===========CRPersistSettingWrpper==========
 *   CRPersistSettingWrpper
 *  ===========================================
 *
 *  Copyright@2015 RogerAbyss
 */


#import "CRMutableDictionaryWrapper.h"
#import "CRTimeWrapper.h"

@class CRPersister;
@interface CRPersistSettingWrpper : CRMutableDictionaryWrapper

/** 取得出Plist文件并封装 */
+ (instancetype)wrapperFromName:(NSString*)name;

/** 取得NSArray,如果没有或者过期取 @[] */
- (NSArray *)getArray_t:(NSString *)name;

/** 取得NSInteger,如果没有或者过期取 0 */
- (NSInteger)getInteger_t:(NSString *)name;

/** 取得NSString,如果没有或者过期取 @"" */
- (NSString *)getString_t:(NSString *)name;

/** 取得NSDictionary,如果没有或者过期取 @{} */
- (NSDictionary *)getDictionary_t:(NSString *)name;

/** 取得CRDictionaryWrapper,如果没有或者过期取 @{}.wrapper */
- (CRDictionaryWrapper *)getDictionaryWrapper_t:(NSString *)name;

/** 存一个值,默认无过期时间, 设置 CRPersister.timeout */
- (void)save:(CRPersister *)persister name:(NSString *)name;

- (void)remove;

@end

@interface CRPersister : CRDictionaryWrapper

/** 返回保存的对象 */
@property (nonatomic, strong, readonly) id object;

/** 判断过期与是否有值 */
@property (nonatomic, assign, readonly) BOOL isValidate;

/** 保存时间 */
@property (nonatomic, strong, readonly) CRTimeWrapper* date;

/** 保质期,0 不计算是否过期 */
@property (nonatomic, assign) NSTimeInterval timeout;

/** 保存的对象的key, 因为object 是id 类型, 取值非安全 */
@property (nonatomic, copy, readonly) NSString* key;

+ (CRPersister *)persisterForm:(id)objct;

@end
