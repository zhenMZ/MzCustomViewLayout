//
//  BaseTableBarController.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/7.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "BaseTableBarController.h"

#import "MessageViewController.h"
#import "HomeViewController.h"
#import "PersonViewController.h"


#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface BaseTableBarController ()
@property (nonatomic,retain)NSArray *viewControllers;
@property (nonatomic,assign)NSInteger selectedIndex;
@end

@implementation BaseTableBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ]
    
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
                                 @{kClassKey  : @"PersonViewController",
                                   kTitleKey  : @"个人帐户",
                                   kImgKey    : @"个人账户2",
                                   kSelImgKey : @"个人账户1"},
                                 
                                 @{kClassKey  : @"PersonViewController",
                                   kTitleKey  : @"个人帐户",
                                   kImgKey    : @"个人账户2",
                                   kSelImgKey : @"个人账户1"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor]} forState:UIControlStateSelected];
        
        [self addChildViewController:nav];
    }];
    
//    float w = [UIScreen mainScreen].bounds.size.width;
//    float h = [UIScreen mainScreen].bounds.size.height;
//    self.tabBar.frame = CGRectMake(w/8, h - 49, w/4*3, 49);
//
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(-(w/8), 0, w , 49)];
//    backView.backgroundColor = [UIColor whiteColor];
//    [self.tabBar insertSubview:backView atIndex:0];
    
//    [self goLine:w :h];
}

- (void)creatTabbar {
    HomeViewController *viewController1 =[[HomeViewController alloc] init];
    
    MessageViewController *viewController2 =[[MessageViewController alloc] init];
    
    PersonViewController *viewController3 =[[PersonViewController alloc] init];
   
    self.viewControllers =@[viewController1,viewController2,viewController3];
}

// 去掉线
//- (void)goLine:(float)w :(float)h {
//    CGRect rect = CGRectMake(0, 0, w, h);
//    
//    UIGraphicsBeginImageContext(rect.size);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//    
//    CGContextFillRect(context, rect);
//    
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    [self.tabBar setBackgroundImage:img];
//    
//    [self.tabBar setShadowImage:img];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
