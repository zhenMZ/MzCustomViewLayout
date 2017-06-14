//
//  CRDataLoader.h
//  XilianApp
//
//  Created by Abyss on 2017/2/23.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <UIKit/UIkit.h>
#import <Foundation/Foundation.h>


@class CRDataLoader;
@class CRRequest;
NS_ASSUME_NONNULL_BEGIN

/** 预处理我们获得得数据，给我数据 */
typedef NSArray* __nonnull (^DataLoaderWillLoad) (CRDataLoader* loader, BOOL byFooter, CRRequest* request);

/** 处理完成了，数据给你看看 */
typedef void (^DataLoaderDidLoad) (CRDataLoader* loader, BOOL byFooter, NSArray* data);

typedef NSDictionary* _Nonnull (^DataLoaderUrlGeter) (NSString* loadApi, NSUInteger pageIndex, NSUInteger pageSize);
typedef void (^DataLoaderRequester) (CRDataLoader* loader, SEL seletor, BOOL byHeader, NSDictionary* refreshData);
typedef  NSArray* _Nonnull  (^DataLoaderListGeter) (NSDictionary *requestData);

typedef id __nonnull (^CustomLoaderHeader) (CRDataLoader* loader, NSDictionary* requestData);
typedef id __nonnull (^CustomLoaderFooter) (CRDataLoader* loader, NSDictionary* requestData);

typedef NS_ENUM(NSUInteger,CRDataLoaderType)
{
    CRDataLoaderTypeNone = 0,
    CRDataLoaderTypeHeader = 1 << 0,
    CRDataLoaderTypeFooter = 1 << 1,
    
    CRDataLoaderTypeAll    = (CRDataLoaderTypeHeader | CRDataLoaderTypeFooter),
};

@interface CRDataLoader : NSObject

/** 本地数据 */
@property (strong) NSArray* _Nullable localData;
/** 加载的Api */
@property (readonly, strong) NSString* _Nullable loadApi;
/** 加载的数据源 */
@property (readonly, strong) NSArray* loadData;
/** 加载的源控件 */
@property (readonly, strong) UIScrollView* targetView;
/** 当前页 */
@property (readonly, assign) NSUInteger currentPage;
/** 总数据量 */
@property (readonly, assign) NSUInteger refreshCount;

/** 每页加载量,不能动态改变 */
@property (assign) NSUInteger pageSize;

/** 源风格(有无Header,Footer) */
@property (assign) CRDataLoaderType style;

/** (自定义)请求url生成 */
@property (copy) DataLoaderUrlGeter __nullable urlGeter;

/** (自定义)请求 */
@property (copy) DataLoaderRequester __nullable requester;

/** (自定义)获取数据源 */
@property (copy) DataLoaderListGeter __nullable listGeter;

/** (自定义)Will请求 */
@property (copy) DataLoaderWillLoad __nullable willLoad;
/** (自定义)Did请求 */
@property (copy) DataLoaderDidLoad __nullable didLoad;

/** (自定义)Header(无入侵) */
@property (copy) CustomLoaderHeader __nullable loadHeader;
/** (自定义)Footer(无入侵) */
@property (copy) CustomLoaderFooter __nullable loadFooter;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithApi:(NSString * _Nullable)api target:(UIScrollView *)targetView;

/** (自定义)创建Loader style默认All pageSize默认10 */
+ (instancetype)loaderWithApi:(NSString * _Nullable)api target:(UIScrollView *)targetView;

/** 数据刷新 */
- (void)reloadData;

/** 自定义Header */
- (void)setRefreshHeader:(id)header;
/** 自定义Footer */
- (void)setRefreshFooter:(id)footer;

/** 默认设置 */
+ (void)setDefuatDataLoaderUrlGeter:(DataLoaderUrlGeter)block;
+ (void)setDefuatDataLoaderRequester:(DataLoaderRequester)block;
+ (void)setDefuatDataLoaderListGeter:(DataLoaderListGeter)block;
+ (void)setDefuatDataLoaderWillLoad:(DataLoaderWillLoad)block;
+ (void)setDefuatDataLoaderDidLoad:(DataLoaderDidLoad)block;
+ (void)setDefuatCustomLoaderHeader:(CustomLoaderHeader)block;
+ (void)setDefuatCustomLoaderFooter:(CustomLoaderFooter)block;

@end
NS_ASSUME_NONNULL_END
