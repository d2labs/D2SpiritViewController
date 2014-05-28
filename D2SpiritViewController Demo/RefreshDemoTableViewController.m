//
//  MMRefreshTableViewController.m
//  MMSuperViewController Demo
//
//  Created by Lanvige Jiang on 7/22/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "RefreshDemoTableViewController.h"
#import "MMListEmptyDefaultView.h"
#import "MMLoadingDefaultView.h"


@interface RefreshDemoTableViewController ()

@property (nonatomic, strong) MMRefreshDefaultView *refreshHeaderView1;
@property (nonatomic, strong) NSArray *listData;
@end

@implementation RefreshDemoTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithListType:MMListRefreshOnly]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.placeholderView = [[MMListEmptyDefaultView alloc] initWithFrame:CGRectZero];
        self.loadingView = [[MMLoadingDefaultView alloc] initWithFrame:CGRectZero];
        
        
        self.listData = @[@1, @2, @3, @4, @5, @6, @7, @8, @2, @3, @4, @45, @2, @2];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.refreshHeaderView = self.refreshHeaderView1;

    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Refresh only";
}


#pragma mark -
#pragma mark Internal Methods

- (BOOL)empty
{
    return self.listData.count == 0;
}

- (IBAction)refreshData:(id)sender
{
    [self forceRefresh];
}

- (void)refresh
{
    [super refresh];
    self.tabBarController.navigationItem.rightBarButtonItem = [UIBarButtonItem exActivityIndicatorButtonItem];
    
    [self performSelector:@selector(refreshCompleted)
               withObject:nil
               afterDelay:1.0];
    return;
}

- (void)refreshCompleted
{
    [super refreshCompletedWithAnimated:NO];
    
    self.tabBarController.navigationItem.rightBarButtonItem = [UIBarButtonItem exRefreshButtonItemWithTarget:self action:@selector(refreshData:)];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
