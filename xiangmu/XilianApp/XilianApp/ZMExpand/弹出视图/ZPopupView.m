//
//  ZPopupView.m
//  XilianApp
//
//  Created by MZ on 2017/6/13.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//


#define ZFirstWindow [UIApplication sharedApplication].windows.firstObject
#define ZRootViewController ZFirstWindow.rootViewController

#define ZColorAlpha(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0  blue:(b) / 255.0  alpha:a]
#define ZColor(r, g, b) ZColorAlpha(r, g, b, 1.0)

#define ZColorFromHexAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:a]
#define ZColorFromHex(rgbValue) ZColorFromHexAlpha(rgbValue, 1.0)

#define ZStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

#import "ZPopupView.h"
#import "sys/utsname.h"
#import "UIView+Toast.h"

NSString *const AlertViewWillShowNotification     = @"AlertViewWillShowNotification";
NSString *const AlertViewDidShowNotification      = @"AlertViewDidShowNotification";
NSString *const AlertViewWillDismissNotification  = @"AlertViewWillDismissNotification";
NSString *const AlertViewDidDismissNotification   = @"AlertViewDidDismissNotification";


@implementation NSString (Extension)

- (CGSize)hd_sizeWithSystemFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return [self hd_sizeWithSystemFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}
#pragma mark - 文本计算方法
- (CGSize)hd_sizeWithSystemFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = mode;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle};
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
}

@end

@implementation UIImage (Extension)

+ (instancetype)hd_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


@end

@implementation UIView (Extension)

- (CGFloat)hd_width {
    return self.frame.size.width;
}
- (CGFloat)hd_height {
    return self.frame.size.height;
}
#pragma mark - 视图相关
- (void)hd_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

@end

#pragma mark - HDAlertItem
@interface ZAlertItem : NSObject

/** 按钮标题 */
@property (nonatomic, copy) NSString *title;
/** 按钮风格 */
@property (nonatomic, assign) ZAlertViewButtonType type;
/** 对应按钮行动的处理 */
@property (nonatomic, copy) ZAlertViewHandler action;

@end


@implementation ZAlertItem

@end



#pragma mark - ZAlertWindow
@interface ZAlertWindow : UIWindow

/** Alert背景视图风格 */
@property (nonatomic, assign) ZAlertViewBackgroundStyle style;

@end


@implementation ZAlertWindow

- (instancetype)initWithFrame:(CGRect)frame andStyle:(ZAlertViewBackgroundStyle)style {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.opaque = NO;
        self.windowLevel = 1899.0; // 不重叠系统的Alert, Alert的层级.
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.style) {
        case ZAlertViewBackgroundStyleGradient: {
            size_t locationsCount = 2; // unsigned long
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.hd_width * 0.5, self.hd_height * 0.5);
            CGFloat radius = MIN(self.hd_width, self.hd_height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            break;
        }
            
        case ZAlertViewBackgroundStyleSolid: {
            [[[UIColor blackColor] colorWithAlphaComponent:0.2] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
    }
}

@end



#pragma mark - ZPopupView
@interface ZPopupView () <CAAnimationDelegate>

/** 是否动画 */
@property (nonatomic, assign, getter = isAlertAnimating) BOOL alertAnimating;
/** 是否可见 */
@property (nonatomic, assign, getter = isVisible) BOOL visible;
/** 图片 */
@property (nonatomic, weak) UIImageView *imageView;
/** Label容器视图 */
@property (nonatomic, weak) UIView *containerLabelView;
/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 消息描述 */
@property (nonatomic, weak) UILabel *messageLabel;
/** 容器视图 */
@property (nonatomic, weak) UIView *containerView;
/** 毛玻璃视图 */
@property (nonatomic, weak) UIVisualEffectView *effectView;
/** 存放行动items */
@property (nonatomic, strong) NSMutableArray *items;
/** 存放按钮 */
@property (nonatomic, strong) NSMutableArray *buttons;
/** 展示的背景Window */
@property (nonatomic, strong) ZAlertWindow *alertWindow;

@end


@implementation ZPopupView

+ (void)initialize {
    if (self != [ZPopupView class]) return;
    
    ZPopupView *appearance = [self appearance]; // 设置整体默认外观
    appearance.viewBackgroundColor = [UIColor clearColor];
    appearance.titleColor = [UIColor blackColor];
    appearance.messageColor = [UIColor darkGrayColor];
    appearance.titleFont = [UIFont boldSystemFontOfSize:17.0];
    appearance.messageFont = [UIFont systemFontOfSize:16.0];
    appearance.buttonFont = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
    appearance.defaultButtonTitleColor = ZColorFromHex(0xcccccc);
    appearance.cancelButtonTitleColor = [UIColor greenColor];
    appearance.destructiveButtonTitleColor = [UIColor redColor];
    appearance.cornerRadius = 5.0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self setUpSubviews];
    }
    
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    return [[self alloc] initWithTitle:title andMessage:message];
}

