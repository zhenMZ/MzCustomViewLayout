//
//  UIScreen+Frame.m
//  XilianApp
//
//  Created by MZ on 2017/4/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UIScreen+Frame.h"

@implementation UIScreen (Frame)

+ (CGSize)size {
     return [[UIScreen mainScreen] bounds].size;
}

+ (CGFloat)width {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)height {
    return [[UIScreen mainScreen] bounds].size.height;
}


@end
