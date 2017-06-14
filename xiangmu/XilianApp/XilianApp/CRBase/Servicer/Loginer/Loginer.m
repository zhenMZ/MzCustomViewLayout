//
//  Loginer.m
//  XilianApp
//
//  Created by Abyss on 2017/4/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "Loginer.h"
#import "CRAcounter.h"
#import "CRDefines.h"
#import "AppDelegate.h"

static LoginFlag isLoginFlag = nil;

@interface Loginer ()
@end

@implementation Loginer

- (instancetype)initWithSomething
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)global
{
    static Loginer* loginer;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        loginer = [[Loginer alloc] initWithSomething];
    });
    
    return loginer;
}

- (void)showLogin
{
    
}

- (NSString *)lastPersonName
{
    return [[CRAcounter acountList].firstObject objectForKey:@"acct"];
}

- (void)loginWithUserName:(NSString *)userName pwd:(NSString *)pwd userDic:(NSDictionary *)userDic
{
    [CRAcounter addAcountNamed:userName pwd:pwd];
    
    APP_DELEGATE.loginer.person = [[CRUser alloc] initWithName:userName];
    APP_DELEGATE.loginer.person.userDic = userDic;
    [APP_DELEGATE.loginer.person refreshWithTimeUpdate:YES];
}

- (BOOL)isLogin
{
    return isLoginFlag?isLoginFlag(self.person):YES;
}

@end
