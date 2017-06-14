//
//  CRNavigationer.m
//  XilianApp
//
//  Created by Abyss on 2017/3/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRNavigationer.h"
#import "UIImage+Strategy.h"
#import "CRDefines.h"
//#import "AppDelegate.h"

static Class Class_NavBar_Defualt = nil;
static Class Class_ToolBar_Defualt = nil;

@interface CRNavigationer ()

@end

@implementation CRNavigationer


- (void)viewDidLoad
{
    [super viewDidLoad];
}

+ (void)setCustomNavBar:(Class)navBarClass
{
    Class_NavBar_Defualt = navBarClass;
}

+ (void)setCustomToolBar:(Class)toolBarClass
{
    Class_ToolBar_Defualt = toolBarClass;
}

+ (instancetype)global
{
    static CRNavigationer* navigationer;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        navigationer = [[CRNavigationer alloc] initWithNavigationBarClass:Class_NavBar_Defualt toolbarClass:Class_ToolBar_Defualt];
    });
    
    return navigationer;
}

- (void)appearanceWithBgColor:(UIColor *)bgColor
                    textColor:(UIColor *)textColor
                    titleFont:(CGFloat)titleFont
                     itemFont:(CGFloat)itemFont
{
    if( !textColor ) textColor = [UIColor blackColor];
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    if(bgColor != nil) [appearance setBackgroundImage:[UIImage imageWithColor:bgColor]
                                        forBarMetrics:UIBarMetricsDefault];
    
    UIFont *font = [UIFont boldSystemFontOfSize:titleFont];
    

    [appearance setTitleTextAttributes:@{NSFontAttributeName:font,
                                         NSForegroundColorAttributeName:textColor}];
    
    
    
    UIBarButtonItem *appearance1 = [UIBarButtonItem appearance];
    
    UIFont *font1 = [UIFont systemFontOfSize:itemFont];
    
    //设置文字外观:正常
    [appearance1 setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor,
                                          NSFontAttributeName:font1
                                         } forState:UIControlStateNormal];

    
    //设置文字背景图片
    [appearance1 setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]
                           forState:UIControlStateNormal
                         barMetrics:UIBarMetricsDefault];
    
    //设置返回文字及图标颜色
    appearance1.tintColor = textColor;
}

@end

@implementation UIViewController (CRNavigationer)

- (CRNavigationer *)navigationer
{
    return [CRNavigationer global];
}

@end
