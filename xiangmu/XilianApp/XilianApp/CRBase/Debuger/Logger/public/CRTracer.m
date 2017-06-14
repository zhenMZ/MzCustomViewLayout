//
//  CRTracer.m
//  XilianApp
//
//  Created by Abyss on 2017/5/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRTracer.h"
#import "CRLogger.h"

#import "CRManager.h"

@interface CRTracer()
@end
@implementation CRTracer

- (DDFileLogger *)fileLogger
{
    DDFileLogger* fileLogger = nil;
    
    for (id loger in [[DDLog sharedInstance] allLoggers])
    {
        if ([loger isKindOfClass:[DDFileLogger class]])
        {
            fileLogger = loger;
        }
    }
    
    return fileLogger;
}

/** 获取Tracer */
+ (instancetype)globel
{
    static id tracer = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        tracer = [[self alloc] init];
    });
    
    return tracer;
}

/** 获取最近文件 */
- (DDLogFileInfo *)recently
{
    return self.fileLogger.logFileManager.unsortedLogFileInfos.lastObject;
}

/** 获取所有文件 */
- (NSArray<DDLogFileInfo *> *)list
{
    return self.fileLogger.logFileManager.sortedLogFileInfos;
}

/** 跟踪事件 */
+ (void)trace:(NSString *)event
{
    NSString* reString = [NSString stringWithFormat:@"%@",event];
    DDLogDebug(reString);
}

/** 跟踪路径 */
+ (void)tracePage:(NSString *)page
{
    if ([page isEqualToString:key_undefinePage])
    {
        return;
    }
    
    NSString* reString = [NSString stringWithFormat:@"进入页面 [%@]",page];
    DDLogDebug(reString);
}

@end

@implementation DDLogFileInfo (Read)

- (NSString *)content
{
    NSString* content = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
    
    return content?:@"没有找到任何日志";
}

@end
