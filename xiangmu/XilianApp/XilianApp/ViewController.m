//
//  ViewController.m
//  XilianApp
//
//  Created by Abyss on 2017/2/14.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "ViewController.h"
#import "CRAcounter.h"

#import "CRCacher.h"
#import <AFNetworking.h>

#import "DefaultRequest.h"
#import "UIButton+Net.h"

#import "CRIconAws.h"
#import "CRIconImageView.h"
#import "CRBanner.h"

#import "UIView+Tool.h"
#import "UIButton+Strategy.h"
#import "UITextField+Strategy.h"
#import "UITextView+PlaceHolder.h"
#import "UILabel+Strategy.h"

#import <AudioToolbox/AudioToolbox.h>


@interface ViewController () <CRBannerDataSource>
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UITextField *testTF;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation ViewController

- (IBAction)test:(id)sender
{
    [_testButton zm_beginSubmitting:@""];
    [self performSelector:@selector(nclick) withObject:self afterDelay:3];

}

- (void)nclick {
     [_testButton zm_endSubmitting];
}

- (void)vibrate   {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)viewDidLoad
{
 

    

    
}

- (void)onclixkd:(UIButton *)sender {
//    [sender zm_beginSubmitting:@"定位中"];
    
    [sender zm_startTime:30 title:@"开始" waitTitle:@"结束"];
}
@end
