//
//  NSObject+CRLogger.h
//  XilianApp
//
//  Created by Abyss on 2017/2/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CRLogger)

/** descrition:根据logDic创建,标题是类名 */
- (NSString *)descriptionWithDic:(NSDictionary *)logDic;
/** descrition:根据logDic创建,标题是类名 */
- (NSString *)descriptionWithDes:(NSString *)description;

/** welcome:根据welcomeDic创建,标题是类名 */
- (NSString *)welcomeWithDic:(NSDictionary *)welcomeDic;
/** welcome:根据welcomeDic创建,标题是类名 */
- (NSString *)welcomeWithDes:(NSString *)welcomeLog;

@end
