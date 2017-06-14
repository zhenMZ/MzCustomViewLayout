//
//  UINavigation+Strategy.h
//  myApp
//
//  Created by 任超 on 15/4/11.
//  Copyright (c) 2015年 Chongqing Xilian Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (Strategy)

- (void)initNav:(NSString *)title;

- (void)setupTitle:(NSString *)title;
- (void)setupLeftButton:(NSString *)str;
- (void)setupLeftButtonWithImage:(NSString *)image and:(NSString *)highlightImage;
- (void)setupRightButton:(NSString *)str;
- (void)setupRightButtonWithImage:(NSString *)image and:(NSString *)highlightImage;

@end

@interface UIBarButtonItem (Extension)
+ (instancetype)buttonWithImage:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action;
@end