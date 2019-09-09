//
//  ZTopicDetailView.h
//  PlaneCircle
//
//  Created by Daniel on 9/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZTopicDetailView : ZView

///问题区域点击
@property (copy, nonatomic) void(^onQuestionClick)(ModelQuestionBase *model);
///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);
///头像点击事件
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);
///实务区域点击
@property (copy, nonatomic) void(^onPracticeClick)(NSArray *arrPractice, NSInteger rowIndex);
///关注话题
@property (copy, nonatomic) void(^onAttentionClick)(ModelTag *model);

///开始刷新问题数据
@property (copy, nonatomic) void(^onQuestionBackgroundClick)();
///开始刷新实务数据
@property (copy, nonatomic) void(^onPracticeBackgroundClick)();

///开始刷新问题顶部数据
@property (copy, nonatomic) void(^onQuestionRefreshHeader)();
///开始刷新问题底部数据
@property (copy, nonatomic) void(^onQuestionRefreshFooter)();

///开始刷新实务顶部数据
@property (copy, nonatomic) void(^onPracticeRefreshHeader)();
///开始刷新实务底部数据
@property (copy, nonatomic) void(^onPracticeRefreshFooter)();

///设置问题背景
-(void)setQuestionBackgroundViewWithState:(ZBackgroundState)state;
///设置实务背景
-(void)setPracticeBackgroundViewWithState:(ZBackgroundState)state;

///设置问题数据
-(void)setViewDataQuestionWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;
///设置实务数据
-(void)setViewDataPracticeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;
///设置话题对象
-(void)setViewDataWithModel:(ModelTag *)model;

///获取实务数据集合
-(NSArray *)getPracticeArray;

///问题结束顶部刷新
-(void)endRefreshQuestionHeader;
///问题结束底部刷新
-(void)endRefreshQuestionFooter;
///实务结束顶部刷新
-(void)endRefreshPracticeHeader;
///实务结束底部刷新
-(void)endRefreshPracticeFooter;

@end
