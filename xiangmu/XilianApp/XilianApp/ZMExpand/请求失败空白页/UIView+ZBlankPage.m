//
//  UIView+ZBlankPage.m
//  XilianApp
//
//  Created by MZ on 2017/5/27.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UIView+ZBlankPage.h"
#import <objc/runtime.h>

static char BlankPageViewKey;
@implementation UIView (ZBlankPage)

- (void)setBlankPageView:(ZBlankPageView *)blankPageView{
    
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
    
}

- (ZBlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)configBlankPage:(ZBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block{
    if (hasData) {
        if (self.blankPageView) {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    }else{
        if (!self.blankPageView) {
            self.blankPageView = [[ZBlankPageView alloc] initWithFrame:self.bounds];
        }
        self.blankPageView.hidden = NO;
        [self.blankPageContainer addSubview:self.blankPageView];
        
        [self.blankPageView configWithType:blankPageType hasData:hasData hasError:hasError reloadButtonBlock:block];
    }
}

- (UIView *)blankPageContainer{
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}


@end
