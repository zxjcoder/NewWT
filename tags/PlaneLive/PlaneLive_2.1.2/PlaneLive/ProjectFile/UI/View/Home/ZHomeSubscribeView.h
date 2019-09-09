//
//  ZHomeSubscribeView.h
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZHomeSubscribeView : ZView

///查看全部点击事件
//@property (copy, nonatomic) void(^onAllClick)();
///订阅点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelSubscribe *model);

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array;

///获取高度
-(CGFloat)getViewHeight;

@end
