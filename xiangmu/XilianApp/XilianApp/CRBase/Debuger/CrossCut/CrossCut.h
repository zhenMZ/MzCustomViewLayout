//
//  CrossCut.h
//  XilianApp
//
//  Created by Abyss on 2017/5/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CrossCut;
typedef void (^TouchBlock) (CrossCut* crossCut);

@interface CrossCut : UIButton

@property (nonatomic, copy) TouchBlock touch;

+ (instancetype)crossCutNamed:(NSString *)title;

- (instancetype)initWithColor:(UIColor *)color title:(NSString *)title;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
