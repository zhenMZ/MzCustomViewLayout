//
//  CRIconAws.m
//  XilianApp
//
//  Created by Abyss on 2017/3/9.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRIconAws.h"

@implementation CRIconAws

- (NSDictionary *)iconMap
{
    return @{@"Adjust":[NSNumber numberWithUnsignedShort:0xf042],
             @"Android":[NSNumber numberWithUnsignedShort:0xf17b]};
}

- (UIImage *)createImageForIconName:(NSString *)name
{
    if (!self.iconMap[name]) return [UIImage new];
    
    return [super createImageForIcon:[self.iconMap[name] unsignedShortValue]];
}

- (UIImage *)createImageForIcon:(CRIconUniCharAws)icon
{
    return [super createImageForIcon:icon];
}

- (NSString *)defaultName
{
    return nil;
}

@end
