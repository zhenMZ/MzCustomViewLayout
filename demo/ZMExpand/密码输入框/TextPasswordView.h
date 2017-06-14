//
//  TextPasswordView.h
//  XilianApp
//
//  Created by MZ on 2017/6/5.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextPasswordView;

@protocol TextPasswordViewDelegate <NSObject>

@optional

- (void)TXTPasswordView:(TextPasswordView *)view WithPasswordString:(NSString *)password;

@end


@interface TextPasswordView : UIView

@property (nonatomic, retain) UITextField *passwordTF;
@property (nonatomic, assign) id<TextPasswordViewDelegate> delegate;

@end


