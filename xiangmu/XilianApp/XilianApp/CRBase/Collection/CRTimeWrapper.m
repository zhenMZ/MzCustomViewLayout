//
//  CRTimeWrapper.m
//  Pods
//
//  Created by 任超 on 15/7/21.
//
//

#import "CRTimeWrapper.h"
#import "CRDateUtil.h"
#import "CRMathUtil.h"
#import "NSObject+CRLogger.h"

static NSDateFormatter* CRTimeWrapperDateFormatter = nil;
@interface CRTimeWrapper ()
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) BOOL isUp;
@end
@implementation CRTimeWrapper

- (void)startUp
{
    _isOn = YES;
    _isUp = YES;
    
    [self timeJumpUp];
}

- (void)startDown
{
    _isOn = YES;
    _isUp = NO;
    
    [self timeJumpDown];
}

- (void)stop
{
    _isOn = NO;
}

- (void)timeJumpUp
{
    if (_isOn && ![self.date isEqualToDate:_pDate] && _isUp)
    {
        _timeInterval++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self timeJumpUp];
                
                if (_timesChangeBlock) {
                    _timesChangeBlock(self);
                }
            });
        });
    }
}

- (void)timeJumpDown
{
    if (_isOn && ![self.date isEqualToDate:_pDate] && !_isUp)
    {
        _timeInterval--;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self timeJumpDown];
                
                if (_timesChangeBlock) {
                    _timesChangeBlock(self);
                }
            });
        });
    }
}


- (NSDate *)date
{
    return [NSDate dateWithTimeIntervalSince1970:self.timeInterval];
}

- (NSString *)dateDescription
{
    return [_formatter?_formatter:[NSDate formatterDefualt] stringFromDate:self.date];
}

- (NSString *)datePeriodDescription
{
    return [NSDate stringForTimeIntervalFromDate:self.date toDate:self.pDate];
}

+ (CRTimeWrapper *)wrapperNow
{
    return [CRTimeWrapper wrapperFromDate:[NSDate date]];
}

+ (CRTimeWrapper *)wrapperFromDate:(NSDate *)date
{
    return [CRTimeWrapper wrapperFromTimeInterval:[date timeIntervalSince1970]];
}

+ (CRTimeWrapper *)wrapperFromDateString:(NSString *)dateString
{
    return [CRTimeWrapper wrapperFromDate:[[NSDate formatterDefualt] dateFromString:dateString]];
}

+ (CRTimeWrapper *)wrapperFromTimeInterval:(NSTimeInterval)timeInterval
{
    CRTimeWrapper* wrapper = [[CRTimeWrapper alloc] initWithTimeInterval:timeInterval];
    
    if (CRTimeWrapperDateFormatter) {
        wrapper.formatter = CRTimeWrapperDateFormatter;
    }
    
    wrapper.pDate = [NSDate date];
    
    return wrapper;
}

+ (CRTimeWrapper *)wrapperFromString:(NSString *)string
{
    if (string.length == 0)
    {
        return [CRTimeWrapper wrapperNow];
    }
    
    if (string.length < 2)
    {
        string = @"0";
    }
    
    if ([CRMathUtil isPureInt:string])
    {
        return [CRTimeWrapper wrapperFromTimeInterval:string.longLongValue];
    }
    
    return [CRTimeWrapper wrapperFromDateString:string];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval
{
    self = [super init];
    if (self)
    {
        _timeInterval = timeInterval;
    }
    
    return self;
}

#pragma mark 归档

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithDouble:self.timeout]      forKey:@"timeout"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.timeInterval] forKey:@"timeInterval"];
    
    [aCoder encodeObject:[self pDate]          forKey:@"pDate"];
    [aCoder encodeObject:[self formatter]      forKey:@"formatter"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil)
    {
        _timeout      = [[aDecoder decodeObjectForKey:@"timeout"] doubleValue];
        _timeInterval = [[aDecoder decodeObjectForKey:@"timeInterval"] doubleValue];
        
        self.pDate     = [aDecoder decodeObjectForKey:@"pDate"];
        self.formatter = [aDecoder decodeObjectForKey:@"formatter"];
    }
    
    return self;
}

- (BOOL)isValidate
{
    if (self.timeout == 0)
    {
        return self.timeInterval > 0;
    }

    return self.timeInterval > 0 && ((self.timeInterval + self.timeout) > (self.pDate?self.pDate.timeIntervalSince1970:[[NSDate date] timeIntervalSince1970]));
}

+ (void)setDefaultFormatter:(NSDateFormatter *)formatter
{
    CRTimeWrapperDateFormatter = formatter;
}

- (void)cancel
{
    _timesChangeBlock = nil;
}

- (NSString *)description
{
    return [self descriptionWithDic:@{@"Time":self.dateDescription,
                                      @"Time2":self.datePeriodDescription,
                                      @"Time3":@(self.timeInterval)}];
}

@end

@implementation NSDate (CRTimeWrapper)

- (CRTimeWrapper *)wrapper
{
    return [CRTimeWrapper wrapperFromDate:self];
}

@end
