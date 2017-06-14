//
//  CRDataLoaderConfig.m
//  XilianApp
//
//  Created by Abyss on 2017/5/15.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRDataLoaderConfig.h"
#import "CRDataLoader.h"
#import "MJRefresh.h"

@interface CRDataLoader ()
- (void)requestData:(BOOL)byFooter;
@end

@implementation CRDataLoaderConfig

+ (void)defualt
{
    // 默认参数生成器
    [CRDataLoader setDefuatDataLoaderUrlGeter:^NSDictionary * _Nonnull(NSString * _Nonnull loadApi, NSUInteger pageIndex, NSUInteger pageSize) {
        return @{};
    }];
    
    // 请求器
   [CRDataLoader setDefuatDataLoaderRequester:^(CRDataLoader * _Nonnull loader, SEL  _Nonnull seletor, BOOL byHeader, NSDictionary * _Nonnull refreshData) {
       
       
       // 请求后回调
       [loader performSelector:seletor
                    withObject:nil
                    afterDelay:0];
   }];
    
    // 获得数组数据
    [CRDataLoader setDefuatDataLoaderListGeter:^NSArray * _Nonnull(NSDictionary * _Nonnull requestData) {
        return @[];
    }];
    
    // 将要处理数据
    [CRDataLoader setDefuatDataLoaderWillLoad:^NSArray *(CRDataLoader * _Nonnull loader, BOOL byFooter, CRRequest * _Nonnull request) {
        return @[];
    }];
    
    // 已经处理完数据
    [CRDataLoader setDefuatDataLoaderDidLoad:^(CRDataLoader * _Nonnull loader, BOOL byFooter, NSArray * _Nonnull data) {
        
    }];
        
    // Header
    [CRDataLoader setDefuatCustomLoaderHeader:^id(CRDataLoader* loader, NSDictionary * _Nonnull requestData) {
        return [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [loader requestData:NO];
        }];
;
    }];
    
    // Footer
    [CRDataLoader setDefuatCustomLoaderFooter:^id(CRDataLoader* loader, NSDictionary * _Nonnull requestData) {
        return  [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            [loader requestData:YES];
        }];
;
    }];
}

@end
