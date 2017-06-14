//
//  CRUser.m
//  XilianApp
//
//  Created by Abyss on 2017/5/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRUser.h"
#import "Loginer.h"
#import "CRDefines.h"
#import "CRTimeWrapper.h"
#import "CRDictionaryWrapper.h"
#import "CRLocationManager.h"

@interface CRUser ()
@end

@implementation CRUser

- (NSString *)ID
{
    return [self.userDic.wrapper getString:@"ID"];
}

- (CRTimeWrapper *)lastLoginTime
{
    return [self.userDic.wrapper get:@"DATE"];
}

- (CRAddressWrapper *)location
{
    return [self.userDic.wrapper get:@"LOCATION"];
}

- (void)refreshWithTimeUpdate:(BOOL)timeUpdate
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:self.userDic];
    
    if (timeUpdate)
    {
        [dic setValue:[CRTimeWrapper wrapperNow] forKey:@"DATE"];
    }
    
    [[CRLocationManager share] requestLocationUserblock:^(CLLocation *currentLocation, CRLocationAccuracy achievedAccuracy, CRLocationStatus status)
    {
        CRAddressWrapper* location = [CRAddressWrapper wrapperFrom:currentLocation];
        
        __block CRAddressWrapper* weak = location;
        location.reserveAddress = ^(CRAddressWrapper *place){
            if (weak)
            {
                if (_locationChange)
                {
                    _locationChange(weak);
                }
                
                [dic setValue:weak forKey:@"LOCATION"];
                
                self.userDic = dic;
            }
        };
    }];
    
    self.userDic = dic;
}

@end
