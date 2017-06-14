//
//  DefaultRequest.m
//  XilianApp
//
//  Created by Abyss on 2017/3/2.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "DefaultRequest.h"
#import "DefaultCacheFilter.h"
#import "DefaultAccessory.h"

@implementation DefaultRequest

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.filters = [NSSet setWithObject:[DefaultCacheFilter defaultFilter]];
        self.accessories = [NSSet setWithObject:[DefaultAccessory defaultAccessory]];
    }
    
    return self;
}

- (BOOL)isSuccess
{
    return YES;
}

- (NSDictionary *)publicHeader
{
    return @{@"Client":@"Test"};
}

- (NSDictionary *)publicParam
{
    return @{@"param":@"test"};
}

+ (DefaultRequest *)requestApi:(NSString *)api
{
    return [DefaultRequest requestApi:api success:NULL];
}

+ (DefaultRequest *)requestApi:(NSString *)api success:(CRRequestSuccess)success
{
    return [DefaultRequest requestApi:api params:nil success:success];
}

+ (DefaultRequest *)requestApi:(NSString *)api params:(id)params success:(CRRequestSuccess)success
{
    return [DefaultRequest requestBy:CRRequestMethodPOST api:api params:params success:success];
}

+ (DefaultRequest *)requestBy:(CRRequestMethod)method api:(NSString *)api params:(__nullable id)params success:(CRRequestSuccess)success
{
    DefaultRequest* request = [[DefaultRequest alloc] init];
    
    request.url = api;
    request.params = params;
    request.requestMethod = method;
    request.success = success;
    
    [request start];
    
    return request;
}

@end
