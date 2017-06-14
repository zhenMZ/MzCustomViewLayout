//
//  ZCommonTableView.m
//  XilianApp
//
//  Created by zhen mz on 2017/4/13.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "ZCommonTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableViewCell+ZCongigure.h"
@interface ZCommonTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArrayList;
@property (nonatomic, copy) NSString *CellIdentifier;

@end

@implementation ZCommonTableView

- (NSArray *)dataArrayList {
    if (!_dataArrayList) {
        _dataArrayList = [NSArray array];
    }
    return _dataArrayList;
}

- (void)handleWithTable:(UITableView *)tableView CLASSwithCellIdentifier:(NSString *)identifier {
    tableView.delegate = self;
    tableView.dataSource = self;
    _CellIdentifier = identifier;
    [UITableViewCell mz_registerTable:tableView classIdentifier:identifier];
}

- (void)handleWithTable:(UITableView *)tableView XIBwithCellIdentifier:(NSString *)identifier {
    tableView.delegate = self;
    tableView.dataSource = self;
    _CellIdentifier = identifier;
    [UITableViewCell mz_registerTable:tableView xibIdentifier:identifier];
}

- (void)getDataForTableWithModel:(NSArray *(^)())modelArrayBlock completion:(void (^)())completion {
    if (modelArrayBlock) {
        self.dataArrayList = modelArrayBlock();
        if (completion) {
            completion();
        }
    }
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArrayList[indexPath.row];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataArrayList.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_CellIdentifier forIndexPath:indexPath];
    [cell mz_configure:cell dafaSouce:item indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemAtIndexPath:indexPath];
    return [tableView fd_heightForCellWithIdentifier:_CellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell mz_configure:cell dafaSouce:item indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
