//
//  ZPopupView.h
//  XilianApp
//
//  Created by MZ on 2017/6/13.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

//HD_EXTERN NSString *const AlertViewWillShowNotification;
//HD_EXTERN NSString *const AlertViewDidShowNotification;
//HD_EXTERN NSString *const AlertViewWillDismissNotification;
//HD_EXTERN NSString *const AlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, ZAlertViewStyle) {
    ZAlertViewStyleAlert = 0,  // 默认
    ZAlertViewStyleActionSheet,  // 下面弹出视图
    ZToastView      //  ToastView  风火轮
};

typedef NS_ENUM(NSInteger, ZAlertViewButtonType) {
    ZAlertViewButtonTypeDefault = 0,   // 字体默认ni才
    ZAlertViewButtonTypeDestructive,   // 字体默认红色
    ZAlertViewButtonTypeCancel         // 字体默认绿色
};

typedef NS_ENUM(NSInteger, ZAlertViewBackgroundStyle) {
    ZAlertViewBackgroundStyleSolid = 0,    // 平面的
    ZAlertViewBackgroundStyleGradient      // 聚光的
};

typedef NS_ENUM(NSInteger, ZAlertViewButtonsListStyle) {
    ZAlertViewButtonsListStyleNormal = 0,
    ZAlertViewButtonsListStyleRows // 每个按钮都是一行
};

typedef NS_ENUM(NSInteger, ZAlertViewTransitionStyle) {
    ZAlertViewTransitionStyleFade = 0,             // 渐退
    ZAlertViewTransitionStyleSlideFromTop,         // 从顶部滑入滑出
    ZAlertViewTransitionStyleSlideFromBottom,      // 从底部滑入滑出
    ZAlertViewTransitionStyleBounce,               // 弹窗效果
    ZAlertViewTransitionStyleDropDown              // 顶部滑入底部滑出
};

@class ZPopupView;
typedef void(^ZAlertViewHandler)(ZPopupView *alertView);

@interface NSString (Extension)

@end

@interface UIImage (Extension)

@end

@interface UIView (Extension)
@end

@interface ZPopupView : UIView

/** 图标的名字 */
@property (nonatomic, copy) NSString *imageName;

/** 标题-只支持1行 */
@property (nonatomic, copy) NSString *title;

/** 消息描述-支持多行 */
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) ZAlertViewStyle alertViewStyle;              // 默认是 AlertViewStyleAlert
@property (nonatomic, assign) ZAlertViewTransitionStyle transitionStyle;   // 默认是 AlertViewTransitionStyleFade
@property (nonatomic, assign) ZAlertViewBackgroundStyle backgroundStyle;   // 默认是 AlertViewBackgroundStyleSolid
@property (nonatomic, assign) ZAlertViewButtonsListStyle buttonsListStyle; // 默认是 AlertViewButtonsListStyleNormal

@property (nonatomic, copy) ZAlertViewHandler willShowHandler;
@property (nonatomic, copy) ZAlertViewHandler didShowHandler;
@property (nonatomic, copy) ZAlertViewHandler willDismissHandler;
@property (nonatomic, copy) ZAlertViewHandler didDismissHandler;

@property (nonatomic, strong) UIColor *viewBackgroundColor          UI_APPEARANCE_SELECTOR; // 默认是白色
@property (nonatomic, strong) UIColor *titleColor                   UI_APPEARANCE_SELECTOR; // 默认是黑色
@property (nonatomic, strong) UIColor *messageColor                 UI_APPEARANCE_SELECTOR; // 默认是灰色
@property (nonatomic, strong) UIColor *defaultButtonTitleColor      UI_APPEARANCE_SELECTOR; // 默认是白色
@property (nonatomic, strong) UIColor *cancelButtonTitleColor       UI_APPEARANCE_SELECTOR; // 默认是白色
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor  UI_APPEARANCE_SELECTOR; // 默认是白色
@property (nonatomic, strong) UIFont *titleFont                     UI_APPEARANCE_SELECTOR; // 默认是6.0
@property (nonatomic, strong) UIFont *messageFont                   UI_APPEARANCE_SELECTOR; // 默认是16.0
@property (nonatomic, strong) UIFont *buttonFont                    UI_APPEARANCE_SELECTOR; // 默认是buttonFontSize
@property (nonatomic, assign) CGFloat cornerRadius                  UI_APPEARANCE_SELECTOR; // 默认是5.0


/**
 *  设置默认按钮图片和状态
 */
- (void)setDefaultButtonImage:(UIImage *)defaultButtonImage forState:(UIControlState)state  UI_APPEARANCE_SELECTOR;

/**
 *  设置取消按钮图片和状态
 */
- (void)setCancelButtonImage:(UIImage *)cancelButtonImage forState:(UIControlState)state    UI_APPEARANCE_SELECTOR;

/**
 *  设置毁灭性按钮图片和状态
 */
- (void)setDestructiveButtonImage:(UIImage *)destructiveButtonImage forState:(UIControlState)state  UI_APPEARANCE_SELECTOR;

/**
 *  初始化一个弹窗提示
 */
- (instancetype)initWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (instancetype)alertViewWithTitle:(NSString *)title andMessage:(NSString *)message;

/**
 *  添加按钮点击时候和处理
 *
 *  @param title   按钮名字
 *  @param type    按钮类型
 *  @param handler 点击按钮处理事件
 */
- (void)addButtonWithTitle:(NSString *)title type:(ZAlertViewButtonType)type handler:(ZAlertViewHandler)handler;

/**
 *  显示弹窗提示
 */
- (void)show;

/**
 *  移除视图
 */
- (void)removeAlertView;

/**
 快速弹窗
 
 @param title 标题
 @param message 消息体
 @param cancelButtonTitle 取消按钮文字
 @param otherButtonTitles 其他按钮
 @param block 回调
 @return 返回AlertView对象
 */
+ (ZPopupView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles handler:(void (^)(ZPopupView *alertView, NSInteger buttonIndex))block;
/**
 ActionSheet样式弹窗
 
 @param title 标题
 @return 返回HBAlertView对象
 */
+ (ZPopupView *)showActionSheetWithTitle:(NSString *)title;







@end
