//
//  CRNetConfig.h
//  XilianApp
//
//  Created by Abyss on 2017/2/28.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 CRNetConfig
 服务器配置器
 
 存放所有服务器配置
 */

@class CRRequest;
@class CRNetEngine;
@protocol CRNetHostRule;
@protocol CRNetSeverConfiguration;


@class AFSecurityPolicy;
@interface CRNetConfig : NSObject

/** 网路配置 */
@property (strong) NSURLSessionConfiguration* sessionConfiguration;
/** 安全策略 (如SSL) */
@property (strong) AFSecurityPolicy* __nullable securityPolicy;
/** 服务器配置列表 */
@property (strong) NSSet<NSObject<CRNetSeverConfiguration>*>* __nullable severs;
/** 服务器配置 */
@property (strong,readonly) NSObject<CRNetSeverConfiguration>* sever;
/** 自动切换服务器 切换的时候每次+1, 返回最初即是 0 */
@property (assign) NSUInteger shouldChangeHostAutomaticly;

/** 默认配置器 */
+ (instancetype)defaultConfig;

/** 切换配置 "DEBUG"/"RELEASE"/... */
- (void)swithSeverTo:(NSString *)severName;

@end

NS_ASSUME_NONNULL_END

///////////////////// 一些配置 /////////////////////
//////////////////////////////////////////////////

/** 是否使用CDN ---> true */
static NSString* __nullable key_netConfig_useCDN = @"__useCDN";
/** 是否使用缓存 ---> 1,2 半使用 短暂全使用 */
static NSString* __nullable key_netConfig_useCache = @"__useCache";
/** 缓存时间 ---> timestamp */
static NSString* __nullable key_netConfig_cacheTime = @"__cacheTime";
/** 短暂缓存时间 ---> timestamp */
static NSString* __nullable key_netConfig_cacheTimeEphemerally = @"__cacheTimeEphemerally";
/** 是否后台加载 ---> true */
static NSString* __nullable key_netConfig_backgroundMode = @"__backgroundMode";
/** 平台类型 ---> 平台类型字符串 */
static NSString* __nullable key_netConfig_platform = @"__platform";
/** 版本号 ---> 版本号 */
static NSString* __nullable key_netConfig_version = @"__version";
