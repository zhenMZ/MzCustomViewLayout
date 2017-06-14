//
//  TimeWrapperViewController.m
//  XilianApp
//
//  Created by Abyss on 2017/5/16.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "TimeWrapperViewController.h"

@interface TimeWrapperViewController ()
{
    CRTimeWrapper* _inputDate;
    CRTimeWrapper* _nowDate;
    
    BOOL _go;
    BOOL _foward;
}

@property (weak, nonatomic) IBOutlet UITextField *inputDateString;
@property (weak, nonatomic) IBOutlet UITextField *pDateString;

@property (weak, nonatomic) IBOutlet UILabel *Des1;
@property (weak, nonatomic) IBOutlet UILabel *Time1;
@property (weak, nonatomic) IBOutlet UILabel *Long1;
@property (weak, nonatomic) IBOutlet UILabel *Des2;
@property (weak, nonatomic) IBOutlet UILabel *Time2;
@property (weak, nonatomic) IBOutlet UILabel *Long2;

@end

@implementation TimeWrapperViewController

- (NSString *)name
{
    return @"TimeWrapper";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nowDate = [CRTimeWrapper wrapperNow];
    _nowDate.timesChangeBlock = ^(CRTimeWrapper* timeWrapper)
    {
        _Des2.text = _nowDate.datePeriodDescription;
        _Time2.text = _nowDate.dateDescription;
        _Long2.text = [NSString stringWithFormat:@"%f",_nowDate.timeInterval];
    };
    [_nowDate startUp];
}

- (void)refresh
{
    _Des1.text = _inputDate.datePeriodDescription;
    _Time1.text = _inputDate.dateDescription;
    _Long1.text = [NSString stringWithFormat:@"%f",_inputDate.timeInterval];
}

- (IBAction)show:(id)sender
{
    _inputDate = [CRTimeWrapper wrapperFromString:_inputDateString.text?:@""];
    _inputDate.pDate = [CRTimeWrapper wrapperFromString:_pDateString.text?:@""].date;
    
    _inputDate.timesChangeBlock = ^(CRTimeWrapper* timeWrapper)
    {
        _Des1.text = _inputDate.datePeriodDescription;
        _Time1.text = _inputDate.dateDescription;
        _Long1.text = [NSString stringWithFormat:@"%f",_inputDate.timeInterval];
    };
    
    [self refresh];
}

- (IBAction)start:(id)sender
{
    [_inputDate startUp];
}

- (IBAction)stop:(id)sender
{
    [_inputDate stop];
}

- (IBAction)foward:(id)sender
{
    [_inputDate startUp];
}

- (IBAction)backward:(id)sender
{
    [_inputDate startDown];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_inputDate stop];
    [_nowDate stop];
    [super viewDidDisappear:animated];
}

@end
