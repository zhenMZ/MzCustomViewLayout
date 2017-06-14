//
//  DemoTracerViewController.m
//  XilianApp
//
//  Created by Abyss on 2017/5/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "DemoTracerViewController.h"
#import <CocoaLumberjack/DDFileLogger.h>

@interface DemoTracerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *content;
@end

@implementation DemoTracerViewController

- (NSString *)name
{
    return @"Tracer";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self refresh:nil];
}

- (IBAction)refresh:(id)sender
{
    self.titleLabel.text = [CRTracer globel].recently.fileName;
    self.content.text    = [CRTracer globel].recently.content;
}

@end
