//
//  DefaultAccessory.h
//  XilianApp
//
//  Created by Abyss on 2017/3/2.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRNetDefine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 DefaultCacheFilter
 默认的过滤器
 
 功能:
 1.输出request
 */
@interface DefaultAccessory : NSObject <CRRequestAccessory>

+ (instancetype)defaultAccessory;

// 协议 =======

- (void)requestWillStart:(CRRequest *)request;
- (void)requestDidStop:(CRRequest *)request;

@end

NS_ASSUME_NONNULL_END
