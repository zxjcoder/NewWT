//
//  ZTopicTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleTableView.h"

@interface ZTopicTableView : ZCircleTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelQuestionTopic *model);

///关注话题
@property (copy, nonatomic) void(^onAttentionClick)(ModelTag *model);

-(void)setViewDataWithModel:(ModelTag *)model;

@end
