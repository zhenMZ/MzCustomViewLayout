//
//  UITableViewCell+ZCongigure.h
//  XilianApp
//
//  Created by zhen mz on 2017/4/13.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZViewModelProtocol.h"
@interface UITableViewCell (ZCongigure)


+ (void)mz_registerTable:(UITableView *)tableView xibIdentifier:(NSString *)identifier;

+ (void)mz_registerTable:(UITableView *)tableView classIdentifier:(NSString *)identifier;

/**
 根据model配置cell的内容
 
 @param cell cell
 @param model 数据
 @param indexPath index
 */
- (void)mz_configure:(UITableViewCell *)cell dafaSouce:(id)model indexPath:(NSIndexPath *)indexPath;

/**
 根据view Model配置cell的内容
 
 @param cell cell
 @param viewModel viewModel
 @param indexPath index
 */
- (void)mz_configure:(UITableViewCell *)cell viewModel:(id<MZViewModelProtocol>)viewModel indexPath:(NSIndexPath *)indexPath;

@end
