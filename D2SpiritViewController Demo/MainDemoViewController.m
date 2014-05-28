//
//  ViewController.m
//  MMSuperViewController Demo
//
//  Created by Lanvige Jiang on 7/21/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import "MainDemoViewController.h"
#import "RefreshLoadMoreDemoTableViewController.h"
#import "RefreshDemoTableViewController.h"
#import "LoadMoreDemoTableViewController.h"
#import "RefreshLogoDemoTableViewController.h"
#import "NullDemoViewController.h"
#import "LoadingOnlyViewController.h"


@interface MainDemoViewController ()

@property (nonatomic, strong) MMSuperListViewController *listViewController;
@end

@implementation MainDemoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"Full Tableview";
            break;
        }
        case 1: {
            cell.textLabel.text = @"Header only";
            break;
        }
        case 2: {
            cell.textLabel.text = @"Footer only";
            break;
        }
        case 3: {
            cell.textLabel.text = @"Refresh Logo";
            break;
        }
        case 4: {
            cell.textLabel.text = @"Null Data";
            break;
        }
        case 5: {
            cell.textLabel.text = @"Loading";
        }
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            self.listViewController = [[RefreshLoadMoreDemoTableViewController alloc] init];
            [self.navigationController pushViewController:self.listViewController animated:YES];
            break;
        }
        case 1: {
            self.listViewController = [[RefreshDemoTableViewController alloc] init];
            [self.navigationController pushViewController:self.listViewController animated:YES];
            break;
        }
        case 2: {
            self.listViewController = [[LoadMoreDemoTableViewController alloc] init];
            [self.navigationController pushViewController:self.listViewController animated:YES];
            break;
        }
        case 3: {
            self.listViewController = [[RefreshLogoDemoTableViewController alloc] init];
            [self.navigationController pushViewController:self.listViewController animated:YES];
            break;
        }
        case 4: {
            self.listViewController = [[NullDemoViewController alloc] init];
            [self.navigationController pushViewController:self.listViewController animated:YES];
            break;
        }
        case 5:{
            self.listViewController = [[LoadingOnlyViewController alloc] init];
            [self.navigationController pushViewController:self.listViewController animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
