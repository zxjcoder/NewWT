//
//  ZTopicTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZTopicTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelQuestionTopic *model);
///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelQuestionTopic *model);
///关注话题
@property (copy, nonatomic) void(^onAttentionClick)(ModelTag *model);

-(void)setViewDataWithModel:(ModelTag *)model;

@end
