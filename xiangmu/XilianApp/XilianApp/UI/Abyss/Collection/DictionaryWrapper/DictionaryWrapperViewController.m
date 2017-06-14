//
//  DictionaryWrapperViewController.m
//  XilianApp
//
//  Created by Abyss on 2017/5/16.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "DictionaryWrapperViewController.h"

@interface DictionaryWrapperViewController ()
{
    CRDictionaryWrapper* _wrapper;
}
@property (weak, nonatomic) IBOutlet UITextView *exampleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputString;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITextView *output;

@end

@implementation DictionaryWrapperViewController

- (NSString *)name
{
    return @"DictionaryWrapper";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _wrapper = @{@"string":@"sdasd111",
                 @"array":@[@"1",@"2",@"3"],
                 @"dic":@{@"key":@(200)},
                 @"hahaha":@{@"list":@[@1,@(1.999999)]}}.wrapper;

    _exampleLabel.text = [_wrapper.dictionary description];
    _inputString.text = @"hahaha.list";
    _segment.selectedSegmentIndex = 2;
    
    [self refresh:nil];
}

- (IBAction)refresh:(id)sender
{
    switch (_segment.selectedSegmentIndex) {
        case 0:
        {
            _output.text = [_wrapper get:_inputString.text?:@""]?:@"格式错误";
        }
            break;
        case 1:
        {
            _output.text = [NSString stringWithFormat:@"%.f",[_wrapper getDouble:_inputString.text?:@""]];
        }
            break;
        case 2:
        {
            _output.text = [_wrapper getArray:_inputString.text?:@""].description;
        }
            break;
        case 3:
        {
            _output.text = [_wrapper getDictionary:_inputString.text?:@""].description;
        }
            break;
        case 4:
        {
            _output.text = [_wrapper getString:_inputString.text?:@""];
        }
            break;
        default:
            break;
    }
}

@end
