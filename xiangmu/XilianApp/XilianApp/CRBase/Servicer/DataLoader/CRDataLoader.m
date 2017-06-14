//
//  CRDataLoader.m
//  XilianApp
//
//  Created by Abyss on 2017/2/23.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import "CRDataLoader.h"
#import "MJRefresh.h"
#import "CRRequest.h"

static DataLoaderRequester s_requester = nil;
static DataLoaderUrlGeter s_urlGeter = nil;
static DataLoaderListGeter s_listGeter = nil;
static DataLoaderWillLoad s_willLoad = nil;
static DataLoaderDidLoad s_didLoad = nil;
static CustomLoaderHeader s_headerLoad = nil;
static CustomLoaderFooter s_FooterLoad = nil;

@interface CRDataLoader()
{
    NSMutableArray*         _refreshData;
    
    /** 数据是否加载完毕 */
    BOOL                    _dataDone;
    
    id                      _header;
    id                      _footer;
    
    DataLoaderRequester     _requester;
    DataLoaderListGeter     _listGeter;
    DataLoaderWillLoad      _willLoad;
    DataLoaderDidLoad       _didLoad;
    CustomLoaderHeader      _headerLoad;
    CustomLoaderFooter      _footerLoad;
}
@end
@implementation CRDataLoader

- (instancetype)initWithTarget:(UIScrollView *)targetView
{
    return [self initWithApi:nil target:targetView];
}

- (instancetype)initWithApi:(NSString *)api target:(UIScrollView *)targetView
{
    if(!(self = [super init]))
    {
        return self;
    }
    
    /** TargetView 需要兼容TableView&CollectionView */
    _targetView = targetView;
    
    /** ScrollView */
    [_targetView setShowsHorizontalScrollIndicator:NO];
    [_targetView setShowsVerticalScrollIndicator:NO];
    
    /** TableView */
    if([_targetView isKindOfClass:[UITableView class]])
    {
        [((UITableView *)_targetView) setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    /** CollectionView */
    if([_targetView isKindOfClass:[UICollectionView class]])
    {
    }
    
    _loadApi = api;
        
    _refreshData = [[NSMutableArray alloc] init];
    _localData   = [[NSMutableArray alloc] init];
    _pageSize    = 10;
    _dataDone    = FALSE;
    
    self.requester  = s_requester;
    self.listGeter  = s_listGeter;
    self.willLoad   = s_willLoad;
    self.didLoad    = s_didLoad;
    self.loadHeader = s_headerLoad;
    self.loadFooter = s_FooterLoad;
    self.urlGeter   = s_urlGeter;
    
    /** 上拉 */
    _header = s_headerLoad;

    /** 下拉 */
    _footer = s_FooterLoad;
    
    return self;
}

+ (instancetype)loaderWithApi:(NSString * _Nullable)api target:(UIScrollView *)targetView
{
    return [[self alloc] initWithApi:api target:targetView];
}

#pragma mark - Attribute

- (NSArray *)loadData
{
    if (!_loadApi && _localData)
    {
        return _localData;
    }
    
    return _refreshData;
}

- (NSUInteger)refreshCount
{
    return self.loadData.count;
}

- (void)reloadData
{
    [self requestData:FALSE];
}

- (void)setStyle:(CRDataLoaderType)style
{
    switch (style)
    {
        case CRDataLoaderTypeNone:
        {
            [self setupHeader:NO];
            [self setupFooter:NO];
        }
            break;
        case CRDataLoaderTypeHeader:
        {
            [self setupHeader:YES];
            [self setupFooter:NO];
        }
            break;
        case CRDataLoaderTypeFooter:
        {
            [self setupHeader:NO];
            [self setupFooter:YES];
        }
            break;
        case CRDataLoaderTypeAll:
        {
            [self setupHeader:YES];
            [self setupFooter:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark - Deel

- (void)requestData:(BOOL)byFooter
{
    // 下拉
    if(byFooter)
    {
        if(_dataDone)
        {
            ((UIScrollView *)_targetView).mj_footer.state = MJRefreshStateNoMoreData;
            
            return ;
        }
    }
    // 上拉
    else
    {
        _dataDone = FALSE;
    }
    
    _currentPage = byFooter ? self.refreshCount/_pageSize : 0;
    
    if (_loadApi)
    {
        NSDictionary* params = @
        {
            @"requestParams": _urlGeter(_loadApi, _currentPage, _pageSize),
            @"pageIndex"    : [NSNumber numberWithInt:(int)_currentPage],
            @"refreshName"  : _loadApi,
            @"pageSize"     : [NSNumber numberWithInt:(int)_pageSize],
        };
        
        SEL handler = byFooter ? @selector(footRequestHandler:) : @selector(headRequestHandler:);
        
        _requester(self ,handler, !byFooter, params);
    }
}

- (void) headRequestHandler:(CRRequest *)request
{
    [self requestHandler:request byFooter:FALSE];
}

- (void) footRequestHandler:(CRRequest *)request
{
    [self requestHandler:request byFooter:TRUE];
}

- (void) requestHandler:(CRRequest *)request byFooter:(BOOL)byFooter
{
    NSArray* netList = nil;
    
    if (_willLoad)
    {
       netList = _willLoad(self,byFooter,request);
    }
    else
    {
        netList = nil;
        /** 获取数据 */
    }
    
    _dataDone = (netList.count == 0);
    
    if (!byFooter)
    {
        [_refreshData removeAllObjects];
    }
    
    ((UIScrollView *)_targetView).mj_header.state = MJRefreshStateIdle;
    ((UIScrollView *)_targetView).mj_footer.state = MJRefreshStateIdle;
    
    [_refreshData addObjectsFromArray:netList];
    
    
    if (netList.count < _pageSize) _dataDone = YES;
    if(_dataDone)
        ((UIScrollView *)_targetView).mj_footer.state = MJRefreshStateNoMoreData;
    
    if ([_targetView respondsToSelector:@selector(reloadData)])
        [((UITableView *)_targetView) reloadData];
    
    if (_didLoad)
    {
        _didLoad(self,byFooter,self.loadData);
    }
}

#pragma mark - Header&Footer

- (void)setRefreshHeader:(id)header
{
    _header = header;
}

- (void)setRefreshFooter:(id)footer
{
    _footer = footer;
}

- (void)setupHeader:(BOOL)show
{
    ((UIScrollView *)_targetView).mj_header = show?_header:nil;
}

- (void)setupFooter:(BOOL)show
{
    ((UIScrollView *)_targetView).mj_footer = show?_footer:nil;
}

#pragma mark - Defuat

+ (void)setDefuatDataLoaderUrlGeter:(DataLoaderUrlGeter)block
{
    s_urlGeter = block;
}

+ (void)setDefuatDataLoaderRequester:(DataLoaderRequester)block
{
    s_requester = block;
}

+ (void)setDefuatDataLoaderListGeter:(DataLoaderListGeter)block
{
    s_listGeter = block;
}

+ (void)setDefuatDataLoaderWillLoad:(DataLoaderWillLoad)block
{
    s_willLoad = block;
}

+ (void)setDefuatDataLoaderDidLoad:(DataLoaderDidLoad)block
{
    s_didLoad = block;
}

+ (void)setDefuatCustomLoaderHeader:(CustomLoaderHeader)block
{
    s_headerLoad = block;
}

+ (void)setDefuatCustomLoaderFooter:(CustomLoaderFooter)block
{
    s_FooterLoad = block;
}

@end
