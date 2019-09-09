//
//  ZNewHomeView.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZNewHomeView : UIView

///刷新顶部事件
@property (copy, nonatomic) void(^onRefreshHeader)();
///工具栏子项点击事件
//@property (copy, nonatomic) void(^onToolItemClick)(NSInteger index);
///广告点击事件
@property (copy, nonatomic) void(^onBannerClick)(ModelBanner *model);
///去设置无网络
@property (copy, nonatomic) void(^onGoNoNetworkClick)();
///什么是订阅点击事件
@property (copy, nonatomic) void(^onWhatSubscribeClick)();
///什么是系列课点击事件
@property (copy, nonatomic) void(^onWhatCurriculumClick)();
///查看律所事件
@property (copy, nonatomic) void(^onAllLawFirmClick)();
///律所点击事件
@property (copy, nonatomic) void(^onLawFirmClick)(ModelLawFirm *model);
///查看微课事件
@property (copy, nonatomic) void(^onAllPracticeClick)();
///查看免费专区事件
@property (copy, nonatomic) void(^onAllFreeClick)();
///免费专区事件
@property (copy, nonatomic) void(^onFreeItemClick)(NSArray *array, NSInteger row);
///查看问答事件
//@property (copy, nonatomic) void(^onAllQuestionClick)();
///问题点击事件
//@property (copy, nonatomic) void(^onQuestionClick)(ModelQuestionBoutique *model);;
///查看订阅事件
@property (copy, nonatomic) void(^onAllSubscribeClick)();
///查看课程事件
@property (copy, nonatomic) void(^onAllCurriculumClick)();
///系列课点击事件
@property (copy, nonatomic) void(^onCurriculumClick)(ModelSubscribe *model);
///微课点击事件
@property (copy, nonatomic) void(^onPracticeClick)(NSArray *array, NSInteger row);
///订阅点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelSubscribe *model);
///内容偏移量
@property (copy, nonatomic) void(^onContentOffsetClick)(CGFloat contentOffsetY, CGFloat bannerHeight);

///设置首页数据
-(void)setViewData:(NSDictionary *)dicData;
///重置广告位置-放置轮播一半的情况
-(void)adjustWhenControllerViewWillAppera;
///刷新顶部数据
-(void)endRefreshHeader;
///设置播放对象
-(void)setPlayObject:(ModelTrack *)model isPlaying:(BOOL)isPlaying;
/// 设置显示无网络区域
-(void)setShowNoNetwork:(BOOL)show;

@end
