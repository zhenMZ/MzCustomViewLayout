//
//  CRNetEngine.h
//  XilianApp
//
//  Created by Abyss on 2017/2/28.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#import "CRNetConfig.h"
#import "CRCacher.h"

NS_ASSUME_NONNULL_BEGIN

/** 网络服务缓存器的数据库 */
static NSString* _Nullable key_cacher_net = @"com.abyss.cacher.net";
/** 网络引擎的线程 */
static char* _Nullable key_netEngine_default = "com.abyss.netEngine.default";

/**
 CRNetEngine
 网络引擎
 
 关于请求
 自定义Request的子类 进行请求
 设置Filter 不同模块公共参数管理
 设置Accessory 不同模块回调管理
 
 关于缓存
 */
@class CRRequest;
@interface CRNetEngine : NSObject

/** AFNetwork的Manager */
@property (strong) AFHTTPSessionManager* manager;
/** 配置器 */
@property (strong) CRNetConfig* config;
/** 缓存器 */
@property (strong) CRCacher* cacher;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/** 默认网络引擎 */
+ (instancetype)defaultEngine;

- (void)sendRequest:(CRRequest* __nonnull)request;
- (void)cancelRequest:(CRRequest *)request;
- (void)clearRequests;

@end

NS_ASSUME_NONNULL_END
