//
//  CRNavigationer.h
//  XilianApp
//
//  Created by Abyss on 2017/3/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface CRNavigationer : UINavigationController

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/** 先设置再创建 */
+ (void)setCustomNavBar:(nullable Class)navBarClass;
+ (void)setCustomToolBar:(nullable Class)toolBarClass;

+ (instancetype)global;

- (void)appearanceWithBgColor:(UIColor *)bgColor
                    textColor:(UIColor *)textColor
                    titleFont:(CGFloat)titleFont
                     itemFont:(CGFloat)itemFont;

@end

@interface UIViewController (CRNavigationer)
@property (weak, readonly) CRNavigationer* navigationer;
@end

NS_ASSUME_NONNULL_END
