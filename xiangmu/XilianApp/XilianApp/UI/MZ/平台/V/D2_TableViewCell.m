//
//  D2_TableViewCell.m
//  XilianApp
//
//  Created by MZ on 2017/5/25.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "D2_TableViewCell.h"
#import "MzCustomViewLayout.h"
#import "Masonry.h"
@interface D2_TableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)MzCustomViewLayout *layout;
@property(nonatomic,assign)CGFloat hightED;
@property(nonatomic,strong)UICollectionView *collectionView;
@end


@implementation D2_TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
        self.hightED = 128;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.collectionView.collectionViewLayout = self.layout;
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(128);//先随定一个
        }];
        
        // 主线程延迟执行：
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.collectionView reloadData];
            
            
        });

    }
    return self;
    
    
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection =     UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"testCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}

-(void)setDataArr:(NSArray *)dataArr{
    [self.collectionView reloadData];
    self.hightED = 128; //当重新换数据源的时候 初始化自己的高度. (如果不写 就有一种意外比如 比如一个cell被重用,开始这个cell的collectionView的cell 和重用之后是一样的  self.hightED != hight  重用之前 和重用之后的内容高度 很定是一样的啊 那么他的高度是不用跟新 但是更新tableViewCell的高度的 代理方法还是 要走吧)
    _dataArr = dataArr;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"testCell" forIndexPath:indexPath];
    cell.contentView.layer.borderWidth = 0.5;

    cell.contentView.layer.borderColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1].CGColor;
    return cell;
}

#pragma mark - getter & setter
- (MzCustomViewLayout *)layout {
    if (!_layout) {
        _layout = [[MzCustomViewLayout alloc]init];
        _layout.rowSpacing = 0;
        _layout.lineSpacing = 0;
        _layout.ColOfPortrait = 5;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_layout getCollectionItemSizeWithBlock:^CGSize(NSIndexPath *indexPath) {
 
        CGFloat width = self.collectionView.frame.size.width/5;
        return CGSizeMake(width, width);
        }];
 
    }
    return _layout;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
