//
//  MZPaymentForm.m
//  XilianApp
//
//  Created by zhen mz on 2017/4/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "MZPaymentForm.h"
#import "MZSetPasswordView.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MZPaymentForm ()<MZSetPasswordViewDelegate>
@property (weak, nonatomic) IBOutlet MZSetPasswordView *inputView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic,copy) NSString *textString;

@end
@implementation MZPaymentForm

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    
    _inputView.layer.borderWidth = 1.0f;
    _inputView.layer.borderColor = UIColorFromRGB(0xC8C8C8).CGColor;
    _inputView.delegate = self;
}

-(void)passwordView:(MZSetPasswordView *)passwordView inputPassword:(NSString *)password
{
    //    //密码检测，必须是6位数字
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{6}$"];
    //    if(![predicate evaluateWithObject:password])
    //    {
    //        self.inputPassword = nil;
    //    }
    //    else
    //    {
    self.inputPassword = password;
    
    if(_completeHandle)
    {
        _completeHandle(_inputPassword);
    }
    //    }
}

-(CGSize)viewSize
{
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size;
}

-(IBAction)closeView:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.superview.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        self.superview.alpha = 0;
    }completion:^(BOOL finished) {
        if(finished)
        {
            [self removeFromSuperview];
        }
    }];

}

-(void)setGoodsName:(NSString *)goodsName
{
    if(_goodsName != goodsName)
    {
        _goodsName = goodsName;
        
        _goodsNameLabel.text = _goodsName;
    }
}

-(void)setAmount:(CGFloat)amount
{
    if(_amount != amount)
    {
        _amount = amount;
        
        _amountLabel.text = [NSString stringWithFormat:@"%.2f",amount];
    }
}

-(void)fieldBecomeFirstResponder
{
    [_inputView fieldBecomeFirstResponder];
}



@end
