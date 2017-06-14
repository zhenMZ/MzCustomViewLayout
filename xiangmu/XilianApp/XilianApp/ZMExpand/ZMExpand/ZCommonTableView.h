//
//  ZCommonTableView.h
//  XilianApp
//
//  Created by zhen mz on 2017/4/13.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZCommonTableView : NSObject


- (void)handleWithTable:(UITableView *)tableView CLASSwithCellIdentifier:(NSString *)identifier;

- (void)handleWithTable:(UITableView *)tableView XIBwithCellIdentifier:(NSString *)identifier;

- (void)getDataForTableWithModel:(NSArray *(^)())modelArrayBlock completion:(void (^)())completion;


@end
