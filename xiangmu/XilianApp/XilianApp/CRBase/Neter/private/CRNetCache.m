//
//  CRNetCache.m
//  XilianApp
//
//  Created by Abyss on 2017/2/28.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRNetCache.h"

@implementation CRNetCache

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.version forKey:NSStringFromSelector(@selector(version))];
    [aCoder encodeObject:self.date forKey:NSStringFromSelector(@selector(date))];
    [aCoder encodeObject:self.identifier forKey:NSStringFromSelector(@selector(identifier))];
    [aCoder encodeObject:self.data forKey:NSStringFromSelector(@selector(data))];
    [aCoder encodeObject:self.dateEphemerally forKey:NSStringFromSelector(@selector(dateEphemerally))];
}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.version = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(version))];
    self.date = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(date))];
    self.identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(identifier))];
    self.data = [aDecoder decodeObjectOfClass:[NSData class] forKey:NSStringFromSelector(@selector(data))];
    self.dateEphemerally = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(dateEphemerally))];
    
    return self;
}


- (id)responseData
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.data?:[NSData data]];
}


@end

