//
//  CRIconImageView.h
//  XilianApp
//
//  Created by Abyss on 2017/3/8.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CREFontIcon.h"

#define CRImageView CRIconImageView
NS_ASSUME_NONNULL_BEGIN

/**
 CRIconImageView
 可以直接使用xib创建并设定属性
 */
IB_DESIGNABLE
@interface CRIconImageView : UIImageView <CREFontIcon>

@property (nonatomic, assign) IBInspectable UniChar iconUnichar;
@property (nonatomic, assign) IBInspectable NSString* iconHex;
@property (nonatomic, copy) IBInspectable NSString* iconName;

@property (nonatomic, copy, nullable) IBInspectable NSString    *ttf;

@property (nonatomic, assign) IBInspectable CGFloat size;

@property (nonatomic, assign, getter=isPadded) IBInspectable BOOL padded;
@property (nonatomic, assign, getter=isSquare) IBInspectable BOOL square;

@property (nonatomic, assign) IBInspectable CGFloat edgeInsetTop;
@property (nonatomic, assign) IBInspectable CGFloat edgeInsetBottom;
@property (nonatomic, assign) IBInspectable CGFloat edgeInsetLeft;
@property (nonatomic, assign) IBInspectable CGFloat edgeInsetRight;

@property (nonatomic, copy) IBInspectable UIColor *color;
#if __has_feature(nullability)
@property (nonatomic, copy, nullable) IBInspectable UIColor *color2;
#else
@property (nonatomic, copy) IBInspectable UIColor *color2;
#endif

@property (nonatomic, copy) IBInspectable UIColor *strokeColor;
@property (nonatomic, assign) IBInspectable CGFloat strokeWidth;

@end

@interface CRIconImageView (Category)
@end
NS_ASSUME_NONNULL_END
