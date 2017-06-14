//
//  CRBanner.h
//  XilianApp
//
//  Created by Abyss on 2017/3/8.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRBannerFooter.h"
#import "CRPageControl.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CRBannerDataSource, CRBannerDelegate;

/**
 CRBanner
 ImageView的代理
 
 可以直接使用xib创建并设定属性
 */
@interface CRBanner : UIView <UIAppearance>

/** 是否需要循环滚动, 默认为 NO */
@property (assign) IBInspectable BOOL shouldLoop;

/** 是否显示footer, 默认为 NO (此属性为YES时, shouldLoop会被置为NO) */
@property (assign) IBInspectable BOOL showFooter;

/** 是否自动滑动, 默认为 NO */
@property (assign) IBInspectable BOOL autoScroll;

/** 自动滑动间隔时间(s), 默认为 5.0 */
@property (assign) IBInspectable CGFloat scrollInterval;

/** pageControl, 可自由配置其属性 */
@property (strong) CRPageControl *pageControl;

@property (weak) IBOutlet id<CRBannerDataSource> dataSource;
@property (weak) IBOutlet id<CRBannerDelegate> delegate;

- (void)reloadData;

- (void)startTimer;
- (void)stopTimer;

@end

@protocol CRBannerDataSource <NSObject>
@required

- (NSInteger)numberOfItemsInBanner:(CRBanner *)banner;
- (UIView *)banner:(CRBanner *)banner viewForItemAtIndex:(NSInteger)index;

@optional

- (NSString *)banner:(CRBanner *)banner titleForFooterWithState:(CRBannerFooterState)footerState;

@end

@protocol CRBannerDelegate <NSObject>
@optional

- (void)banner:(CRBanner *)banner didSelectItemAtIndex:(NSInteger)index;
- (void)bannerFooterDidTrigger:(CRBanner *)banner;

@end
NS_ASSUME_NONNULL_END
