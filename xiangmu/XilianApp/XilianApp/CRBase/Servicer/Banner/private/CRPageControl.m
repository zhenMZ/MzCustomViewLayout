//
//  CRPageControl.m
//  testappdomain
//
//  Created by Abyss on 2017/3/8.
//  Copyright © 2017年 Chongqing Xilian Technology Co., Ltd. All rights reserved.
//

#import "CRPageControl.h"
#import "UIView+Tool.h"
#import <objc/runtime.h>

@implementation CRPageControl

+ (void)load
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    Method origin = class_getInstanceMethod([self class], @selector(_indicatorSpacing));
#pragma clang diagnostic pop
    Method custom = class_getInstanceMethod([self class], @selector(custom_indicatorSpacing));
    method_exchangeImplementations(origin, custom);
}

- (double)custom_indicatorSpacing
{
    return 8.0;
}

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    
    if(!self.subviews) return;
    NSUInteger index;
    for (index = 0; index < [self.subviews count]; index++)
    {
        UIView* point   = [self.subviews objectAtIndex:index];
        
        point.height    = 6;
        point.width     = 6;
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
 
    CGFloat right = self.superview.width;
    
    self.width = numberOfPages * 8;
    self.right = right - 10;
    self.height = 8;
    self.bottom = self.superview.height - 2;
}

@end
