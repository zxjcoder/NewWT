//
//  ZHomeTableView.h
//  PlaneLive
//
//  Created by Daniel on 28/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZHomeTableView : ZView

///刷新顶部事件
@property (copy, nonatomic) void(^onRefreshHeader)();

///广告点击事件
@property (copy, nonatomic) void(^onBannerClick)(ModelBanner *model);

///查看实务事件
@property (copy, nonatomic) void(^onAllPracticeClick)();

///查看问答事件
@property (copy, nonatomic) void(^onAllQuestionClick)();

///问题点击事件
@property (copy, nonatomic) void(^onQuestionClick)(ModelQuestionBoutique *model);;

///查看订阅事件
//@property (copy, nonatomic) void(^onAllSubscribeClick)();

///实务点击事件
@property (copy, nonatomic) void(^onPracticeClick)(NSArray *array, NSInteger row);

///订阅点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelSubscribe *model);

///内容偏移量
@property (copy, nonatomic) void(^onContentOffsetClick)(CGFloat contentOffsetY, CGFloat bannerHeight);

///设置首页数据
-(void)setViewDataWithBannerArray:(NSArray *)arrBanner
                    arrayPractice:(NSArray *)arrayPractice
                      arrQuestion:(NSArray *)arrQuestion
                     arrSubscribe:(NSArray *)arrSubscribe;

-(void)setViewLoading;

-(void)setViewLoadFail;

///从新开始动画
-(void)setAnimateQuestion;

///结束刷新顶部
-(void)endRefreshHeader;

@end
