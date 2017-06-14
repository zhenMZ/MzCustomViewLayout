//
//  CRAcounter.m
//  XilianApp
//
//  Created by Abyss on 2017/2/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRAcounter.h"
#import <SAMKeychain/SAMKeychain.h>

#import "CRAcount.h"

@interface CRAcounter()
@end

@implementation CRAcounter

+ (NSString *)serviceName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (CRAcount *)acountNamed:(NSString *)name
{
    return [[CRAcount alloc] initWithName:name];
}

+ (void)delAcountNamed:(NSString *)name
{
    [SAMKeychain deletePasswordForService:[CRAcounter serviceName] account:name];
}

+ (NSArray *)acountList
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:[SAMKeychain accountsForService:[CRAcounter serviceName]]];
    
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
    {
        return ((NSDate *)[obj1 objectForKey:@"mdat"]).timeIntervalSince1970 < ((NSDate *)[obj2 objectForKey:@"mdat"]).timeIntervalSince1970;
    }];
    
    return array;
}

+ (void)addAcountNamed:(NSString *)name
{
    [CRAcounter addAcountNamed:name pwd:@""];
}

+ (void)addAcountNamed:(NSString *)name pwd:(NSString *)pwd
{
    [SAMKeychain setPassword:pwd forService:[CRAcounter serviceName] account:name];
}

@end
