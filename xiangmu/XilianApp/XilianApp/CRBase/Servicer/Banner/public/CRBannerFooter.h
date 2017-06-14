//
//  CRBannerFooter.h
//  XilianApp
//
//  Created by Abyss on 2017/3/8.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CRBannerFooterState) {
    CRBannerFooterStateIdle = 0,    // 正常状态下的footer提示
    CRBannerFooterStateTrigger,     // 被拖至触发点的footer提示
};

NS_ASSUME_NONNULL_BEGIN

@interface CRBannerFooter : UICollectionReusableView

@property (nonatomic, assign) CRBannerFooterState state;

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, copy) NSString *idleTitle;
@property (nonatomic, copy) NSString *triggerTitle;

+ (void)setDefaultArrow:(NSString *)arrow side:(float)side;

@end

NS_ASSUME_NONNULL_END
