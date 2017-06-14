//
//  ZPopView.h
//  XilianApp
//
//  Created by zhen mz on 2017/5/20.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZShowAnimationStyle) {
    ZAnimationDefault    = 0,
    ZAnimationLeftShake  ,
    ZAnimationTopShake   ,
    ZAnimationNO         ,
};


@interface ZPopView : UIView

@property (nonatomic, assign) ZShowAnimationStyle animationStyle;

- (instancetype)initWithFrame:(CGRect)frame withSpecificUI:(UIView *)view ;

- (void)showXib;
- (void)closeXib;


@end
