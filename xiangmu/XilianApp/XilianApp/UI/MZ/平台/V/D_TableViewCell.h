//
//  D_TableViewCell.h
//  XilianApp
//
//  Created by zhen mz on 2017/5/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class D_TableViewCell;
@protocol testTableViewCellDelegate <NSObject>

-(void)uodataTableViewCellHight:(D_TableViewCell*)cell andHight:(CGFloat)hight andIndexPath:(NSIndexPath *)indexPath;
@end

@interface D_TableViewCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,weak) id<testTableViewCellDelegate>deleget;
@property(nonatomic,strong)UILabel *lable;
@end
