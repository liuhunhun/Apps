//
//  MyActivityIndicator.m
//  SinaWeiboClient
//
//  Created by waiting_alone on 13-2-14.
//  Copyright (c) 2013年 waiting_alone. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MyActivityIndicator.h"
#import "MBSpinningCircle.h"

@implementation MyActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.8;
    }
    return self;
}

- (void)cleanSubViews {
    NSArray *array = [self subviews];
    for (UIView *_view in array) {
        [_view removeFromSuperview];
    }
}

-(void)addBounceAnimation
{
    MBSpinningCircle *_activityIndicator = [MBSpinningCircle circleWithSize:NSSpinningCircleSizeLarge color:[UIColor colorWithRed:50.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1.0]];
    CGRect circleRect = _activityIndicator.frame;
    circleRect.origin = CGPointMake(25, 25);
    _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _activityIndicator.frame = circleRect;
    _activityIndicator.circleSize = NSSpinningCircleSizeLarge;
    _activityIndicator.hasGlow = YES;
    _activityIndicator.isAnimating = YES;
    _activityIndicator.speed = 0.55;
    
    UIView *indicatorBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 50, self.frame.size.height / 2.0 - 100, 100, 100)];
    indicatorBackgroundView.layer.cornerRadius = 5.0;
    indicatorBackgroundView.layer.masksToBounds = YES;
    indicatorBackgroundView.backgroundColor = [UIColor blackColor];
    
    [indicatorBackgroundView addSubview:_activityIndicator];
    
    [self addSubview:indicatorBackgroundView];
    
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)],
    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.35, 1.35, 1)],
    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)],
    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    NSArray *frameTimes = @[@(0.0), @(0.5), @(0.9), @(1.0)];
    [self.layer addAnimation:[self animationWithValues:frameValues times:frameTimes duration:0.4] forKey:@"popup"];
}

-(void)addDismissAnimation
{
    NSArray *frameValues = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 1.15, 1)],
    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
    
    NSArray *frameTimes = @[@(0.0), @(0.1), @(0.5), @(1.0)];
    CAKeyframeAnimation *animation = [self animationWithValues:frameValues times:frameTimes duration:0.25];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.layer addAnimation:animation forKey:@"popup"];
    
    [self performSelector:@selector(cleanSubViews) withObject:nil afterDelay:0.15];
}

-(CAKeyframeAnimation*)animationWithValues:(NSArray*)values times:(NSArray*)times duration:(CGFloat)duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = values;
    animation.keyTimes = times;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    return animation;
}

@end
