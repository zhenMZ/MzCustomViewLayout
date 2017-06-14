//
//  UILabel+Strategy.h
//  XilianApp
//
//  Created by MZ on 2017/4/20.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Strategy)

/**
 垂直方向固定获取动态宽度，最小宽度为0

 @return 返回更新后的lable（其实位置相同）
 */
- (UILabel *)resetSizeLableForHorizontal;

/**
 水平方向固定获取动态高度，最小高度为0
 
 @return 返回更新后的lable（其实位置相同）
 */
- (UILabel *)resetSizeLableForVertical;

/**
  垂直方向固定获取动态宽度，最小宽度为minWidth

 @param minWidth minWidth
 @return 返回更新后的lable（其实位置相同）
 */
- (UILabel *)resetSizeLableForHorizontal:(CGFloat)minWidth;

/**
 水平方向固定获取动态高度，最小高度为minHeight

 @param minHeight minHeight
 @return 返回更新后的lable（其实位置相同）
 */
- (UILabel *)resetSizeLableForVertical:(CGFloat)minHeight;


/**
 限制最大和最小 以及最小字体

 @param maxSize 最大
 @param minSize 最小
 @param minFontSize 最小字体
 */
- (void)z_adjustLableToMaxSize:(CGSize)maxSize
                       minSize:(CGSize)minSize
                   minFontSize:(int)minFontSize;

/**
 最大尺寸，最小字体

 @param maxSize lable最大为多大
 @param minFontSize 字体最小多小
 */
- (void)z_adjustLableToMaxSize:(CGSize)maxSize
                   minFontSize:(int)minFontSize;

/**
 限制最小字体的lable 自适应

 @param minFontSize 字体
 */
- (void)z_adjustLableTominFontSize:(int)minFontSize;

/**
 lable 自适应
 */
- (void)z_adjustLable;

@end
