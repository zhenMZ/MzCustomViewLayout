//
//  UITextField+Strategy.h
//  XilianApp
//
//  Created by MZ on 2017/4/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Strategy)

@property (nonatomic, retain) NSString *mz_identify;

- (NSArray *)mz_loadHistory;

- (void)mz_showHistory;

- (void)mz_hideHistory;

- (void)mz_clearHistory;

- (void)mz_synchronize;

@end
