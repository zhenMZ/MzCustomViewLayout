//
//  CRIconAws.h
//  XilianApp
//
//  Created by Abyss on 2017/3/9.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRFontIconFactory.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(UniChar, CRIconUniCharAws)
{
    CRIconUniCharAwsAdjust = 0xf042,
    NIKFontAwesomeIconAndroid = 0xf17b,
};

@interface CRIconAws : CRFontIconFactory

- (NSDictionary *)iconMap;

- (UIImage *)createImageForIcon:(CRIconUniCharAws)icon;
- (UIImage *)createImageForIconName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
