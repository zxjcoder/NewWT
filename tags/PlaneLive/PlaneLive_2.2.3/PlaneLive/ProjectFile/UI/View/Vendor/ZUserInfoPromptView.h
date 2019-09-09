//
//  ZUserInfoPromptView.h
//  PlaneCircle
//
//  Created by Daniel on 7/22/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZUserInfoPromptView : ZView

///确定点击
@property (copy, nonatomic) void(^onSubmitClick)();
///取消点击
@property (copy, nonatomic) void(^onCancelClick)();

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
