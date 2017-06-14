//
//  ZBlankPageView.h
//  XilianApp
//
//  Created by MZ on 2017/5/27.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZBlankPageType) {
    EaseBlankPageTypeView = 0,
    EaseBlankPageTypeProject,
    EaseBlankPageTypeNoButton,
    EaseBlankPageTypeMaterialScheduling
};


@interface ZBlankPageView : UIView
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UILabel *tipLable;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, copy) void(^reloadButtonBlock)(id sender);

- (void)configWithType:(ZBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;


@end
