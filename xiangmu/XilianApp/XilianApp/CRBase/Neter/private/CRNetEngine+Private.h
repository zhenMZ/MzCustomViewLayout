//
//  CRNetEngine+Private.h
//  XilianApp
//
//  Created by Abyss on 2017/3/1.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRNetEngine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 CRNetEngine (Private)
 CRNetEngine的私有补充
 */
@interface CRNetEngine (Private)

- (NSString *)evaluateUrlFor:(CRRequest *)request useCDN:(BOOL)useCDN;
- (NSString *)evaluateHostIn:(NSObject<CRNetSeverConfiguration> *)sever;

- (NSURLSessionTask *)sessionTaskForRequest:(CRRequest *)request error:(NSError * _Nullable __autoreleasing *)error;

- (NSURLSessionDownloadTask *)downloadTaskWithDownloadPath:(NSString *)downloadPath
                                                 URLString:(NSString *)URLString
                                                parameters:(id)parameters
                                                  progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                                     error:(NSError * _Nullable __autoreleasing *)error;

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                           error:(NSError * _Nullable __autoreleasing *)error;

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                           error:(NSError * _Nullable __autoreleasing *)error;
@end

NS_ASSUME_NONNULL_END
