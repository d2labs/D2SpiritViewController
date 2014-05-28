//
//  D2SpiritLoadMoreCell.m
//  Highlander
//
//  Created by Lanvige Jiang on 5/24/14.
//  Copyright (c) 2014 d2 Labs. All rights reserved.
//

#import "D2SpiritLoadMoreTableFooterView.h"

@interface D2SpiritLoadMoreTableFooterView ()
@property (nonatomic, strong) UIButton *touchButton;
@property (nonatomic, strong) UIView *seperatorView;
@end


@implementation D2SpiritLoadMoreTableFooterView

- (id)initWithFrame:(CGRect)frame
{
    CGRect rect = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44);
    if (self = [super initWithFrame:rect]) {

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        [self addSubview:self.indicatorView];
        [self addSubview:self.statusLabel];

        // Init the load more state
        self.status = D2SpiritLoadMoreNormal;

        // [self addSubview:self.seperatorView];
    }

    return self;
}


#pragma mark -
#pragma mark

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:[self bounds]];
        _indicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _indicatorView.hidden = YES;
        _indicatorView.backgroundColor = [UIColor whiteColor];
    }

    return _indicatorView;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:[self bounds]];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor grayColor];
        _statusLabel.font = [UIFont hl_hiraFontOfSize:13.f];
        _statusLabel.backgroundColor = [UIColor whiteColor];
    }

    return _statusLabel;
}

- (UIView *)seperatorView
{
    if (!_seperatorView) {
        CGRect sepFrame = CGRectMake(13.f, 0.f, 310.f, .7f);
        _seperatorView = [[UIView alloc] initWithFrame:sepFrame];
        _seperatorView.backgroundColor = [UIColor lightGrayColor];
        _seperatorView.alpha = .8f;
    }

    return _seperatorView;
}

#pragma mark -
#pragma mark Setters

- (void)setStatus:(D2SpiritLoadMoreStatus)status
{

	switch (status) {
		case D2SpiritLoadMoreNormal: {
            [self addTarget:self action:@selector(loadMoreAction:) forControlEvents:UIControlEventTouchUpInside];
//			self.statusLabel.text = NSLocalizedString(@"loadmore", @"Load More items");
            self.statusLabel.text = NSLocalizedString(@"取更多", @"Load More items");
			[self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;

			break;
        }
		case D2SpiritLoadMoreLoading: {
            [self removeTarget:self action:@selector(loadMoreAction:) forControlEvents:UIControlEventTouchUpInside];
//			self.statusLabel.text = NSLocalizedString(@"loading", @"Loading items");
            self.statusLabel.text = NSLocalizedString(@"加载中...", @"Loading items");
			self.indicatorView.hidden = NO;
            [self.indicatorView startAnimating];

			break;
        }
		case D2SpiritLoadMoreOver: {
            [self removeTarget:self action:@selector(loadMoreAction:) forControlEvents:UIControlEventTouchUpInside];
//			self.statusLabel.text = NSLocalizedString(@"nomore", @"There is no more item");
            self.statusLabel.text = NSLocalizedString(@"没有更多", @"Load More items");

            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;

            break;
        }
		default:
			break;
	}

	_status = status;
}


#pragma mark -
#pragma mark Actions

- (IBAction)loadMoreAction:(id)sender
{
    if (self.status != D2SpiritLoadMoreNormal) {
        return;
    }

    if ([self.delegate respondsToSelector:@selector(loadMore)]) {
        [self.delegate loadMore];
    }
}

@end
