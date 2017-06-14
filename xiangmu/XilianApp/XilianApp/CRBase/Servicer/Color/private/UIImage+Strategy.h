//
//  UIImage+Strategy
//
//  Created by 沐汐 on 14-9-13.
//  Copyright (c) 2014年 沐汐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Strategy)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end
