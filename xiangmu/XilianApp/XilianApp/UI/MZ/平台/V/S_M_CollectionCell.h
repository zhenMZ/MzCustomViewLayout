//
//  S_M_CollectionCell.h
//  XilianApp
//
//  Created by zhen mz on 2017/5/7.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S_M_CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (nonatomic, retain) NSDictionary *baseInfoDic;
@end
