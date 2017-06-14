//
//  ZPopWindow.h
//  XilianApp
//
//  Created by MZ on 2017/6/13.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPopWindow : UIWindow

@property (nonatomic, assign) BOOL touchWithHide;

@property (nonatomic, readonly) UIView *baseView;

+ (ZPopWindow *)shareWindow;

@end
