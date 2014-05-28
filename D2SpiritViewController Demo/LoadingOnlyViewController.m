//
//  LoadingOnlyViewController.m
//  MMSuperViewController Demo
//
//  Created by Lanvige Jiang on 8/5/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "LoadingOnlyViewController.h"
#import "MMListEmptyDefaultView.h"
#import "MMLoadingDefaultView.h"


@interface LoadingOnlyViewController ()

@property (nonatomic, strong) MMRefreshDefaultView *refreshHeaderView1;
@property (nonatomic, strong) MMLoadMoreDefaultView *loadMoreFooterView1;
@property (nonatomic, strong) NSArray *listData;

@end

@implementation LoadingOnlyViewController

- (id)init
{
    if (self = [super initWithListType:MMListRefreshAndLoadMore]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.placeholderView = [[MMListEmptyDefaultView alloc] initWithFrame:CGRectZero];
        self.loadingView = [[MMLoadingDefaultView alloc] initWithFrame:self.view.bounds];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.refreshHeaderView = self.refreshHeaderView1;
    self.loadMoreFooterView = self.loadMoreFooterView1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.listData = @[];
    self.title = @"Refresh&More";
    
    [self load];
}


#pragma mark -
#pragma mark Internal Methods

- (BOOL)empty
{
    return self.listData.count == 0;
}

- (void)load
{
    [super load];
    
    [self performSelector:@selector(loadCompleted)
               withObject:nil
               afterDelay:2.f];
}

- (void)loadCompleted
{
    self.listData = @[@1, @2, @3, @4, @5, @6, @7, @8, @2, @3, @4, @45, @2, @2];
    [self.tableView reloadData];
    [super loadCompletedWithAnimated:NO];
}

- (void)loadMore
{
    [super loadMore];
    
    self.allLoadFinished = YES;
    [self performSelector:@selector(loadMoreCompletedWithAnimated:)
               withObject:nil
               afterDelay:1.0];
    return;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

#pragma mark -
#pragma mark - UITableViewDataSrouce

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const kCellIdentifier = @"loadingCellIndentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.listData[indexPath.row]];
    
    return cell;
}


- (MMRefreshDefaultView *)refreshHeaderView1
{
    if (!_refreshHeaderView1) {
		_refreshHeaderView1 = [[MMRefreshDefaultView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        _refreshHeaderView1.backgroundColor = [UIColor clearColor];
        [_refreshHeaderView1 updateLastUpdatedDate];
	}
    
    return _refreshHeaderView1;
}

- (MMLoadMoreDefaultView *)loadMoreFooterView1
{
    if (!_loadMoreFooterView1) {
		_loadMoreFooterView1 = [[MMLoadMoreDefaultView alloc] init];
	}
    
    return _loadMoreFooterView1;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
