//
//  ZBlankPageView.m
//  XilianApp
//
//  Created by MZ on 2017/5/27.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "ZBlankPageView.h"
#import "Masonry.h"
#import "UIView+Tool.h"
@implementation ZBlankPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configWithType:(ZBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block {
    
    if (hasData) {
        [self removeFromSuperview]; return;
    }
    
    self.alpha = 1.0;
    
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
        [self addSubview:_showImageView];
    }
    
    if (!_tipLable) {
        _tipLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLable.numberOfLines = 0;
        _tipLable.font = [UIFont systemFontOfSize:15];
        _tipLable.textColor = [UIColor grayColor];
        _tipLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLable];
    }
    
    [_showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_top).with.offset(100);
    }];
    [_tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self);
        make.top.equalTo(_showImageView.mas_bottom);
        make.height.mas_equalTo(50);
    }];

    
    
    
    _reloadButtonBlock = nil;
    
    if (_reloadButton) {
        _reloadButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_reloadButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton.adjustsImageWhenHighlighted = YES;
        [self addSubview:_reloadButton];
        [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_tipLable.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(130, 40));
        }];

        
    }
    _reloadButton.hidden = NO;
    _reloadButtonBlock = block;
    
    if (hasError) {
        
        [_showImageView setImage:[UIImage imageNamed:@""]];
        _tipLable.text = @"不爽，网太P了";
        
        if (blankPageType==EaseBlankPageTypeMaterialScheduling) {
            _reloadButton.hidden=YES;
        }else {
            if (_reloadButton) {
                _reloadButton.hidden = NO;
            }
            NSString *imageName, *tipStr;
            switch (blankPageType) {
                case EaseBlankPageTypeProject:
                {
                    imageName = @"";
                    tipStr = @"服务器没有数据";
                }
                    break;
                case EaseBlankPageTypeNoButton:
                {
                    imageName = @"";
                    tipStr = @"卧槽，每数据了";
                    if (_reloadButton) {
                        _reloadButton.hidden = YES;
                    }
                }
                    break;
                default://其它页面（这里没有提到的页面，都属于其它）
                {
                    imageName = @"";
                    tipStr = @"当前还未有数据";
                }
                    break;
            }
            [_showImageView setImage:[UIImage imageNamed:imageName]];
            _tipLable.text = tipStr;

        }

    }

    
}
- (void)reloadButtonClick:(id)sender{
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_reloadButtonBlock) {
            _reloadButtonBlock(sender);
        }
    });
}


@end
