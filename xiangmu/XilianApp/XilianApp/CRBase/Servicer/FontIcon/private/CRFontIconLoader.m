//
//  CRFontIconLoader.m
//  XilianApp
//
//  Created by Abyss on 2017/3/9.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRFontIconLoader.h"
#import <CoreText/CoreText.h>
#import "CRManager.h"

@implementation CRFontIconLoader

- (CGPathRef)loadIcon:(UniChar)icon
                heiht:(CGFloat)height
             maxWidth:(CGFloat)width
                 name:(NSString * __nullable)name CF_RETURNS_RETAINED;
{
    
    CGPathRef path = [self createPathForIcon:icon height:height name:name];
    
    CGRect bounds = CGPathGetBoundingBox(path);
    static const float EPSILON = 0.01;
    
    if (bounds.size.width > width + EPSILON)
    {
        CGPathRef scaledPath = [self createScaledPath:path scale:width / bounds.size.width];
        CGPathRelease(path);
        path = scaledPath;
        bounds = CGPathGetBoundingBox(path);
    }
    
    if (bounds.size.height > height + EPSILON)
    {
        // Some icons (e.g. odnoklassniki) exceed their bounds.
        // We lose pixel perfection here, but better than clipping.
        CGPathRef scaledPath = [self createScaledPath:path scale:height / bounds.size.height];
        CGPathRelease(path);
        path = scaledPath;
    }
    return path;
}

- (CGPathRef)createPathForIcon:(UniChar)icon
                        height:(CGFloat)height
                          name:(NSString * __nullable)name CF_RETURNS_RETAINED
{
    CTFontRef font = name?[self fontWithName:name]:[self font];
    
    CGFloat fontHeight = CTFontGetSize(font);
    CGAffineTransform scale = CGAffineTransformMakeScale(height / fontHeight,
                                                         height / fontHeight);
    CGAffineTransform transform = CGAffineTransformTranslate(scale, 0, CTFontGetDescent(font));
    
    return CTFontCreatePathForGlyph(font, [self glyphForIcon:icon from:font], &transform);
}

- (CTFontRef)fontWithName:(NSString * __nonnull)name
{
    static CTFontRef __font;
    static dispatch_once_t __onceToken;
    dispatch_once(&__onceToken, ^{
        NSURL *url = [CRManager bundleResourceWith:name extension:@"ttf"];
        NSAssert(url, @"FontIcon not found in bundle.", nil);
        
        CGDataProviderRef provider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
        CGFontRef cgFont = CGFontCreateWithDataProvider(provider);
        CTFontDescriptorRef fontDescriptor =
        CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)@{});
        
        __font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
        
        CFRelease(fontDescriptor);
        CFRelease(cgFont);
        CFRelease(provider);
    });
    return __font;
}

- (CTFontRef)font
{
    static CTFontRef __font;
    static dispatch_once_t __onceToken;
    dispatch_once(&__onceToken, ^{
        NSURL *url = [CRManager bundleResourceWith:@"FontAwesome" extension:@"otf"];
        NSAssert(url, @"Font Awesome not found in bundle.", nil);
        CGDataProviderRef provider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
        CGFontRef cgFont = CGFontCreateWithDataProvider(provider);
        CTFontDescriptorRef fontDescriptor =
        CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)@{});
        
        __font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
        
        CFRelease(fontDescriptor);
        CFRelease(cgFont);
        CFRelease(provider);
    });
    return __font;
}

- (CGPathRef)createScaledPath:(CGPathRef)path scale:(CGFloat)factor CF_RETURNS_RETAINED
{
    CGAffineTransform scale = CGAffineTransformMakeScale(factor, factor);
    return CGPathCreateCopyByTransformingPath(path, &scale);
}

- (CGGlyph)glyphForIcon:(UniChar)icon from:(CTFontRef)font
{
    UniChar const characters[] = {icon};
    CGGlyph glyph;
    CTFontGetGlyphsForCharacters(font, characters, &glyph, 1);
    return glyph;
}


@end
