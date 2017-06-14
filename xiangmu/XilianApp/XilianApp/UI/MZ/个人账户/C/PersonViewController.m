//
//  PersonViewController.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/7.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "PersonViewController.h"
#import "AuthcodeView.h"
#import "TextPasswordView.h"
@interface PersonViewController ()<TextPasswordViewDelegate>
{
    TextPasswordView *_passwordView;
}
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    AuthcodeView *code = [[AuthcodeView alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    [self.view addSubview:code];
    
     _passwordView = [[TextPasswordView alloc] initWithFrame:CGRectMake(30, 250, 250, 50)];
    _passwordView.delegate = self;
    [self.view addSubview:_passwordView];

    [_passwordView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclick:)]];

    
}

- (void)onclick:(UITapGestureRecognizer*)tap {
    
    [_passwordView.passwordTF becomeFirstResponder];
    
    
}

- (void)TXTPasswordView:(TextPasswordView *)view WithPasswordString:(NSString *)password {
    
    NSLog(@"输出的密码：%@",password);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
