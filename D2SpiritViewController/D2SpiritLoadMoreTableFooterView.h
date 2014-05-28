//
//  D2SpiritLoadMoreCell.h
//  Highlander
//
//  Created by Lanvige Jiang on 5/24/14.
//  Copyright (c) 2014 d2 Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    D2SpiritLoadMoreNormal = 0,
	D2SpiritLoadMoreLoading = 1,
	D2SpiritLoadMoreOver = 2
} D2SpiritLoadMoreStatus;


@protocol D2SpiritLoadMoreTableFooterDelegate;


@interface D2SpiritLoadMoreTableFooterView : UIControl

@property (nonatomic, assign) D2SpiritLoadMoreStatus status;
@property (nonatomic, weak) id<D2SpiritLoadMoreTableFooterDelegate> delegate;
/// View
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *statusLabel;

@end



@protocol D2SpiritLoadMoreTableFooterDelegate <NSObject>
@required
- (void)loadMore;
@optional
@end