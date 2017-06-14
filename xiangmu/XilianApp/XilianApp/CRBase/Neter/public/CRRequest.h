//
//  CRRequest.h
//  XilianApp
//
//  Created by Abyss on 2017/2/28.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRNetConfig.h"
#import "CRNetDefine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 CRRequest
 
 网络请求 (父类)
 
 请继承,重载一些方法使用
 */
@class CRNetCache;
@interface CRRequest : NSObject

/** url */
@property (strong) NSString* url;
/** params */
@property (strong) NSDictionary* __nullable params;
/** response */
@property (strong) id __nullable data;
/** Error */
@property (strong) NSError* __nullable error;
/** 缓存 */
@property (strong, readonly) CRNetCache* __nullable cache;
/** 过滤条件 */
@property (strong) NSSet<NSObject<CRNetFilter> *>* __nullable filters;
/** 附加逻辑 */
@property (strong) NSSet<NSObject<CRRequestAccessory> *>* __nullable accessories;
/** 标示符 */
@property (strong, readonly) NSString* __nullable identifier;
/** 请求类型 */
@property (assign) CRRequestMethod requestMethod;
/** 请求任务 */
@property (strong) NSURLSessionTask* requestTask;
/** 额外信息 */
@property (strong) NSDictionary* __nullable userInfo;
/** 是否使用缓存 */
@property (assign, readonly) int useCache;
/** 回调:成功 */
@property (copy) CRRequestSuccess __nullable success;
/** 回调:失败 */
@property (copy) CRRequestFailure __nullable failure;
/** Formdata */
@property (copy) AFConstructingBlock __nullable constructingBodyBlock;

- (void)start;

- (void)stop;

- (void)startCallSuccess:(CRRequestSuccess)success
                 failure:(CRRequestFailure)failure;

/** Override */
- (BOOL)isSuccess;
/** Override */
- (NSDictionary *)publicHeader;
/** Override */
- (NSDictionary *)publicParam;

@end

NS_ASSUME_NONNULL_END
