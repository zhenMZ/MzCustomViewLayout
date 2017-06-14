//
//  MZSetPasswordView.h
//  XilianApp
//
//  Created by zhen mz on 2017/4/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZSetPasswordView;
@protocol MZSetPasswordViewDelegate <NSObject>

- (void)passwordView:(MZSetPasswordView*)passwordView inputPassword:(NSString*)password;

@end

@interface MZSetPasswordView : UIView


@property (nonatomic, weak) id<MZSetPasswordViewDelegate> delegate;

@property (nonatomic, strong) UITextField *passwordTextField;

-(void)fieldBecomeFirstResponder;
-(void)clearUpPassword;


@end


