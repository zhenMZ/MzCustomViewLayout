//
//  CRNetConfig.m
//  XilianApp
//
//  Created by Abyss on 2017/2/28.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRNetConfig.h"
#import "DefuatSeverSetting.h"

@interface CRNetConfig()
@property (nonatomic, strong) NSString* name;
@end
@implementation CRNetConfig

+ (instancetype)defaultConfig
{
    static id defaultConfig = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        defaultConfig = [[self alloc] init];
    });
    
    return defaultConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _severs = [DefuatSeverSetting defualt];
    }
    return self;
}

- (void)swithSeverTo:(NSString *)severName
{
    _name = severName?:@"";
}

- (NSObject<CRNetSeverConfiguration>*)sever
{
    if (!_severs)
    {
        return nil;
    }
    
    __block NSString* name = _name?:@"DEBUG";
    __block NSObject<CRNetSeverConfiguration>* temp = nil;

    [_severs enumerateObjectsUsingBlock:^(NSObject<CRNetSeverConfiguration>* obj, BOOL* stop)
    {
        if ([name isEqualToString:obj.configurationName])
        {
            temp = obj;
            *stop = YES;
        }
    }];
    
    
    return temp;
}

@end
