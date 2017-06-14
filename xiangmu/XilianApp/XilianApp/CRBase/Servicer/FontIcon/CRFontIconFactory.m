//
//  CRFontIconFactory.m
//  XilianApp
//
//  Created by Abyss on 2017/3/9.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRFontIconFactory.h"
#import "CRFontIconLoader.h"
#import "CRFontIconRender.h"

@implementation CRFontIconFactory

@synthesize size = _size;
@synthesize edgeInsets = _edgeInsets;
@synthesize padded = _padded;
@synthesize square = _square;
@synthesize colors = _colors;
@synthesize strokeColor = _strokeColor;
@synthesize strokeWidth = _strokeWidth;
@synthesize renderingMode = _renderingMode;


- (id)init
{
    self = [super init];
    if (self) {
        _size = 32.0;
        _padded = YES;
        _colors = @[[UIColor darkGrayColor]];
        _strokeColor = [UIColor blackColor];
        _strokeWidth = 0.0;
    }
    return self;
}

- (void)setColors:(NSArray<UIColor *> *)colors
{
    _colors = [colors copy];

    if (self.renderingMode == UIImageRenderingModeAutomatic)
    {
        self.renderingMode = UIImageRenderingModeAlwaysOriginal;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    CRFontIconFactory *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy != nil)
    {
        copy.size = self.size;
        copy.edgeInsets = self.edgeInsets;
        copy.colors = self.colors;
        copy.strokeColor = self.strokeColor;
        copy.strokeWidth = self.strokeWidth;
    }
    
    return copy;
}

- (UIImage *)createImageForIcon:(UniChar)icon
{
    CGPathRef path = [self createPath:icon];
    UIImage *image = [self createImageWithPath:path];
    CGPathRelease(path);
    
    return image;
}

- (CGPathRef)createPath:(UniChar)icon CF_RETURNS_RETAINED
{
    CGFloat paddedSize = _size - _strokeWidth;
    CGFloat width = _square ? paddedSize : CGFLOAT_MAX;
    
    
    return [[CRFontIconLoader new] loadIcon:icon heiht:paddedSize maxWidth:width name:self.defaultName];
}

- (UIImage *)createImageWithPath:(CGPathRef)path
{
    CGRect bounds = CGPathGetBoundingBox(path);
    CGSize imageSize = bounds.size;
    CGPoint offset = CGPointZero;
    
    // remove leading padding
    offset.x = -bounds.origin.x;
    if (_padded)
    {
        imageSize.height = _size;
        imageSize.width += _strokeWidth;
    }
    else
    {
        // remove vertical padding
        offset.y = -bounds.origin.y;
        assert(imageSize.height <= _size + 0.01);
    }
    
    imageSize = [self roundImageSize:imageSize];
    
    if (_square)
    {
        CGFloat diff = imageSize.height - imageSize.width;
        if (diff > 0)
        {
            offset.x += .5 * diff;
            imageSize.width = imageSize.height;
        }
        else
        {
            offset.y += .5 * -diff;
            imageSize.height = imageSize.width;
        }
    };
    
    CGFloat padding = _strokeWidth * .5;
    offset.x += padding + _edgeInsets.left;
    offset.y += padding + _edgeInsets.bottom;
    imageSize.width += _edgeInsets.left + _edgeInsets.right;
    imageSize.height += _edgeInsets.top + _edgeInsets.bottom;
    
    CRFontIconRender *renderer = [self createRenderer:path];
    renderer.offset = offset;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, imageSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [renderer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if ([image respondsToSelector:@selector(renderingMode)])
    {
        if (image.renderingMode != _renderingMode)
        {
            image = [image imageWithRenderingMode:_renderingMode];
        }
    }
    
    return image;
}

- (CGSize)roundImageSize:(CGSize)size
{
    // Prevent +1 on values that are slightly too big (e.g. 24.000001).
    static const float EPSILON = 0.01;
    return CGSizeMake(ceil(size.width - EPSILON), ceil(size.height - EPSILON));
}

- (CRFontIconRender *)createRenderer:(CGPathRef)path
{
    CRFontIconRender *renderer = [CRFontIconRender new];
    renderer.path = path;
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:_colors.count];
    for (UIColor *color in _colors) {
        CGColorRef cgColor = CGColorCreateCopy(color.CGColor);
        [colors addObject:(__bridge id) cgColor];
        CGColorRelease(cgColor);
    }
    renderer.colors = colors;
    CGColorRef cgColor = CGColorCreateCopy(_strokeColor.CGColor);
    renderer.strokeColor = cgColor;
    CGColorRelease(cgColor);
    renderer.strokeWidth = _strokeWidth;
    
    return renderer;
}

- (NSString *)defaultName {return nil;}
- (NSDictionary *)iconMap {return nil;}
- (UIImage *)createImageForIconName:(NSString *)name {return nil;}

@end
