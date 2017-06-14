//
//  CRUser.h
//  XilianApp
//
//  Created by Abyss on 2017/5/22.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRAcount.h"
#import "CRAddressWrapper.h"
#import "CRTimeWrapper.h"


typedef void (^LocationBlock) (CRAddressWrapper* location);
@interface CRUser : CRAcount

/** 服务端唯一识别码 */
@property (nonatomic, copy, readonly) NSString* ID;

/** 地理位置 可能为nil */
@property (nonatomic, strong) CRAddressWrapper* location;
/** 地理位置获取 */
@property (nonatomic, copy) LocationBlock locationChange;

/** 上次登录时间 */
@property (nonatomic, strong, readonly) CRTimeWrapper* lastLoginTime;

/** 刷新地理位置,并且保存信息 */
- (void)refreshWithTimeUpdate:(BOOL)timeUpdate;

@end
