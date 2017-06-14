//
//  CRRunTimeMagic.m
//  XilianApp
//
//  Created by Abyss on 2017/2/18.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRRunTimeMagic.h"
#import <objc/runtime.h>

#if __has_include(<PINRemoteImage/PINRemoteImage.h>)
    #import <PINRemoteImage/PINRemoteImage.h>
    #import "CRCacheForPINImage.h"
#endif

static BOOL _useCacheInPINRemoteImage = NO;

@interface CRRunTimeMagic()
@end
@implementation CRRunTimeMagic

+ (void)useCacheInPINRemoteImage
{
    _useCacheInPINRemoteImage = YES;
}

@end

#if __has_include(<PINRemoteImage/PINRemoteImage.h>)
@interface PINRemoteImageManager (CRRunTimeMagic)
@end
@implementation PINRemoteImageManager (CRRunTimeMagic)

+(void)load
{
    Method originalMethod = class_getInstanceMethod([self class], @selector(defaultImageCache));
    
    /** 获取自定义的pb_setBackgroundColor方法 */
    Method exchangeMethod = class_getInstanceMethod([self class], @selector(rc_defaultImageCache));
    
    /** 交换方法 */
    method_exchangeImplementations(originalMethod, exchangeMethod);
}

/** 自定义的方法 */
- (id<PINRemoteImageCaching>)rc_defaultImageCache
{
    return [CRCacheForPINImage cacherNamed:@"com.cacher.pin"];
}

@end
#endif
