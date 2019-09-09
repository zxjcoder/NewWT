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

///开始刷新订阅数据
@property (copy, nonatomic) void(^onSubscribeBackgroundClick)();
///开始刷新实务数据
@property (copy, nonatomic) void(^onPracticeBackgroundClick)();

///开始刷新订阅底部数据
@property (copy, nonatomic) void(^onSubscribeRefreshFooter)();

///开始刷新实务底部数据
@property (copy, nonatomic) void(^onPracticeRefreshFooter)();

///实务点击事件
@property (copy, nonatomic) void(^onPracticeClick)(NSArray *array, NSInteger row);
///订阅点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelSubscribe *model);

///设置实务背景状态
-(void)setPracticeBackgroundFail;
///设置订阅背景状态
-(void)setSubscribeBackgroundFail;

///设置订阅数据
-(void)setViewDataSubscribeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;
///设置实务数据
-(void)setViewDataPracticeWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;

///订阅结束底部刷新
-(void)endRefreshSubscribeFooter;
///实务结束底部刷新
-(void)endRefreshPracticeFooter;

///设置View坐标
-(void)setViewFrame:(CGRect)frame;

@end
