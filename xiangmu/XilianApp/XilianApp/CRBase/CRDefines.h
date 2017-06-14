//
//  CRDefines.h
//  XilianApp
//
//  Created by Abyss on 2017/2/17.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

static NSString* key_base_bundle = @"com.abyss.bundle";

/* 是否是测试环境 */
#define DEBUG 1

#ifdef DEBUG
    #define rBaseUrl                @""
    #define rImageUrl               rBaseUrl
#else
    #define NSAssert(...)

    #define rBaseUrl                @""
    #define rImageUrl               rBaseUrl
#endif

/** 实例化对象 */
#define rINSTANCE(_class, _name) rINSTANCE_STRONG(_class, _name)

#if __has_feature(objc_arc)
    #define rINSTANCE_STRONG(_class, _name) _class* sd = [[_class alloc] init];
    #define rINSTANCE_WEAK  (_class, _name) rINSTANCE_STRONG(_class, _name)
#else
    #define rINSTANCE_STRONG(_class, _name) _class* sd = [[_class alloc] init];
    #define rINSTANCE_WEAK  (_class, _name) _class* sd = [[[_class alloc] init] autorelease];
#endif

/** 线程锁 */
#define Lock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self->_lock)

#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define APP_NAVIGATION [CRNavigationer global]

#define kScreen ([UIScreen mainScreen].bounds.size)
