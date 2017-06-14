//
//  UITextView+PlaceHolder.h
//  XilianApp
//
//  Created by MZ on 2017/4/19.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UITextView (PlaceHolder)<UITextViewDelegate>
@property (nonatomic, strong) UITextView *placeHolderTextView;


/**
 textView添加占位符

 @param placeHolder 占位符
 */
- (void)text_addPlaceHolder:(NSString *)placeHolder;

/**
 获取输入的字符数，用于限制输入字符

 @param text textView中的字符串
 @return 数量
 */
- (NSInteger)getInputNumberForText:(NSString *)text;


@end
