//
//  CRLogger.m
//  XilianApp
//
//  Created by Abyss on 2017/2/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRLogger.h"
#import "CocoaLumberjack.h"
#import "CRLoggerFormatter.h"

@interface CRLogger()
@end
@implementation CRLogger

+ (void)setup
{
    // 控制台日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // 本地日志
    DDFileLogger* fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];

    [[DDTTYLogger sharedInstance] setLogFormatter:[[CRLoggerFormatter alloc] init]];
    
    NSLog(@"%@",[self welcomeWithDic:@{@"位置":fileLogger.logFileManager.logsDirectory}]);
}

+ (void)setLevel:(int)level forClass:(Class)aClass
{
    [DDLog setLevel:level forClass:aClass];
}

@end
