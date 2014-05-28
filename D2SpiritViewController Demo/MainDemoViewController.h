//
//  ViewController.h
//  MMSuperViewController Demo
//
//  Created by Lanvige Jiang on 7/21/13.
//  Copyright (c) 2013 Lanvige Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainDemoViewController : UIViewController <
    UITableViewDelegate,
    UITableViewDataSource
    >

@property (nonatomic, strong) UITableView *tableView;

@end
