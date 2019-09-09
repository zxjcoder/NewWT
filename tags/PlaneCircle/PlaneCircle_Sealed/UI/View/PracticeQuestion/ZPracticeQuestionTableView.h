//
//  ZPracticeQuestionTableView.h
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPracticeQuestionTableView : ZView

///开始刷新顶部数据
@property (copy, nonatomic) void(^onRefreshHeader)();
///开始刷新底部数据
@property (copy, nonatomic) void(^onRefreshFooter)();

///文本
@property (copy, nonatomic) void(^onTextClick)();
///PPT
@property (copy, nonatomic) void(^onPPTClick)();
///收藏
@property (copy, nonatomic) void(^onCollectionClick)();
///点赞
@property (copy, nonatomic) void(^onPraiseClick)();
///查看热门全部
@property (copy, nonatomic) void(^onHotAllClick)();
///偏移量
@property (copy, nonatomic) void(^onOffsetChange)(CGFloat y);

///问题详情
@property (copy, nonatomic) void(^onQuestionRowClick)(ModelPracticeQuestion *model);
///答案详情
@property (copy, nonatomic) void(^onAnswerRowClick)(ModelPracticeQuestion *model);
///用户详情
//@property (copy, nonatomic) void(^onUserInfoClick)(ModelUserBase *model);

///设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model;

///设置最新问题数据源
-(void)setViewNewDataWithModel:(ModelPracticeQuestion *)model;

///结束顶部刷新
-(void)endRefreshHeader;
///结束底部刷新
-(void)endRefreshFooter;

///设置热门数据源
//-(void)setViewHotDataWithDictionary:(NSDictionary *)dicResult;
///设置最新数据源
//-(void)setViewNewDataWithDictionary:(NSDictionary *)dicResult;

///设置热门数据源
///设置热门数据源
-(void)setViewHotDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader pageSizeHot:(int)pageSizeHot questionCount:(NSInteger)questionCount;
///设置最新数据源
-(void)setViewNewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader questionCount:(NSInteger)questionCount;

@end
