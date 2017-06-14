//
//  UINavigation+Strategy.m
//  myApp
//
//  Created by 任超 on 15/4/11.
//  Copyright (c) 2015年 Chongqing Xilian Technology Co., Ltd. All rights reserved.
//

#import "UINavigation+Strategy.h"

@implementation UIViewController (Strategy)

- (void)initNav:(NSString *)title
{
    [self setupTitle:title];
    [self setupLeftButtonWithImage:@"arrow_left" and:nil];
}

- (void)setupTitle:(NSString *)title
{
    self.title = title;
}
- (void)setupLeftButton:(NSString *)str
{
    [self setupLeftButtonWithImage:str and:nil];
}
- (void)setupLeftButtonWithImage:(NSString *)image and:(NSString *)highlightImage
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem buttonWithImage:image highlightedImage:highlightImage target:self action:@selector(left:)];
}
- (void)setupRightButton:(NSString *)str
{
    [self setupRightButtonWithImage:str and:nil];
}
- (void)setupRightButtonWithImage:(NSString *)image and:(NSString *)highlightImage
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonWithImage:image highlightedImage:highlightImage target:self action:@selector(right:)];
}

- (void)left:(id)sender
{
    DDLogInfo(@"go back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)right:(id)sender
{
    DDLogError(@"SubClass overwrite @selector(right:)");
}

@end
@implementation UIBarButtonItem (Extension)

+ (instancetype)buttonWithImage:(NSString *)image highlightedImage:(NSString *)highlightedImage target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    
    NSString* title         = nil;
    UIImage* normalImage    = nil;
    UIImage* highlightImage = nil;
    
    if (image)
        normalImage = [UIImage imageNamed:image];
    else
        title = @"NONAME";
    
    if (highlightImage)
        highlightImage = [UIImage imageNamed:highlightedImage];
    else title = @"NONAME";
    
    CGRect frame = button.frame;
    if (normalImage || highlightImage)
    {
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        frame.size = button.currentBackgroundImage.size;
        [button setFrame:frame];
        return [[self alloc] initWithCustomView:button];
    }
    else if (image || title)
    {
        button = nil;
        if (!title || [title isEqualToString:@"NONAME"]) title = image;
        UIBarButtonItem *ret = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
        [ret setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:16],UITextAttributeTextColor:[UIColor whiteColor]} forState:UIControlStateNormal];
        return ret;
    }
    else
    {
        DDLogError(@"Create barbutton failed");
        return nil;
    }
}
@end
