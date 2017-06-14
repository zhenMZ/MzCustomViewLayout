//
//  BaseViewController.m
//  XilianApp
//
//  Created by Abyss on 2017/4/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController
{
    id<UIGestureRecognizerDelegate> _delegate;
}

- (NSString *)name
{
    return key_undefinePage;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = self.name;
    [CRTracer tracePage:self.name];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setExtendedLayoutIncludesOpaqueBars:NO];

    self.view.backgroundColor = [CRColor background];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
