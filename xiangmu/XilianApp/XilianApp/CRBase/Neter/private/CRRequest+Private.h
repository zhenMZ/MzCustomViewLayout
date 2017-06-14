//
//  CRRequest+Private.h
//  XilianApp
//
//  Created by Abyss on 2017/3/1.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 CRRequest (Private)
 CRRequest的私有补充
 */
@interface CRRequest (Private)

- (void)clearBlock;
- (void)writeCache;

- (void)accessoryWillStart;
- (void)accessoryDidEnd;

@end

NS_ASSUME_NONNULL_END
