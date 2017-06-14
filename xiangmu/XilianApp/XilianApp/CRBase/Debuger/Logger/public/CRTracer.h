//
//  CRTracer.h
//  XilianApp
//
//  Created by Abyss on 2017/5/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/DDFileLogger.h>

/**
 CRTracer
 跟踪者
 
 map所有用户行为
 获取用户操作日志
 方便大数据分析
 */

NS_ASSUME_NONNULL_BEGIN

static NSString* __nonnull key_undefinePage = @"未定义的页面";

@interface CRTracer : NSObject
@property (nonatomic, weak , readonly) DDFileLogger* fileLogger;

- (instancetype)ini UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/** 获取Tracer */
+ (instancetype)globel;

/** 获取最近文件 */
- (DDLogFileInfo *)recently;
/** 获取所有文件 */
- (NSArray<DDLogFileInfo *> *)list;

/** 跟踪自定义事件 */
+ (void)trace:(NSString *)event;

/** 跟踪路径 */
+ (void)tracePage:(NSString *)page;

@end

@interface DDLogFileInfo (Read)
- (NSString *)content;
@end

NS_ASSUME_NONNULL_END
