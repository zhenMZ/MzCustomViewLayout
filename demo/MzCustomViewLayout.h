//
//  MzCustomViewLayout.h
//  demo
//
//  Created by MZ on 2017/5/16.
//  Copyright © 2017年 zgxl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGSize(^SizeBlock)(NSIndexPath *indexPath);

typedef enum : NSUInteger {
    Vertical, // 0
    Horizontal, // 1
} MzCustomViewLayoutDirection;

IB_DESIGNABLE
@interface MzCustomViewLayout : UICollectionViewLayout

/** 行间距 */
@property (nonatomic, assign) CGFloat rowSpacing;
/** 列间距 */
@property (nonatomic, assign) CGFloat lineSpacing;
/** 内边距 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property(nonatomic,assign)IBInspectable NSUInteger ColOfPortrait;

@property(nonatomic,assign)IBInspectable NSUInteger ColOfLandscape;

@property(nonatomic,assign)IBInspectable MzCustomViewLayoutDirection LayoutDirection;

- (void)getCollectionItemSizeWithBlock:(CGSize (^)(NSIndexPath *indexPath))block;

@end
