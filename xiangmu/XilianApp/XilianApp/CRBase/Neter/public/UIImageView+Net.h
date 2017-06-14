//
//  UIImageView+Net.h
//  XilianApp
//
//  Created by Abyss on 2017/3/6.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(Net)

- (void)loadImageNamed:(NSString *)url;

- (void)loadImageNamed:(NSString *)url placeHolder:(NSString *)placeHolder;

@end
