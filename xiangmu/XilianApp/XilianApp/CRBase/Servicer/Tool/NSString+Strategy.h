//
//  NSString+Strategy.h
//  XilianApp
//
//  Created by Abyss on 2017/3/6.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#import "NSData+AES256.h"
@interface NSString (Strategy)

/** 取NSURL,如果没有host会加上一个host */
- (NSURL *)URL;

+ (void)setDefaultHost:(NSString *)host;

/** 时间的格式 style默认样式 format自定义样式 */
- (NSString *)time;
/** style 0:默认 1:pre 2:suf ,分割 */
- (NSString *)timeStyle:(int)style;
- (NSString *)timeFormat:(NSString *)format;

+ (void)setDefaultTimeStyle:(int)style;
/** 请以^为分隔符分割成两种style 如 yyyy-MM-dd^ HH:mm:ss */
+ (void)setDefaultTimeFormat:(NSString *)format;

/** 钱 num保留位数 unit单位 unitType默认单位:0无单位,1前置单位,2后置单位 pre前置符号 suf后置符号 */
- (NSString *)money;
- (NSString *)moneyWithUnit:(int)unitType;
- (NSString *)moneyPre:(NSString *)pre;
- (NSString *)moneySuf:(NSString *)suf;

+ (void)setMoneyDefaultUnit:(int)unitType;
+ (void)setMoneyDefaultUnitPre:(NSString *)pre;
+ (void)setMoneyDefaultUnitSuf:(NSString *)suf;




/************************************
 ************** 新增 *************************
 *****************************************/

/**
 类似评论那种时间（e.g ：刚刚，几分钟前， 今天... , 昨天... ，某年某月）
 
 @param beTime 时间撮
 @return e.g 所示字符串
 */
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;

/**
 是否包含汉字

 @return yes OR No
 */
- (BOOL)isContainChinese;

/**
 是否包含空格

 @return yee or no
 */
- (BOOL)isContainSpace;

/**
 是否包含某字符串

 @param string 字符串
 @return yes or no
 */
- (BOOL)isContainString:(NSString *)string;

/**
 字符串去空格

 @param containSpaceString  @"    this     is a    test    .   "
 @return <#return value description#>
 */
+ (NSString *)StringGoSapce:(NSString *)containSpaceString;

/**
 字符串为null或者nil
 */
- (BOOL)isNullOrNil;


/**
 判断手机号码

 @return yes or no
 */
- (BOOL)is_MobileNumber;

/**
 判断邮箱地址

 @return yes or no
 */
- (BOOL)is_EmailAddress;

/**
 精确判断身份证有效性

 @return yes or no
 */
+ (BOOL)is_accurateVerifyIdentifyCardNum:(NSString *)value;

/**
 判断银行卡

 @return yes or no
 */
- (BOOL)is_bankCardCheck;

/**
 判断网址

 @return yes or no
 */
- (BOOL)is_ValidUrl;

/**
 判断字符串是否满足以下要求（简单版）

 @param minLenth 最小长度
 @param maxLenth 最大长度
 @param containChinese 包含中文
 @param firstCannotBeDigtal 首字母不为数字
 @return yes or no
 */
- (BOOL)is_ValidWithMinLenth:(NSInteger)minLenth
                   maxLenght:(NSInteger)maxLenth
              containChinese:(BOOL)containChinese
         firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 判断字符串是否满足下面要求（精确版）

 @param minLenth <#minLenth description#>
 @param maxLenth 最大长度
 @param containChinese 包含中文
 @param containDigtal 包含数字
 @param containLetter 包含字母/
 @param containOtherCharacter 包含某个字母
 @param firstCannotBeDegtal 首字母不为数字
 @return yes or no
 */
- (BOOL)is_ValidWithMinLenth:(NSInteger)minLenth
                    maxLenth:(NSInteger)maxLenth
              containChinese:(BOOL)containChinese
               containDigtal:(BOOL)containDigtal
               containLetter:(BOOL)containLetter
       containOtherCharacter:(NSString *)containOtherCharacter
         firstCannotBedigtal:(BOOL)firstCannotBeDegtal;

-(NSString *)aes256_encrypt:(NSString *)key;
-(NSString *)aes256_decrypt:(NSString *)key;



@end
