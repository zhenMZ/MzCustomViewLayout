//
//  CRManager.m
//  XilianApp
//
//  Created by Abyss on 2017/3/2.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRManager.h"
#import "CRDefines.h"

#import <UIKit/UIDevice.h>

@implementation CRManager

+ (NSBundle *)bundle
{
#if !TARGET_INTERFACE_BUILDER
    NSBundle *bundle = [NSBundle mainBundle];
#else
    /** 这样才会在Interface中生效 */
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
#endif
    
    return [NSBundle bundleWithPath:[bundle pathForResource:key_base_bundle ofType:@"bundle"]];
}

+ (NSString *)bundleImageName:(NSString *)name
{
    return [NSString stringWithFormat:@"%@.bundle/%@",key_base_bundle,name];

}

+ (NSURL *)bundleResourceWith:(NSString *)name extension:(NSString *)extension
{
    return [[CRManager bundle] URLForResource:name withExtension:extension];
}

/** 版本号 */
+ (NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/** build号 */
+ (NSString *)appBuild
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

/** app名称 */
+ (NSString *)appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

/** app标识 */
+ (NSString *)appIdentifier
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

/** 系统版本 */
+ (NSString *)appIphoneVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

/** 手机型号 */
+ (NSString *)appIphoneInfo
{
    return [[UIDevice currentDevice] model];
}

@end
