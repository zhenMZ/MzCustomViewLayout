//
//  ZPopWindow.m
//  XilianApp
//
//  Created by MZ on 2017/6/13.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "ZPopWindow.h"

@interface ZPopWindow ()<UIGestureRecognizerDelegate>

@end

@implementation ZPopWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        gesture.cancelsTouchesInView = NO;
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (UIView *)baseView {
    return self.rootViewController.view;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

+ (ZPopWindow *)shareWindow {
    
    static ZPopWindow *window;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[ZPopWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        window.rootViewController = [UIViewController new];
    });
    return window;
}

- (void)actionTap:(UITapGestureRecognizer*)gesture
{
    if ( self.touchWithHide  )
    {
      
    }
}
@end
