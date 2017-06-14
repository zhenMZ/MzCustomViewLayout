//
//  CRColor.h
//  XilianApp
//
//  Created by Abyss on 2017/3/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRColor : NSObject

+ (UIColor *)topic;
+ (UIColor *)topoc2;

+ (UIColor *)text;
+ (UIColor *)description;
+ (UIColor *)tip;

+ (UIColor *)warn;
+ (UIColor *)pass;

+ (UIColor *)line;

+ (UIColor *)background;

@end

typedef struct
{
    int r;
    int g;
    int b;
}ColorRGB;


@interface UIColor (Strategy)

+ (UIColor *)colorWithHexString:(NSString *)hex;
+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithRGB:(CGFloat)red Green:(CGFloat) green Blue:(CGFloat)blue alpha:(CGFloat)alpha;


@end
