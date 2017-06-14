//
//  HomeViewController.m
//  XilianApp
//
//  Created by zhen mz on 2017/5/7.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "HomeViewController.h"
#import "S_ViewController.h"
#import "D_ViewController.h"
#import "DemoTracerViewController.h"
#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
@interface HomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UISegmentedControl *segView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"喜乐宝";
    self.title = @"tttt";
    self.navigationItem.titleView = self.segView;
//    self.navigationItem.titleView = self.segView;
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"扫码"]];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:img];
    self.navigationItem.leftBarButtonItem = leftBtn;


    [self.view addSubview:self.scrollView];
}

- (UISegmentedControl*)segView {
    if (!_segView) {
        _segView = [[UISegmentedControl alloc] initWithItems:@[@"商家",@"代理商"]];
        _segView.frame = CGRectMake(20, 79, 160, 30);
        _segView.selectedSegmentIndex = 0;
        _segView.backgroundColor = [UIColor clearColor];
        _segView.tintColor = [UIColor whiteColor];
        _segView.layer.cornerRadius = 5.0f;
        _segView.layer.borderWidth = 2.0f;
        _segView.layer.borderColor = [UIColor whiteColor].CGColor;
        _segView.layer.masksToBounds = YES;
        [_segView addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:15], NSFontAttributeName,nil];
        [_segView setTitleTextAttributes:dic forState:UIControlStateNormal];
        [_segView setTitleTextAttributes:dic forState:UIControlStateSelected];

        
    }
    return _segView;
}


- (UIScrollView*)scrollView {
    if (!_scrollView) {

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH - 64 - 49 )];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [_scrollView setContentSize:CGSizeMake(screenW*2, CGRectGetHeight(_scrollView.frame))];
        
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW*2, screenH - 64)];
        [_scrollView addSubview:contentView];
        
        S_ViewController *controller1 = [[S_ViewController alloc] init];
        controller1.view.frame = CGRectMake(0, 0, screenW,  CGRectGetHeight(_scrollView.frame));
        [contentView addSubview:controller1.view];
        [self addChildViewController:controller1];
        
        D_ViewController *controller2 = [[D_ViewController alloc] init];
        controller2.view.frame = CGRectMake(screenW, 0, screenW,  CGRectGetHeight(_scrollView.frame));
        [contentView addSubview:controller2.view];
        [self addChildViewController:controller2];

        
    }
    return _scrollView;
}

- (void)didClicksegmentedControlAction:(UISegmentedControl*)seg {
    NSInteger index = seg.selectedSegmentIndex;
    [_scrollView setContentOffset:CGPointMake(index*CGRectGetWidth(_scrollView.frame), 0) animated:YES];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _segView.selectedSegmentIndex = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
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
