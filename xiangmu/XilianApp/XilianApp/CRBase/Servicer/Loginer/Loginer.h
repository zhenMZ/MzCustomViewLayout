//
//  Loginer.h
//  XilianApp
//
//  Created by Abyss on 2017/4/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRUser.h"

NS_ASSUME_NONNULL_BEGIN
@class CRAcount;

typedef BOOL (^LoginFlag) (CRUser* person);
typedef BOOL (^LoginDeel) (CRUser* person);
typedef BOOL (^LogoutDeel) (CRUser* person);

/** 登陆者 */
/** 
 *  保留登录者信息
 *
 *
 *
 *
 */
@interface Loginer : NSObject

/** 是否登录 */
@property (nonatomic, assign, readonly) BOOL isLogin;

/** 当前或者上次登录的用户, 退出登录或第一次打开 为nil */
@property (nonatomic, strong) CRUser* person;

/** 退出登录或者第一次打开 为 nil */
@property (nonatomic, copy) NSString* lastPersonName;

+ (instancetype)global;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/** 显示登录页面 */
- (void)showLogin;

/** 登录 */
- (void)loginWithUserName:(NSString *)userName pwd:(NSString *)pwd userDic:(NSDictionary *)userDic;

/** 登入的判断依据 */
- (void)setLoginFlag:(LoginFlag)flag;

/** 登入后进行的操作 */
- (void)setLoginDeel:(LoginDeel)deel;

/** 登出后进行的操作 */
- (void)setLogoutDell:(LogoutDeel)deel;

@end

NS_ASSUME_NONNULL_END
