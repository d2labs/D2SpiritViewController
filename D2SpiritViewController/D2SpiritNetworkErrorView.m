//
//  D2NetworkErrorDefaultView.m
//  Highlander
//
//  Created by Lanvige Jiang on 5/19/14.
//  Copyright (c) 2014 d2 Labs. All rights reserved.
//

#import "D2SpiritNetworkErrorView.h"

@interface D2SpiritNetworkErrorView()
@property (nonatomic, strong) UIImageView *loadEmptyImageView;
@end


@implementation D2SpiritNetworkErrorView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.loadEmptyImageView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 300.f, 200, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor hl_contentColor];
        label.font = [UIFont hl_hiraFontOfSize:13.f];
        label.text = @"网络错误";

        [self addSubview:label];
    }

    return self;
}

- (UIImageView *)loadEmptyImageView
{
    if (!_loadEmptyImageView) {
        CGRect rect = self.frame;
        _loadEmptyImageView = [[UIImageView alloc] initWithFrame:rect];
        _loadEmptyImageView.backgroundColor = [UIColor whiteColor];
        _loadEmptyImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleTopMargin;

        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 200.f)];
        iconImageView.center = [self contrainCenter];
        iconImageView.contentMode = UIViewContentModeCenter;
        iconImageView.image = [UIImage imageInBundleNamed:@"load_empty"];
        [_loadEmptyImageView addSubview:iconImageView];
    }

    return _loadEmptyImageView;
}

- (CGPoint)contrainCenter
{
    CGPoint center = self.center;
    center.y = center.y - 32.f;
    return center;
}

@end
