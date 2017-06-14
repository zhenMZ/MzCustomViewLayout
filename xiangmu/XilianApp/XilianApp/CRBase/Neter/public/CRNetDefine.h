//
//  CRNetDefine.h
//  XilianApp
//
//  Created by Abyss on 2017/2/28.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#ifndef CRNetDefine_h
#define CRNetDefine_h

typedef NS_ENUM(NSInteger, CRRequestMethod)
{
    CRRequestMethodGET = 0,
    CRRequestMethodPOST,
    CRRequestMethodHEAD,
    CRRequestMethodPUT,
    CRRequestMethodDELETE,
    CRRequestMethodPATCH,
};

@class CRRequest;
@class CRNetEngine;
typedef void(^CRRequestSuccess)(__kindof CRRequest* request, BOOL isCache);
typedef void(^CRRequestFailure)(__kindof CRRequest* request);

@protocol AFMultipartFormData;

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^AFURLSessionTaskProgressBlock)(NSProgress *);

// 服务器配置
@protocol CRNetHostRule;
@protocol CRNetSeverConfiguration <NSObject>
@required
- (NSString *)configurationName;
- (NSArray *)hostList;
@optional
- (NSString *)CDN;
- (NSNumber *)cache;
- (NSNumber *)cacheEphemerally;
@end

// 过滤器
@protocol CRNetFilter <NSObject>
@required
- (NSDictionary *)filter;
@end

// 额外组件
@protocol CRRequestAccessory <NSObject>
@optional
- (void)requestWillStart:(CRRequest *)request;
- (void)requestDidStop:(CRRequest *)request;
@end

#endif /* CRNetDefine_h */
