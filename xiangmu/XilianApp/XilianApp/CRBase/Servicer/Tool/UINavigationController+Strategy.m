//
//  UINavigationController+Strategy.m
//  XilianApp
//
//  Created by MZ on 2017/4/20.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UINavigationController+Strategy.h"

@implementation UINavigationController (Strategy)

- (id)z_findViewController:(NSString *)className {
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(className)]) {
            return viewController;
        }
    }
    return nil;
}

- (UIViewController *)z_rootViewController {
    if (self.viewControllers && [self.viewControllers count] >0) {
        return [self.viewControllers firstObject];
    }
    return nil;
}

- (NSArray *)z_popToViewControllerWidthClassName:(NSString*)className animated:(BOOL)amimated {
    return [self popToViewController:[self z_findViewController:className] animated:YES];

}

- (NSArray *)z_popToViewControllerWithLevel:(NSInteger)level animation:(BOOL)animated {
    NSInteger viewControllersCount = self.viewControllers.count;
    if (viewControllersCount > level) {
        NSInteger idx = viewControllersCount - level - 1;
        UIViewController *viewController = self.viewControllers[idx];
        return [self popToViewController:viewController animated:animated];
    } else {
        return [self popToRootViewControllerAnimated:animated];
    }

}

- (void)z_pushViewController:(UIViewController *)controller{
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;            //改变视图控制器出现的方式
    transition.subtype = kCATransitionFromLeft;     //出现的位置
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:controller animated:NO];
}

- (void)z_popViewController {
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;            //改变视图控制器出现的方式
    transition.subtype = kCATransitionFromRight;     //出现的位置
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self popViewControllerAnimated:NO];;
}

@end
