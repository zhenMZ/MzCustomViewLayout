//
//  AddressWrapperViewController.m
//  XilianApp
//
//  Created by Abyss on 2017/5/16.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "AddressWrapperViewController.h"

@interface AddressWrapperViewController ()
{
    CRAddressWrapper* _wrapper;
}
@property (weak, nonatomic) IBOutlet UITextField *t1;
@property (weak, nonatomic) IBOutlet UITextField *t2;
@property (weak, nonatomic) IBOutlet UITextField *t3;
@property (weak, nonatomic) IBOutlet UITextField *t4;
@property (weak, nonatomic) IBOutlet UITextField *t5;
@property (weak, nonatomic) IBOutlet UITextField *l1;
@property (weak, nonatomic) IBOutlet UITextField *l2;
@property (weak, nonatomic) IBOutlet UILabel *result;
@end

@implementation AddressWrapperViewController

- (NSString *)name
{
    return @"AddressWrapper";
}

- (IBAction)refresh:(id)sender
{
    if (!_wrapper)
    {
        _wrapper = [[CRAddressWrapper alloc] init];
    }
    
    _wrapper.country = _t1.text;
    _wrapper.province = _t2.text;
    _wrapper.city = _t3.text;
    _wrapper.district = _t4.text;
    
    _wrapper.address = _t5.text;
    
    if (_l1.text.length>0 && _l2.text.length>0)
    {
        CLLocation* map = [[CLLocation alloc] initWithLatitude:_l1.text.doubleValue longitude:_l2.text.doubleValue];
        
        _wrapper.map = map;
    }
    
    _result.text = [NSString stringWithFormat:@"%@%@%@%@ \n%@ \n%@",_wrapper.country,_wrapper.province,_wrapper.city,_wrapper.district,_wrapper.address,_wrapper.map];
    
    __block AddressWrapperViewController* weak = self;
    _wrapper.reserveAddress = ^(CRAddressWrapper* wrapper)
    {
        weak.result.text = [NSString stringWithFormat:@"%@%@%@%@ \n%@ \n%@",wrapper.country,wrapper.province,wrapper.city,wrapper.district,wrapper.address,wrapper.map];
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _l1.text = @"39";
    _l2.text = @"116";
    
    [self refresh:nil];
}

@end
