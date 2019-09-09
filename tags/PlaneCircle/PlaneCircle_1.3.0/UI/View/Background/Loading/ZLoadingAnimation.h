//
//  ZLoadingAnimation.h
//  PlaneCircle
//
//  Created by Daniel on 8/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ZLoadingAnimation : NSObject

/*        缩小动画 无自动恢复效果         */
+ (CABasicAnimation *)animationForScaleSmall;

/*        缩小动画 自动恢复效果         */
+ (CABasicAnimation *)animationForScaleAutoreverses;

/*        透明度动画         */
+ (CABasicAnimation *)animationForAlpha;

/*        旋转动画         */
+ (CABasicAnimation *)rotateAnimation;

@end
