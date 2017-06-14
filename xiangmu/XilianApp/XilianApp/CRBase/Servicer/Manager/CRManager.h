//
//  CRManager.h
//  XilianApp
//
//  Created by Abyss on 2017/3/2.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 CRManager 
 
 管理自定义bundle
 管理App参数
 */
@interface CRManager : NSObject

/** Bundle */
+ (NSBundle *)bundle;
+ (NSString *)bundleImageName:(NSString *)name;
+ (NSURL *)bundleResourceWith:(NSString *)name extension:(NSString *)extension;

/** 版本号 */
+ (NSString *)appVersion;
/** build号 */
+ (NSString *)appBuild;
/** app名称 */
+ (NSString *)appName;
/** app标识 */
+ (NSString *)appIdentifier;

/** 系统版本 */
+ (NSString *)appIphoneVersion;
/** 手机型号 */
+ (NSString *)appIphoneInfo;

@end
