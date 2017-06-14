//
//  UIView+Tool.h
//  XilianApp
//
//  Created by Abyss on 2017/3/6.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Tool)

@property CGSize size;

@property CGPoint origin;

@property CGFloat width;
@property CGFloat height;

@property CGFloat top;
@property CGFloat left;
@property CGFloat right;
@property CGFloat bottom;

@property CGFloat x;
@property CGFloat y;
@property CGFloat w;
@property CGFloat h;

/** 轻微圆角 */
- (void)setRoundCorner;
/** 圆 */
- (void)setRoundCornerAll;
/** 旋转 */
- (void)setAnimateRotationWith:(CGFloat)rate;
/** 边界 */
- (void)setBorderWithColor:(UIColor *)color;
/** 居中 */
- (void)centerToParent;

- (void)addSubviews:(UIView *)view,...NS_REQUIRES_NIL_TERMINATION;
- (void)removeAllSubviews;

-(BOOL)containsSubView:(UIView *)subView;
-(BOOL)containsSubViewOfClassType:(Class)anyClass;

@end
