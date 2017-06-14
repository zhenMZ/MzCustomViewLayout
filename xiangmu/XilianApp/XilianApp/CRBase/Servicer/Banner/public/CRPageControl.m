//
//  CRPageControl.m
//  testappdomain
//
//  Created by Abyss on 2017/3/8.
//  Copyright © 2017年 Chongqing Xilian Technology Co., Ltd. All rights reserved.
//

#import "CRPageControl.h"


@implementation CRPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    _strokeWidth        = 0;
    _spacingWidth       = 3;
    _diameterWidth      = 5;
    _pageControlStyle   = CRPageControlStyleDefault;
    _hidesForSinglePage = YES;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapped:)];
    
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)onTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    
    if (touchPoint.x < self.frame.size.width/2)
    {
        self.currentPage -= 1;
    }
    else
    {
        self.currentPage += 1;
    }
    
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)drawRect:(CGRect)rect
{
    if (self.hidesForSinglePage && self.numberOfPages==1)
    {
        return;
    }
    
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    
    CGFloat spacing   = _spacingWidth;
    CGFloat diameter  = _diameterWidth - 2 * _strokeWidth;
    
    if (_pageControlStyle | CRPageControlStyleImage)
    {
        diameter = _diameterWidth;
    }
    else
    {
        
    }
    
    NSInteger total_width = self.numberOfPages*diameter + (self.numberOfPages - 1)*spacing;
    
    
    UIColor *pageIndicatorTintColor = self.pageIndicatorTintColor?:[CRPageControl appearance].pageIndicatorTintColor;
    UIColor *currentPageIndicatorTintColor = self.currentPageIndicatorTintColor?:[CRPageControl appearance].currentPageIndicatorTintColor;
    UIColor *pageIndicatorStrokeColor = self.pageIndicatorStrokeColor?:[CRPageControl appearance].pageIndicatorStrokeColor;
    UIColor *currentPageIndicatorStrokeColor = self.currentPageIndicatorStrokeColor?:[CRPageControl appearance].currentPageIndicatorStrokeColor;
    
    int i;
    for (i=0; i<self.numberOfPages; i++)
    {
        CGFloat x;
        
        switch (_pageControlLocation)
        {
            case CRPageControlLocationLeft:
            {
                x = i * (diameter + spacing);
            }
                break;
            case CRPageControlLocationCenter:
            {
                x = (self.frame.size.width-total_width)/2 + i * (diameter + spacing);
            }
                break;
            case CRPageControlLocationRight:
            {
                x = (self.frame.size.width - total_width - self.edgeWidth) + i * (diameter + spacing);
            }
                break;
            default:
                break;
        }
        
        switch (_pageControlStyle)
        {
            case CRPageControlStyleDefault:
            {
                CGContextSetFillColorWithColor(myContext,
                                               i==_currentPage?
                                               [currentPageIndicatorTintColor CGColor]:[pageIndicatorTintColor CGColor]);
                
                CGContextFillEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
                
                CGContextSetStrokeColorWithColor(myContext,
                                                 i==_currentPage?
                                                 [currentPageIndicatorStrokeColor CGColor]:[pageIndicatorStrokeColor CGColor]);
                
                CGContextStrokeEllipseInRect(myContext, CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter));
            }
                break;
            case CRPageControlStyleImage:
            {
                UIImage* indicatorImage = [self indicatorImageForIndex:i];
                UIImage* currentIndicatorImage = [self currentIndicatorImageForIndex:i];
                
                if (indicatorImage && currentIndicatorImage)
                {
                    [i==self.currentPage?currentIndicatorImage:indicatorImage drawInRect:CGRectMake(x,(self.frame.size.height-diameter)/2,diameter,diameter)];
                }
            }
                break;
            default:
                break;
        }
        
    }
}

- (void)setPageControlStyle:(CRPageControlStyle)style
{
    _pageControlStyle = style;
    
    [self setNeedsDisplay];
}

- (void)setCurrentPage:(NSInteger)page
{
    if (_numberOfPages == 0) return;
    
    if (page >= _numberOfPages) page = 0;
    else if (page < 0) page = _numberOfPages - 1;
    
    _currentPage = page;
    
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)numOfPages
{
    _numberOfPages = numOfPages;
    
    [self setNeedsDisplay];
}

- (void)setIndicatorImage:(UIImage *)aIndicatorImge forIndex:(NSInteger)index
{
    if (!self.indicatorImageForIndex) [self setIndicatorImageForIndex:[NSMutableDictionary dictionary]];
    
    if(aIndicatorImge)
        [self.indicatorImageForIndex setObject:aIndicatorImge forKey:@(index)];
    else
        [self.indicatorImageForIndex removeObjectForKey:@(index)];
    
    [self setNeedsDisplay];
}

- (UIImage *)indicatorImageForIndex:(NSInteger)index
{
    UIImage* aIndicatorImge = [self.indicatorImageForIndex objectForKey:@(index)];
    if (!aIndicatorImge)
        aIndicatorImge = self.indicatorImage;
    
    return aIndicatorImge;
}

- (void)setCurrentIndicatorImage:(UIImage *)aCurrentIndicatorImage forIndex:(NSInteger)index
{
    if (!self.currentIndicatorImageForIndex) [self setCurrentIndicatorImageForIndex:[NSMutableDictionary dictionary]];
    
    if (aCurrentIndicatorImage)
        [self.currentIndicatorImageForIndex setObject:aCurrentIndicatorImage forKey:@(index)];
    else
        [self.currentIndicatorImageForIndex removeObjectForKey:@(index)];
    
    [self setNeedsDisplay];
}

- (UIImage *)currentIndicatorImageForIndex:(NSInteger)index
{
    UIImage* aCurrentIndicatorImge = [self.currentIndicatorImageForIndex objectForKey:@(index)];
    
    if (!aCurrentIndicatorImge)
        aCurrentIndicatorImge = self.currentIndicatorImage;
    
    return aCurrentIndicatorImge;
}
@end
