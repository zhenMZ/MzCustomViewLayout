//
//  MZPayView.h
//  XilianApp
//
//  Created by zhen mz on 2017/4/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZPayView : UIView

@property (nonatomic, assign) id delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, assign) CGFloat amount;

- (void)show;
- (void)dismiss;

@end


@protocol MZPayViewDelegate <NSObject>

- (void)MZPayViewDelegate:(NSString *)password;

@end
