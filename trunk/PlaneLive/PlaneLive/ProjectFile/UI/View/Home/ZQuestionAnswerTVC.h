//
//  ZQuestionAnswerTVC.h
//  PlaneLive
//
//  Created by Daniel on 03/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZQuestionAnswerTVC : ZBaseTVC

///问题区域
@property (copy, nonatomic) void(^onPhotoClick)(ModelUserBase *model);

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

@end
