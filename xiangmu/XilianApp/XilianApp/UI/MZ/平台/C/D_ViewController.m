//
//  D_ViewController.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/7.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "D_ViewController.h"
#import "D_TableViewCell.h"
#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
#import "S_M_CollectionCell.h"
#import "CollectionReusableView.h"
#import "SDCycleScrollView.h"
#import "D2_TableViewCell.h"
@interface D_ViewController ()<UITableViewDataSource,UITableViewDelegate,testTableViewCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)D_TableViewCell *toolCell;
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NSMutableDictionary *dicH;
@property (nonatomic,strong)NSArray *dataCollectArr;
@property(nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic, strong) SDCycleScrollView *headerView;
@property (nonatomic, strong) SDCycleScrollView *headerView1;


@end

@implementation D_ViewController

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
                     @[@{@"w":@"4",@"h":@"2"},@{@"w":@"8",@"h":@"1"},@{@"w":@"8",@"h":@"1"},@{@"w":@"6",@"h":@"2"},@{@"w":@"6",@"h":@"2"},@{@"w":@"3",@"h":@"3"},@{@"w":@"3",@"h":@"2"},@{@"w":@"3",@"h":@"2"},@{@"w":@"3",@"h":@"2"},@{@"w":@"3",@"h":@"1"},@{@"w":@"3",@"h":@"1"},@{@"w":@"3",@"h":@"1"},],
                     @[@{@"w":@"4",@"h":@"2"},@{@"w":@"8",@"h":@"1"},@{@"w":@"8",@"h":@"1"},@{@"w":@"6",@"h":@"2"},@{@"w":@"6",@"h":@"2"},@{@"w":@"3",@"h":@"3"},@{@"w":@"3",@"h":@"2"},@{@"w":@"3",@"h":@"2"},@{@"w":@"3",@"h":@"2"},@{@"w":@"3",@"h":@"1"},@{@"w":@"3",@"h":@"1"},@{@"w":@"3",@"h":@"1"},],
                     @[@{@"w":@"4",@"h":@"2"},@{@"w":@"8",@"h":@"1"},@{@"w":@"8",@"h":@"1"},@{@"w":@"6",@"h":@"2"},@{@"w":@"6",@"h":@"2"},@{@"w":@"3",@"h":@"3"},@{@"w":@"3",@"h":@"2"},@{@"w":@"3",@"h":@"2"},@{@"w":@"3",@"h":@"2"},@{@"w":@"3",@"h":@"1"},@{@"w":@"3",@"h":@"1"},@{@"w":@"3",@"h":@"1"},],
                     ];
    }
    return _dataArr;
}

- (NSArray *)dataCollectArr {
    if (!_dataCollectArr) {
        _dataCollectArr = @[@{@"log":@"订单",@"title":@"订单",@"content":@"待发货管理"},
                            @{@"log":@"售后",@"title":@"售后",@"content":@"退换订单处理"},
                            @{@"log":@"吊牌",@"title":@"在售",@"content":@"上下架商品"},
                            @{@"log":@"仓库",@"title":@"仓库",@"content":@"库存商品管理"},
                            @{@"log":@"团购",@"title":@"团购",@"content":@"线下团购管理"},
                            @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                            @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                            @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                            @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                            @{@"log":@"吊牌",@"title":@"在售",@"content":@"上下架商品"},
                            @{@"log":@"仓库",@"title":@"仓库",@"content":@"库存商品管理"},
                            @{@"log":@"团购",@"title":@"团购",@"content":@"线下团购管理"},
                            @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                            @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                            @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                            @{@"log":@"统计",@"title":@"统计",@"content":@"商城数据总览"},
                     ];
    }
    return _dataCollectArr;
}

- (SDCycleScrollView*)headerView {
    if (!_headerView) {
        NSMutableArray *imageMutableArray = [NSMutableArray array];
        for (int i = 1; i<9; i++) {
            [imageMutableArray addObject:@"团购"];
        }
        _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenW, 200) imageNamesGroup:imageMutableArray];
    }
    return _headerView;
}
- (SDCycleScrollView*)headerView1 {
    if (!_headerView1) {
        NSMutableArray *imageMutableArray = [NSMutableArray array];
        for (int i = 1; i<9; i++) {
            [imageMutableArray addObject:@"团购"];
        }
        _headerView1 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenW, 200) imageNamesGroup:imageMutableArray];
    }
    return _headerView1;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.view addSubview:self.tableView];

    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        self.collectionView.height = [self getCollectionViewHeight]+64;
        NSLog(@"偏移量%@",NSStringFromCGPoint(offset));
    }
}

-(float)getCollectionViewHeight
{
    [self.collectionView layoutIfNeeded];
    return self.collectionView.contentSize.height;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH - 64)style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.collectionView;
        [_tableView registerClass:[D_TableViewCell class] forCellReuseIdentifier:@"D_TableViewCell"];
        [_tableView registerClass:[D2_TableViewCell class] forCellReuseIdentifier:@"D2_TableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 2;
    }
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        D2_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"D2_TableViewCell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.dataArr = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
        return cell;

    }else {
        if (indexPath.section == 3 && indexPath.row == 1) {
            UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            [cell.contentView addSubview:self.headerView1];
            return cell;
        }else {
            D_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"D_TableViewCell" forIndexPath:indexPath];
            cell.deleget = self;
            cell.indexPath = indexPath;
            cell.dataArr = self.dataArr[indexPath.section-1];
            return cell;
 
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"33333");
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"第%ld区",(long)section];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 128;
    }
    
    if (indexPath.section == 3 && indexPath.row == 1) {
        return 200;
    }
    
    if (self.dicH[indexPath]) {
        NSNumber *num = self.dicH[indexPath];
        return [num floatValue];
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.contentMode = UIViewContentModeCenter;
    imgView.image = [UIImage imageNamed:@"ser_b1"];
    imgView.frame = CGRectMake(0, 0, screenW, 40);
    return imgView;
    
}


-(void)uodataTableViewCellHight:(D_TableViewCell *)cell andHight:(CGFloat)hight andIndexPath:(NSIndexPath *)indexPath{
    
    if (![self.dicH[indexPath] isEqualToNumber: @(hight)]) {
        self.dicH[indexPath] = @(hight);
        NSLog(@"indexPath.row = %ld",indexPath.section);
        NSLog(@"高度 = %lf",[@(hight) floatValue]);
        [self.tableView reloadData];
    }
}
- (NSMutableDictionary *)dicH {
    if(_dicH == nil) {
        _dicH = [[NSMutableDictionary alloc] init];
    }
    return _dicH;
}

- (UICollectionView*)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection =     UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, screenW, screenH - 64- 49) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"S_M_CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"S_M_CollectionCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"CollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionReusableView"];
        CGFloat rgb = 244/255.0;
        _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];

    }
    return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataCollectArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    S_M_CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"S_M_CollectionCell" forIndexPath:indexPath];
    cell.baseInfoDic = self.dataCollectArr[indexPath.item];
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

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset" context:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
