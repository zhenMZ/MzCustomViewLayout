//
//  ZPopView.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/20.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "ZPopView.h"
@interface ZPopView()
@property (nonatomic, retain) UIView *barView;
@property (nonatomic, retain) UIView *view;

@end
@implementation ZPopView


- (instancetype)initWithFrame:(CGRect)frame withSpecificUI:(UIView *)view {
    self = [super initWithFrame: CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64)];
    if (self) {
        self.userInteractionEnabled = YES;
        self.barView.backgroundColor = [UIColor colorWithRed:198 green:198 blue:198 alpha:1];
        self.barView.frame = frame;
        self.barView = view;
    }
    return self;
}



- (void)showXib {
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

    switch (_animationStyle) {
        case ZAnimationDefault:
        {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.barView.transform = CGAffineTransformIdentity;
                self.barView.alpha = 1.0;
                self.barView.layer.shadowColor = [UIColor grayColor].CGColor;
                self.barView.layer.shadowOpacity = 0.5;
            } completion:nil];

        }
            break;
        case ZAnimationTopShake:
        {
           
            
            CGPoint startPoint = CGPointMake(self.center.x, - self.barView.frame.size.height);
             self.barView.layer.position=startPoint;
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.barView.layer.position=self.center;
                
            } completion:^(BOOL finished) {
                
            }];

            
            
        }
            break;
        case ZAnimationLeftShake:
        {
            CGPoint startPoint = CGPointMake(-self.barView.frame.size.width, self.center.y);
            self.barView.layer.position = startPoint;
            [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.barView.layer.position=self.center;
            } completion:^(BOOL finished) {
                
            }];

        }
            break;
        case ZAnimationNO:
        {
            
        }
            break;
        default: {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.barView.transform = CGAffineTransformIdentity;
                self.barView.alpha = 1.0;
                self.barView.layer.shadowColor = [UIColor grayColor].CGColor;
                self.barView.layer.shadowOpacity = 0.5;
            } completion:nil];

        }
            break;
    }

    

}

- (void)closeXib {
    [UIView animateWithDuration:.25 delay:0 options:
     UIViewAnimationOptionCurveEaseInOut animations:^{
         
         self.alpha = 0.0;
         
         self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    
     } completion:^(BOOL finished) {
         if (finished) {

             [self removeFromSuperview];
         }
     }];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.barView]) {
        [self closeXib];
    }
}


@end
