//
//  CRFontIconLoader.h
//  XilianApp
//
//  Created by Abyss on 2017/3/9.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreGraphics;

NS_ASSUME_NONNULL_BEGIN

@interface CRFontIconLoader : NSObject

/** ttf */
- (CGPathRef)loadIcon:(UniChar)icon
                heiht:(CGFloat)height
             maxWidth:(CGFloat)width
                 name:(NSString * __nullable)name CF_RETURNS_RETAINED;


@end

NS_ASSUME_NONNULL_END
