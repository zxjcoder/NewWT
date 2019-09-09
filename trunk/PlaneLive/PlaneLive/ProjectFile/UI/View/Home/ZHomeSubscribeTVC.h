//
//  ZHomeSubscribeTVC.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZHomeSubscribeTVC : ZBaseTVC

///查看全部点击事件
@property (copy, nonatomic) void(^onAllSubscribeClick)();
///订阅点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelSubscribe *model);
///描述文本点击事件
@property (copy, nonatomic) void(^onDescClick)();
///设置数据源
-(void)setViewDataWithArray:(NSArray*)array;

@end
