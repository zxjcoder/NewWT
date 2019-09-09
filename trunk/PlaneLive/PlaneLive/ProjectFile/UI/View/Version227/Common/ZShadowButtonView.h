//
//  ZShadowButtonView.h
//  PlaneLive
//
//  Created by WT on 20/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 按下去可以缩放的按钮 & 有投影的按钮
@interface ZShadowButtonView : UIView

@property (copy, nonatomic) void(^onButtonClick)();

-(void)setButtonBGImage:(NSString *)imageName;
-(void)setButtonTitle:(NSString *)title;

@end
