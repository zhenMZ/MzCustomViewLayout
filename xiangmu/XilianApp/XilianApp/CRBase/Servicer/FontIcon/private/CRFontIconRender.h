//
//  CRFontIconRender.h
//  XilianApp
//
//  Created by Abyss on 2017/3/9.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CRFontIconRender : NSObject

@property (nonatomic, assign) CGPathRef path;
@property (nonatomic, assign) CGPoint offset;

@property (nonatomic, copy) NSArray<UIColor *> *colors;
@property (nonatomic, assign) CGColorRef strokeColor;
@property (nonatomic, assign) CGFloat strokeWidth;

- (void)renderInContext:(CGContextRef)context;

@end

NS_ASSUME_NONNULL_END
