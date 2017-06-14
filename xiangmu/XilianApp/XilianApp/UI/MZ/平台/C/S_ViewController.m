//
//  S_ViewController.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/7.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//
#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
#import "S_ViewController.h"
#import "CollectionReusableView.h"
#import "S_M_CollectionCell.h"
#import "S_ViewModel.h"

@interface S_ViewController ()
<
    UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
>

@property (nonatomic, retain) UICollectionView *selfCollectionView;
@property (nonatomic, retain) NSArray *dataArr;
@property (nonatomic, retain) S_ViewModel *model;
@end

@implementation S_ViewController

- (S_ViewModel *)model {
    if (!_model) {
        _model = [S_ViewModel new];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.model handleWithTable:self.selfCollectionView];
    [self.view addSubview:self.selfCollectionView];

}


-(UICollectionView *)selfCollectionView{
    if (!_selfCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection =     UICollectionViewScrollDirectionVertical;
        _selfCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 64- 49) collectionViewLayout:layout];
        
    }
    return _selfCollectionView;
}

@end
