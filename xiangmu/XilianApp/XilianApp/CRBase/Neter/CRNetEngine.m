//
//  CRNetEngine.m
//  XilianApp
//
//  Created by Abyss on 2017/2/28.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRNetEngine.h"
#import "CRRequest.h"
#import "CRDefines.h"
#import "CRRequest+Private.h"
#import "CRNetEngine+Private.h"
#import "CRNetCache.h"

@interface CRNetEngine ()
{
    dispatch_queue_t _processingQueue;
    
    dispatch_semaphore_t _lock;
    
    NSMutableDictionary<NSNumber *, CRRequest *> *_requestsRecord;
}
@end

@implementation CRNetEngine

+ (instancetype)defaultEngine
{
    static id defaultEngine = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        defaultEngine = [[self alloc] init];
    });
    
    return defaultEngine;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _config     = [CRNetConfig defaultConfig];
        _cacher     = [CRCacher cacherNamed:key_cacher_net];
        _manager    = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_config.sessionConfiguration];
        _processingQueue = dispatch_queue_create(key_netEngine_default, DISPATCH_QUEUE_CONCURRENT);
        _manager.completionQueue = _processingQueue;
        
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        _lock = dispatch_semaphore_create(1);
        _requestsRecord = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 方法实现

- (void)sendRequest:(CRRequest *)request
{
    // 取出所有的Filter设置
    NSSet<NSObject<CRNetFilter> *>* filters = request.filters;
    
    __block NSMutableDictionary* filterConfiguration = [NSMutableDictionary dictionary];
    
    
    [filters enumerateObjectsUsingBlock:^(NSObject<CRNetFilter> * obj, BOOL *stop){
        [obj.filter enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, BOOL *stop){
            [filterConfiguration setObject:value forKey:key];
        }];
    }];
    
    
    BOOL useCDN = filterConfiguration[key_netConfig_useCDN];
    
    request.url = [self evaluateUrlFor:request useCDN:useCDN];

    
    [request accessoryWillStart];
    
    NSError * __autoreleasing error = nil;
    
    /** 公共参数 */
    NSMutableDictionary* publicParam = [NSMutableDictionary dictionaryWithDictionary:request.publicParam];
    [publicParam addEntriesFromDictionary:request.params];
    request.params = publicParam;
    
    /** 公共头 */
    if (request.publicHeader && request.publicHeader.allKeys.count > 0)
    {
        [request.publicHeader enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* value, BOOL* stop)
         {
             [_manager.requestSerializer setValue:value forHTTPHeaderField:key];
         }];
    }
    
    request.requestTask = [self sessionTaskForRequest:request error:&error];
    
    [self addRequestToRecord:request];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:request.params?:@{}];
    
    [params addEntriesFromDictionary:filterConfiguration];
    
    request.params = params;
    
    if(request.cache)
    {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [request accessoryDidEnd];
                
                if (request.success)
                {
                    request.success(request, YES);
                }
            });
    }
    
    if (request.cache && request.useCache == 2 && request.cache.dateEphemerally.timeIntervalSince1970 >= [NSDate date].timeIntervalSince1970)
    {
    }
    else
    {
        [request.requestTask resume];
    }
}

- (void)cancelRequest:(CRRequest *)request
{
    NSParameterAssert(request != nil);
    
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearBlock];
}

- (void)clearRequests
{
    Lock();
    NSArray *allKeys = [_requestsRecord allKeys];
    Unlock();
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            Lock();
            CRRequest *request = _requestsRecord[key];
            Unlock();

            [request stop];
        }
    }
}

#pragma mark - 请求池

- (void)addRequestToRecord:(CRRequest *)request
{
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRecord:(CRRequest *)request
{
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    Unlock();
}

#pragma mark - 结果处理

- (void)handleRequestResult:(NSURLSessionTask *)task
             responseObject:(id)responseObject
                      error:(NSError *)error
{
    Lock();
    CRRequest *request = _requestsRecord[@(task.taskIdentifier)];
    Unlock();
    
    // When the request is cancelled and removed from records, the underlying
    // AFNetworking failure callback will still kicks in, resulting in a nil `request`.
    //
    // Here we choose to completely ignore cancelled tasks. Neither success or failure
    // callback will be called.
    if (!request) return;
    
    request.data        = responseObject;
    
    if (error)
    {
        // 请求失败
        [self requestDidFailWithRequest:request error:error];
    }
    else
    {
        // 请求成功
        [self requestDidSucceedWithRequest:request];
        
        
        if (request.isSuccess)
        {
            //业务成功            
            @autoreleasepool
            {
                [request writeCache];
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestFromRecord:request];
        [request clearBlock];
    });
}

- (void)requestDidSucceedWithRequest:(CRRequest *)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [request accessoryDidEnd];

        if (request.success)
        {
            request.success(request, NO);
        }
    });
}

- (void)requestDidFailWithRequest:(CRRequest *)request error:(NSError *)error
{
    request.error = error;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [request accessoryDidEnd];
        
        if (request.failure)
        {
            request.failure(request);
        }
    });
}

@end
