//
//  CRCacheForPINImage.h
//  XilianApp
//
//  Created by Abyss on 2017/2/18.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRCacher.h"

#if __has_include(<PINRemoteImage/PINRemoteImage.h>)
#import <PINRemoteImage/PINRemoteImage.h>
#endif

@interface CRCacheForPINImage : CRCacher <PINRemoteImageCaching>

/** 重构父类创建方法 */
+ (instancetype)cacherNamed:(NSString *)name;

@end
