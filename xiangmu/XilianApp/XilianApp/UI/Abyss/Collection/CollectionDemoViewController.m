//
//  CollectionDemoViewController.m
//  XilianApp
//
//  Created by Abyss on 2017/5/16.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CollectionDemoViewController.h"
#import "CRDataLoader.h"

#import "AddressWrapperViewController.h"
#import "DictionaryWrapperViewController.h"
#import "SpecialWrapperViewController.h"
#import "TimeWrapperViewController.h"

@interface CollectionDemoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) CRDataLoader* loader;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CollectionDemoViewController

- (NSString *)name
{
    return @"Colloction";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _loader = [CRDataLoader loaderWithApi:nil target:self.tableView];
    _loader.localData = @[@{@"name":@"DictionaryWrapper",@"push":@"DictionaryWrapperViewController"},
                          @{@"name":@"TimeWrapper",@"push":@"TimeWrapperViewController"},
                          @{@"name":@"AddressWrapperView",@"push":@"AddressWrapperViewController"},
                          @{@"name":@"SpecialWrapper",@"push":@"SpecialWrapperViewController"},];
    
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
    static NSString *identifier = @"CollectionDemoViewController";
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
    if (model) [APP_NAVIGATION pushViewController:[model new] animated:YES];
}

@end
