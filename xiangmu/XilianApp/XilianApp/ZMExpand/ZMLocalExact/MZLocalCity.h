//
//  MZLocal.h
//  XilianApp
//
//  Created by zhen mz on 2017/4/13.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^localAddressCallBack)(NSDictionary*address);//返回地址字典
typedef void (^localCityCallBack)(NSString*city);//返回城市
typedef void (^failure)(NSError*failure);//返回error

@interface MZLocalCity : NSObject

/**
 *  单例
 *
 *  @return BJLocalCity
 */
+(MZLocalCity*)Shared;
/**
 *  开启定位
 *
 *  @param localAddressCallBack 定位回调成功返回地址数组
 *  @param failure              定位失败
 */
+(void)startLocalAddressSuccess:(localAddressCallBack)localAddressCallBack failure:(failure)failure;
/**
 *  开启定位
 *
 *  @param localCallBack 定位回调成功返回城市
 *  @param failure       定位失败
 */
+(void)startLocalCitySuccess:(localCityCallBack)localCallBack failure:(failure)failure;
@end

