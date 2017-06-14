//
//  CRLoggerFormatter.m
//  XilianApp
//
//  Created by Abyss on 2017/2/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRLoggerFormatter.h"
#import "CRLogger.h"


@implementation CRLoggerFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
#if DEBUG_LOG
    return [NSString stringWithFormat:@"<%@,%llu>[%@:%@] %@\n%@\n-----------\n",
            logMessage.fileName,
            (uint64_t)logMessage.line,
            logMessage.threadName,
            logMessage.threadID,
            logMessage.function,
            logMessage.message];
#else
    return @"";
#endif
}

@end
