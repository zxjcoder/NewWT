//
//  ZTransitionAnimation.m
//  PlaneLive
//
//  Created by WT on 20/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZTransitionAnimation.h"

@interface ZTransitionAnimation()
{
    ZTransitionAnimationType _typeStyle;
    NSTimeInterval _transitionTime;
}

@end

@implementation ZTransitionAnimation

- (instancetype)initWithStytle:(ZTransitionAnimationType)type
{
    if (self = [super init])
    {
        _typeStyle = type;
        _transitionTime = 0.25;
    }
    return self;
}
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return _transitionTime;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    switch (_typeStyle)
    {
        case ZTransitionAnimationTypePush:
        {
            toView.frame = CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT);
            [containerView addSubview:toView];
            [UIView animateWithDuration:_transitionTime animations:^{
                toView.frame = CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
            break;
        }
        case ZTransitionAnimationTypePop:
        {
            [UIView animateWithDuration:_transitionTime animations:^{
                fromView.frame = CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT);
            } completion:^(BOOL finished) {
                [containerView addSubview:toView];
                [transitionContext completeTransition:YES];
            }];
            break;
        }
        case ZTransitionAnimationTypePresent:
        {
            toView.frame = CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT);
            [containerView addSubview:toView];
            [UIView animateWithDuration:_transitionTime animations:^{
                toView.frame = CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
            break;
        }
        case ZTransitionAnimationTypeDissmiss:
        {
            [UIView animateWithDuration:_transitionTime animations:^{
                fromView.frame = CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT);
            } completion:^(BOOL finished) {
                [containerView addSubview:toView];
                [transitionContext completeTransition:YES];
            }];
            break;
        }
        default:
            break;
    }
}

@end
