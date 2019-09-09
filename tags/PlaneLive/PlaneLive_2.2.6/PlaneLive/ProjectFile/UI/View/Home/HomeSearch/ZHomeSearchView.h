//
//  ZHomeSearchView.h
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZHomeSearchView : ZView

///偏移量改变
@property (copy, nonatomic) void(^onContentOffsetChange)(CGFloat contentOffsetY);

///开始刷新系列课数据
@property (copy, nonatomic) void(^onSeriesCourseBackgroundClick)();
///开始刷新订阅数据
@property (copy, nonatomic) void(^onSubscribeBackgroundClick)();
///开始刷新微课数据
@property (copy, nonatomic) void(^onPracticeBackgroundClick)();

///开始刷新系列课底部数据
@property (copy, nonatomic) void(^onSeriesCourseRefreshFooter)();
///开始刷新订阅底部数据
@property (copy, nonatomic) void(^onSubscribeRefreshFooter)();
///开始刷新微课底部数据
@property (copy, nonatomic) void(^onPracticeRefreshFooter)();


///微课点击事件
@property (copy, nonatomic) void(^onPracticeClick)(NSArray *array, NSInteger row);
///订阅点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelSubscribe *model);
///系列课点击事件
@property (copy, nonatomic) void(^onSeriesCourseClick)(ModelSubscribe *model);

///设置微课加载中
-(void)setPracticeBackgroundLoading;
///设置系列课加载中
-(void)setSeriesCourseBackgroundLoading;
///设置订阅加载中
-(void)setSubscribeBackgroundLoading;

///设置微课背景状态
-(void)setPracticeBackgroundFail;
///设置系列课背景状态
-(void)setSeriesCourseBackgroundFail;
///设置订阅背景状态
-(void)setSubscribeBackgroundFail;

///设置系列课数据
-(void)setViewDataSeriesCourseWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;
///设置订阅数据
-(void)setViewDataSubscribeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;
///设置微课数据
-(void)setViewDataPracticeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;

///系列课结束底部刷新
-(void)endRefreshSeriesCourseFooter;
///订阅结束底部刷新
-(void)endRefreshSubscribeFooter;
///微课结束底部刷新
-(void)endRefreshPracticeFooter;

///设置View坐标
-(void)setViewFrame:(CGRect)frame;

@end
