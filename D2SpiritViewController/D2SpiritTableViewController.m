//
//  D2SpiritTableViewController.m
//  Highlander
//
//  Created by Lanvige Jiang on 5/3/14.
//  Copyright (c) 2014 d2 Labs. All rights reserved.
//

#import "D2SpiritTableViewController.h"
#import "D2SpiritStatusView.h"
#import "D2SpiritEmptyView.h"
#import "D2SpiritNetworkErrorView.h"



@interface D2SpiritTableViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL refreshEnabled;
@property (nonatomic, assign) BOOL loadMoreEnabled;

@property (nonatomic, strong) D2SpiritStatusView *statusView;
@property (nonatomic, strong) D2SpiritEmptyView *emptyView;
@property (nonatomic, strong) D2SpiritNetworkErrorView *errorView;
@end


@implementation D2SpiritTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }

    return self;
}


#pragma mark -
#pragma mark UIView lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        /// S1: http://stackoverflow.com/questions/18900428/ios-7-uitableview-shows-under-status-bar
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;

        self.navigationController.navigationBar.translucent = YES;
        self.tabBarController.tabBar.translucent = NO;

        /// S2: http://stackoverflow.com/questions/19325677/tab-bar-covers-tableview-cells-in-ios7
    }

    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.notificationView];

    self.delegate = self;

    // add the views
    if (self.refreshEnabled) {
        [self.tableView addSubview:self.refreshHeaderView];
    }
}

#pragma mark -
#pragma mark UIView lazy init

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }

    return _tableView;
}

- (D2SpiritRefreshTableHeaderView *)refreshHeaderView
{
    if (!_refreshHeaderView) {
        _refreshHeaderView = [[D2SpiritRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
    }

    return _refreshHeaderView;
}

- (D2SpiritLoadMoreTableFooterView *)loadMoreFooterView
{
    if (!_loadMoreFooterView) {
        _loadMoreFooterView = [[D2SpiritLoadMoreTableFooterView alloc] initWithFrame:CGRectZero];
        _loadMoreFooterView.delegate = self;
    }

    return _loadMoreFooterView;
}

- (D2SpiritNotificationView *)notificationView
{
    if (!_notificationView) {
        _notificationView = [[D2SpiritNotificationView alloc] initWithFrame:CGRectZero];
        _notificationView.backgroundColor = [UIColor hl_darkOrangeColor];
        _notificationView.alpha = .8f;

        UILabel *label = [[UILabel alloc] initWithFrame:_notificationView.bounds];
        label.text = @"您有100条更新...";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont hl_hiraFontOfSize:14.f];
        [_notificationView addSubview:label];
    }

    return _notificationView;
}

- (D2SpiritEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[D2SpiritEmptyView alloc] initWithFrame:self.tableView.frame];
    }

    return _emptyView;
}

- (D2SpiritNetworkErrorView *)errorView
{
    if (!_errorView) {
        _errorView = [[D2SpiritNetworkErrorView alloc] initWithFrame:self.tableView.frame];
    }

    return _errorView;
}


- (BOOL)refreshEnabled
{
    // Get value from specific controller
    if ([self.delegate respondsToSelector:@selector(shouldDisplayRefreshView)]) {
        return [self.delegate shouldDisplayRefreshView];
    }

    return FALSE;
}

- (BOOL)loadMoreEnabled
{
    if ([self.delegate respondsToSelector:@selector(shouldDisplayLoadMoreView)]) {
        return [self.delegate shouldDisplayLoadMoreView];
    }

    return FALSE;
}


#pragma mark -
#pragma mark UITableView Delegation & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

// Loadmore
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (!self.loadMoreEnabled) {
        return;
    }
    
    NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForRow:([tableView numberOfRowsInSection:0] - 1) inSection:0];

    if (indexPath.row == lastCellIndexPath.row) {
        [self loadMoreTableViewData];
        return;
    }
}

#pragma mark -
#pragma mark

