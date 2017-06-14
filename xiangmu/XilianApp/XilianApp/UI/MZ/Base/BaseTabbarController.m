//
//  BaseTabbarController.m
//  XilianApp
//
//  Created by MZ on 2017/5/12.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "BaseTabbarController.h"
#import "UIView+Tool.h"

#import "MessageViewController.h"
#import "HomeViewController.h"
#import "PersonViewController.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"
@interface BaseTabbarController ()
{
    UIView *_backView;
}
@property (nonatomic,retain)NSArray *viewControllers;

@end

@implementation BaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTabbar];
    [self creatUI];
    
    if (_selectedIndex > [self.viewControllers count]||_selectedIndex<0)
    {
        _selectedIndex =0;
        
    }
    for(int i=100 ;i<103; i++)
    {
        UIButton *button =(UIButton  *)[_backView viewWithTag:i];
        button.selected = NO;
    }
    UIButton *button =(UIButton  *)[_backView viewWithTag:_selectedIndex + 100];
    button.selected = YES;
    
    
    UIViewController *viewController1 =self.viewControllers[_selectedIndex];
    [self.view addSubview: viewController1.view];
    [self.view sendSubviewToBack:viewController1.view];

    

}

- (void)creatUI {
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen.height - 49 - 64, kScreen.width, 49)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"HomeViewController",
                                   kTitleKey  : @"喜乐宝",
                                   kImgKey    : @"平台2",
                                   kSelImgKey : @"平台1"},
                                 
                                 @{kClassKey  : @"MessageViewController",
                                   kTitleKey  : @"消息",
                                   kImgKey    : @"消息2",
                                   kSelImgKey : @"消息1"},
                                 
                                 @{kClassKey  : @"PersonViewController",
                                   kTitleKey  : @"个人帐户",
                                   kImgKey    : @"个人账户2",
                                   kSelImgKey : @"个人账户1"},
                                ];
    

    
    for (int i = 0; i < 3; i ++) {
        
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreen.width/8 + i * (kScreen.width/4), 1, kScreen.width/4, 48);
        [btn setImage:[UIImage imageNamed:childItemsArray[i][kImgKey]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:childItemsArray[i][kSelImgKey]] forState:UIControlStateSelected];
        [btn setTitle:childItemsArray[i][kTitleKey] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 0.0,0.0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-10.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+100;
        [_backView addSubview:btn];
    }
    
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == _selectedIndex) {
        return;
    }
    else
    {
        UIViewController *viewController =self.viewControllers[_selectedIndex];
        [viewController.view removeFromSuperview];
        _selectedIndex = selectedIndex;
        UIViewController *viewController1 =self.viewControllers[_selectedIndex];
        [self.view addSubview: viewController1.view];
        [self.view sendSubviewToBack:viewController1.view];
    }
}

- (void)creatTabbar {
    HomeViewController *viewController1 =[[HomeViewController alloc] init];
    
    MessageViewController *viewController2 =[[MessageViewController alloc] init];
    
    PersonViewController *viewController3 =[[PersonViewController alloc] init];
    
    self.viewControllers =@[viewController1,viewController2,viewController3];

}

- (void)btnClick:(UIButton *)sender  {
    UIButton *btn =(UIButton *)sender;
    self.selectedIndex =btn.tag-100;
    
    for(int i=100 ;i<103; i++)
    {
        UIButton *button =(UIButton  *)[_backView viewWithTag:i];
        button.selected = NO;
    }
    btn.selected = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
