//
//  ZTopicTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZTopicTableView : ZBaseTableView

///头像区域点击
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);
///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelQuestionBase *model);
///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);
///关注话题
@property (copy, nonatomic) void(^onAttentionClick)(ModelTag *model);

-(void)setViewDataWithModel:(ModelTag *)model;

@end
