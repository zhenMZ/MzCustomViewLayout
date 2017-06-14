//
//  UIView+Tool.m
//  XilianApp
//
//  Created by Abyss on 2017/3/6.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UIView+Tool.h"
//#define SCREEN_SCALE ([[UIScreen mainScreen] scale])
#define PIXEL_INTEGRAL(pointValue) pointValue
//(round(pointValue * SCREEN_SCALE) / SCREEN_SCALE)

@implementation UIView (Tool)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)h
{
    return self.height;
}

- (void)setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (void)setH:(CGFloat)h
{
    self.height = h;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)w
{
    return self.width;
}

- (void)setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (void)setW:(CGFloat)w
{
    self.width = w;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)y
{
    return self.top;
}

- (void)setTop:(CGFloat)newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (void)setY:(CGFloat)y
{
    self.top = y;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)x
{
    return self.left;
}

- (void)setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (void)setX:(CGFloat)x
{
    self.left = x;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (void)centerToParent
{
    if(self.superview)
    {
        switch ([UIApplication sharedApplication].statusBarOrientation)
        {
            case UIInterfaceOrientationUnknown:
            {
                //NSLog(@"UIInterfaceOrientationUnknown");
                break;
            }
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
            {
                self.left = PIXEL_INTEGRAL((self.superview.height / 2.0) - (self.width / 2.0));
                self.top = PIXEL_INTEGRAL((self.superview.width / 2.0) - (self.height / 2.0));
                break;
            }
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
            {
                self.left = PIXEL_INTEGRAL((self.superview.width / 2.0) - (self.width / 2.0));
                self.top = PIXEL_INTEGRAL((self.superview.height / 2.0) - (self.height / 2.0));
                break;
            }
        }
    }
}

- (void)addSubviews:(UIView *)view,...
{
    [self addSubview:view];
    va_list ap;
    va_start(ap, view);
    UIView *akey=va_arg(ap,id);
    while (akey) {
        [self addSubview:akey];
        akey=va_arg(ap,id);
    }
    va_end(ap);
}

- (void)removeAllSubviews
{
    while (self.subviews.count)
    {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)setRoundCorner
{
    self.layer.masksToBounds = YES;
    
    self.layer.cornerRadius = 4.0f;
}

- (void)setRoundCornerAll
{
    self.layer.masksToBounds = YES;
    
    self.layer.cornerRadius = self.height/2.0;
}

- (void)setAnimateRotationWith:(CGFloat)rate
{
    __block UIView* v = self;
    [UIView animateWithDuration:1 animations:^(){
        v.transform = CGAffineTransformMakeRotation(M_PI * rate);
    }];
}

- (void)setBorderWithColor:(UIColor *)color
{
    self.layer.masksToBounds = YES;
    
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = color.CGColor;
}

- (BOOL) containsSubView:(UIView *)subView
{
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) containsSubViewOfClassType:(Class)class_r {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:class_r]) {
            return YES;
        }
    }
    return NO;
}

@end
