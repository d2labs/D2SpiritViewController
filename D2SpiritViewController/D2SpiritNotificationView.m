//
//  D2SpiritNotificationView.m
//  Highlander
//
//  Created by Lanvige Jiang on 5/25/14.
//  Copyright (c) 2014 d2 Labs. All rights reserved.
//

#import "D2SpiritNotificationView.h"


@implementation D2SpiritNotificationView


#pragma mark -
#pragma mark NSObject

- (id)initWithFrame:(CGRect)frame
{
    CGRect rect = CGRectMake(0, 0, 320, 44);

    if (self = [super initWithFrame:rect]) {
        self.center = [self hidingCenter];
        self.hidden = YES;
    }

    return self;
}


#pragma mark -
#pragma mark Actions

- (void)show
{
    if ([self isShowing]) {
        return;
    }

    self.hidden = NO;

    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
        self.center = [self showingCenter];
    } completion:^(BOOL finished){
        [self hideAnimatedAfter:2.f];
    }];
}

- (void)hidden
{
    if (![self isShowing]) {
        return;
    }

    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
        self.center = [self hidingCenter];
    } completion:^(BOOL finished){
        self.hidden = YES;
    }];

}

- (void)hideAnimatedAfter:(NSTimeInterval) timeInterval
{
    [self performSelector:@selector(hidden) withObject:nil afterDelay:timeInterval];
}


#pragma mark -
#pragma mark 

- (BOOL)isShowing
{
    return (self.center.y == self.showingCenter.y);
}

- (CGPoint)showingCenter
{
    CGFloat y = 22;

    return CGPointMake(self.bounds.size.width / 2, y);
}

- (CGPoint)hidingCenter
{
    CGFloat y = -22;

    return CGPointMake(self.bounds.size.width / 2, y);
}

@end
