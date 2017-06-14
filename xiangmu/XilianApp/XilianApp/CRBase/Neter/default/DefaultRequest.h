//
//  DefaultRequest.h
//  XilianApp
//
//  Created by Abyss on 2017/3/2.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 DefaultRequest
 默认的请求发起者
 
 通过DefualtRequest发起简单的请求
 
 默认:
 Filter     :   DefaultCacheFilter
 Accessory  :   DefaultAccessory   
 isSuccess  :   总是成功
 */
@interface DefaultRequest : CRRequest


+ (DefaultRequest *)requestApi:(NSString *)api;
+ (DefaultRequest *)requestApi:(NSString *)api success:(__nullable CRRequestSuccess)success;
+ (DefaultRequest *)requestApi:(NSString *)api params:(__nullable id)params success:(__nullable CRRequestSuccess)success;
+ (DefaultRequest *)requestBy:(CRRequestMethod)method api:(NSString *)api params:(__nullable id)params success:(CRRequestSuccess)success;

@end

NS_ASSUME_NONNULL_END
