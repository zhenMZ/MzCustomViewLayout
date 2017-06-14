//
//  S_ViewModel.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/10.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//
#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
#import "S_ViewModel.h"

#import "S_M_CollectionCell.h"
#import "CollectionReusableView.h"
@interface S_ViewModel()
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation S_ViewModel

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@{@"log":@"订单",@"title":@"订单",@"content":@"待发货管理"},
                     @{@"log":@"售后",@"title":@"售后",@"content":@"退换订单处理"},
                     @{@"log":@"吊牌",@"title":@"在售",@"content":@"上下架商品"},
                     @{@"log":@"仓库",@"title":@"仓库",@"content":@"库存商品管理"},
                     @{@"log":@"团购",@"title":@"团购",@"content":@"线下团购管理"},
                     @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                     @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                     @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                     @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                     ];
    }
    return _dataArr;
}

- (void)handleWithTable:(UICollectionView *)collectionView
{
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:@"S_M_CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"S_M_CollectionCell"];
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionReusableView"];
    CGFloat rgb = 244/255.0;
    collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    S_M_CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"S_M_CollectionCell" forIndexPath:indexPath];
    cell.baseInfoDic = self.dataArr[indexPath.item];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(screenW/2-13, 80);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionReusableView" forIndexPath:indexPath];
        headerView.line.text = @".\n.";
        
        return headerView;
    }
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){screenW-20,165};
}

#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
}







@end
