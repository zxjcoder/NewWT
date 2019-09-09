//
//  ZTopicQuestionTableView.h
//  PlaneCircle
//
//  Created by Daniel on 9/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZTopicQuestionTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelQuestionTopic *model);
///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelQuestionTopic *model);


@end
