//
//  MZPaymentForm.h
//  XilianApp
//
//  Created by zhen mz on 2017/4/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZPaymentForm : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,assign) CGFloat amount;

@property (nonatomic,copy) NSString *inputPassword;
@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

-(void)fieldBecomeFirstResponder;
-(CGSize)viewSize;

@end