- (instancetype)initWithTitle:(NSString *)title andMessage:(NSString *)message {
    ZPopupView *alertView = [[[self class] alloc] init];
    
    alertView.title = title;
    alertView.message = message;
    alertView.items = [[NSMutableArray alloc] init];
    
    return alertView;
}

- (void)addButtonWithTitle:(NSString *)title type:(ZAlertViewButtonType)type handler:(ZAlertViewHandler)handler {
    ZAlertItem *item = [[ZAlertItem alloc] init];
    
    item.title = title;
    item.type = type;
    item.action = handler;
    [self.items addObject:item];
}

- (void)show {
    if (self.isVisible) return;
    if (self.isAlertAnimating) return;
    
    __weak typeof(self) weakSelf = self;
    if (self.willShowHandler) {
        self.willShowHandler(weakSelf);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AlertViewWillShowNotification object:self userInfo:nil];
    
    self.visible = YES;
    self.alertAnimating = YES;
    
    [self setupButtons]; // 设置按钮
    [self.alertWindow addSubview:self];
    [self.alertWindow makeKeyAndVisible];
    [self setSubviewsFrame]; // 布局
    
    [self transitionInCompletion:^{
        if (weakSelf.didShowHandler) {
            weakSelf.didShowHandler(weakSelf);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:AlertViewDidShowNotification object:weakSelf userInfo:nil];
        
        weakSelf.alertAnimating = NO;
    }];
}

- (void)removeAlertView {
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissAnimated:animated cleanup:YES];
}

/**
 *  撤销弹窗提示
 *
 *  @param animated 是否动画
 *  @param cleanup  是否清除
 */
- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup {
    BOOL isVisible = self.isVisible;
    
    __weak typeof(self) weakSelf = self;
    if (self.isVisible) {
        if (self.willDismissHandler) {
            self.willDismissHandler(weakSelf);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AlertViewWillDismissNotification object:self userInfo:nil];
    }
    
    void (^dismissComplete)(void) = ^{
        weakSelf.visible = NO;
        weakSelf.alertAnimating =  NO;
        
        if (isVisible) {
            if (weakSelf.didDismissHandler) {
                weakSelf.didDismissHandler(weakSelf);
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AlertViewDidDismissNotification object:weakSelf userInfo:nil];
        }
        
        [self removeView];
    };
    
    if (animated && isVisible) {
        self.alertAnimating =  YES;
        [self transitionOutCompletion:dismissComplete];
        
    } else {
        dismissComplete();
    }
}


#pragma mark - Transitions动画
/**
 *  进入的动画
 */
