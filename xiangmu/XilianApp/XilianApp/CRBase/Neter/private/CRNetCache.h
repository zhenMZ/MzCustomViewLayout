//
//  CRNetCache.h
//  XilianApp
//
//  Created by Abyss on 2017/2/28.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 CRNetCache
 请求缓存模型
 */
@interface CRNetCache : NSObject<NSCoding>

/** 标示符 */
@property (strong) NSString* identifier;
/** 终止日期 */
@property (strong) NSDate *date;
/** 有效日期,该时间内不会发生重复请求 */
@property (strong) NSDate *dateEphemerally;
/** 版本号 */
@property (strong) NSString *version;
/** 数据 */
@property (strong) NSData* data;

/** 取来用的data */
@property (strong, readonly) id responseData;

@end

NS_ASSUME_NONNULL_END
