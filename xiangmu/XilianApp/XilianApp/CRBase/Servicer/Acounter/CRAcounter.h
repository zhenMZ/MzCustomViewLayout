//
//  CRAcounter.h
//  XilianApp
//
//  Created by Abyss on 2017/2/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRAcount;
NS_ASSUME_NONNULL_BEGIN

/** 钥匙串服务名称 */
static NSString* key_user_default = @"com.abyss.user.default";

/**
 CRNetEngine
 账户管理者
 
 储存在本地钥匙串中
 */
@interface CRAcounter : NSObject

/** 获取钥匙串服务名称 */
+ (NSString *)serviceName;

/** 列出所有账户的name,最新的在0 */
+ (NSArray *)acountList;

/** 取出一个Acount */
+ (nullable CRAcount *)acountNamed:(NSString *)name;

/** 删除一个Acount */
+ (void)delAcountNamed:(NSString *)name;

/** 添加一个Acount */
+ (void)addAcountNamed:(NSString *)name;
+ (void)addAcountNamed:(NSString *)name pwd:(NSString *)pwd;

@end

NS_ASSUME_NONNULL_END
