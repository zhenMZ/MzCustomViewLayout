//
//  CRBaser.h
//  XilianApp
//
//  Created by Abyss on 2017/2/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* CR库中心控制器 */
/**
 关于宏
 ----------
 尽量全部写在CRDefines
 尽量不适用宏,以防和已经存在的冲突难找到错误
 
 关于运行时
 ----------
 [CRRunTimeMagic]统一管理运行时的类
 
 关于本地储存
 ----------
 账户信息使用[CRAcounter]存在设备Keychain里面
 本地简单默认数据保存[RStorager]结合文件与数据库存储(com.cacher.default)
 网络图片使用[],默认三方是PinRemoteImage 数据库(com.cacher.pin)
 缓存(Cacher)集合内存存储,本地文件和数据存储，适合存储公共的,简单的一些数据
 
 关于日志打印
 ----------
 使用[CRLogger],默认三方是CocoaLumberjack
 利用[NSObject+CRLogger]可以更方便的输出Decription属性和打印对象
 通过[CRLoggerFormatter]设置默认格式，也可以继承他定义自己的格式输出
 打印控制按钮 DEBUG_LOG 默认取决于 DEBUG(工程默认)
 */


@interface CRBaser : NSObject

/* 启动一系列服务,建议在程序开启时调用 PS:区分DEBUG */
+ (void)setup;

/* 启动页面 */
+ (void)start:(UIViewController *)controller;

@end
