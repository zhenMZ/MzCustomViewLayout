//
//  UILabel+Strategy.m
//  XilianApp
//
//  Created by MZ on 2017/4/20.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UILabel+Strategy.h"

@implementation UILabel (Strategy)


- (UILabel *)resetSizeLableForHorizontal {
    return [self resetSizeLableForHorizontal:0];
}

- (UILabel *)resetSizeLableForVertical {
    return [self resetSizeLableForVertical:0];
}

- (UILabel *)resetSizeLableForHorizontal:(CGFloat)minWidth {
    CGRect newFrame = self.frame;
    CGSize constainedSize = CGSizeMake(CGFLOAT_MAX, newFrame.size.height);
    NSString *text = self.text;
    UIFont *font = self.font;
    CGSize size = CGSizeZero;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        size = [text boundingRectWithSize:constainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }else{
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED <= 60000)
        size = [text sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    newFrame.size.width = ceil(size.width);
    if (minWidth > 0) {
        newFrame.size.width = (newFrame.size.width < minWidth ? minWidth : newFrame.size.width);
    }
    self.frame = newFrame;
    return self;

}

- (UILabel *)resetSizeLableForVertical:(CGFloat)minHeight {
    CGRect newFrame = self.frame;
    CGSize constrainedSize = CGSizeMake(newFrame.size.width, CGFLOAT_MAX);
    NSString *text = self.text;
    UIFont *font = self.font;
    CGSize size = CGSizeZero;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        size = [text boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }else{
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED <= 60000)
        size = [text sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    newFrame.size.height = ceilf(size.height);
    if(minHeight > 0){
        newFrame.size.height = (newFrame.size.height < minHeight ? minHeight : newFrame.size.height);
    }
    self.frame = newFrame;
    return self;

}

#pragma mark - 
- (void)z_adjustLableToMaxSize:(CGSize)maxSize
                       minSize:(CGSize)minSize
                   minFontSize:(int)minFontSize {
    
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    
    if (maxSize.height == CGSizeZero.height) {
        maxSize.width = [[UIScreen mainScreen] bounds].size.width - 40.0;
        maxSize.height = MAXFLOAT;
    }
    
    CGSize tempSize = [[self text] sizeWithFont:[self font]
                              constrainedToSize:maxSize
                                  lineBreakMode:[self lineBreakMode]];
    
    if (minSize.height != CGSizeZero.height) {
        if (tempSize.width <= minSize.width) tempSize.width = minSize.width;
        if (tempSize.height <= minSize.height) tempSize.height = minSize.height;
    }
    
    CGRect newFrameSize = CGRectMake(  [self frame].origin.x
                                     , [self frame].origin.y
                                     , tempSize.width
                                     , tempSize.height);

    UIFont *labelFont = [self font]; // temporary label object
    CGFloat fSize = [labelFont pointSize]; // temporary font size value
    CGSize calculatedSizeWithCurrentFontSize; // temporary frame size
    
    // Calculate label size as if there was no constrain
    CGSize unconstrainedSize = CGSizeMake(tempSize.width, MAXFLOAT);
    
    // Keep reducing the font size until the calculated frame size
    // is smaller than the maxSize parameter
    do {
        // Create a temporary font object
        labelFont = [UIFont fontWithName:[labelFont fontName]
                                    size:fSize];
        // Calculate the frame size
        calculatedSizeWithCurrentFontSize =
        [[self text] sizeWithFont:labelFont
                constrainedToSize:unconstrainedSize
                    lineBreakMode:NSLineBreakByWordWrapping];
        // Reduce the temporary font size value
        fSize--;
    } while (calculatedSizeWithCurrentFontSize.height > maxSize.height);
    
    // Reset the font size to the last calculated value
    [self setFont:labelFont];
    
    // Reset the frame size
    [self setFrame:newFrameSize];

}

- (void)z_adjustLableToMaxSize:(CGSize)maxSize
                   minFontSize:(int)minFontSize {
    [self z_adjustLableToMaxSize:maxSize minSize:CGSizeZero minFontSize:minFontSize];
}

- (void)z_adjustLableTominFontSize:(int)minFontSize {
    [self z_adjustLableToMaxSize:CGSizeZero minSize:CGSizeZero minFontSize:minFontSize];
}

- (void)z_adjustLable {
    [self z_adjustLableToMaxSize:CGSizeZero minSize:CGSizeZero minFontSize:[self minimumScaleFactor]];
    
}





@end
