//
//  ZUserInfoQuestionTVC.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserInfoQuestionTVC : ZBaseTVC

///我的问题
@property (copy, nonatomic) void(^onQuestionClick)();
///我的粉丝
@property (copy, nonatomic) void(^onFansClick)();
///待我回答
@property (copy, nonatomic) void(^onAnswerClick)();

@end
