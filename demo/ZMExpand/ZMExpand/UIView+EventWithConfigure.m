//
//  UIView+EventWithConfigure.m
//  XilianApp
//
//  Created by zhen mz on 2017/4/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UIView+EventWithConfigure.h"
#import <objc/runtime.h>
@implementation UIView (EventWithConfigure)

- (void)setViewDelegate:(id<MZViewProtocol>)viewDelegate {
    objc_setAssociatedObject(self, @selector(viewDelegate), viewDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setViewEventBlock:(ViewEventBlock)viewEventBlock {
    objc_setAssociatedObject(self, @selector(viewEventBlock), viewEventBlock, OBJC_ASSOCIATION_COPY);
}

- (void)mz_viewWithViewModel:(id<MZViewProtocol>)viewModel {
    if (viewModel) {
        self.viewDelegate = viewModel;
    }
}

- (id<MZViewProtocol>)viewDelegate {
    return objc_getAssociatedObject(self, _cmd);
}
- (ViewEventBlock)viewEventBlock {
    return objc_getAssociatedObject(self, @selector(viewEventBlock));
}

- (void)mz_configureViewWithViewModel:(id<MZViewModelProtocol>)viewModel
{
    
}
@end
