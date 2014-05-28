//
//  D2SpiritTableViewController.h
//  Highlander
//
//  Created by Lanvige Jiang on 5/3/14.
//  Copyright (c) 2014 d2 Labs. All rights reserved.
//

#import "D2SpiritViewController.h"
#import "D2SpiritRefreshTableHeaderView.h"
#import "D2SpiritLoadMoreTableFooterView.h"
#import "D2SpiritNotificationView.h"


@protocol D2SpritTableViewDelegate <NSObject>
@required
- (BOOL)shouldDisplayRefreshView;
- (BOOL)shouldDisplayLoadMoreView;
@optional
- (void)reloadTableData;
- (void)loadMoreTableData;
@end



@interface D2SpiritTableViewController : UIViewController <
        UITableViewDataSource,
        UITableViewDelegate,
        D2SpiritRefreshTableHeaderDelegate,
        D2SpiritLoadMoreTableFooterDelegate,
        D2SpritTableViewDelegate
        >

//@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id<D2SpritTableViewDelegate> delegate;
@property (nonatomic, strong) D2SpiritRefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) D2SpiritLoadMoreTableFooterView *loadMoreFooterView;
@property (nonatomic, strong) D2SpiritNotificationView *notificationView;

@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, assign) BOOL moreloading;
@property (nonatomic, assign) BOOL isLoadOver;

#pragma mark - PullToRefresh

- (void)forceReloadDataSourceWithTableView:(UITableView *)tableView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)loadMoreTableViewData;
- (void)doneLoadMoreTableViewData;
- (void)loadOver;
- (void)resetLoadMore;

- (void)showEmptyView;
- (void)hideStatusView;
- (void)showErrorView;
- (void)showNotificationView;

@end
