//
//  ZAddCartAnimationLayer.h
//  PlaneLive
//
//  Created by WT on 29/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 添加图片到购物车
@interface ZAddCartAnimationLayer : NSObject

/**
 加入购物车的动画效果
 
 @param view       显示的View
 @param startPoint 动画起点
 @param endPoint   动画终点
 @param completion 动画执行完成后的回调
 */
+ (void)addCartAnimationWithView:(UIView *)view startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint completion:(void (^)(BOOL finished))completion;
/**
 购物车按钮缩放
 
 @param view       购物车按钮
 @param completion 动画执行完成后的回调
 */
+ (void)addCartViewScale:(UIView *)view;

@end
