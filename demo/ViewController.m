//
//  ViewController.m
//  demo
//
//  Created by MZ on 2017/5/16.
//  Copyright © 2017年 zgxl. All rights reserved.
//

#import "ViewController.h"
#import "MzCustomViewLayout.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic)UICollectionView *collection;
@property (strong, nonatomic)MzCustomViewLayout *layout;
@property (strong, nonatomic)NSArray *dataArr;
@end

@implementation ViewController

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr =
                     @[@{@"type":@"3"},@{@"type":@"3"},@{@"type":@"3"},@{@"type":@"3"},@{@"type":@"4"},@{@"type":@"8"},@{@"type":@"8"},
                       @{@"type":@"3"},@{@"type":@"6"},@{@"type":@"3"},@{@"type":@"3"},@{@"type":@"3"},@{@"type":@"6"},@{@"type":@"3"},@{@"type":@"3"},@{@"type":@"3"},@{@"type":@"3"}];
                  
    }
    return _dataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    [self.collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"testCell"];
    
    self.collection.collectionViewLayout = self.layout;
    [self.view addSubview:self.collection];
    // 主线程延迟执行：
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.collection reloadData];
        
        
    });

}
#pragma mark UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld %ld\n",(long)indexPath.section,(long)indexPath.row);
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"testCell" forIndexPath:indexPath];
    cell.contentView.layer.borderWidth = 0.5;
    cell.contentView.layer.borderColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1].CGColor;
    return cell;
}

#pragma mark - getter & setter
- (MzCustomViewLayout *)layout {
    if (!_layout) {
        _layout = [[MzCustomViewLayout alloc]init];
        _layout.rowSpacing = 0;
        _layout.lineSpacing = 0;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _layout.ColOfPortrait = 12;
        
        [_layout getCollectionItemSizeWithBlock:^CGSize(NSIndexPath *indexPath) {
            
            NSDictionary *dic = self.dataArr[indexPath.row];
            int index = [dic[@"type"] intValue];
            
            CGFloat width = self.collection.frame.size.width/12;
            switch (index) {
                case 1:
                {
                    return CGSizeMake(width, 60);
                }
                    break;
                case 2:
                {
                    return CGSizeMake(width*2, 60);//0.125
                }
                    break;
                case 3:
                {
                    return CGSizeMake(width*3, 60);
                    
                    
                }
                    break;
                case 4:
                {
                    return CGSizeMake(width*4, 120);
                    
                    
                }
                    break;
                case 6:
                {
                    return CGSizeMake(width*6, 120);
                    
                    
                }
                    break;
                case 8:
                {
                    return CGSizeMake(width*8, 60);
                    
                    
                }
                    break;
                case 9:
                {
                    return CGSizeMake(width*9, 60);
                    
                    
                }
                    break;
                case 12:
                {
                    return CGSizeMake(width*12, 60);
                    
                    
                }
                    break;
                default:
                {
                    return CGSizeZero;
                }
                    break;
            }
        }];
        
    }
    return _layout;
}

-(UICollectionView *)collection
{
    if (!_collection) {
        _collection = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.showsVerticalScrollIndicator = NO;
    }
    return _collection;
}




@end
