//
//  NSString+Strategy.m
//  XilianApp
//
//  Created by Abyss on 2017/3/6.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "NSString+Strategy.h"
#import "CRNetEngine+Private.h"

static NSString* Default_URL = nil;

static int Default_TimeStyle = 0;
static NSString* Default_TimeFormat = nil;

static int Default_MoneyUnitType = 0;
static NSString* Default_MoneyPre = nil;
static NSString* Default_MoneySuf = nil;

//static NSString* Default_URL = nil;
//static NSString* Default_URL = nil;

@implementation NSString(Strategy)

- (NSURL *)URL
{
    if (!self) return [NSURL URLWithString:@""];
    
    if([self hasPrefix:@"http"])
    {
        return [NSURL URLWithString:self];
    }
    else
    {
        NSString* host = [[CRNetEngine defaultEngine] evaluateHostIn:[CRNetEngine defaultEngine].config.sever];
        
        return [NSURL URLWithString:[host stringByAppendingString:self]];
    }
}

+ (void)setDefaultHost:(NSString *)host
{
    if (host) Default_URL = host;
}

- (NSString *)time
{
   return [self timeStyle:Default_TimeStyle];
}

- (NSString *)timeStyle:(int)style
{
    NSString* format = nil;
    if (!Default_TimeFormat) return @"未设置格式";
    if (![Default_TimeFormat containsString:@","]) return @"格式不正确";
    
    switch (style) {
        case 0:
        {
            format = Default_TimeFormat;
        }
            break;
        case 1:
        {
            NSRange range = [Default_TimeFormat rangeOfString:@","];
            format = [Default_TimeFormat substringWithRange:range];
        }
            break;
        case 2:
        {
            NSRange range = [Default_TimeFormat rangeOfString:@","];
            format = [Default_TimeFormat substringFromIndex:range.location + 1];
        }
            break;
        default:
            break;
    }
    
    return [self timeFormat:format];
}

- (NSString *)timeFormat:(NSString *)format
{
    if (!format) return @"未设置格式";
    
    if ([self isEqualToString:@""])
    {
        return @"";
    }
    else if([self containsString:@"日"] || [self containsString:@":"] || [self containsString:@"-"] || [self containsString:@" "] || [self containsString:@"星"] || [self containsString:@"年"])
    {
        return self;
    }
    else
    {
        NSTimeInterval time = [self longLongValue];
        
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = format;
        
        return [formatter stringFromDate:date];
    }
    
    return @"数据来源异常";
}

+ (void)setDefaultTimeFormat:(NSString *)format
{
    if (format) Default_TimeFormat = format;
}

+ (void)setDefaultTimeStyle:(int)style
{
    if (style>0) Default_TimeStyle = style;
}

// 钱 num保留位数 unit单位 unitType默认单位 pre前置符号 suf后置符号
- (NSString *)money
{
    return [self moneyWithUnit:Default_MoneyUnitType];
}

- (NSString *)moneyWithUnit:(int)unitType
{
    return [self moneyWithUnit:unitType];
}

- (NSString *)moneyWithUnit:(int)unitType num:(int)num
{
    return [self moneyWithUnit:unitType pre:Default_MoneyPre suf:Default_MoneySuf];
}

- (NSString *)moneyWithUnit:(int)unitType pre:(NSString *)pre suf:(NSString *)suf
{
    if(!self) return @"";
    
    NSUInteger value = self.integerValue;
    
    switch (unitType)
    {
        case 0:
        {
            return [NSString stringWithFormat:@"%.2lu",(unsigned long)value];
        }
            break;
        case 1:
        {
            if (!Default_MoneyPre && !pre) return @"没有设置金钱单位";
            
            return [NSString stringWithFormat:@"%@ %.2lu",pre,(unsigned long)value];
        }
            break;
        case 2:
        {
            if (!Default_MoneySuf && !suf) return @"没有设置金钱单位";
            
            return [NSString stringWithFormat:@"%.2lu %@",(unsigned long)value,suf];
        }
            break;
        default:
            break;
    }
    
    return @"请检查数据来源";
}

- (NSString *)moneyPre:(NSString *)pre
{
    return [self moneyWithUnit:1 pre:pre suf:@""];
}

- (NSString *)moneySuf:(NSString *)suf
{
    return [self moneyWithUnit:2 pre:@"" suf:suf];
}

+ (void)setMoneyDefaultUnit:(int)unitType
{
    if(unitType > 0) Default_MoneyUnitType = unitType;
}

+ (void)setMoneyDefaultUnitPre:(NSString *)pre
{
    if(pre) Default_MoneyPre = pre;
}

+ (void)setMoneyDefaultUnitSuf:(NSString *)suf
{
    if(suf) Default_MoneySuf = suf;
}

+ (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime <60*60) {//时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
        
    }
    else if(distanceTime <24*60*60*365){
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

+ (NSString *)StringGoSapce:(NSString *)containSpaceString {

    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [containSpaceString componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@" "];
}

- (BOOL)isNullOrNil {
    
    if(self == nil){
        return NO;
    }
    if ([self isEqual:[NSNull null]]) {
        return NO;
    }
    return YES;
    
}

- (BOOL)isContainChinese {
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return NO;

}

- (BOOL)isContainSpace {
    NSRange range = [self rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)isContainString:(NSString *)string
{
    NSRange rang = [self rangeOfString:string];
    if (rang.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }

}

#pragma mark -- 正则
- (BOOL)is_ValidateByRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (BOOL)is_MobileNumber {
    NSString *mobileRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$";
    BOOL ret1 = [self is_ValidateByRegex:mobileRegex];
    return ret1;
}

- (BOOL)is_EmailAddress {
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self is_ValidateByRegex:emailRegex];
}

- (BOOL)is_ValidUrl {
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self is_ValidateByRegex:regex];
}

- (BOOL)is_ValidWithMinLenth:(NSInteger)minLenth
                   maxLenght:(NSInteger)maxLenth
              containChinese:(BOOL)containChinese
         firstCannotBeDigtal:(BOOL)firstCannotBeDigtal {
    
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    
    NSString *regex = [NSString stringWithFormat:@"%@[%@A-Za-z0-9_]{%d,%d}", first, hanzi, (int)(minLenth-1), (int)(maxLenth-1)];
    return [self is_ValidateByRegex:regex];

}

- (BOOL)is_ValidWithMinLenth:(NSInteger)minLenth
                    maxLenth:(NSInteger)maxLenth
              containChinese:(BOOL)containChinese
               containDigtal:(BOOL)containDigtal
               containLetter:(BOOL)containLetter
       containOtherCharacter:(NSString *)containOtherCharacter
         firstCannotBedigtal:(BOOL)firstCannotBeDegtal {
   
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDegtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    return [self is_ValidateByRegex:regex];

    
    
}

- (BOOL)is_bankCardCheck {
    NSString * lastNum = [[self substringFromIndex:(self.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[self substringToIndex:(self.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}

+ (BOOL)is_accurateVerifyIdentifyCardNum:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                NSString *test = [value substringWithRange:NSMakeRange(17,1)];
                if ([[M lowercaseString] isEqualToString:[test lowercaseString]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }

}

-(NSString *)aes256_encrypt:(NSString *)key {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data aes256_encrypt:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}
-(NSString *)aes256_decrypt:(NSString *)key {
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data aes256_decrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
    
    
}


@end
