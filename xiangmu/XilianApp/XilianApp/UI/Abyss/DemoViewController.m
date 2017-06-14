//
//  DemoViewController.m
//  XilianApp
//
//  Created by Abyss on 2017/5/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "DemoViewController.h"
#import "DemoTracerViewController.h"
#import "CRDataLoader.h"
#import "LoginViewController.h"

@interface DemoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) CRDataLoader* loader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loader = [CRDataLoader loaderWithApi:nil target:self.tableView];
    _loader.localData = @[@{@"name":@"Collection",@"push":@"CollectionDemoViewController"},
                          @{@"name":@"Login",@"push":@"LoginViewController"},
                          @{@"name":@"测试3",@"push":@""},
                          @{@"name":@"测试4",@"push":@""},
                          @{@"name":@"测试5",@"push":@""},
                          @{@"name":@"测试6",@"push":@""},
                          @{@"name":@"测试7",@"push":@""},
                          @{@"name":@"测试8",@"push":@""},
                          @{@"name":@"Tracer",@"push":@"DemoTracerViewController"},];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _loader.refreshCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DemoViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary* dic = _loader.loadData[indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"name"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = _loader.loadData[indexPath.row];
    
    NSString* push = [dic objectForKey:@"push"];

    Class model = NSClassFromString(push);
    if (model)
    {
        [APP_NAVIGATION pushViewController:[model new] animated:YES];
    }
}

@end
