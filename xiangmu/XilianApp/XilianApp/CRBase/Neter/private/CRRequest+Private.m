//
//  CRRequest+Private.m
//  XilianApp
//
//  Created by Abyss on 2017/3/1.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRRequest+Private.h"
#import "CRNetCache.h"
#import "CRManager.h"
#import "CRNetEngine.h"

@implementation CRRequest (Private)

- (void)clearBlock
{
    self.success = nil;
    self.failure = nil;
}

- (void)writeCache
{
    if (self.useCache == 0) return;

    NSNumber* time = [self.params objectForKey:key_netConfig_cacheTime]?:@(0);
    NSNumber* timeEphemerally = [self.params objectForKey:key_netConfig_cacheTimeEphemerally]?:@(0);
    
    CRNetCache* cache = [[CRNetCache alloc] init];
    
    cache.date = [NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970 + time.longLongValue];
    cache.data = [NSKeyedArchiver archivedDataWithRootObject:self.data];
    cache.identifier = self.identifier;
    cache.version = [CRManager appVersion];
    cache.dateEphemerally = [NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970 + timeEphemerally.longLongValue];
    
    [[CRNetEngine defaultEngine].cacher setObject:cache forKey:cache.identifier];
}

- (void)accessoryWillStart
{
    if(!self.accessories) return;
    
    for (NSObject<CRRequestAccessory> *accessory in self.accessories)
    {
        [accessory requestWillStart:self];
    }
}

- (void)accessoryDidEnd
{
    if(!self.accessories) return;
    
    for (NSObject<CRRequestAccessory> *accessory in self.accessories)
    {
        [accessory requestDidStop:self];
    }
}

@end
