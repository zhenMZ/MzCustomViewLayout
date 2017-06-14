//
//  UIView+EventWithConfigure.h
//  XilianApp
//
//  Created by zhen mz on 2017/4/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ViewEventBlock)();

@interface UIView (EventWithConfigure)

@property (nullable, nonatomic, weak) id<MZViewProtocol> viewDelegate;

@property (nonatomic, copy) ViewEventBlock viewEventBlock;

- (void)mz_viewWithViewModel:(id<MZViewProtocol>)viewModel;

/**
 view中调用，把请求的数据传给view 

 @param viewModel model数据
 */
- (void)mz_configureViewWithViewModel:(id<MZViewModelProtocol>)viewModel;

@end
NS_ASSUME_NONNULL_END