- (NSIndexPath *)indexPathOfObject:(HLKObject *)object
{
    // return [NSIndexPath indexPathForRow:[self.objects indexOfObject:object] inSection:0];
    return nil;
}

- (HLKObject *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    // return [self.objects objectAtIndex:indexPath.row];
    return nil;
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.refreshEnabled) {
        [self.refreshHeaderView refreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.refreshEnabled) {
        [self.refreshHeaderView refreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark D2SpiritRefreshTableHeaderDelegate Methods

- (void)refreshTableHeaderDidTriggerRefresh:(D2SpiritRefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)refreshTableHeaderDataSourceIsLoading:(D2SpiritRefreshTableHeaderView *)view
{
    // should return if data source model is reloading
    return self.refreshing;
}


#pragma mark -
#pragma mark D2SpritTableViewDelegate Implement

- (BOOL)shouldDisplayRefreshView
{
    return YES;
}

- (BOOL)shouldDisplayLoadMoreView
{
    return YES;
}



#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

// about contentInset http://blog.csdn.net/catandrat111/article/details/8492564
- (void)forceReloadDataSourceWithTableView:(UITableView *)tableView
{
    [UIView animateWithDuration:.3f
                     animations:^{
                         UIEdgeInsets insets = tableView.contentInset;
                         insets.top += kMaxRefreshScrollOffset;

                         self.tableView.contentOffset = CGPointMake(0.0f, 0 - kMaxRefreshScrollOffset);
                         self.tableView.contentInset = insets;
                     }];

    [self.refreshHeaderView setState:D2SpiritPullRefreshLoading];
    [self reloadTableViewDataSource];
}

- (void)reloadTableViewDataSource
{
    if (self.moreloading) {
        return;
    }

    self.refreshing = YES;

    if ([self.delegate respondsToSelector:@selector(reloadTableData)]) {
        [self.delegate reloadTableData];
    }
}

- (void)doneLoadingTableViewData
{
    //  model should call this when its done loading
    self.refreshing = NO;
    [self.refreshHeaderView refreshScrollViewDataSourceDidFinishedLoading:self.tableView];

    // Add load more if possiable
    // if (self.loadMoreEnabled && !self.isLoadOver) {
    if (self.loadMoreEnabled) {
        self.tableView.tableFooterView = self.loadMoreFooterView;
    }
}


#pragma mark -
#pragma mark Loadmore

- (void)loadMore
{
    [self loadMoreTableViewData];
}

- (void)loadMoreTableViewData
{
    if (self.refreshing || self.moreloading || self.isLoadOver) {
        return;
    }

    if ([self.delegate respondsToSelector:@selector(loadMoreTableData)]) {
        [self.delegate loadMoreTableData];
    }

    self.moreloading = YES;
    self.loadMoreFooterView.status = D2SpiritLoadMoreLoading;
}

- (void)doneLoadMoreTableViewData
{
    self.moreloading = NO;
    self.loadMoreFooterView.status = D2SpiritLoadMoreNormal;
}

- (void)loadOver
{
    self.isLoadOver = YES;
    self.loadMoreFooterView.status = D2SpiritLoadMoreOver;

    /// Remove no more detail info
    // self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)resetLoadMore
{
    self.isLoadOver = NO;
    self.loadMoreFooterView.status = D2SpiritLoadMoreNormal;

    /// Remove no more detail info
//    if (self.loadMoreEnabled) {
//        self.tableView.tableFooterView = self.loadMoreFooterView;
//    }
}



#pragma mark -
#pragma mark Actions


#pragma mark -
#pragma mark

- (void)showEmptyView
{
    self.statusView = self.emptyView;
    [self.tableView addSubview:self.statusView];
}

- (void)showErrorView
{
    self.statusView = self.errorView;
    [self.tableView addSubview:self.statusView];
}

- (void)hideStatusView
{
    [self.statusView removeFromSuperview];
}

- (void)showNotificationView
{
    [self.notificationView show];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
