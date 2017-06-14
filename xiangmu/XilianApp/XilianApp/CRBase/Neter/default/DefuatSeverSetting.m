//
//  DefuatSeverSetting.m
//  XilianApp
//
//  Created by Abyss on 2017/3/1.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "DefuatSeverSetting.h"
#import "CRNetDefine.h"
#import "CRManager.h"

@class SeverConfiguration;
@class SeverHost;
@interface DefuatSeverSetting()
@property (strong) NSArray* severs;
@end
@implementation DefuatSeverSetting

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        _severs = array;
    }
    return self;
}

+ (NSSet<NSObject<CRNetSeverConfiguration>*>* )defualt
{
    DefuatSeverSetting* setting = nil;
    
    NSArray* list = [NSArray arrayWithContentsOfURL:[CRManager bundleResourceWith:key_severConfiguration_defualt extension:@"plist"]];
    
    setting = [[DefuatSeverSetting alloc] initWithArray:list];
    
    NSMutableSet* set = [NSMutableSet set];
    
    for (NSDictionary* dic in setting.severs)
    {
        SeverConfiguration* configuration = [[SeverConfiguration alloc] initWithDic:dic];
        
        [set addObject:configuration];
    }
  
    return set;
}

@end

@implementation SeverConfiguration

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    
    if (self)
    {
        _sever = dic;
    }
    
    return self;
}

- (NSString *)configurationName
{
    return _sever[@"name"];
}

- (NSArray<NSObject<CRNetHostRule> *> *)hostList
{
    return _sever[@"list"];
}

- (NSString *)CDN
{
    return _sever[@"cdn"];
}

- (NSNumber *)cache
{
    return _sever[@"cache"];
}

- (NSNumber *)cacheEphemerally
{
    return _sever[@"cacheEphemerally"];
}

- (NSDictionary *)colorTopic
{
    return _sever[@"color"];
}

@end


