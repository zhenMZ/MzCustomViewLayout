//
//  UITextView+PlaceHolder.m
//  XilianApp
//
//  Created by MZ on 2017/4/19.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UITextView+PlaceHolder.h"

static  NSString  const *z_placeHolderTextView = @"z_placeHolderTextView";

@implementation UITextView (PlaceHolder)

- (UITextView *)placeHolderTextView {
    return objc_getAssociatedObject(self, (__bridge const void *)(z_placeHolderTextView));

}

- (void)setPlaceHolderTextView:(UITextView *)placeHolderTextView {
    objc_setAssociatedObject(self, (__bridge const void *)(z_placeHolderTextView), placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)text_addPlaceHolder:(NSString *)placeHolder {
    if (![self placeHolderTextView]) {
        UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.font = self.font;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor grayColor];
        textView.userInteractionEnabled = NO;
        textView.text = placeHolder;
        [self addSubview:textView];
        [self setPlaceHolderTextView:textView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    }
    self.placeHolderTextView.text = placeHolder;
}

- (NSInteger)getInputNumberForText:(NSString *)text {
    NSInteger textNum = 0;
    UITextRange *selectRange = [self markedTextRange];
    if (selectRange) {
        NSString *newText = [self textInRange:selectRange];
        textNum = (newText.length + 1) / 2 + [self offsetFromPosition:self.beginningOfDocument toPosition:selectRange.start] +text.length;
    }else{
        textNum = self.text.length + text.length;
    }
    return textNum;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(NSNotification *)noti {
    self.placeHolderTextView.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.text && [self.text isEqualToString:@""]) {
        self.placeHolderTextView.hidden = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
