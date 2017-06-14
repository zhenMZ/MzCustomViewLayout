//
//  UIImageView+Net.m
//  XilianApp
//
//  Created by Abyss on 2017/3/6.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UIImageView+Net.h"
#import <PINImageView+PINRemoteImage.h>
#import "HolderBuilder.h"
#import "UIView+Tool.h"
#import "NSString+Strategy.h"

@implementation UIImageView(Net)

- (void)loadImageNamed:(NSString *)url
{
    [self loadImageNamed:url placeHolder:nil];
}

- (void)loadImageNamed:(NSString *)url placeHolder:(NSString *)placeHolder
{
    UIImage* holder = nil;
    
    if (!placeHolder) holder = [HolderBuilder holderImageW:self.width*2 H:self.height*2];
    
    holder = [UIImage imageNamed:placeHolder]?:[UIImage new];
    
    [self pin_setImageFromURL:url.URL placeholderImage:holder completion:^(PINRemoteImageManagerResult * __nonnull result){
        
    }];
}

@end
