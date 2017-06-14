//
//  CRMathUtil.m
//  XilianApp
//
//  Created by Abyss on 2017/5/16.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRMathUtil.h"

@implementation CRMathUtil

+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}


@end
