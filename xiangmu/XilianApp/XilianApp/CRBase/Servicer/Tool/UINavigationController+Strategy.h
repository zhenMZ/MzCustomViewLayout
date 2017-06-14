//
//  UINavigationController+Strategy.h
//  XilianApp
//
//  Created by MZ on 2017/4/20.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationController (Strategy)


/**
 寻找Navigation中的某个viewcontroler对象

 @param className viewcontroler名称
 @return viewcontroler对象
 */
- (id)z_findViewController:(NSString *)className;

/**
 RootViewController

 @return RootViewController
 */
- (UIViewController *)z_rootViewController;

/**
 返回指定的viewcontroler

 @param className  指定viewcontroler类名
 @param amimated 是否动画
 @return pop之后的viewcontrolers
 */
- (NSArray *)z_popToViewControllerWidthClassName:(NSString*)className animated:(BOOL)amimated;

/**
 pop n层

 @param level  n层
 @param animated 是否动画
 @return pop之后的viewcontrolers
 */
- (NSArray *)z_popToViewControllerWithLevel:(NSInteger)level animation:(BOOL)animated;

- (void)z_pushViewController:(UIViewController *)controller;

- (void)z_popViewController;


@end
