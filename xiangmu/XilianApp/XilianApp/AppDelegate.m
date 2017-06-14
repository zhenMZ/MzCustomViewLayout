//
//  AppDelegate.m
//  XilianApp
//
//  Created by Abyss on 2017/2/14.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "AppDelegate.h"

#import "CRBaser.h"
#import "CRLogger.h"
#import "CrossCut.h"

#import "DemoViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /** 加载框架 */
    /**
     * 1.控制台欢迎
     * 2.网络客户端配置
     * 3.数据处理器
     * 4.测试器
     * 5.上次登录信息收集
     */
    [CRBaser setup];
    
    /** 日志记录"打开App"事件 */
    [CRTracer trace:@"打开App"];
    
    /** 进入主页 */
    /**
     * 1.定义了全局的Navigation,单树跳转
     * 2.DEBUG下，开启快捷测试栏
     */
    [CRBaser start:[DemoViewController new]];
    return YES;
}

- (Loginer *)loginer
{
    return [Loginer global];
}

@end
