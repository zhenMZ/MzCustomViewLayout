//
//  CREFontIcon.h
//  XilianApp
//
//  Created by Abyss on 2017/3/9.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CREFontIcon

/** The height in points of the created images. */
@property (nonatomic, assign) CGFloat size;

/** Additional padding added to the created images. */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, assign, getter=isPadded) BOOL padded;

/**
 * Create images to be square?
 *
 * If true, the icon is scaled to fit in a square of "size".
 * If false, "size" determines the icon's height.
 **/
@property (nonatomic, assign, getter=isSquare) BOOL square;

/**
 * Colors for the gradient filling the icon.
 *
 * Array of NSColor/UIColor.
 *
 * Default: dark gray
 */
@property (nonatomic, copy) NSArray<UIColor *> *colors;

/**
 * Color for stroke around the icon.
 *
 * Default: black (but strokeWidth defaults to 0.0)
 */
@property (nonatomic, copy) UIColor *strokeColor;

/**
 * Width for stroke around the icon.
 *
 * Default: 0.0
 */
@property (nonatomic, assign) CGFloat strokeWidth;

/**
 * Rendering mode for the created images.
 *
 * By default, iOS will determine if color information is retained when using the image in a
 * control.  Set this to UIImageRenderingModeAlwaysOriginal to always get color.
 *
 * Default: UIImageRenderingModeAutomatic
 */
@property(nonatomic, assign) UIImageRenderingMode renderingMode NS_AVAILABLE_IOS(7_0);

@end

NS_ASSUME_NONNULL_END
