//
//  NSObject+CRLogger.m
//  XilianApp
//
//  Created by Abyss on 2017/2/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "NSObject+CRLogger.h"
#import "CRLogger.h"

@implementation NSObject (CRLogger)

- (NSString *)delWithDicForLog:(NSDictionary *)dic
{
    NSString* des = @"";
    
#if DEBUG_LOG
    for (NSString* key in dic.allKeys)
    {
        id value = [dic objectForKey:key]?:@"NULL";
        NSString* valueString = @"";
        
        if([value isKindOfClass:[NSString class]])
        {
            valueString = value;
        }
        else if ([value isKindOfClass:[NSNumber class]])
        {
            valueString = [value stringValue];
        }
        else
        {
            valueString = [NSString stringWithFormat:@"\n%@",value];
        }
        
        des = [des stringByAppendingString:[NSString stringWithFormat:@"@ %@: %@\n",key,valueString]];
    }
#endif
    
    return des;
}

/** descrition:根据logDic创建,标题是类名 */
- (NSString *)descriptionWithDic:(NSDictionary *)logDic
{
    return [self descriptionWithDes:[self delWithDicForLog:logDic]];
}

/** descrition:根据logDic创建,标题是类名 */
- (NSString *)descriptionWithDes:(NSString *)description
{
#if DEBUG_LOG
    NSString* title = [NSString stringWithFormat:@"\n======================================\n  %@ \n======================================\n",NSStringFromClass([self class])];
    
    NSString* end   = @"\n\n";
    
    return [NSString stringWithFormat:@"%@%@%@",title,description,end];
#else
    return @"";
#endif
}

/** welcome:根据welcomeDic创建,标题是类名 */
- (NSString *)welcomeWithDic:(NSDictionary *)welcomeDic
{
    return [self welcomeWithDes:[self delWithDicForLog:welcomeDic]];
}

/** welcome:根据welcomeDic创建,标题是类名 */
- (NSString *)welcomeWithDes:(NSString *)welcomeLog
{
#if DEBUG_LOG
    NSString* title = [NSString stringWithFormat:@"\n\n Running %@!\n\n",NSStringFromClass([self class])];
    NSString* end   = @"\n\n";
    
    return [NSString stringWithFormat:@"%@%@%@",title,welcomeLog,end];
#else
    return @"";
#endif
}
@end
