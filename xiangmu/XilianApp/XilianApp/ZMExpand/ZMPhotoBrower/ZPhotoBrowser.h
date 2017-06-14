//
//  ZPhotoBrowser.h
//  XilianApp
//
//  Created by zhen mz on 2017/4/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

/***
   图片用这个
 
 */





#import <UIKit/UIKit.h>

@class ZPhotoBrowser;

@protocol ZPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(ZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(ZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end

@interface ZPhotoBrowser : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceIamgesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, weak) id<ZPhotoBrowserDelegate> delegate;


- (void)show;
@end
