//
//  ZBackgroundView.h
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBackgroundView : UIView

///功能按钮点击事件
@property (copy, nonatomic) void(^onButtonClick)();

///设置背景显示
-(void)setViewStateWithState:(ZBackgroundState)state;

@end
