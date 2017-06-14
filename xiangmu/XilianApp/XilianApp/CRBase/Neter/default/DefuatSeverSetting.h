//
//  DefuatSeverSetting.h
//  XilianApp
//
//  Created by Abyss on 2017/3/1.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRNetDefine.h"

/** plist文件名,默认配置取自plist */
static NSString* __nonnull key_severConfiguration_defualt = @"com.abyss.severConfiguration";

NS_ASSUME_NONNULL_BEGIN

/**
 DefuatSeverSetting
 服务器配置集合
 
 可能会有测试,预发布,正式服等不同的服务器环境
 */
@interface DefuatSeverSetting : NSSet

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithArray:(NSArray *)array;

+ (NSSet *)defualt;

@end

/**
 SeverConfiguration
 服务器配置
 
 例如:"DEBUG"模式下,一系列的配置
 */
@interface SeverConfiguration : NSObject<CRNetSeverConfiguration>
@property (strong) NSDictionary* sever;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/** 配置名称 */
- (NSString *)configurationName;

/** host列表 */
- (NSArray *)hostList;

/** CDN */
- (NSString *)CDN;

/** 缓存时间 */
- (NSNumber *)cache;

/** 缓存时间 */
- (NSNumber *)cacheEphemerally;

/** 颜色主题 */
- (NSDictionary *)colorTopic;

@end

NS_ASSUME_NONNULL_END
