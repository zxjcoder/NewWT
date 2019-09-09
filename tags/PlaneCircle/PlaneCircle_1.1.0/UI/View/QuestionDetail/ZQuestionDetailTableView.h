//
//  ZQuestionDetailTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTableView.h"

@interface ZQuestionDetailTableView : ZTableView

///选中答案行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelAnswerBase *model, NSInteger row);
///话题选中事件
@property (copy, nonatomic) void(^onTopicSelected)(ModelTag *model);
///邀请回答
@property (copy, nonatomic) void(^onInvitationClick)(ModelQuestionDetail *model);
///添加答案
@property (copy, nonatomic) void(^onAddAnswerClick)(ModelQuestionDetail *model);
///关注问题
@property (copy, nonatomic) void(^onAttentionClick)(ModelQuestionDetail *model);
///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);

///设置数据源
-(void)setViewDataWithDictionary:(NSDictionary *)dicResult;
///设置数据源
-(void)setViewDataWithModel:(ModelQuestionDetail *)model;
///添加回答数据
-(void)addViewDataWithAnswerId:(NSString *)answerId;
///删除指定行
-(void)setDeleteRowWithRow:(NSInteger )row;

@end
