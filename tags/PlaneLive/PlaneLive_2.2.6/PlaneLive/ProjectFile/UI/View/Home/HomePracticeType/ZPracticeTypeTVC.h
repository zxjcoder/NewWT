//
//  ZPracticeTypeTVC.h
//  PlaneLive
//
//  Created by Daniel on 02/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"
#import "ZHomeItemNavView.h"

#define kPracticeTVCTitleHeight 40
#define kPracticeTVCHeight (APP_FRAME_WIDTH/3+kPracticeTVCTitleHeight)+kZHomeItemNavViewHeight

@interface ZPracticeTypeTVC : ZBaseTVC

///查看全部点击事件
@property (copy, nonatomic) void(^onAllClick)(ModelPracticeType *model);

///微课点击事件
@property (copy, nonatomic) void(^onPracticeClick)(NSArray *array, NSInteger row);

@end
