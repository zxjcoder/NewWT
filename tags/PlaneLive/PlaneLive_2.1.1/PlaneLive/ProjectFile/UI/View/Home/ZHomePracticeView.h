//
//  ZHomePracticeView.h
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

#define kHomePracticeViewTitleHeight 50
#define kHomePracticeViewHeight (APP_FRAME_WIDTH/3+kHomePracticeViewTitleHeight)*2+17

@interface ZHomePracticeView : ZView

///查看全部点击事件
@property (copy, nonatomic) void(^onAllClick)();

///实务点击事件
@property (copy, nonatomic) void(^onPracticeClick)(NSArray *array, NSInteger row);

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array;

///获取高度
+(CGFloat)getViewHeight;

@end
