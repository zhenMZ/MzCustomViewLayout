//
//  UIButton+ImagePosition.m
//  XilianApp
//
//  Created by MZ on 2017/4/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UIButton+Strategy.h"
#import <objc/runtime.h>

@interface UIButton ()
@property (nonatomic, strong) UIView *mz_modelView;
@property(nonatomic, strong) UIActivityIndicatorView *mz_spinnerView;
@property(nonatomic, strong) UILabel *mz_spinnerTitleLabel;

@end

@implementation UIButton (Strategy)

- (void)zm_setImagePosition:(ImagePosition)position spacing:(CGFloat)spacing {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    switch (position) {
        case MZImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            break;
            
        case MZImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing/2), 0, imageHeight + spacing/2);
            break;
            
        case MZImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;
            
        case MZImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;
            
        default:
            break;
    }
}

- (void)zm_beginSubmitting:(NSString *)title {
    [self zm_endSubmitting];
    
    self.submiting = @YES;
    self.hidden = YES;
    
    self.mz_modelView = [[UIView alloc] initWithFrame:self.frame];
    self.mz_modelView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.6];
    self.mz_modelView.layer.cornerRadius = self.layer.cornerRadius;
    self.mz_modelView.layer.borderWidth = self.layer.borderWidth;
    self.mz_modelView.layer.borderColor = self.layer.borderColor;
    
    CGRect viewBounds = self.mz_modelView.bounds;
    self.mz_spinnerView = [[UIActivityIndicatorView alloc]
                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.mz_spinnerView.tintColor = self.titleLabel.textColor;
    
    CGRect spinnerViewBounds = self.mz_spinnerView.bounds;
    
    if (title == nil || [title isEqualToString:@""]) {
        self.mz_spinnerView.frame = CGRectMake(
                                               viewBounds.size.width / 2 - spinnerViewBounds.size.width / 2, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                               spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    }else{
        self.mz_spinnerView.frame = CGRectMake(
                                               15, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                               spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    }
    
    self.mz_spinnerTitleLabel = [[UILabel alloc] init];
    self.mz_spinnerTitleLabel.frame = viewBounds;
    self.mz_spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.mz_spinnerTitleLabel.text = title;
    self.mz_spinnerTitleLabel.font = self.titleLabel.font;
    self.mz_spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.mz_modelView addSubview:self.mz_spinnerView];
    [self.mz_modelView addSubview:self.mz_spinnerTitleLabel];
    [self.superview addSubview:self.mz_modelView];
    [self.mz_spinnerView startAnimating];
    
    
}

- (void)zm_endSubmitting {
    
    if (!self.isSubmiting.boolValue) {
        return;
    }
    
    self.submiting = @NO;
    self.hidden = NO;
    
    [self.mz_modelView removeFromSuperview];
    self.mz_modelView = nil;
    self.mz_spinnerView = nil;
    self.mz_spinnerTitleLabel = nil;
    
}

- (NSNumber *)isSubmiting {
    return objc_getAssociatedObject(self, @selector(setSubmiting:));
}

- (void)setSubmiting:(NSNumber *)submiting {
    objc_setAssociatedObject(self, @selector(setSubmiting:), submiting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)mz_spinnerView {
    return objc_getAssociatedObject(self, @selector(setMz_spinnerView:));
}

- (void)setMz_spinnerView:(UIActivityIndicatorView *)mz_spinnerView {
    objc_setAssociatedObject(self, @selector(setMz_spinnerView:), mz_spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)mz_modelView {
    return objc_getAssociatedObject(self, @selector(setMz_modelView:));
}

- (void)setMz_modelView:(UIView *)mz_modelView {
    objc_setAssociatedObject(self, @selector(setMz_modelView:), mz_modelView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)mz_spinnerTitleLabel {
    return objc_getAssociatedObject(self, @selector(setMz_spinnerTitleLabel:));
}

- (void)setMz_spinnerTitleLabel:(UILabel *)mz_spinnerTitleLabel {
    objc_setAssociatedObject(self, @selector(setMz_spinnerTitleLabel:), mz_spinnerTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)zm_startTime:(NSInteger)timeout title:(NSString *)title waitTitle:(NSString *)waitTitle {
    __block NSInteger timeOut = timeout;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeOut<=0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else
        {
            int secondds = timeOut % 60;
            NSString *starTime = [NSString stringWithFormat:@"%.2d",secondds];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"___ %@",starTime);
                [self setTitle:[NSString stringWithFormat:@"%@%@",starTime,waitTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

















@end
