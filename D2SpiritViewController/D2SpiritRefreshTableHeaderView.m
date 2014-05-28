//
//  D2SpiritRefreshTableHeaderView.m
//  D2Spirit
//
//  Created by Lanvige Jiang on 5/25/14.
//  Copyright (c) 2014 d2 Labs. All rights reserved.
//


#import "D2SpiritRefreshTableHeaderView.h"


#define FLIP_ANIMATION_DURATION 0.18f


@interface D2SpiritRefreshTableHeaderView ()
- (void)setState:(D2SpiritPullRefreshState)aState;
@end



@implementation D2SpiritRefreshTableHeaderView


#pragma mark -
#pragma mark NSObject init

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];

        [self addSubview:self.statusLabel];
        [self.layer addSublayer:self.arrowImageLayer];
        [self addSubview:self.activityView];

        [self setState:D2SpiritPullRefreshNormal];
    }

    return self;
}

- (void)dealloc
{
}


#pragma mark -
#pragma mark UIView lazy init

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(144.0f, self.frame.size.height - 38.0f, 170.f, 20.0f)];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont hl_hiraFontOfSize:13.0f];
        _statusLabel.textColor = [UIColor hl_contentColor];
        // _statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        // _statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentLeft;
    }

    return _statusLabel;
}

- (CALayer *)arrowImageLayer
{
    if (!_arrowImageLayer) {
        _arrowImageLayer = [CALayer layer];
        _arrowImageLayer.frame = CGRectMake(105.0f, self.frame.size.height - 45.0f, 32.0f, 32.0f);
        _arrowImageLayer.contentsGravity = kCAGravityResizeAspect;
        _arrowImageLayer.contents = (id)[UIImage imageNamed : @"control_pull_refresh"].CGImage;

        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            _arrowImageLayer.contentsScale = [[UIScreen mainScreen] scale];
        }
    }

    return _arrowImageLayer;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(110.0f, self.frame.size.height - 38.0f, 20.0f, 20.0f);
    }

    return _activityView;
}

#pragma mark -
#pragma mark Setters

- (void)setState:(D2SpiritPullRefreshState)aState
{
    switch (aState) {
        case D2SpiritPullRefreshPulling: {
            // self.statusLabel.text = NSLocalizedString(@"releasetorefresh", @"Release to refresh status");
            self.statusLabel.text = NSLocalizedString(@"释放更新", @"Release to refresh status");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            self.arrowImageLayer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];

            break;
        }
        case D2SpiritPullRefreshNormal: {
            if (self.state == D2SpiritPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                self.arrowImageLayer.transform = CATransform3DIdentity;
                [CATransaction commit];
            }

            // self.statusLabel.text = NSLocalizedString(@"pulltorefresh", @"Pull to refresh status");
            self.statusLabel.text = NSLocalizedString(@"下拉刷新", @"Pull to refresh status");
            [self.activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
            self.arrowImageLayer.hidden = NO;
            self.arrowImageLayer.transform = CATransform3DIdentity;
            [CATransaction commit];

            break;
        }
        case D2SpiritPullRefreshLoading: {
            self.statusLabel.text = NSLocalizedString(@"加载中...", @"Loading Status");
            [self.activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
            self.arrowImageLayer.hidden = YES;
            [CATransaction commit];

            break;
        }
        default:
            break;
    }

    _state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.state == D2SpiritPullRefreshLoading) {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, kMaxRefreshScrollOffset);

        // scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        UIEdgeInsets insets = scrollView.contentInset;
        insets.top = offset;
        scrollView.contentInset = insets;
    } else if (scrollView.isDragging) {
        BOOL loading = NO;

        if ([self.delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
            loading = [self.delegate refreshTableHeaderDataSourceIsLoading:self];
        }

        if (self.state == D2SpiritPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !loading) {
            [self setState:D2SpiritPullRefreshNormal];
        } else if (_state == D2SpiritPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !loading) {
            [self setState:D2SpiritPullRefreshPulling];
        }

        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL loading = NO;

    if ([self.delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
        loading = [self.delegate refreshTableHeaderDataSourceIsLoading:self];
    }

    if (scrollView.contentOffset.y <= -65.0f && !loading) {
        if ([self.delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
            [self.delegate refreshTableHeaderDidTriggerRefresh:self];
        }

        [self setState:D2SpiritPullRefreshLoading];

        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
             // scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);

             UIEdgeInsets insets = scrollView.contentInset;
             insets.top = kMaxRefreshScrollOffset;
             scrollView.contentInset = insets;
         } completion:^(BOOL finished){
         }];

    }
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
         // [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];

         UIEdgeInsets insets = scrollView.contentInset;
         // insets.top -= kMaxRefreshScrollOffset;
         insets.top = 0;
         scrollView.contentInset = insets;
     } completion:^(BOOL finished){
     }];

    [self setState:D2SpiritPullRefreshNormal];
}

@end
