//
//  ZQuestionAnswerTableView.h
//  PlaneLive
//
//  Created by Daniel on 03/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZQuestionAnswerTableView : ZBaseTableView

///问题区域
@property (copy, nonatomic) void(^onPhotoClick)(ModelUserBase *model);

///问题区域
@property (copy, nonatomic) void(^onQuestionClick)(ModelQuestionItem *model);

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

@end
