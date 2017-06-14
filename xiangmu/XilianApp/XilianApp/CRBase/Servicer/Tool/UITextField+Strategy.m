//
//  UITextField+Strategy.m
//  XilianApp
//
//  Created by MZ on 2017/4/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "UITextField+Strategy.h"
#import <objc/runtime.h>

static char KTextFieldidentifyKey;
static char KTextFieldHistoryViewIdentifyKey;

static CGFloat const mz_ANIMATION_DURATION = 0.3f;
static CGFloat const mz_ITEM_HEIGHT = 40;
static CGFloat const mz_CLEAR_BUTTON_HEIGHT = 45;
static CGFloat const mz_MAX_HEIGHT = 300;

#define mz_history_X(view) (view.frame.origin.x)
#define mz_history_Y(view) (view.frame.origin.y)
#define mz_history_W(view) (view.frame.size.width)
#define mz_history_H(view) (view.frame.size.height)


@interface UITextField ()<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) UITableView *mz_historyTableView;
@end
@implementation UITextField (Strategy)


- (NSString*)mz_identify {
    return objc_getAssociatedObject(self, &KTextFieldidentifyKey);
}

- (void)setMz_identify:(NSString *)identify {
    objc_setAssociatedObject(self, &KTextFieldidentifyKey, identify, OBJC_ASSOCIATION_RETAIN);
}

- (UITableView*)mz_historyTableView {
    UITableView* table = objc_getAssociatedObject(self, &KTextFieldHistoryViewIdentifyKey);
    
    if (table == nil) {
        table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITextFieldHistoryCell"];
        table.layer.borderColor = [UIColor grayColor].CGColor;
        table.layer.borderWidth = 1;
        table.delegate = self;
        table.dataSource = self;
        objc_setAssociatedObject(self, &KTextFieldHistoryViewIdentifyKey, table, OBJC_ASSOCIATION_RETAIN);
    }
    
    return table;
}

- (NSArray *)mz_loadHistory {
    if (self.mz_identify == nil) {
        return nil;
    }
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic = [def objectForKey:@"UITextField+mzHistory"];
    
    if (dic != nil) {
        return [dic objectForKey:self.mz_identify];
    }
    
    return nil;
}

- (void)mz_synchronize {
    if (self.mz_identify == nil || [self.text length] == 0) {
        return;
    }
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic = [def objectForKey:@"UITextField+mzHistory"];
    NSArray* history = [dic objectForKey:self.mz_identify];
    
    NSMutableArray* newHistory = [NSMutableArray arrayWithArray:history];
    
    __block BOOL haveSameRecord = false;
    __weak typeof(self) weakSelf = self;
    
    [newHistory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(NSString*)obj isEqualToString:weakSelf.text]) {
            *stop = true;
            haveSameRecord = true;
        }
    }];
    
    if (haveSameRecord) {
        return;
    }
    
    [newHistory addObject:self.text];
    
    NSMutableDictionary* dic2 = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic2 setObject:newHistory forKey:self.mz_identify];
    
    [def setObject:dic2 forKey:@"UITextField+mzHistory"];
    
    [def synchronize];
}

- (void)mz_showHistory; {
    NSArray* history = [self mz_loadHistory];
    
    if (self.mz_historyTableView.superview != nil || history == nil || history.count == 0) {
        return;
    }
    
    CGRect frame1 = CGRectMake(mz_history_X(self), mz_history_Y(self) + mz_history_H(self) + 1, mz_history_W(self), 1);
    CGRect frame2 = CGRectMake(mz_history_X(self), mz_history_Y(self) + mz_history_H(self) + 1, mz_history_W(self), MIN(mz_MAX_HEIGHT, mz_ITEM_HEIGHT * history.count + mz_CLEAR_BUTTON_HEIGHT));
    
    self.mz_historyTableView.frame = frame1;
    
    [self.superview addSubview:self.mz_historyTableView];
    
    [UIView animateWithDuration:mz_ANIMATION_DURATION animations:^{
        self.mz_historyTableView.frame = frame2;
    }];
}

- (void) mz_clearHistoryButtonClick:(UIButton*) button {
    [self mz_clearHistory];
    [self mz_hideHistory];
}

- (void)mz_hideHistory {
    if (self.mz_historyTableView.superview == nil) {
        return;
    }
    
    CGRect frame1 = CGRectMake(mz_history_X(self), mz_history_Y(self) + mz_history_H(self) + 1, mz_history_W(self), 1);
    
    [UIView animateWithDuration:mz_ANIMATION_DURATION animations:^{
        self.mz_historyTableView.frame = frame1;
    } completion:^(BOOL finished) {
        [self.mz_historyTableView removeFromSuperview];
    }];
}

- (void)mz_clearHistory; {
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    
    [def setObject:nil forKey:@"UITextField+mzHistory"];
    [def synchronize];
}


#pragma mark tableview datasource
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    return [self mz_loadHistory].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITextFieldHistoryCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITextFieldHistoryCell"];
    }
    
    cell.textLabel.text = [self mz_loadHistory][indexPath.row];
    
    return cell;
}
#pragma clang diagnostic pop

#pragma mark tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    UIButton* clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(mz_clearHistoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return clearButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return mz_ITEM_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section; {
    return mz_CLEAR_BUTTON_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    self.text = [self mz_loadHistory][indexPath.row];
    [self mz_hideHistory];
}



@end
