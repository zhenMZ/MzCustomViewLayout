//
//  BaseViewController.h
//  XilianApp
//
//  Created by Abyss on 2017/4/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRNavigationer.h"
#import "UINavigation+Strategy.h"

#import "CRLogger.h"
#import "CRCacher.h"

#import "CRDefines.h"
#import "AppDelegate.h"



typedef float screenFrame;

extern screenFrame ScreenW ();
extern screenFrame ScreenH ();

#import "UIView+Tool.h"
#import "UINavigation+Strategy.h"
#import "NSString+Strategy.h"
#import "UIScreen+Frame.h"
#import "UIButton+Strategy.h"
#import "UITextField+Strategy.h"
#import "UITextView+PlaceHolder.h"
#import "UILabel+Strategy.h"
#import "UINavigationController+Strategy.h"
#import "UIImage+Strategy.h"

#import "CRColor.h"

#import "CRIconImageView.h"
#import "UIButton+Net.h"

#import "CRDictionaryWrapper.h"
#import "CRTimeWrapper.h"
#import "CRAddressWrapper.h"

@interface BaseViewController : UIViewController
- (NSString *)name;
@end
