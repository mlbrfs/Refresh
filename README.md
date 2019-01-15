# Refresh
UIScrollView Refresh control for  swift4.2  

#引入项目

1.直接将Refresh.framework导入项目内
2.或者将Refresh文件夹导入项目

#使用方法

下面是scrollView分类方法

// 添加头部或者尾部控件 和调用时回调block


// 给刷新事件添加Target和响应事件
- (void)addHeaderWithTarget:(id _Nonnull)target action:(SEL _Nonnull)action;
- (void)addFooterWithTarget:(id _Nonnull)target action:(SEL _Nonnull)action;

// 调用结束或者开始刷新  并调用响应回调和action
- (void)startHeaderRefresh;
- (void)startFooterRefresh;
- (void)endHeaderRefresh;
- (void)endFooterRefresh;

// 判断是否在刷新

@property (nonatomic, readonly) BOOL isHeaderRefreshing;

@property (nonatomic, readonly) BOOL isFooterRefreshing;

// 给刷新时不同状态赋值文案

@property (nonatomic, copy) NSString * _Nonnull headerPullToRefreshText;

@property (nonatomic, copy) NSString * _Nonnull headerReleaseToRefreshText;

@property (nonatomic, copy) NSString * _Nonnull headerRefreshingText;

@property (nonatomic, copy) NSString * _Nonnull footerPullToRefreshText;

@property (nonatomic, copy) NSString * _Nonnull footerReleaseToRefreshText;

@property (nonatomic, copy) NSString * _Nonnull footerRefreshingText;

// 删除刷新视图

- (void)removerHeader;

- (void)removerFooter;

