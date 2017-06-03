//
//  MzCustomViewLayout.m
//  demo
//
//  Created by MZ on 2017/5/16.
//  Copyright © 2017年 zgxl. All rights reserved.
//

#import "MzCustomViewLayout.h"
#define LayoutHorizontal self.LayoutDirection == Horizontal
#define LayoutVertical   self.LayoutDirection == Vertical
@interface MzCustomViewLayout ()
@property (nonatomic, assign) NSUInteger columnsCount;  //  列数
@property (nonatomic, strong) NSMutableArray *saveColumnHeightArray; // 保存列高度
@property (nonatomic, strong) NSMutableArray *itemsAttributes;      // 保存item位置信息
@property (nonatomic, copy) SizeBlock block;

@end

@implementation MzCustomViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.lineSpacing = 0;
        self.rowSpacing = 0;
        self.columnsCount = 12;
    }
    return self;
}

- (void)prepareLayout {
   
    //根据屏幕方向确定总共需要的列数
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft | orientation ==  UIDeviceOrientationLandscapeRight){
        self.columnsCount = self.ColOfLandscape;
    }else{
        self.columnsCount = self.ColOfPortrait;
    }

    //确定所有item的个数
    NSUInteger itemCounts = [[self collectionView]numberOfItemsInSection:0];
    //初始化保存所有item attributes的数组
    self.itemsAttributes = [NSMutableArray arrayWithCapacity:itemCounts];
    
    //根据列数确定存储列高度的数组容量，全部置0
    self.saveColumnHeightArray = [NSMutableArray arrayWithCapacity:self.columnsCount];
    for (NSInteger i = 0; i<self.columnsCount; i++) {
        [self.saveColumnHeightArray addObject:@(0)];
    }
    
    
    for (NSUInteger i = 0; i < itemCounts; i++) {
        //找到最短列
        NSUInteger shtIndex = [self findShortestColumn];
        
        //x -- 尽可能用整数
        NSUInteger origin_x = LayoutVertical ? shtIndex * [self columnWidth] : [self.saveColumnHeightArray[shtIndex] integerValue];
        //y
        NSUInteger origin_y = LayoutVertical ? [self.saveColumnHeightArray[shtIndex] integerValue] : shtIndex * [self columnWidth];
        
        //width
        NSUInteger size_width = 0.0;

        CGSize size = CGSizeZero;
        if (self.block != nil) {
            size = self.block([NSIndexPath indexPathForRow:i inSection:0]);
        }else{
            NSAssert(size.width != 0 ,@"未实现block");
        }

        size_width = size.width;
        //height
        NSUInteger size_height = 0.0;
        size_height = size.height;

        if (LayoutHorizontal) {
            
            NSUInteger temp = size_width;
            size_width = size_height;
            size_height = temp;
            
            if (size_width != [self columnWidth]) {
                
                for (int i = 0; i < size_width/[self columnWidth]; i ++) {
                    self.saveColumnHeightArray[shtIndex + i] = @(origin_y + size_height);
                }
            }else{
                
                self.saveColumnHeightArray[shtIndex] = @(origin_x + size_width);
                
            }
            
        }else{
            
            if (size_width != [self columnWidth]) {
                
                for (int i = 0; i < size_width/[self columnWidth]; i ++) {
                    self.saveColumnHeightArray[shtIndex + i] = @(origin_y + size_height);
                }
            }else{
                
                self.saveColumnHeightArray[shtIndex] = @(origin_y + size_height);
                
            }
            
        }
        
        
        
        //给attributes.frame 赋值，并存入 self.itemsAttributes
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(origin_x+self.lineSpacing, origin_y+self.rowSpacing, size_width, size_height);
        [self.itemsAttributes addObject:attributes];
        
    }
    
}
- (void)getCollectionItemSizeWithBlock:(CGSize (^)(NSIndexPath *indexPath))block {
    if (self.block != block) {
        self.block = block;
    }
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    
    return self.itemsAttributes;
    
}


-(CGSize)collectionViewContentSize{
    
    CGSize size = self.collectionView.bounds.size;
    NSUInteger longstIndex = [self findLongestColumn];
    float columnMax = [self.saveColumnHeightArray[longstIndex] floatValue];
    if (LayoutVertical) {
        size.height = columnMax;
    }else{
        size.width  = columnMax;
    }
    
    return size;
}


//均分的宽度
- (float)columnWidth{
    
    return LayoutVertical ? self.collectionView.bounds.size.width / self.columnsCount : roundf(self.collectionView.bounds.size.height / self.columnsCount);
    
}

//寻找此时高度最短的列.第一列为0
-(NSUInteger)findShortestColumn{
    
    NSUInteger shortestIndex = 0;
    CGFloat shortestValue = MAXFLOAT;
    
    
    NSUInteger index=0;//游标
    for (NSNumber *columnHeight in self.saveColumnHeightArray) {
        if ([columnHeight floatValue] < shortestValue) {
            shortestValue = [columnHeight floatValue];
            shortestIndex = index;
        }
        index++;
    }
    
    return shortestIndex;
    
}


//寻找此时高度最长的列.第一列为0
-(NSUInteger)findLongestColumn{
    NSUInteger longestIndex = 0;
    CGFloat longestValue = 0;
    
    
    NSUInteger index=0;//游标
    for (NSNumber *columnHeight in self.saveColumnHeightArray) {
        if ([columnHeight floatValue] > longestValue) {
            longestValue = [columnHeight floatValue];
            longestIndex = index;
        }
        index++;
    }
    
    return longestIndex;
    
}


@end
