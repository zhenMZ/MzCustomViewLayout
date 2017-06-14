//
//  S_ViewModel.h
//  XilianApp
//
//  Created by zhen mz on 2017/5/10.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface S_ViewModel : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

- (void)handleWithTable:(UICollectionView *)collectionView;


@end
