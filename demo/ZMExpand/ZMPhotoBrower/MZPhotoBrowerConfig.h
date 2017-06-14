//
//  MZPhotoBrowerConfig.h
//  XilianApp
//
//  Created by zhen mz on 2017/4/11.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//



typedef enum {
    MZWaitingViewModeLoopDiagram, // 环形
    MZWaitingViewModePieDiagram // 饼型
} MZWaitingViewMode;

// 图片保存成功提示文字
#define MZPhotoBrowserSaveImageSuccessText @" ^_^ 保存成功 ";

// 图片保存失败提示文字
#define MZPhotoBrowserSaveImageFailText @" >_< 保存失败 ";

// browser背景颜色
#define MZPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define MZPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define MZPhotoBrowserShowImageAnimationDuration 0.4f

// browser中显示图片动画时长
#define MZPhotoBrowserHideImageAnimationDuration 0.4f

// 图片下载进度指示进度显示样式（MZWaitingViewModeLoopDiagram 环形，MZWaitingViewModePieDiagram 饼型）
#define MZWaitingViewProgressMode MZWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define MZWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define MZWaitingViewItemMargin 10
