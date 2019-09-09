//
//  ZMyCollectionView.h
//  PlaneCircle
//
//  Created by Daniel on 7/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZMyCollectionView : ZView

///实务顶部刷新
@property (copy, nonatomic) void(^onRefreshPracticeHeader)();
///答案顶部刷新
@property (copy, nonatomic) void(^onRefreshAnswerHeader)();
///订阅顶部刷新
@property (copy, nonatomic) void(^onRefreshSubscribeHeader)();

///实务刷新
@property (copy, nonatomic) void(^onBackgroundPracticeClick)(ZBackgroundState state);
///答案刷新
@property (copy, nonatomic) void(^onBackgroundAnswerClick)(ZBackgroundState state);
///订阅刷新
@property (copy, nonatomic) void(^onBackgroundSubscribeClick)(ZBackgroundState state);

///实务底部刷新
@property (copy, nonatomic) void(^onRefreshPracticeFooter)();
///答案底部刷新
@property (copy, nonatomic) void(^onRefreshAnswerFooter)();
///订阅底部刷新
@property (copy, nonatomic) void(^onRefreshSubscribeFooter)();

///实务设置分页数量
@property (copy, nonatomic) void(^onPageNumChangePractice)();
///答案设置分页数量
@property (copy, nonatomic) void(^onPageNumChangeAnswer)();
///订阅设置分页数量
@property (copy, nonatomic) void(^onPageNumChangeSubscribe)();

///实务选中
@property (copy, nonatomic) void(^onPracticeRowClick)(ModelCollection *model);
///答案选中
@property (copy, nonatomic) void(^onAnswerRowClick)(ModelCollectionAnswer *model);
///答案->问题选中
@property (copy, nonatomic) void(^onQuestionRowClick)(ModelCollectionAnswer *model);
///订阅被选中
@property (copy, nonatomic) void(^onSubscribeRowClick)(ModelCollection *model);

///删除实务按钮点击
@property (copy, nonatomic) void(^onDeletePracticeClick)(ModelCollection *model);
///删除答案按钮点击
@property (copy, nonatomic) void(^onDeleteAnswerClick)(ModelCollectionAnswer *model);
///删除订阅按钮点击
@property (copy, nonatomic) void(^onDeleteSubscribeClick)(ModelCollection *model);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

///设置实务背景状态
-(void)setPracticeBackgroundViewWithState:(ZBackgroundState)backState;
///设置答案背景状态
-(void)setAnswerBackgroundViewWithState:(ZBackgroundState)backState;
///设置订阅背景状态
-(void)setSubscribeBackgroundViewWithState:(ZBackgroundState)backState;

///设置实务
-(void)setViewPracticeWithDictionary:(NSDictionary *)dic;
///设置答案
-(void)setViewAnswerWithDictionary:(NSDictionary *)dic;
///设置订阅
-(void)setViewSubscribeWithDictionary:(NSDictionary *)dic;

///结束实务顶部刷新
-(void)endRefreshPracticeHeader;
///结束实务底部刷新
-(void)endRefreshPracticeFooter;
///结束答案顶部刷新
-(void)endRefreshAnswerHeader;
///结束答案底部刷新
-(void)endRefreshAnswerFooter;
///结束订阅顶部刷新
-(void)endRefreshSubscribeHeader;
///结束订阅底部刷新
-(void)endRefreshSubscribeFooter;

@end
