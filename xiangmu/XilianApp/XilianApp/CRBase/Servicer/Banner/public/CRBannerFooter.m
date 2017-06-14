//
//  CRBannerFooter.m
//  XilianApp
//
//  Created by Abyss on 2017/3/8.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRBannerFooter.h"
#import "CRBanner.h"

static NSString* Default_BannerArrow = nil;
static float Default_BannerArrowSide = 15;

@implementation CRBannerFooter


@synthesize idleTitle = _idleTitle;
@synthesize triggerTitle = _triggerTitle;

+ (void)setDefaultArrow:(NSString *)arrow side:(float)side
{
    if (arrow) Default_BannerArrow = arrow;
    Default_BannerArrowSide = side;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        [self addSubview:self.arrowView];
        [self addSubview:self.label];
        
        self.arrowView.image = [UIImage imageNamed:Default_BannerArrow];
        self.state = CRBannerFooterStateIdle;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat arrowX = self.bounds.size.width / 2 - Default_BannerArrowSide - 2;
    CGFloat arrowY = self.bounds.size.height / 2 - Default_BannerArrowSide / 2;
    CGFloat arrowW = Default_BannerArrowSide;
    CGFloat arrowH = Default_BannerArrowSide;
    self.arrowView.frame = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    
    CGFloat labelX = self.bounds.size.width / 2 + 2;
    CGFloat labelY = 0;
    CGFloat labelW = Default_BannerArrowSide;
    CGFloat labelH = self.bounds.size.height;
    self.label.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

#pragma mark - setters & getters

- (void)setState:(CRBannerFooterState)state
{
    _state = state;
    
    switch (state) {
        case CRBannerFooterStateIdle:
        {
            self.label.text = self.idleTitle;
            [UIView animateWithDuration:0.3 animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0);
            }];
            
        }
            break;
        case CRBannerFooterStateTrigger:
        {
            self.label.text = self.triggerTitle;
            [UIView animateWithDuration:0.3 animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
    }
    return _arrowView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:13];
        _label.textColor = [UIColor darkGrayColor];
        _label.numberOfLines = 0;
    }
    return _label;
}

- (void)setIdleTitle:(NSString *)idleTitle
{
    _idleTitle = idleTitle;
    
    if (self.state == CRBannerFooterStateIdle) {
        self.label.text = idleTitle;
    }
}

- (NSString *)idleTitle
{
    if (!_idleTitle) {
        _idleTitle = @"拖动查看详情"; // default
    }
    return _idleTitle;
}

- (void)setTriggerTitle:(NSString *)triggerTitle
{
    _triggerTitle = triggerTitle;
    
    if (self.state == CRBannerFooterStateTrigger) {
        self.label.text = triggerTitle;
    }
}

- (NSString *)triggerTitle
{
    if (!_triggerTitle) {
        _triggerTitle = @"释放查看详情"; // default
    }
    return _triggerTitle;
}

@end
