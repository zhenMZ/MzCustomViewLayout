//
//  UITableViewCell+ZCongigure.m
//  XilianApp
//
//  Created by zhen mz on 2017/4/13.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UITableViewCell+ZCongigure.h"

@implementation UITableViewCell (ZCongigure)

+ (UINib *)nibWithIdentifier:(NSString *)identifier
{
    return [UINib nibWithNibName:identifier bundle:nil];
}

+ (void)mz_registerTable:(UITableView *)tableView xibIdentifier:(NSString *)identifier {
    [tableView registerNib:[self nibWithIdentifier:identifier] forCellReuseIdentifier:identifier];
}

+ (void)mz_registerTable:(UITableView *)tableView classIdentifier:(NSString *)identifier {
    [tableView registerClass:NSClassFromString(identifier) forCellReuseIdentifier:identifier];
}

- (void)mz_configure:(UITableViewCell *)cell dafaSouce:(id)model indexPath:(NSIndexPath *)indexPath {
    
}
- (void)mz_configure:(UITableViewCell *)cell viewModel:(id<MZViewModelProtocol>)viewModel indexPath:(NSIndexPath *)indexPath {
    
}



@end
