//
//  CRColor.m
//  XilianApp
//
//  Created by Abyss on 2017/3/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRColor.h"

@implementation CRColor

+ (UIColor *)topic
{
    return nil;
}

+ (UIColor *)topoc2
{
    return nil;
}

+ (UIColor *)text
{
    return nil;
}

+ (UIColor *)description
{
    return nil;
}

+ (UIColor *)tip
{
    return nil;
}

+ (UIColor *)warn
{
    return nil;
}

+ (UIColor *)pass
{
    return nil;
}

+ (UIColor *)line
{
    return nil;
}

+ (UIColor *)background
{
    return [UIColor colorWithRGB:244 Green:244 Blue:244 alpha:1];
}

@end

@implementation UIColor (Strategy)

+ (UIColor *)colorWithHex:(NSUInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor *)colorWithHexString:(NSString *)hex
{
    return [UIColor colorWithHexString:hex alpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha
{
    //过滤字符串中的特殊符号
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) {
        NSLog(@"输入的16进制颜色(html颜色值)格式不正确");
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *)colorWithRGB:(CGFloat)red Green:(CGFloat) green Blue:(CGFloat)blue alpha:(CGFloat)alpha;
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

@end
