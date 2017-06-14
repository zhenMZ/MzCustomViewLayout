//
//  CRNetEngine+Private.m
//  XilianApp
//
//  Created by Abyss on 2017/3/1.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRNetEngine+Private.h"
#import "CRRequest.h"
#import "CRLogger.h"

@interface CRNetEngine ()
- (void)handleRequestResult:(NSURLSessionTask *)task
             responseObject:(id)responseObject
                      error:(NSError *)error;
@end
@implementation CRNetEngine (Private)

- (NSURLSessionTask *)sessionTaskForRequest:(CRRequest *)request error:(NSError * _Nullable __autoreleasing *)error
{
    NSString* url = request.url;
    id param = request.params;
    AFConstructingBlock constructingBlock = request.constructingBodyBlock;
    
    switch (request.requestMethod)
    {
        case CRRequestMethodGET:
            return [self dataTaskWithHTTPMethod:@"GET" URLString:url parameters:param error:error];
        case CRRequestMethodPOST:
            return [self dataTaskWithHTTPMethod:@"POST" URLString:url parameters:param constructingBodyWithBlock:constructingBlock error:error];
        case CRRequestMethodHEAD:
            return [self dataTaskWithHTTPMethod:@"HEAD" URLString:url parameters:param error:error];
        case CRRequestMethodPUT:
            return [self dataTaskWithHTTPMethod:@"PUT" URLString:url parameters:param error:error];
        case CRRequestMethodDELETE:
            return [self dataTaskWithHTTPMethod:@"DELETE" URLString:url parameters:param error:error];
        case CRRequestMethodPATCH:
            return [self dataTaskWithHTTPMethod:@"PATCH" URLString:url parameters:param error:error];
    }
}

- (NSURLSessionDownloadTask *)downloadTaskWithDownloadPath:(NSString *)downloadPath
                                                 URLString:(NSString *)URLString
                                                parameters:(id)parameters
                                                  progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                                     error:(NSError * _Nullable __autoreleasing *)error
{
    return nil;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                           error:(NSError * _Nullable __autoreleasing *)error
{
    return [self dataTaskWithHTTPMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:nil error:error];
}


- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                           error:(NSError * _Nullable __autoreleasing *)error
{
    NSMutableURLRequest *request = nil;
    
    if (block)
    {
        request = [self.manager.requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    }
    else
    {
        request = [self.manager.requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    
    __block NSURLSessionDataTask* dataTask = nil;
    dataTask = [self.manager dataTaskWithRequest:request
                           completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *_error)
                {
                    [self handleRequestResult:dataTask responseObject:responseObject error:_error];
                }];
    
    return dataTask;
}

- (NSString *)evaluateUrlFor:(CRRequest *)request useCDN:(BOOL)useCDN
{
    if (!request.url)
    {
        DDLogDebug(@"该请求没有传入url");
        return @"";
    }
    
    NSURL* url_temp = [NSURL URLWithString:request.url];
    
    // 直接用url
    if (url_temp.host && url_temp.scheme)
    {
        return request.url;
    }
    
    // HOST
    NSString* host = @"";
    
    if (useCDN)
    {
        // 使用CDN
        DDLogDebug(@"未完善");
    }
    else
    {
        // 不使用CDN
        host = [self evaluateHostIn:self.config.sever];
    }
    
    return [host stringByAppendingString:request.url];
}

- (NSString *)evaluateHostIn:(NSObject<CRNetSeverConfiguration> *)sever
{
    if (!sever)
    {
        DDLogDebug(@"请调用[CRNetConfig]swithSeverTo:并且设置severs");
        return @"";
    }
    
    if(!sever.hostList || sever.hostList.count == 0)
    {
        DDLogDebug(@"请设置sever的hostList");
        return @"";
    }
    
    if (self.config.shouldChangeHostAutomaticly >= sever.hostList.count)
    {
        self.config.shouldChangeHostAutomaticly = 0;
    }
    
    NSString* host = sever.hostList[self.config.shouldChangeHostAutomaticly];
    
    if (![host hasPrefix:@"http"] || host.length < 4)
    {
        DDLogDebug(@"sever含有非法host");
        return @"";
    }
    
//    // 不要末尾/
//    if ([host hasSuffix:@"/"])
//    {
//        host = [host substringToIndex:host.length - 1];
//    }
    
    // 要末尾/
    if (![host hasSuffix:@"/"])
    {
        host = [host stringByAppendingString:@"/"];
    }
    
    return host;
}

@end
