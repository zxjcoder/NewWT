//
//  ZLoadingBGView.h
//  PlaneCircle
//
//  Created by Daniel on 8/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,ZLoadingBGViewType){
    /**
     *  线性动画
     */
    ZLoadingBGViewTypeSingleLine = 0,
    
    /**
     *  方形点动画
     */
    ZLoadingBGViewTypeSquare = 1,
    
    /**
     *  三角形运动动画
     */
    ZLoadingBGViewTypeTriangleTranslate = 2,
    
    /**
     *  原型视图裁剪动画
     */
    ZLoadingBGViewTypeClip
};

@interface ZLoadingBGView : UIView

/*        显示加载动画 并添加到父视图上         */
+ (void)showLoadingOnView:(UIView *)superView Type:(ZLoadingBGViewType)type;

/*        显示动画 并添加在主窗口上         */
+ (void)showLoadingOnTheKeyWindowWithType:(ZLoadingBGViewType)type;

/*        停止动画         */
+ (void)hideLoading;

/*        设置动画背景色（全屏背景色）         */
+ (void)backgroudColor:(UIColor *)color;

/*        设置中心视图的动画背景颜色 默认透明色         */
+ (void)centerBGViewBackgroudColor:(UIColor *)color;

@end
