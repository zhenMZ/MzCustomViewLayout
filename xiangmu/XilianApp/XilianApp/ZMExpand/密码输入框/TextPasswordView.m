//
//  TextPasswordView.m
//  XilianApp
//
//  Created by MZ on 2017/6/5.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "TextPasswordView.h"
@interface TextPasswordView ()<UITextFieldDelegate> {
    
    UILabel *_lable_point1;
    UILabel *_lable_point2;
    UILabel *_lable_point3;
    UILabel *_lable_point4;
    UILabel *_lable_point5;
    UILabel *_lable_point6;
}
@end


@implementation TextPasswordView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat width = frame.size.width;
        CGFloat boxSize   = frame.size.height - 20;
        CGFloat spaceSize = (width - 6*boxSize ) / 7;
        
        [self setUI:boxSize withSapceSize:spaceSize];
    }
    return self;
}

- (void)setUI:(CGFloat)boxWidth withSapceSize:(CGFloat)spaceSize {
    
    [self addSubview:self.passwordTF];
    
    UIView *view_box1 = [[UIView alloc] initWithFrame:CGRectMake(spaceSize*1+boxWidth*0, spaceSize, boxWidth, boxWidth)];
    UIView *view_box2 = [[UIView alloc] initWithFrame:CGRectMake(spaceSize*2+boxWidth*1, spaceSize, boxWidth, boxWidth)];
    UIView *view_box3 = [[UIView alloc] initWithFrame:CGRectMake(spaceSize*3+boxWidth*2, spaceSize, boxWidth, boxWidth)];
    UIView *view_box4 = [[UIView alloc] initWithFrame:CGRectMake(spaceSize*4+boxWidth*3, spaceSize, boxWidth, boxWidth)];
    UIView *view_box5 = [[UIView alloc] initWithFrame:CGRectMake(spaceSize*5+boxWidth*4, spaceSize, boxWidth, boxWidth)];
    UIView *view_box6 = [[UIView alloc] initWithFrame:CGRectMake(spaceSize*6+boxWidth*5, spaceSize, boxWidth, boxWidth)];
    
    [view_box1.layer setBorderWidth:1.0];
    [view_box2.layer setBorderWidth:1.0];
    [view_box3.layer setBorderWidth:1.0];
    [view_box4.layer setBorderWidth:1.0];
    [view_box5.layer setBorderWidth:1.0];
    [view_box6.layer setBorderWidth:1.0];
    
    view_box1.layer.borderColor = [[UIColor grayColor]CGColor];
    view_box2.layer.borderColor = [[UIColor grayColor]CGColor];
    view_box3.layer.borderColor = [[UIColor grayColor]CGColor];
    view_box4.layer.borderColor = [[UIColor grayColor]CGColor];
    view_box5.layer.borderColor = [[UIColor grayColor]CGColor];
    view_box6.layer.borderColor = [[UIColor grayColor]CGColor];
    
    [self addSubview:view_box1];
    [self addSubview:view_box2];
    [self addSubview:view_box3];
    [self addSubview:view_box4];
    [self addSubview:view_box5];
    [self addSubview:view_box6];
    
    _lable_point1 = [[UILabel alloc] init];
    _lable_point2 = [[UILabel alloc] init];
    _lable_point3 = [[UILabel alloc] init];
    _lable_point4 = [[UILabel alloc] init];
    _lable_point5 = [[UILabel alloc] init];
    _lable_point6 = [[UILabel alloc] init];
    
    _lable_point1.frame = CGRectMake((view_box1.frame.size.width-10)/2, (view_box1.frame.size.width-10)/2, 10, 10);
    _lable_point2.frame = CGRectMake((view_box1.frame.size.width-10)/2, (view_box1.frame.size.width-10)/2, 10, 10);
    _lable_point3.frame = CGRectMake((view_box1.frame.size.width-10)/2, (view_box1.frame.size.width-10)/2, 10, 10);
    _lable_point4.frame = CGRectMake((view_box1.frame.size.width-10)/2, (view_box1.frame.size.width-10)/2, 10, 10);
    _lable_point5.frame = CGRectMake((view_box1.frame.size.width-10)/2, (view_box1.frame.size.width-10)/2, 10, 10);
    _lable_point6.frame = CGRectMake((view_box1.frame.size.width-10)/2, (view_box1.frame.size.width-10)/2, 10, 10);
    
    [_lable_point1.layer setCornerRadius:5];
    [_lable_point2.layer setCornerRadius:5];
    [_lable_point3.layer setCornerRadius:5];
    [_lable_point4.layer setCornerRadius:5];
    [_lable_point5.layer setCornerRadius:5];
    [_lable_point6.layer setCornerRadius:5];
    
    [_lable_point1.layer setMasksToBounds:YES];
    [_lable_point2.layer setMasksToBounds:YES];
    [_lable_point3.layer setMasksToBounds:YES];
    [_lable_point4.layer setMasksToBounds:YES];
    [_lable_point5.layer setMasksToBounds:YES];
    [_lable_point6.layer setMasksToBounds:YES];
    
    _lable_point1.backgroundColor = [UIColor blackColor];
    _lable_point2.backgroundColor = [UIColor blackColor];
    _lable_point3.backgroundColor = [UIColor blackColor];
    _lable_point4.backgroundColor = [UIColor blackColor];
    _lable_point5.backgroundColor = [UIColor blackColor];
    _lable_point6.backgroundColor = [UIColor blackColor];
    
    [view_box1 addSubview:_lable_point1];
    [view_box2 addSubview:_lable_point2];
    [view_box3 addSubview:_lable_point3];
    [view_box4 addSubview:_lable_point4];
    [view_box5 addSubview:_lable_point5];
    [view_box6 addSubview:_lable_point6];
    
    _lable_point1.hidden=YES;
    _lable_point2.hidden=YES;
    _lable_point3.hidden=YES;
    _lable_point4.hidden=YES;
    _lable_point5.hidden=YES;
    _lable_point6.hidden=YES;
}

