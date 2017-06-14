//
//  HolderBuilder.h
//  XilianApp
//
//  Created by Abyss on 2017/2/23.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HolderBuilder : NSObject

+ (UIImage *)holderImageW:(float)w H:(float)h;
+ (void)setDefaultHolderImage:(NSString *)holderImage;

+ (UIView *)holderViewName:(NSString *)name
                      icon:(NSString *)icon
                     title:(NSString *)title
                       des:(NSString *)des
                    action:(SEL)action
                    button:(NSString *)button;
@end
