//
//  CRBaser.m
//  XilianApp
//
//  Created by Abyss on 2017/2/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRBaser.h"

#import "CRLogger.h"
#import "CRCacher.h"

#import "CRNavigationer.h"
#import "CRDefines.h"
#import "AppDelegate.h"
#import "CRNetConfig.h"
#import "CRDataLoaderConfig.h"

#import "DemoViewController.h"

#import "CRAcounter.h"
#import "CRUser.h"
#import "Loginer.h"

#if DEBUG
    #import "CrossCut.h"
    #import <FLEXManager.h>
    #import <GDPerformanceView/GDPerformanceMonitor.h>
#endif

#import "BaseTabbarController.h"

@implementation CRBaser

+ (void)setup
{
    [CRBaser sayWelcome];

    [self setupNetEngine];
    [self setupDataLoader];
    [self setupDebugger];
    [self setupLoginInfo];
}

+ (void)setupLoginInfo
{
    APP_DELEGATE.loginer.person = [[CRUser alloc] initWithName:APP_DELEGATE.loginer.lastPersonName];
}

+ (void)start:(UIViewController *)controller
{
    if (!APP_DELEGATE.window)
    {
        APP_DELEGATE.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    
    [CRNavigationer setCustomNavBar:nil];
    [CRNavigationer setCustomToolBar:nil];
    
    [[CRNavigationer global] appearanceWithBgColor:[UIColor whiteColor] textColor:[UIColor blackColor] titleFont:16 itemFont:12];
    
    [CRNavigationer global].viewControllers = @[controller];
    
    APP_DELEGATE.window.rootViewController = [CRNavigationer global];
    
    [APP_DELEGATE.window makeKeyAndVisible];
    
#if DEBUG
    [CRBaser setupCrossCut];
#endif
}

+ (void)setupNetEngine
{
    [CRCacher cacherDefault];
    
#if DEBUG
    [[CRNetConfig defaultConfig] swithSeverTo:@"DEBUG"];
#else
    [[CRNetConfig defaultConfig] swithSeverTo:@"RELEASE"];
#endif
}

+ (void)setupDataLoader
{
    [CRDataLoaderConfig defualt];
}

+ (void)setupDebugger
{
    [CRLogger setup];
    
#if DEBUG
    [[FLEXManager sharedManager] showExplorer];
    
    NSLog(@"\n\n 内置测试工具开启!\n\n");
    
    [[GDPerformanceMonitor sharedInstance] startMonitoring];
    NSLog(@"\n\n 性能检测器开启!\n\n");
#else
#endif
}

+ (void)setupCrossCut
{
    CrossCut* roger = [CrossCut crossCutNamed:@"Roger"];
    CrossCut* MZ    = [[CrossCut alloc] initWithColor:[UIColor redColor] title:@"MZ"];
    MZ.bottom       = [UIScreen mainScreen].bounds.size.height - 50;
    roger.bottom    = [UIScreen mainScreen].bounds.size.height - 50;
    roger.right     = [UIScreen mainScreen].bounds.size.width + 20;
    
    [APP_DELEGATE.window addSubview:roger];
    [APP_DELEGATE.window addSubview:MZ];
    
    roger.touch = ^(CrossCut* c)
    {
        [APP_NAVIGATION pushViewController:[DemoViewController new] animated:YES];
    };
    MZ.touch = ^(CrossCut* c){
        BaseTabbarController *vc = [BaseTabbarController new];
        vc.selectedIndex = 0;
        [APP_NAVIGATION pushViewController:vc animated:YES];
    };
}

+ (void)sayWelcome
{
    NSString* logo   = @"\n======================================\n  CRAppBase \n======================================\n";
    
    NSString* roger = [NSString stringWithFormat:@"\n@  Copyright@2017 RogerAbyss"];
    NSString* email = [NSString stringWithFormat:@"\n@  ContactMe      Roger_ren@qq.com"];
    
    NSString* map    = @"\n\n================================================\n";
    NSString* map1   = @"\n┴┬┴┬／￣＼＿／￣＼";
    NSString* map2   = @"\n┬┴┬┴▏　    ▏▔▔▔▔＼";
    NSString* map3   = @"\n┴┬┴／＼　／　　　   ﹨";
    NSString* map4   = @"\n┬┴∕　　　　　／　　  　）";
    NSString* map5   = @"\n┴┬▏　　　　　　　●　　▏";
    NSString* map6   = @"\n┬┴▏　　　　　　　　　　▔█";
    NSString* map7   = @"\n┴◢██◣　　　　　＼＿＿＿／";
    NSString* map8   = @"\n┬█████◣　　　　　　　／";
    NSString* map9   = @"\n┴█████████████◣";
    NSString* map10  = @"\n◢██████████████▆▄";
    NSString* map11  = @"\n█◤◢██◣◥█████████◤＼";
    NSString* map12  = @"\n◥◢████　████████◤　 ＼";
    NSString* map13  = @"\n┴█████　██████◤　　　 ﹨";
    NSString* map14  = @"\n ┬│　　　│█████◤　　　　　▏";
    NSString* map15  = @"\n┴││                    ▏";
    NSString* map16  = @"\n┬ ∕　　　 ∕　　　　／▔▔▔＼ ∕▏";
    NSString* map17  = @"\n┴/＿＿＿／﹨　　　∕　　　　　﹨　／＼";
    NSString* map18  = @"\n┬┴┬┴┬┴＼ 　　 ＼ 　　　　　﹨／　　 ﹨";
    NSString* map19  = @"\n┴┬┴┬┴┬┴ ＼＿＿＿＼　　　　 ﹨／▔＼﹨ ▔＼";
    NSString* map20  = @"\n▲△▲▲╓╥╥╥╥╥╥╥╥＼　　 ∕　 ／▔﹨／▔﹨\n\n";
    
    NSString* service = @"\n\n 启动服务中...\n";
    NSString* description = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
                             map,map1,map2,map3,map4,map5,map6,map7,map8,map9,map10,
                             map11,map12,map13,map14,map15,map16,map17,map18,map19,map20,logo,roger,email,service];
    NSLog(@"%@",description);
}

@end