- (UITextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _passwordTF.delegate = self;
        _passwordTF.keyboardType = UIKeyboardTypeNumberPad;
        [_passwordTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordTF;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _passwordTF) {
        
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidChange:(id)sender {
    
    UITextField *_filed = (UITextField *)sender ;
    
    switch (_filed.text.length) {
        case 0:
        {
            _lable_point1.hidden = YES;
            _lable_point2.hidden = YES;
            _lable_point3.hidden = YES;
            _lable_point4.hidden = YES;
            _lable_point5.hidden = YES;
            _lable_point6.hidden = YES;
        }
            break;
        case 1:
        {
            _lable_point1.hidden = NO;
            _lable_point2.hidden = YES;
            _lable_point3.hidden = YES;
            _lable_point4.hidden = YES;
            _lable_point5.hidden = YES;
            _lable_point6.hidden = YES;
        }
            break;
        case 2:
        {
            _lable_point1.hidden = NO;
            _lable_point2.hidden = NO;
            _lable_point3.hidden = YES;
            _lable_point4.hidden = YES;
            _lable_point5.hidden = YES;
            _lable_point6.hidden = YES;
        }
            break;
        case 3:
        {
            _lable_point1.hidden = NO;
            _lable_point2.hidden = NO;
            _lable_point3.hidden = NO;
            _lable_point4.hidden = YES;
            _lable_point5.hidden = YES;
            _lable_point6.hidden = YES;
        }
            break;
        case 4:
        {
            _lable_point1.hidden = NO;
            _lable_point2.hidden = NO;
            _lable_point3.hidden = NO;
            _lable_point4.hidden = NO;
            _lable_point5.hidden = YES;
            _lable_point6.hidden = YES;
        }
            break;
        case 5:
        {
            _lable_point1.hidden = NO;
            _lable_point2.hidden = NO;
            _lable_point3.hidden = NO;
            _lable_point4.hidden = NO;
            _lable_point5.hidden = NO;
            _lable_point6.hidden = YES;
        }
            break;
        case 6:
        {
            _lable_point1.hidden = NO;
            _lable_point2.hidden = NO;
            _lable_point3.hidden = NO;
            _lable_point4.hidden = NO;
            _lable_point5.hidden = NO;
            _lable_point6.hidden = NO;
        }
            break;
        default:
            break;
    }
    if (_filed.text.length==6)
    {
        [self.delegate TXTPasswordView:self WithPasswordString:_filed.text];
    }
 
}


@end
