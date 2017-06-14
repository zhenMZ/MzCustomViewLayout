//
//  CRAcount.m
//  XilianApp
//
//  Created by Abyss on 2017/2/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRAcount.h"
#import <SAMKeychain/SAMKeychain.h>
#import "CRAcounter.h"
#import "CRCacher.h"
#import "NSObject+CRLogger.h"

@interface CRAcount()
@end

@implementation CRAcount

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    
    if(!self) return nil;
    if(!name) return nil;
    
    _name = name;
    
    return self;
}

- (NSString *)password
{
    return [SAMKeychain passwordForService:[CRAcounter serviceName] account:_name]?:@"";
}

- (void)setUserDic:(NSDictionary *)userDic
{
    [[CRCacher cacherDefault] setObject:userDic forKey:[key_user_default stringByAppendingString:_name]];
}

- (NSDictionary *)userDic
{
    return (NSDictionary *)[[CRCacher cacherDefault] objectForKey:[key_user_default stringByAppendingString:_name]]?:@{};
}

- (NSString *)description
{
    return [self descriptionWithDic:@{@"Name":self.name,
                                      @"Password":self.password,
                                      @"UserInfo":self.userDic}];
}

@end

