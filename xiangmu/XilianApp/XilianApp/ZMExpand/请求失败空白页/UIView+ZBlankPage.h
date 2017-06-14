//
//  UIView+ZBlankPage.h
//  XilianApp
//
//  Created by MZ on 2017/5/27.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBlankPageView.h"
@interface UIView (ZBlankPage)


@property (strong, nonatomic) ZBlankPageView *blankPageView;

- (void)configBlankPage:(ZBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;
@end
