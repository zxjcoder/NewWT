//
//  ZPlaySuccessView.h
//  PlaneLive
//
//  Created by Daniel on 25/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPlaySuccessView : ZView

///初始化 0,只有一个按钮 1,两个按钮
-(instancetype)initWithType:(int)type;

///返回订阅点击
@property (copy, nonatomic) void(^onSubmitClick)();

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
