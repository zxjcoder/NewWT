//
//  ZHomePracticeTVC.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBaseTVC.h"

#define kZHomePracticeTVCTitleHeight 50
#define kZHomePracticeTVCHeight (APP_FRAME_WIDTH/3+kZHomePracticeTVCTitleHeight)*2+17

@interface ZHomePracticeTVC : ZBaseTVC

///查看全部点击事件
@property (copy, nonatomic) void(^onAllClick)();

///微课点击事件
@property (copy, nonatomic) void(^onPracticeClick)(NSArray *array, NSInteger row);

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array;

@end
