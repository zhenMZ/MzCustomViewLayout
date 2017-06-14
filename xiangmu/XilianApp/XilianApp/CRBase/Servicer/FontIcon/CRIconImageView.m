//
//  CRIconImageView.m
//  XilianApp
//
//  Created by Abyss on 2017/3/8.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRIconImageView.h"
#import "CRFontIconFactory.h"
#import "CRIconAws.h"

@interface CRIconImageView()
@property (nonatomic, strong) CRFontIconFactory *factory;
@end

@implementation CRIconImageView
@synthesize size = _size;
@synthesize iconName = _iconName;
@synthesize ttf = _ttf;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _size = -1.0;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _size = -1.0;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (CRFontIconFactory *)factory
{
    if (!_factory)
    {
        _factory = [CRIconAws new];
        
        if (_size < 0.0)
        {
            [self updateAutomaticSize];
        }
    }
    
    return _factory;
}

- (void)setNeedsUpdateImage
{
    self.image = nil;
    
    if (self.superview && _iconUnichar)
    {
        self.image = [self.factory createImageForIcon:_iconUnichar];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (!self.image && _iconUnichar)
    {
        self.image = [self.factory createImageForIcon:_iconUnichar];
    }
}

- (void)setBounds:(CGRect)bounds
{
    if (_size < 0.0)
    {
        [self updateAutomaticSize];
    }
}

- (void)setIconUnichar:(UniChar)iconUnichar
{
    _iconUnichar = iconUnichar;
    
    [self setNeedsUpdateImage];
}

- (NSString *)iconHex
{
    return [NSString stringWithFormat:@"%02X", _iconUnichar];
}

- (void)setIconHex:(NSString *)iconHex
{
    self.iconUnichar = strtol(iconHex.UTF8String, NULL, 16);
}

- (NSString *)iconName
{
    return _iconName;
}

- (void)setIconName:(NSString *)iconName
{
    if (!self.factory.iconMap[iconName]) return;
    
    _iconName = iconName;
    self.iconUnichar = [self.factory.iconMap[iconName] unsignedShortValue];
}

- (NSString *)ttf
{
    return _ttf;
}

- (void)setTtf:(NSString *)ttf
{
    if(ttf)
    {
        _ttf = ttf;
#warning [TODO] - IconFont Custom 
//        _factory = ???
    }
}

- (void)updateAutomaticSize
{
    assert(_size < 0.0);
    CGSize size = self.bounds.size;
    self.factory.size = size.width < size.height ? size.width : size.height;
    [self setNeedsUpdateImage];
}

- (CGFloat)size
{
    return _size;
}

- (void)setSize:(CGFloat)size
{
    _size = size;
    
    if (size < 0.0)
    {
        [self updateAutomaticSize];
    }
    else
    {
        self.factory.size = size;
        [self setNeedsUpdateImage];
    }
}

- (BOOL)isPadded
{
    return self.factory.padded;
}

- (void)setPadded:(BOOL)padded
{
    self.factory.padded = padded;
    [self setNeedsUpdateImage];
}

- (BOOL)isSquare {
    return self.factory.square;
}

- (void)setSquare:(BOOL)square
{
    self.factory.square = square;
    [self setNeedsUpdateImage];
}

- (UIEdgeInsets)edgeInsets
{
    return self.factory.edgeInsets;
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    self.factory.edgeInsets = edgeInsets;
    [self setNeedsUpdateImage];
}

- (CGFloat)edgeInsetTop {
    return self.edgeInsets.top;
}

- (void)setEdgeInsetTop:(CGFloat)edgeInsetTop
{
    UIEdgeInsets edgeInsets = self.edgeInsets;
    edgeInsets.top = edgeInsetTop;
    self.edgeInsets = edgeInsets;
}

- (CGFloat)edgeInsetBottom
{
    return self.edgeInsets.bottom;
}

- (void)setEdgeInsetBottom:(CGFloat)edgeInsetBottom
{
    UIEdgeInsets edgeInsets = self.edgeInsets;
    edgeInsets.bottom = edgeInsetBottom;
    self.edgeInsets = edgeInsets;
}

- (CGFloat)edgeInsetLeft
{
    return self.edgeInsets.left;
}

- (void)setEdgeInsetLeft:(CGFloat)edgeInsetLeft
{
    UIEdgeInsets edgeInsets = self.edgeInsets;
    edgeInsets.left = edgeInsetLeft;
    self.edgeInsets = edgeInsets;
}

- (CGFloat)edgeInsetRight {
    return self.edgeInsets.right;
}

- (void)setEdgeInsetRight:(CGFloat)edgeInsetRight
{
    UIEdgeInsets edgeInsets = self.edgeInsets;
    edgeInsets.right = edgeInsetRight;
    self.edgeInsets = edgeInsets;
}

- (NSArray<UIColor *> *)colors
{
    return self.factory.colors;
}

- (void)setColors:(NSArray<UIColor *> *)colors
{
    self.factory.colors = [colors copy];
    [self setNeedsUpdateImage];
}

- (UIColor *)color
{
    return self.colors[0];
}

- (void)setColor:(UIColor *)color
{
    UIColor *color2 = self.color2;
    
    if (color2)
    {
        self.colors = @[color, color2];
    }
    else
    {
        self.colors = @[color];
    }
}

- (UIColor *)color2
{
    return self.colors.count > 1 ? self.colors[1] : nil;
}

- (void)setColor2:(UIColor *)color2
{
    self.colors = @[self.color, color2];
}

- (UIColor *)strokeColor
{
    return self.factory.strokeColor;
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    self.factory.strokeColor = [strokeColor copy];
    [self setNeedsUpdateImage];
}

- (CGFloat)strokeWidth
{
    return self.factory.strokeWidth;
}

- (void)setStrokeWidth:(CGFloat)strokeWidth
{
    self.factory.strokeWidth = strokeWidth;
    [self setNeedsUpdateImage];
}

- (UIImageRenderingMode)renderingMode
{
    return self.factory.renderingMode;
}

- (void)setRenderingMode:(UIImageRenderingMode)renderingMode
{
    self.factory.renderingMode = renderingMode;
    [self setNeedsUpdateImage];
}

@end
@implementation CRIconImageView (Category)
@end
