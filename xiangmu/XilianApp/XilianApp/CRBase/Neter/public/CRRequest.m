//
//  CRRequest.m
//  XilianApp
//
//  Created by Abyss on 2017/2/28.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRRequest.h"
#import "CRNetEngine.h"
#import "CRNetCache.h"

#import "CRManager.h"
#import "CRLogger.h"

@interface CRRequest ()
{
    id _data;
    CRNetCache* _cache;
}
@end
@implementation CRRequest

- (CRNetCache *)cache
{
    if (_cache) return _cache;
    if (!self.identifier) return nil;
    
    CRNetCache<NSCoding>* __nullable cache = (CRNetCache<NSCoding>*)[[CRNetEngine defaultEngine].cacher objectForKey:self.identifier];
    
    if (!cache || !self.useCache || self.useCache < 1) return nil;
    if (![cache.version isEqualToString:[CRManager appVersion]]) return nil;
    if (cache.date.timeIntervalSince1970 <= [NSDate date].timeIntervalSince1970) return nil;
    
    return cache;
}

- (int)useCache
{
    if (!self.params) return 0;
    
    BOOL exist = self.params[key_netConfig_useCache];
    
    return exist?[self.params[key_netConfig_useCache] intValue]:0;
}

- (NSString *)identifier
{
    NSURL* temp = [NSURL URLWithString:self.url];
    
    if (temp && temp.host && temp.scheme)
    {
        return self.url;
    }

    return nil;
}

- (BOOL)isSuccess
{
    return YES;
}

- (id)data
{
    return _data?:(self.cache?self.cache.responseData:@"");
}

- (void)setData:(id)data
{
    _data = data;
}

- (void)start
{
    [[CRNetEngine defaultEngine] sendRequest:self];
}

- (void)stop
{
    [[CRNetEngine defaultEngine] cancelRequest:self];
}

- (void)startCallSuccess:(CRRequestSuccess)success
                 failure:(CRRequestFailure)failure
{
    self.success = success;
    self.failure = failure;
    
    [self start];
}

- (NSDictionary *)publicParam {return nil;}
- (NSDictionary *)publicHeader {return nil;}

- (NSString *)description
{
    return [self descriptionWithDic:@{ @"Success":self.isSuccess?@"YES":@"NO",
                                       @"Identifier":self.identifier?:@"",
                                       @"Method":@(self.requestMethod),
                                       @"Params":self.params?:@"",
                                       @"Filters":self.filters?:@"",
                                       @"Accessories":self.accessories?:@"",
                                       @"UserInfo":self.userInfo?:@"",
                                       @"Error":self.error?:@"",
                                       @"Data":self.data?:@"",
                                       @"Header":self.requestTask.response?:@""}];
}


@end
