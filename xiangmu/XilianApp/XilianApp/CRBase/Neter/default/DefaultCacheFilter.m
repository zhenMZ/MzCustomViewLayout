//
//  DefaultCacheFilter.m
//  XilianApp
//
//  Created by Abyss on 2017/3/2.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "DefaultCacheFilter.h"
#import "CRNetConfig.h"
#import "CRManager.h"

@implementation DefaultCacheFilter

+ (instancetype)defaultFilter
{
    return [[self alloc] init];
}

- (NSDictionary *)filter
{
    return @{key_netConfig_useCache:@"2",
             key_netConfig_cacheTime:[CRNetConfig defaultConfig].sever.cache,
             key_netConfig_cacheTimeEphemerally:[CRNetConfig defaultConfig].sever.cacheEphemerally};
}

@end
