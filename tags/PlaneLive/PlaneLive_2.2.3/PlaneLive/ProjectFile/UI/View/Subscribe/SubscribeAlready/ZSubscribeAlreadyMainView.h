//
//  ZSubscribeAlreadyMainView.h
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

///已订阅详情View
@interface ZSubscribeAlreadyMainView : ZView

///偏移量
@property (copy, nonatomic) void(^onContentOffsetY)(CGFloat alpha);

///工具栏显示
@property (copy, nonatomic) void(^onShowToolOffsetY)(CGFloat offsetY, CGFloat toolViewY);

///每期看点击
@property (copy, nonatomic) void(^onEachWatchClick)(ModelCurriculum *model);

///连续播点击
@property (copy, nonatomic) void(^onContinuousSowingClick)(NSArray *array, NSInteger row);

///开始刷新连续播顶部数据
@property (copy, nonatomic) void(^onRefreshContinuousSowingHeader)();
///开始刷新连续播底部数据
@property (copy, nonatomic) void(^onRefreshContinuousSowingFooter)();
///连续播背景点击
@property (copy, nonatomic) void(^onContinuousSowingBackgroundClick)(ZBackgroundState state);
///开始刷新每期看顶部数据
@property (copy, nonatomic) void(^onRefreshEachWatchHeader)();
///开始刷新每期看底部数据
@property (copy, nonatomic) void(^onRefreshEachWatchFooter)();
///每期看背景点击
@property (copy, nonatomic) void(^onEachWatcBackgroundClick)(ZBackgroundState state);

/// 设置数据源
-(void)setViewDataWithModel:(ModelCurriculum *)model;
/// 设置数据源
-(void)setViewDataWithSubscribeModel:(ModelSubscribeDetail *)model;

///设置每期看数据源
-(void)setViewDataWithEachWatchArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;

///设置连续播数据源
-(void)setViewDataWithContinuousSowingArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;

///设置每期看背景
-(void)setEachWatchBackgroundViewWithState:(ZBackgroundState)state;
///设置连续播背景
-(void)setContinuousSowingBackgroundViewWithState:(ZBackgroundState)state;

///获取分页数量
-(int)getPageNum;

@end
