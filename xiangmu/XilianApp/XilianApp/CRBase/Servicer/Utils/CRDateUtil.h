/**
 *  ==================CRDate===================
 *   CRDateUtil
 *  ===========================================
 *
 *  Copyright@2015 RogerAbyss
 */

#import <Foundation/Foundation.h>

@interface CRDateUtil : NSDate
@end


/** 时间阀值,未超过阀值显示现在时间的表示(单位:秒) */
#define rPRE_NSDATE_CURRENT         3 

@interface NSDate (CRDateUtil)

/** 显示时间差值 EXP: 1分钟以前 */
+ (NSString *)stringForTimeInterval:(NSTimeInterval)seconds;

/** 显示时间差值 EXP: 1分钟以前 */
+ (NSString *)stringForTimeIntervalFromDate:(NSDate *)startDate
                                     toDate:(NSDate *)endDate;

/** 过去时间 表示 */
+ (NSString *)expressionPast;

/** 未来时间 表示 */
+ (NSString *)expressionFuture;

/** 现在时间 表示 */
+ (NSString *)expressionPresent;

/** 时间单位:全部 */
+ (NSCalendarUnit)formatterDisplay;

/** 时间格式:默认 */
+ (NSDateFormatter *)formatterDefualt;

/** 按单位比较差值 + 1 代表startDate 已经过了一天  */
+ (NSInteger)compareFramDate:(NSDate *)startDate
                         unit:(NSCalendarUnit)unit;

/** 按单位比较差值 + 1 代表startDate 比 endDate 晚一天  */
+ (NSInteger)compareFramDate:(NSDate *)startDate
                       toDate:(NSDate *)endDate
                         unit:(NSCalendarUnit)unit;

/** 判断是否是今天 */
- (BOOL)isToday;

/** 判断是否是昨天 */
- (BOOL)isYestoday;

@end
