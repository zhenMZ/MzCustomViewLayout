//
//  S_M_CollectionCell.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/7.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "S_M_CollectionCell.h"

@implementation S_M_CollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBaseInfoDic:(NSDictionary *)baseInfoDic {
    _baseInfoDic = baseInfoDic;
    
    _logImg.image = [UIImage imageNamed:_baseInfoDic[@"log"]];
    _titleLable.text = _baseInfoDic[@"title"];
    _contentLable.text = _baseInfoDic[@"content"];
    
}


@end
