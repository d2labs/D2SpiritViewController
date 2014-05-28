//
//  D2SpiritRefreshTableHeaderView.h
//  D2Spirit
//
//  Created by Lanvige Jiang on 5/25/14.
//  Copyright (c) 2014 d2 Labs. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kMaxRefreshScrollOffset 60.f

typedef enum{
	D2SpiritPullRefreshPulling = 0,
	D2SpiritPullRefreshNormal,
	D2SpiritPullRefreshLoading,
} D2SpiritPullRefreshState;

@protocol D2SpiritRefreshTableHeaderDelegate;

@interface D2SpiritRefreshTableHeaderView : UIView

@property (nonatomic, assign) D2SpiritPullRefreshState state;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CALayer *arrowImageLayer;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property(nonatomic,unsafe_unretained) id<D2SpiritRefreshTableHeaderDelegate> delegate;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


@protocol D2SpiritRefreshTableHeaderDelegate <NSObject>
- (void)refreshTableHeaderDidTriggerRefresh:(D2SpiritRefreshTableHeaderView*)view;
- (BOOL)refreshTableHeaderDataSourceIsLoading:(D2SpiritRefreshTableHeaderView*)view;
@optional
- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(D2SpiritRefreshTableHeaderView*)view;
@end
