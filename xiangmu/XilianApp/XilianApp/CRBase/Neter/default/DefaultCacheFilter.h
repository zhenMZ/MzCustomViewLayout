//
//  DefaultCacheFilter.h
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
 1.使用缓存,缓存时间自己配置
 2.传递版本号
 3.传递平台
 */
@interface DefaultCacheFilter : NSObject <CRNetFilter>

+ (instancetype)defaultFilter;


// 协议 =======

- (NSDictionary *)filter;

@end

NS_ASSUME_NONNULL_END
