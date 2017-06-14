//
//  CRPageControl.h
//  testappdomain
//
//  Created by Abyss on 2017/3/8.
//  Copyright © 2017年 Chongqing Xilian Technology Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CRPageControlStyle)
{
    CRPageControlStyleDefault   = 0,
    CRPageControlStyleImage     = 1,    
};

typedef NS_ENUM(NSInteger, CRPageControlLocation)
{
    CRPageControlLocationCenter = 0,
    CRPageControlLocationLeft   = 1,
    CRPageControlLocationRight  = 2,
};

@interface CRPageControl : UIControl <UIAppearance>

/** 颜色, 兼容UIPageControl的APPEARANCE */
@property (strong) UIColor *pageIndicatorTintColor UI_APPEARANCE_SELECTOR;
/** 选中颜色, 兼容UIPageControl的APPEARANCE */
@property (strong) UIColor *currentPageIndicatorTintColor UI_APPEARANCE_SELECTOR;

/** 边线 */
@property (strong) UIColor* pageIndicatorStrokeColor;
@property (strong) UIColor* currentPageIndicatorStrokeColor;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;

/** 隐藏PageControl When numberOfPages = 1 默认YES */
@property (nonatomic, assign) BOOL hidesForSinglePage;

@property (nonatomic, assign) CRPageControlStyle pageControlStyle;
@property (nonatomic, assign) CRPageControlLocation pageControlLocation;

@property (assign) NSInteger strokeWidth;
@property (assign) NSInteger spacingWidth;
@property (assign) NSInteger diameterWidth;
@property (assign) NSInteger edgeWidth;

@property (strong) UIImage *indicatorImage, *currentIndicatorImage;
@property (strong) NSMutableDictionary *indicatorImageForIndex, *currentIndicatorImageForIndex;

- (void)setIndicatorImage:(UIImage *)aIndicatorImge forIndex:(NSInteger)index;
- (UIImage *)indicatorImageForIndex:(NSInteger)index;
- (void)setCurrentIndicatorImage:(UIImage *)aCurrentIndicatorImage forIndex:(NSInteger)index;
- (UIImage *)currentIndicatorImageForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
