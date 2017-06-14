//
//  D_TableViewCell.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "D_TableViewCell.h"
#import "Masonry.h"
#import "S_M_CollectionCell.h"
#import "MzCustomViewLayout.h"

@interface D_TableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)MzCustomViewLayout *layout;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,assign)CGFloat hightED;

@end
@implementation D_TableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self.hightED = 0.0;
    

    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //        self.lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.collectionView.collectionViewLayout = self.layout;

        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(50);//先随定一个
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
    self.hightED = 0; //当重新换数据源的时候 初始化自己的高度. (如果不写 就有一种意外比如 比如一个cell被重用,开始这个cell的collectionView的cell 和重用之后是一样的  self.hightED != hight  重用之前 和重用之后的内容高度 很定是一样的啊 那么他的高度是不用跟新 但是更新tableViewCell的高度的 代理方法还是 要走吧)
    _dataArr = dataArr;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld %ld\n",(long)indexPath.section,(long)indexPath.row);
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"testCell" forIndexPath:indexPath];
    cell.contentView.layer.borderWidth = 0.5;
    cell.contentView.layer.borderColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1].CGColor;
    [self updateCollectionViewHight:self.collectionView.collectionViewLayout.collectionViewContentSize.height];
    return cell;
}

#pragma mark - getter & setter
- (MzCustomViewLayout *)layout {
    if (!_layout) {
        _layout = [[MzCustomViewLayout alloc]init];
        _layout.rowSpacing = 0;
        _layout.lineSpacing = 0;
        _layout.ColOfPortrait = 12;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_layout getCollectionItemSizeWithBlock:^CGSize(NSIndexPath *indexPath) {
            
            NSDictionary *dic = self.dataArr[indexPath.row];
            
            int indexW = [dic[@"w"] intValue];
            int indexH = [dic[@"h"] intValue];
            
            CGFloat width = self.collectionView.frame.size.width/12;
            return CGSizeMake(indexW*width, indexH*60);
//            switch (index) {
//                case 1:
//                {
//                    return CGSizeMake(width, 60);
//                }
//                    break;
//                case 2:
//                {
//                    return CGSizeMake(width*2, 60);//0.125
//                }
//                    break;
//                case 3:
//                {
//                    return CGSizeMake(width*3, 60);
//                    
//                    
//                }
//                    break;
//                case 4:
//                {
//                    return CGSizeMake(width*4, 120);
//                    
//                    
//                }
//                    break;
//                case 6:
//                {
//                    return CGSizeMake(width*6, 60);
//                    
//                    
//                }
//                    break;
//                case 8:
//                {
//                    return CGSizeMake(width*8, 60);
//                    
//                    
//                }
//                    break;
//                case 9:
//                {
//                    return CGSizeMake(width*9, 60);
//                    
//                    
//                }
//                    break;
//                case 12:
//                {
//                    return CGSizeMake(width*12, 60);
//                    
//                    
//                }
//                    break;
//                default:
//                {
//                    return CGSizeZero;
//                }
//                    break;
//            }
        }];

        
        
    }
    return _layout;
}

-(void)updateCollectionViewHight:(CGFloat)hight{
    
//    NSLog(@"+%@",self);
//    NSLog(@"++ %f",self.hightED);
//    NSLog(@"+++ %f",hight);
//    
    if (self.hightED != hight) { //这个判断起到两个作用 第一 以为这个方法被调用多次这样写 保证 每个cell里面调用一次,切只调用一次  第二是当cell被重用从用的cell上的collectionView内容高度不一样的时候重新 更新跟新高度
        self.hightED = hight;
        
        NSLog(@"+++++%ld",self.indexPath.row);
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(hight);
        }];
        
        if (_deleget && [_deleget respondsToSelector:@selector(uodataTableViewCellHight:andHight:andIndexPath:)]) {
            [self.deleget uodataTableViewCellHight:self andHight:hight andIndexPath:self.indexPath];
        }
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
