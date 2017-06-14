//
//  CRAcount.h
//  XilianApp
//
//  Created by Abyss on 2017/2/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 账户 储存在本地钥匙串中 */
@interface CRAcount : NSObject

/** 账户的唯一识别码 */
@property (strong, readonly) NSString* name;
/** 账户的密码 */
@property (strong, readonly) NSString* password;
/** 账户的信息 */
@property (strong) NSDictionary* _Nullable userDic;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
