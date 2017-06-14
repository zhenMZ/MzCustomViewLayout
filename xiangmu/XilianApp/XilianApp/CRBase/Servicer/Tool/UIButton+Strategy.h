//
//  UIButton+ImagePosition.h
//  XilianApp
//
//  Created by MZ on 2017/4/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImagePosition) {
    MZImagePositionLeft     = 0,  //图片在左，文字在右，默认
    MZImagePositionRight    = 1,  //图片在右，文字在左
    MZImagePositionTop      = 2,
    MZImagePositionBottom   = 3,
    
    
};



@interface UIButton (Strategy)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)zm_setImagePosition:(ImagePosition)position spacing:(CGFloat)spacing;

/**
 风火轮类型的按钮，点击请求风火轮转动，按钮同时禁用

 @param title 标题
 */
- (void)zm_beginSubmitting:(NSString *)title;

/**
 结束风火轮状态
 */
- (void)zm_endSubmitting;

@property (nonatomic, readonly, getter=isSubmiting) NSNumber *submiting;


/**
 倒计时按钮（获取验证码使用）根据需求以后再改

 @param timeout 总共的秒数
 @param title 倒计时结束显示的标题（注意:此标题会改变原有标题的）
 @param waitTitle 伴随着倒计时一起显示的标题（左边倒计时，右边此标题，倒计时结束后消失）
 */
- (void)zm_startTime:(NSInteger)timeout title:(NSString *)title waitTitle:(NSString *)waitTitle;


@end
