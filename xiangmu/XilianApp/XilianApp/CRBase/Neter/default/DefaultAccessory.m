//
//  DefaultAccessory.m
//  XilianApp
//
//  Created by Abyss on 2017/3/2.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "DefaultAccessory.h"
#import "CRLogger.h"

@implementation DefaultAccessory

+ (instancetype)defaultAccessory
{
    return [[self alloc] init];
}

- (void)requestWillStart:(CRRequest *)request
{
    
}

- (void)requestDidStop:(CRRequest *)request
{
    DDLogInfo(@"%@",request);
}

@end
