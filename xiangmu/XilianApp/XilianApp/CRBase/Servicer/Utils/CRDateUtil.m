//
//  CRDateUtil.m
//  Pods
//
//  Created by 任超 on 15/7/21.
//
//

#import "CRDateUtil.h"

@implementation CRDateUtil

@end

static NSDateFormatter* DefualtDateFormatter = nil;

static inline NSCalendarUnit NSCalendarUnitFromString(NSString *string)
{
    if ([string isEqualToString:@"年"])
    {
        return NSCalendarUnitYear;
    }
    else if ([string isEqualToString:@"月"])
    {
        return NSCalendarUnitMonth;
    }
    else if ([string isEqualToString:@"周"])
    {
        return NSCalendarUnitWeekOfYear;
    }
    else if ([string isEqualToString:@"天"])
    {
        return NSCalendarUnitDay;
    }
    else if ([string isEqualToString:@"小时"])
    {
        return NSCalendarUnitHour;
    }
    else if ([string isEqualToString:@"分钟"])
    {
        return NSCalendarUnitMinute;
    }
    else if ([string isEqualToString:@"秒"])
    {
        return NSCalendarUnitSecond;
    }
    
    return NSDateComponentUndefined;
}

@implementation NSDate (CRDateUtil)

+ (NSString *)stringForTimeInterval:(NSTimeInterval)seconds
{
    NSDate *date = [NSDate date];
    return [NSDate stringForTimeIntervalFromDate:date toDate:[NSDate dateWithTimeInterval:seconds sinceDate:date]];
}

+ (NSString *)stringForTimeIntervalFromDate:(NSDate *)startDate
                                     toDate:(NSDate *)endDate
{
    NSTimeInterval seconds = [startDate timeIntervalSinceDate:endDate];
    if (fabs(seconds) < rPRE_NSDATE_CURRENT) {
        return [NSDate expressionPresent];
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:[self formatterDisplay]
                                                                   fromDate:startDate
                                                                     toDate:endDate options:0];
    
    
    NSString *string         = nil;
    BOOL isApproximate       = NO;
    NSUInteger numberOfUnits = 0;
    
    NSArray* unitChineseArray  = @[@"年", @"月", @"周", @"天", @"小时", @"分钟", @"秒"];
    NSArray* unitPropertyArray = @[@"year", @"month", @"weekOfYear", @"day", @"hour", @"minute", @"second"];
    
    for (NSString *unitName in unitChineseArray)
    {
        NSCalendarUnit unit = NSCalendarUnitFromString(unitName);
        if (self.formatterDisplay & unit)
        {
            NSNumber *number = @(abs([components valueForComponent:NSCalendarUnitFromString(unitName)]));
            @(abs([[components valueForKey:[unitPropertyArray objectAtIndex:[unitChineseArray indexOfObject:unitName]]] intValue]));
            
            if ([number integerValue])
            {
                NSString *suffix = [NSString stringWithFormat:@"%d%@", (int)number.integerValue, unitName];
                
                if (!string) {
                    string = suffix;
                /** 只显示一位数 */
                } else if (numberOfUnits < 1) {
                    string = [string stringByAppendingFormat:@"%@", suffix];
                } else {
                    isApproximate = YES;
                }
                
                numberOfUnits++;
            }
        }
    }
    
    if (string) {
        if (seconds > 0) {
            if ([[self expressionPast] length]) {
                string = [NSString stringWithFormat:@"%@ %@", string, self.expressionPast];
            }
        } else {
            if ([[self expressionFuture] length]) {
                string = [NSString stringWithFormat:@"%@ %@", self.expressionFuture, string];
            }
        }
    }
    else
    {
        string = [self expressionPresent];
    }
    
    return string;
}

+ (NSString *)expressionPast
{
    return @"以前";
}

+ (NSString *)expressionFuture
{
    return @"预计还有";
}

+ (NSString *)expressionPresent
{
    return @"刚才";
}

+ (NSDateFormatter *)formatterDefualt;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DefualtDateFormatter = [[NSDateFormatter alloc] init];
        
        [DefualtDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [DefualtDateFormatter setLocale:[NSLocale currentLocale]];
        
        [DefualtDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [DefualtDateFormatter setShortStandaloneWeekdaySymbols:@[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"]];
    });
    
    return  DefualtDateFormatter;
}

+ (NSCalendarUnit)formatterDisplay
{
    return NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear |
    NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
}

+ (NSInteger)compareFramDate:(NSDate *)startDate
                       toDate:(NSDate *)endDate
                         unit:(NSCalendarUnit)unit
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
    return [components valueForComponent:unit];
}

+ (NSInteger)compareFramDate:(NSDate *)startDate unit:(NSCalendarUnit)unit
{
    return [CRDateUtil compareFramDate:startDate toDate:[NSDate date] unit:unit];
}

/** 判断是否是今天 */
- (BOOL)isToday
{
    return [CRDateUtil compareFramDate:self unit:NSCalendarUnitDay] == 0;
}

/** 判断是否是昨天 */
- (BOOL)isYestoday
{
    return [CRDateUtil compareFramDate:self unit:NSCalendarUnitDay] == -1;
}

@end

#pragma mark - IOS8

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0

@interface NSDateComponents (CRDateUtil)
@end
@implementation NSDateComponents (CRDateUtil)

- (NSInteger)valueForComponent:(NSCalendarUnit)unit
{
    NSString* key = nil;
    
    NSArray* unitChineseArray  = @[@"年", @"月", @"周", @"天", @"小时", @"分钟", @"秒"];
    NSArray* unitPropertyArray = @[@"year", @"month", @"weekOfYear", @"day", @"hour", @"minute", @"second"];
    
    key = [unitPropertyArray objectAtIndex:[unitChineseArray indexOfObject:NSCalendarUnitFromString(unit)]];
    
    return [[self valueForKey:key] integerValue];
}

@end

#endif