- (void)transitionInCompletion:(void(^)(void))completion {
    CGFloat duration = 0.3;
    
    [UIView animateWithDuration:duration animations:^{
        self.alertWindow.alpha = 1.0;
    }];
    
    switch (self.transitionStyle) {
        case ZAlertViewTransitionStyleFade: {
            self.containerView.alpha = 0;
            
            [UIView animateWithDuration:duration animations:^{
                self.containerView.alpha = 1;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case ZAlertViewTransitionStyleSlideFromTop: {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -rect.size.height;
            self.containerView.frame = rect;
            
            [UIView animateWithDuration:duration animations:^{
                self.containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case ZAlertViewTransitionStyleSlideFromBottom: {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = self.hd_height;
            self.containerView.frame = rect;
            
            [UIView animateWithDuration:duration animations:^{
                self.containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case ZAlertViewTransitionStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = duration;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bouce"];
            break;
        }
            
        case ZAlertViewTransitionStyleDropDown: {
            CGFloat y = self.containerView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = duration;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"dropdown"];
            break;
        }
            
        default:
            break;
    }
}

/**
 *  消失的动画
 */
- (void)transitionOutCompletion:(void(^)(void))completion {
    CGFloat duration = 0.3;
    
    switch (self.transitionStyle) {
        case ZAlertViewTransitionStyleSlideFromBottom: {
            CGRect rect = self.containerView.frame;
            rect.origin.y = self.hd_height;
            
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case ZAlertViewTransitionStyleSlideFromTop: {
            CGRect rect = self.containerView.frame;
            rect.origin.y = -rect.size.height;
            
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case ZAlertViewTransitionStyleFade: {
            [UIView animateWithDuration:duration animations:^{
                self.containerView.alpha = 0;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        case ZAlertViewTransitionStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = duration;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
            
            self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            break;
        }
            
        case ZAlertViewTransitionStyleDropDown: {
            CGPoint point = self.containerView.center;
            point.y += self.hd_height;
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.center = point;
                CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                self.containerView.transform = CGAffineTransformMakeRotation(angle);
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
            
        default:
            break;
    }
}


#pragma mark - 布局
- (void)setSubviewsFrame {
    if (self.alertViewStyle == ZAlertViewStyleActionSheet) {
        CGFloat containerViewW = [UIScreen mainScreen].bounds.size.width;
        CGFloat margin = 25.0;
        
        /** 标题 */
        CGSize titleLabelSize = {0, 0};
        CGFloat titleLabelW = containerViewW - margin * 2;
        
        if (self.title.length > 0) {
            titleLabelSize = [self.title hd_sizeWithSystemFont:self.titleLabel.font constrainedToSize:CGSizeMake(titleLabelW, MAXFLOAT)];
        }
        
        //        CGFloat titleLabelH = titleLabelSize.height;
        CGFloat titleLabelH = 64.0;
        CGFloat titleLabelX = margin;
        CGFloat titleLabelY = 0;
        self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        self.titleLabel.numberOfLines = 2;
        
        /** 按钮 */
        CGFloat buttonH = 50.0;
        CGFloat buttonY = 0;
        CGFloat lineY = 0;
        CGFloat lineH = 0.5;
        
        if (self.title.length > 0) {
            lineY = CGRectGetMaxY(self.titleLabel.frame);
            buttonY = lineY + lineH;
        }
        
        if (self.items.count > 0) {
            UIColor *lineColor = [UIColor clearColor]; // 保留线避免设计移除毛玻璃效果好设置颜色
            NSUInteger btnCount = self.buttons.count;
            
            for (NSUInteger i = 0; i < btnCount; i++) {
                if (i > 0) {
                    buttonY += buttonH + lineH;
                    lineY = buttonY;
                }
                
                UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, containerViewW, lineH)];
                horizontalLine.backgroundColor = lineColor;
                [self.containerView addSubview:horizontalLine];
                
                UIButton *button = self.buttons[i];
                if (i == btnCount - 1) {
                    buttonY = buttonY + 6;
                    lineH = 6;
                }
                
                button.frame = CGRectMake(0, buttonY, containerViewW, buttonH);
            }
        }
        
        /** Label容器视图 */
        CGFloat containerLabelViewW = containerViewW;
        CGFloat containerLabelViewH = CGRectGetMaxY(self.titleLabel.frame);
        CGFloat containerLabelViewX = 0;
        CGFloat containerLabelViewY = 0;
        self.containerLabelView.frame = CGRectMake(containerLabelViewX, containerLabelViewY, containerLabelViewW, containerLabelViewH);
        
        /** 容器视图 */
        CGFloat containerViewH = buttonY + buttonH;
        CGFloat containerViewX = 0;
        CGFloat containerViewY = self.hd_height - containerViewH;
        self.containerView.frame = CGRectMake(containerViewX, containerViewY, containerViewW, containerViewH);
        
    } else  if (self.alertViewStyle == ZAlertViewStyleAlert){
        CGFloat margin = 25.0;
        
        CGFloat horizontalMargin = 50.0;
        
        
        CGFloat containerViewW = ([UIScreen mainScreen].bounds.size.width - horizontalMargin * 2);
        
        /** 图片 */
        if (self.imageName.length > 0) {
            CGFloat imageViewH = 60;
            CGFloat imageViewW = imageViewH;
            CGFloat imageViewX = (containerViewW - imageViewW) * 0.5;
            CGFloat imageViewY = margin;
            
            self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        }
        
        /** 标题 */
        CGSize titleLabelSize = {0, 0};
        CGFloat titleLabelW = containerViewW - margin * 2;
        
        if (self.title.length > 0) {
            titleLabelSize = [self.title hd_sizeWithSystemFont:self.titleLabel.font constrainedToSize:CGSizeMake(titleLabelW, MAXFLOAT)];
        }
        
        CGFloat titleLabelH = titleLabelSize.height;
        CGFloat titleLabelX = margin;
        CGFloat titleLabelY = CGRectGetMaxY(self.imageView.frame) + margin;
        self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
        
        /** 消息描述 */
        CGSize messageLabelSize = {0, 0};
        CGFloat messageLabelW = titleLabelW;
        
        if (self.message.length > 0) {
            messageLabelSize = [self.message hd_sizeWithSystemFont:self.messageLabel.font constrainedToSize:CGSizeMake(messageLabelW, MAXFLOAT)];
        }
        
        CGFloat messageLabelH = messageLabelSize.height;
        CGFloat messageLabelX = titleLabelX;
        CGFloat messageLabelY = 0;
        if (self.title.length > 0) {
            messageLabelY = CGRectGetMaxY(self.titleLabel.frame) + (messageLabelH > 0 ? margin : 0);
        } else {
            messageLabelY = messageLabelH > 0 ? margin : 0;
        }
        self.messageLabel.frame = CGRectMake(messageLabelX, messageLabelY, messageLabelW, messageLabelH);
        
        /** 按钮 */
        CGFloat lineY = CGRectGetMaxY(self.messageLabel.frame) + margin;
        CGFloat lineH = 0.5;
        CGFloat buttonH = 44.0;
        CGFloat buttonY = lineY + lineH;
        
        if (self.items.count > 0) {
            UIColor *lineColor = [UIColor clearColor]; // 保留线避免设计移除毛玻璃效果好设置颜色
            
            if (self.items.count == 2 && self.buttonsListStyle == ZAlertViewButtonsListStyleNormal) {
                CGFloat buttonW = containerViewW * 0.5;
                CGFloat buttonX = 0;
                
                UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, containerViewW, lineH)];
                horizontalLine.backgroundColor = lineColor;
                [self.containerView addSubview:horizontalLine];
                
                UIButton *button = self.buttons[0];
                button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
                
                UIView *verticaleLine = [[UIView alloc] initWithFrame:CGRectMake(buttonW, buttonY, lineH, buttonH)];
                verticaleLine.backgroundColor = lineColor;
                [self.containerView addSubview:verticaleLine];
                
                button = self.buttons[1];
                button.frame = CGRectMake(buttonW + lineH, buttonY, buttonW - lineH, buttonH);
                
            } else {
                for (NSUInteger i = 0; i < self.buttons.count; i++) {
                    if (i > 0) {
                        buttonY += buttonH + lineH;
                        lineY = buttonY;
                    }
                    
                    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, containerViewW, lineH)];
                    horizontalLine.backgroundColor = lineColor;
                    [self.containerView addSubview:horizontalLine];
                    
                    UIButton *button = self.buttons[i];
                    button.frame = CGRectMake(0, buttonY, containerViewW, buttonH);
                }
            }
        }
        
        /** Label容器视图 */
        CGFloat containerLabelViewW = containerViewW;
        CGFloat containerLabelViewH = CGRectGetMaxY(self.messageLabel.frame) + margin;
        CGFloat containerLabelViewX = 0;
        CGFloat containerLabelViewY = 0;
        self.containerLabelView.frame = CGRectMake(containerLabelViewX, containerLabelViewY, containerLabelViewW, containerLabelViewH);
        
        /** 容器视图 */
        CGFloat containerViewH = buttonY + buttonH;
        CGFloat containerViewX = horizontalMargin;
        CGFloat containerViewY = (self.hd_height - containerViewH) * 0.5;
        self.containerView.frame = CGRectMake(containerViewX, containerViewY, containerViewW, containerViewH);
    }else if (self.alertViewStyle == ZToastView){
//        风火轮
         [self.containerView makeToastActivity:CSToastPositionCenter];
        self.containerView.frame = CGRectMake(200, 200, 50, 50);
 
    }
    
    self.effectView.frame = self.containerView.bounds;
}


#pragma mark - 视图相关
- (void)setUpSubviews {
    /** 容器视图 */
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.layer.cornerRadius = self.cornerRadius;
    containerView.layer.masksToBounds = YES;
    [containerView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPressContainerView:)]];
    [self addSubview:containerView];
    self.containerView = containerView;
    
    /** 毛玻璃视图 */
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    [self.containerView addSubview:effectView];
    self.effectView = effectView;
    
    /** 图片 */
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.containerView addSubview:imageView];
    self.imageView = imageView;
    
    /** Label容器视图 */
    UIView *containerLabelView = [[UIView alloc] init];
    containerLabelView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];;
    [containerView addSubview:containerLabelView];
    self.containerLabelView = containerLabelView;
    
    /** 标题 */
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = self.titleFont;
    titleLabel.textColor = self.titleColor;
    titleLabel.numberOfLines = 0;
    [self.containerLabelView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    /** 消息描述 */
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = self.messageFont;
    messageLabel.textColor = self.messageColor;
    messageLabel.numberOfLines = 0;
    [self.containerLabelView addSubview:messageLabel];
    self.messageLabel = messageLabel;
}

/**
 *  滑动手势处理
 */
- (void)panPressContainerView:(UIPanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    
    UIButton *btn = [self buttonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (btn) {
                [self buttonAction:btn];
            }
            break;
        }
            
        default:
            break;
    }
}

/**
 *  遍历手指触摸的点是否在按钮上
 */
- (UIButton *)buttonWithLocation:(CGPoint)location {
    UIButton *btn = nil;
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *tempBtn = self.buttons[i];
        
        CGRect btnFrame = [tempBtn convertRect:tempBtn.bounds toView:self];
        
        if (CGRectContainsPoint(btnFrame, location)) {
            tempBtn.highlighted = YES;
            btn = tempBtn;
        } else {
            tempBtn.highlighted = NO;
        }
    }
    
    return btn ? btn : nil;
}

/**
 *  懒加载alertWindow
 */
- (ZAlertWindow *)alertWindow {
    if (!_alertWindow) {
        _alertWindow = [[ZAlertWindow alloc] initWithFrame:[UIScreen mainScreen].bounds andStyle:self.backgroundStyle];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAlertWindow)];
        [_alertWindow addGestureRecognizer:tapGes];
        _alertWindow.alpha = 0.01;
    }
    
    return _alertWindow;
}

