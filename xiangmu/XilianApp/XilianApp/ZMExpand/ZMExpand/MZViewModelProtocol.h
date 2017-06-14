//
//  MZViewModelProtocol.h
//  XilianApp
//
//  Created by zhen mz on 2017/4/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

/**
 *
 *  注意：这个文件还未封装好，view于view之间的耦合未作处理
 *
 */







#import <UIKit/UIKit.h>
#import "DefaultRequest.h"
@class MZViewProtocol;

typedef void (^successBlock)(id responseObject);
typedef void (^failureBlock)(NSError *error);
typedef void (^progressBlock)(NSProgress *progress);
typedef void (^ViewModelInfoBlock)();

@protocol MZViewModelProtocol <NSObject>

@optional

- (DefaultRequest *)mz_viewModelRequest:(progressBlock)progress success:(successBlock)success failure:(failureBlock)failure;

/**
 viewmodel 中请求数据，把数据传给view中使用

 @param modelBlock 传值
 */
- (void)mz_giveModelToViewBlock:(void (^)(id model))modelBlock;

/**
 传递事件

 @param infos 用于区别哪个事件响应
 @return 返回一个block
 */
- (ViewModelInfoBlock)mz_giveModelManagerAction:(NSDictionary *)infos;

@end

@protocol MZViewProtocol <NSObject>

@optional

- (void)mz_view:(__kindof UIView *)view withEvents:(NSDictionary *)events;


@end


