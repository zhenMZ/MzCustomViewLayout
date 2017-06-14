//
//  CRFontIconFactory.h
//  XilianApp
//
//  Created by Abyss on 2017/3/9.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CREFontIcon.h"

NS_ASSUME_NONNULL_BEGIN

/**
 CRFontIconFactory
 字体库工厂
 请继承,重载方法使用
 每个子类对应一个字体库
 */
@interface CRFontIconFactory : NSObject <NSCopying,CREFontIcon>

/** [Override] 字体库名称 */
- (NSString * __nullable)defaultName;


/** [Override] 创建方法 */
- (NSDictionary *)iconMap;
- (UIImage *)createImageForIcon:(UniChar)icon;
- (UIImage *)createImageForIconName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