- (void)onAlertWindow {
    [self dismissAnimated:YES];
}

/**
 *  设置按钮
 */
- (void)setupButtons {
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        UIButton *button = [self buttonForItemIndex:i];
        [self.buttons addObject:button];
        [self.containerView addSubview:button];
    }
}

- (UIButton *)buttonForItemIndex:(NSUInteger)index {
    ZAlertItem *item = self.items[index];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.titleLabel.font = self.buttonFont;
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:item.title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage hd_imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage hd_imageWithColor:[ZColor(230, 230, 230) colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
    
    switch (item.type) {
        case ZAlertViewButtonTypeCancel: {
            [button setTitleColor:self.cancelButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:[self.cancelButtonTitleColor colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
            break;
        }
            
        case ZAlertViewButtonTypeDestructive: {
            [button setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:[self.destructiveButtonTitleColor colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
            break;
        }
            
        case ZAlertViewButtonTypeDefault: {
        default:
            [button setTitleColor:self.defaultButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:[self.defaultButtonTitleColor colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
            break;
        }
    }
    
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)removeView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alertWindow.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self.alertWindow removeFromSuperview];
        self.alertWindow = nil;
        [self hd_removeAllSubviews];
        [self removeFromSuperview];
        
        [ZFirstWindow makeKeyAndVisible];
    }];
}


#pragma mark - 按钮点击的行动
- (void)buttonAction:(UIButton *)button {
    self.alertAnimating =  YES;
    ZAlertItem *item = self.items[button.tag];
    
    if (item.action) {
        item.action(self);
    }
    
    [self dismissAnimated:YES];
}


#pragma mark - 动画的代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void(^completion)(void) = [anim valueForKeyPath:@"handler"];
    
    if (completion) {
        completion();
    }
}


#pragma mark - setter方法
- (void)setImageName:(NSString *)imageName {
    if (_imageName == imageName) return;
    
    _imageName = imageName;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}

- (void)setTitle:(NSString *)title {
    if (_title == title) return;
    
    _title = title;
    self.titleLabel.text = title;
}

- (void)setMessage:(NSString *)message {
    if (_message == message) return;
    
    _message = message;
    self.messageLabel.text = message;
}

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor {
    if (_viewBackgroundColor == viewBackgroundColor) return;
    
    _viewBackgroundColor = viewBackgroundColor;
    self.containerView.backgroundColor = viewBackgroundColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (_titleFont == titleFont) return;
    
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setMessageFont:(UIFont *)messageFont {
    if (_messageFont == messageFont) return;
    
    _messageFont = messageFont;
    self.messageLabel.font = messageFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (_titleColor == titleColor) return;
    
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMessageColor:(UIColor *)messageColor {
    if (_messageColor == messageColor) return;
    
    _messageColor = messageColor;
    self.messageLabel.textColor = messageColor;
}

- (void)setButtonFont:(UIFont *)buttonFont {
    if (_buttonFont == buttonFont) return;
    
    _buttonFont = buttonFont;
    for (UIButton *button in self.buttons) {
        button.titleLabel.font = buttonFont;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius == cornerRadius) return;
    
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
}

- (void)setDefaultButtonTitleColor:(UIColor *)defaultButtonTitleColor {
    if (_defaultButtonTitleColor == defaultButtonTitleColor) return;
    
    _defaultButtonTitleColor = defaultButtonTitleColor;
    [self setColor:defaultButtonTitleColor toButtonsOfType:ZAlertViewButtonTypeDefault];
}

- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor {
    if (_cancelButtonTitleColor == cancelButtonTitleColor) return;
    
    _cancelButtonTitleColor = cancelButtonTitleColor;
    [self setColor:cancelButtonTitleColor toButtonsOfType:ZAlertViewButtonTypeCancel];
}

- (void)setDestructiveButtonTitleColor:(UIColor *)destructiveButtonTitleColor {
    if (_destructiveButtonTitleColor == destructiveButtonTitleColor) return;
    
    _destructiveButtonTitleColor = destructiveButtonTitleColor;
    [self setColor:destructiveButtonTitleColor toButtonsOfType:ZAlertViewButtonTypeDestructive];
}

- (void)setDefaultButtonImage:(UIImage *)defaultButtonImage forState:(UIControlState)state {
    [self setButtonImage:defaultButtonImage forState:state andButtonType:ZAlertViewButtonTypeDefault];
}

- (void)setCancelButtonImage:(UIImage *)cancelButtonImage forState:(UIControlState)state {
    [self setButtonImage:cancelButtonImage forState:state andButtonType:ZAlertViewButtonTypeCancel];
}

- (void)setDestructiveButtonImage:(UIImage *)destructiveButtonImage forState:(UIControlState)state {
    [self setButtonImage:destructiveButtonImage forState:state andButtonType:ZAlertViewButtonTypeDestructive];
}

- (void)setButtonImage:(UIImage *)image forState:(UIControlState)state andButtonType:(ZAlertViewButtonType)type {
    for (NSUInteger i = 0; i < self.items.count; i++) {
        ZAlertItem *item = self.items[i];
        if(item.type == type) {
            UIButton *button = self.buttons[i];
            
            if (state == UIControlStateSelected) {
                state = UIControlStateHighlighted;
            }
            
            [button setBackgroundImage:image forState:state];
        }
    }
}

- (void)setColor:(UIColor *)color toButtonsOfType:(ZAlertViewButtonType)type {
    for (NSUInteger i = 0; i < self.items.count; i++) {
        ZAlertItem *item = self.items[i];
        if(item.type == type) {
            UIButton *button = self.buttons[i];
            [button setTitleColor:color forState:UIControlStateNormal];
            [button setTitleColor:[color colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
        }
    }
}


#pragma mark - 类方法
+ (ZPopupView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles handler:(void (^)(ZPopupView *alertView, NSInteger buttonIndex))block {
    
    ZPopupView *alertView = [[ZPopupView alloc] initWithTitle:title andMessage:message];
    alertView.cancelButtonTitleColor = [UIColor blackColor];
    alertView.defaultButtonTitleColor = ZColorFromHex(0x0093ff);
    alertView.destructiveButtonTitleColor = ZColorFromHex(0xf74c31);
    alertView.buttonFont = [UIFont systemFontOfSize:17.0];
    
    if (!ZStringIsEmpty(cancelButtonTitle)) {
        [alertView addButtonWithTitle:cancelButtonTitle type:ZAlertViewButtonTypeCancel handler:^(ZPopupView *alertView) {
            if (block) {
                block(alertView, 0);
            }
        }];
    }
    
    for (int i = 0; i < otherButtonTitles.count; i++) {
        [alertView addButtonWithTitle:otherButtonTitles[i] type:ZAlertViewButtonTypeDefault handler:^(ZPopupView *alertView) {
            if (block) {
                if (!ZStringIsEmpty(cancelButtonTitle)) {
                    block(alertView, i + 1);
                }
                
                block(alertView, i);
            }
        }];
    }
    
    [alertView show];
    
    return alertView;
}

+ (ZPopupView *)showActionSheetWithTitle:(NSString *)title {
    ZPopupView *alertView = [[ZPopupView alloc] initWithTitle:title andMessage:nil];
    alertView.alertViewStyle = ZAlertViewStyleActionSheet;
    alertView.transitionStyle = ZAlertViewTransitionStyleSlideFromBottom;
    alertView.titleFont = [UIFont systemFontOfSize:13.0];
    alertView.buttonFont = [UIFont systemFontOfSize:17.0];
    alertView.cancelButtonTitleColor = ZColorFromHex(0xf74c31);
    alertView.defaultButtonTitleColor = [UIColor blackColor];
    alertView.destructiveButtonTitleColor = ZColorFromHex(0xf74c31);
    alertView.titleColor = ZColorFromHex(0x999999);
    alertView.cornerRadius = 0;
    
    return alertView;
}

@end
