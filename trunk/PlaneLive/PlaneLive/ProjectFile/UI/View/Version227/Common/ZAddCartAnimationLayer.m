//
//  ZAddCartAnimationLayer.m
//  PlaneLive
//
//  Created by WT on 29/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZAddCartAnimationLayer.h"

@implementation ZAddCartAnimationLayer

/**
 加入购物车的动画效果
 
 @param view       显示的View
 @param startPoint 动画起点
 @param endPoint   动画终点
 @param completion 动画执行完成后的回调
 */
+ (void)addCartAnimationWithView:(UIView *)view startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint completion:(void (^)(BOOL finished))completion
{
    //创建shapeLayer
    CAShapeLayer *animationLayer = [CAShapeLayer layer];
    animationLayer.frame = CGRectMake(startPoint.x-12, startPoint.y-12, 24, 24);
    animationLayer.contents = (id)[UIImage imageNamed:@"cart01"].CGImage;
    //  添加layer到顶层视图控制器上
    [view.layer addSublayer:animationLayer];
    //  创建移动轨迹
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:startPoint];
    [movePath addQuadCurveToPoint:endPoint controlPoint:CGPointMake(0,0)];
    CGFloat durationTime = 0.45;
    //  轨迹动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = durationTime;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.path = movePath.CGPath;
    //  创建缩小动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.4];
    scaleAnimation.duration = durationTime;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    //  添加轨迹动画
    [animationLayer addAnimation:pathAnimation forKey:nil];
    //  添加缩小动画
    [animationLayer addAnimation:scaleAnimation forKey:nil];
    //  动画结束后执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [animationLayer removeFromSuperlayer];
        if (completion) {
            completion(YES);
        }
    });
}
/**
 购物车按钮缩放
 
 @param view       购物车按钮
 @param completion 动画执行完成后的回调
 */
+ (void)addCartViewScale:(UIView *)view
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.75];
    scaleAnimation.duration = 0.1;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:scaleAnimation forKey:nil];
}

@end
