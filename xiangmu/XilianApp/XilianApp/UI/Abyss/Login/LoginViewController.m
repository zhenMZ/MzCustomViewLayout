//
//  LoginViewController.m
//  XilianApp
//
//  Created by Abyss on 2017/5/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "LoginViewController.h"
#import "Loginer.h"

#import "CRAcounter.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *t1;
@property (weak, nonatomic) IBOutlet UITextField *t2;

@property (weak, nonatomic) IBOutlet UITextView *result;
@end

@implementation LoginViewController

- (NSString *)name
{
    return @"登录";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self sayResult];
}

- (IBAction)go:(id)sender
{
    [self.view endEditing:YES];
    
    [APP_DELEGATE.loginer loginWithUserName:_t1.text?:@"" pwd:_t2.text?:@"" userDic:@{}];
    
    [self sayResult];
}

- (void)sayResult
{
    self.result.text = [NSString stringWithFormat:@"userName:%@\nPWD:%@\ntime:%@\nLastName:%@\nUserDic:%@\nLocation:%@",APP_DELEGATE.loginer.person.name,APP_DELEGATE.loginer.person.password,APP_DELEGATE.loginer.person.lastLoginTime,APP_DELEGATE.loginer.lastPersonName,APP_DELEGATE.loginer.person.userDic,APP_DELEGATE.loginer.person.location?:@""];
}

- (IBAction)history:(id)sender
{
    self.result.text = [NSString stringWithFormat:@"%@",[CRAcounter acountList]];
}
- (IBAction)location:(id)sender
{
    APP_DELEGATE.loginer.person.locationChange = ^(CRAddressWrapper* location){
        _result.text = [location description];
    };
    
    [APP_DELEGATE.loginer.person refreshWithTimeUpdate:NO];
}
@end
