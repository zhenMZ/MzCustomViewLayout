//
//  MessageViewController.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/7.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "MessageViewController.h"
#import "TestController.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 100, 100)];
    lab.backgroundColor = [UIColor redColor];
    lab.userInteractionEnabled = YES;
    [self.view addSubview:lab];
    
    [lab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)]];
    
}

- (void)onClick {
   
    TestController *vc = [[TestController alloc] init];
    vc.title =@"fsf";
    [APP_NAVIGATION pushViewController:vc animated:YES];
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
