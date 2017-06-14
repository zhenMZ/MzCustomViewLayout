//
//  CRLoggerFormatter.h
//  XilianApp
//
//  Created by Abyss on 2017/2/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"

/**
 CRLoggerFormatter
 日志输出格式
 */
@interface CRLoggerFormatter : NSObject<DDLogFormatter>
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage;
@end
