//
//  ZQuestionPromptView.h
//  PlaneCircle
//
//  Created by Daniel on 8/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZQuestionPromptView : ZView

///知道了点击
@property (copy, nonatomic) void(^onButtonClick)();

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
