//
//  CrossCut.m
//  XilianApp
//
//  Created by Abyss on 2017/5/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CrossCut.h"

@implementation CrossCut

+ (instancetype)crossCutNamed:(NSString *)title
{
    UIColor* defualtColor = [UIColor colorWithRed:0.21f green:0.45f blue:0.88f alpha:1.00f];
    
    return [[self alloc] initWithColor:defualtColor title:title];
}

- (instancetype)initWithColor:(UIColor *)color title:(NSString *)title
{
    CGRect holdFrame = CGRectMake(-20, 100, 60, 60);
    
    if(self = [super initWithFrame:holdFrame])
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = color;
        self.alpha = .7;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 30;
        self.layer.masksToBounds = YES;
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)p
{
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [p locationInView:appWindow];
    
    if(p.state == UIGestureRecognizerStateBegan)
    {
    }
    else if(p.state == UIGestureRecognizerStateChanged)
    {
        self.center = panPoint;
    }
    else if(p.state == UIGestureRecognizerStateEnded
            || p.state == UIGestureRecognizerStateCancelled)
    {
        self.alpha = .7;
        
        CGFloat ballWidth = self.frame.size.width;
        CGFloat ballHeight = self.frame.size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat top = fabs(panPoint.y);
        CGFloat bottom = fabs(screenHeight - top);
        
        CGFloat minSpace = 0;
        
        minSpace = MIN(MIN(MIN(top, left), bottom), right) ;

        CGPoint newCenter = CGPointZero;
        CGFloat targetY = 0;
        
        if (panPoint.y < 15 + ballHeight / 2.0) {
            targetY = 15 + ballHeight / 2.0;
        }else if (panPoint.y > (screenHeight - ballHeight / 2.0 - 15)) {
            targetY = screenHeight - ballHeight / 2.0 - 15;
        }else{
            targetY = panPoint.y;
        }
        
        CGFloat centerXSpace = (0.5 - 8/55) * ballWidth - 20;
        CGFloat centerYSpace = (0.5 - 8/55) * ballHeight;
        
        if (minSpace == left)
        {
            newCenter = CGPointMake(centerXSpace, targetY);
        }
        else if (minSpace == right)
        {
            newCenter = CGPointMake(screenWidth - centerXSpace, targetY);
        }
        else if (minSpace == top)
        {
            newCenter = CGPointMake(panPoint.x, centerYSpace);
        }else {
            newCenter = CGPointMake(panPoint.x, screenHeight - centerYSpace);
        }
        
        [UIView animateWithDuration:.25 animations:^{
            self.center = newCenter;
        }];
    }
    else
    {
        NSLog(@"pan state : %zd", p.state);
    }
}

- (void)click
{
    if (_touch)
    {
        _touch(self);
    }
}

@end
