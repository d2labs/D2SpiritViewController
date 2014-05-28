//
//  NullDemoViewController.m
//  MMSuperViewController Demo
//
//  Created by Lanvige Jiang on 7/22/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "NullDemoViewController.h"
#import "MMListEmptyDefaultView.h"
#import "MMLoadingDefaultView.h"


@interface NullDemoViewController ()

@property (nonatomic, strong) MMRefreshDefaultView *refreshHeaderView1;
@property (nonatomic, strong) MMLoadMoreDefaultView *loadMoreFooterView1;
@property (nonatomic, strong) NSArray *listData;
@end

@implementation NullDemoViewController

- (id)init
{
    if (self = [super initWithListType:MMListRefreshAndLoadMore]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.placeholderView = [[MMListEmptyDefaultView alloc] initWithFrame:CGRectZero];
        self.loadingView = [[MMLoadingDefaultView alloc] initWithFrame:self.view.bounds];
        
        
        self.listData = @[];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.refreshHeaderView = self.refreshHeaderView1;
    self.loadMoreFooterView = self.loadMoreFooterView1;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Empty list";
    
    [self loadData];
}


#pragma mark -
#pragma mark Internal Methods

- (BOOL)empty
{
    return self.listData.count == 0;
}


- (void)loadData
{
    [super load];
    
    [self performSelector:@selector(loadCompleted)
               withObject:nil
               afterDelay:3.0];
}

- (void)loadCompleted
{
    [super loadCompleted];
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

- (void)refresh
{
    [self performSelector:@selector(refreshCompleted)
               withObject:nil
               afterDelay:3.0];
}

- (void)refreshCompleted
{
    [super refreshCompleted];
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
    static NSString *kCellIdentifier = @"noticesCellIndentifier";
    //    NSString *kCellIdentifier = [NSString stringWithFormat:@"cell_%d", indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    }
    
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
