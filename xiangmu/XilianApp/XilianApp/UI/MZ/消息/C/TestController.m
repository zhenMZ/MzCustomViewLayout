//
//  TestController.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "TestController.h"
#import "ZPopView.h"
#import "MZLocalCity.h"
#import "ZPopupView.h"
@interface TestController () {
    ZPopView *PV; ZPopView *PV2;
}
@property (strong, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.title = @"fsfs";
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 100, 100)];
    lab.backgroundColor = [UIColor redColor];
    lab.userInteractionEnabled = YES;
    [self.view addSubview:lab];
    
    [lab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)]];
    

    
}
- (IBAction)btnClick:(id)sender {
    
    [PV closeXib];
    
    _popView.frame = CGRectMake(100, 250, 100, 100);
    PV2 = [[ZPopView alloc] initWithFrame:CGRectZero withSpecificUI:_popView];
    [PV2 addSubview:_popView];
    PV2.animationStyle = ZAnimationTopShake;
    [PV2 showXib];
    
    [MZLocalCity startLocalAddressSuccess:^(NSDictionary *address) {
        NSLog(@"我现在在%@",address);
        
    } failure:^(NSError *failure) {
        NSLog(@"失败了");
    }];
    
    
    
}

- (void)onClick {
    
    
  
    
    ZPopupView *view1 = [ZPopupView alertViewWithTitle:@"麻辣隔壁" andMessage:@"这真是个麻辣隔壁"];
    [view1 addButtonWithTitle:@"不取消" type:ZAlertViewButtonTypeDefault handler:^(ZPopupView *alertView) {
        
    }];
    [view1 show];
    
    
    ZPopupView *view = [[ZPopupView alloc] init];
    view.alertViewStyle = ZToastView;
    [view show];
//    _popView.frame = CGRectMake(10, 100, 100, 100);
//    PV = [[ZPopView alloc] initWithFrame:CGRectZero withSpecificUI:_popView];
//    [PV addSubview:_popView];
//    [PV showXib];
    
    
}


@end
