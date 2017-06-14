//
//  HolderBuilder.m
//  XilianApp
//
//  Created by Abyss on 2017/2/23.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "HolderBuilder.h"
#import "UIView+Tool.h"

static NSString* Default_HolderImage = nil;

@interface UIImage (Strategy)
+ (UIImage *)holderW:(CGFloat)w H:(CGFloat)h;
@end
@implementation HolderBuilder

+ (UIImage *)holderImageW:(float)w H:(float)h
{
    if (!Default_HolderImage) return nil;
    
    return [UIImage holderW:w H:h];
}


+ (void)setDefaultHolderImage:(NSString *)holderImage
{
    if (holderImage) Default_HolderImage = holderImage;
}

+ (UIView *)holderViewName:(NSString *)name
                      icon:(NSString *)icon
                     title:(NSString *)title
                       des:(NSString *)des
                    action:(SEL)action
                    button:(NSString *)button
{
    return nil;
}

@end

@implementation UIImage (Strategy)

+ (UIImage *)holderW:(CGFloat)w H:(CGFloat)h
{
    UIView* view = [[UIView alloc] init];
    
    view.width = w;
    view.height = h;
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    CGFloat min = MIN(w,h);
    
    UIImageView* img = [[UIImageView alloc] init];
    img.width = MIN(36,min/2);
    img.height = MIN(36,min/2);
    img.image = [UIImage imageNamed:Default_HolderImage];
    
    [view addSubview:img];
    [img centerToParent];
    
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
