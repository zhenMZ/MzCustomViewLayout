//
//  CRLogger.h
//  XilianApp
//
//  Created by Abyss on 2017/2/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "NSObject+CRLogger.h"
#import "CRTracer.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

// DEBUG_LOG 标记是否是测试模式,非测试模式无用的打印不会进行
#define DEBUG_LOG DEBUG

@class DDLogMessage;


/**
 CRLogger
 日志
 
 根据日志等级输出日志到 控制台/文件
 快速打印自定义类的属性
 
 *方便跟踪调试
 *日志管理
 */
@interface CRLogger : NSObject;

/** 开启日志 */
+ (void)setup;

/** 日志打印等级设定 [DDLogLevel] 对于aClass输出level以上的日志 */
+ (void)setLevel:(int)level forClass:(Class)aClass;

@end
