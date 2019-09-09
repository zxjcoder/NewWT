//
//  ZPlayMainView.m
//  PlaneLive
//
//  Created by WT on 14/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZPlayMainView.h"
#import "ZPlayBottomTabView.h"
#import "ZPlayInfoView.h"
#import "ZPlayNavigationView.h"

@interface ZPlayMainView()

@property (strong, nonatomic) ZPlayNavigationView *viewNav;
@property (strong, nonatomic) ZPlayInfoView *viewInfo;
@property (strong, nonatomic) ZPlayBottomTabView *viewTab;

@end

@implementation ZPlayMainView

/// 初始化
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit:ZPlayTabBarViewTypePractice];
    }
    return self;
}
-(void)innerInit:(ZPlayTabBarViewType)type
{
    [self setBackgroundColor:COLORVIEWBACKCOLOR2];
    
    self.viewNav = [[ZPlayNavigationView alloc] initWithFrame:(CGRectMake(0, APP_STATUS_HEIGHT, self.width, [ZPlayNavigationView getH]))];
    [self addSubview:self.viewNav];
    
    self.viewTab = [[ZPlayBottomTabView alloc] initWithFrame:(CGRectMake(0, self.height-[ZPlayBottomTabView getH], self.width, [ZPlayBottomTabView getH])) type:type];
    [self addSubview:self.viewTab];
    
    CGFloat infoY = self.viewNav.y+self.viewNav.height;
    CGFloat infoH = self.height-infoY-[ZPlayBottomTabView getH];
    self.viewInfo = [[ZPlayInfoView alloc] initWithFrame:(CGRectMake(0, infoY, self.width, infoH))];
    [self addSubview:self.viewInfo];
    
    [self innerEvent];
}
/// 设置类型
-(void)setTabType:(ZPlayTabBarViewType)type
{
    [self.viewTab setViewTabType:type];
    [self.viewInfo setViewTabType:type];
}
-(void)innerEvent
{
    ZWEAKSELF
    [self.viewNav setOnCloseViewEvent:^{
        [weakSelf dismiss];
    }];
    [self.viewNav setOnShareViewEvent:^{
        if (weakSelf.onShareViewEvent) {
            weakSelf.onShareViewEvent();
        }
    }];
    [self.viewInfo setOnDetailClick:^{
        if (weakSelf.onDetailClick) {
            weakSelf.onDetailClick();
        }
    }];
    [self.viewInfo setOnMailClick:^{
        if (weakSelf.onMailClick) {
            weakSelf.onMailClick();
        }
    }];
    [self.viewInfo setOnPPTClick:^{
        if (weakSelf.onPPTClick) {
            weakSelf.onPPTClick();
        }
    }];
    [self.viewInfo setOnRateChange:^(float rate) {
        if (weakSelf.onRateChange) {
            weakSelf.onRateChange(rate);
        }
    }];
    [self.viewInfo setOnPreClick:^{
        if (weakSelf.onPreClick) {
            weakSelf.onPreClick();
        }
    }];
    [self.viewInfo setOnNextClick:^{
        if (weakSelf.onNextClick) {
            weakSelf.onNextClick();
        }
    }];
    [self.viewInfo setOnPlayClick:^(BOOL isPlay) {
        if (weakSelf.onPlayClick) {
            weakSelf.onPlayClick(isPlay);
        }
    }];
    [self.viewInfo setOnListClick:^{
        if (weakSelf.onListClick) {
            weakSelf.onListClick();
        }
    }];
    [self.viewInfo setOnSliderValueChange:^(CGFloat sliderValue) {
        if (weakSelf.onSliderValueChange) {
            weakSelf.onSliderValueChange(sliderValue);
        }
    }];
    [self.viewTab setOnCollectionEvent:^(ZPlayTabBarViewType type, BOOL isCollection, NSString *ids) {
        if (weakSelf.onCollectionEvent) {
            weakSelf.onCollectionEvent(type, isCollection, ids);
        }
    }];
    [self.viewTab setOnDownloadEvent:^(ZDownloadStatus status){
        if (weakSelf.onDownloadClick) {
            weakSelf.onDownloadClick(status);
        }
    }];
    [self.viewTab setOnCoursewareEvent:^{
        if (weakSelf.onCoursewareEvent) {
            weakSelf.onCoursewareEvent();
        }
    }];
    [self.viewTab setOnMessageEvent:^{
        if (weakSelf.onMessageEvent) {
            weakSelf.onMessageEvent();
        }
    }];
    [self.viewTab setOnRewardEvent:^(ZPlayTabBarViewType type){
        if (weakSelf.onRewardEvent) {
            weakSelf.onRewardEvent(type);
        }
    }];
}
/// 设置微课数据
-(void)setViewDataWithPracitce:(ModelPractice *)model
{
    [self.viewInfo setViewDataWithPracitce:model];
    [self.viewTab setViewDataWithModel:model];
}
/// 设置订阅数据
-(void)setViewDataWithSubscribe:(ModelCurriculum *)model
{
    [self.viewInfo setViewDataWithSubscribe:model];
    [self.viewTab setViewDataWithModelCurriculum:model];
}
/// 设置微课数据
-(void)setTabViewDataWithPracitce:(ModelPractice *)model
{
    [self.viewTab setViewDataWithModel:model];
}
/// 设置订阅数据
-(void)setTabViewDataWithSubscribe:(ModelCurriculum *)model
{
    [self.viewTab setViewDataWithModelCurriculum:model];
}
/// 设置当前索引
-(void)setPageChange:(NSInteger)index total:(NSInteger)total
{
    [self.viewNav setPageChange:index total:total];
}
/// 设置按钮是否可点
-(void)setOperEnabled:(BOOL)isEnabled
{
    [self.viewInfo setOperEnabled:isEnabled];
}
/// 设置缓冲进度
-(void)setViewCacheProgress:(CGFloat)progress
{
    [self.viewInfo setViewCacheProgress:progress];
}
/// 设置播放时间
-(void)setViewCurrentTime:(NSUInteger)currentTime percent:(CGFloat)percent
{
    [self.viewInfo setViewCurrentTime:currentTime percent:percent];
}
/// 设置最大播放时间
-(void)setMaxDuratuin:(NSUInteger)duration
{
    [self.viewInfo setTotalDuration:duration];
}
/// 获取当前倍率播放
-(CGFloat)getRate
{
    return [self.viewInfo getRate];
}
/// 状态是否播放中
-(BOOL)isPlaying
{
    return [self.viewInfo isPlaying];
}
/// 停止播放
-(void)setStopPlay
{
    [self.viewInfo setStopPlay];
}
/// 开始播放
-(void)setStartPlay
{
    [self.viewInfo setStartPlay];
}
/// 暂停播放
-(void)setPausePlay
{
    [self.viewInfo setPausePlay];
}
/// 设置播放按钮状态
-(void)setDownloadButtonImageNoSuspend:(ZDownloadStatus)status
{
    [self.viewTab setDownloadStatus:status];
}
-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.frame = CGRectMake(0, APP_FRAME_HEIGHT, self.width, self.height);
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        self.frame = CGRectMake(0, 0, self.width, self.height);
    }];
}
-(void)dismiss
{
    [self.viewInfo setOperEnabled:false];
    [self.viewTab setOperEnabled:false];
    [self.viewNav setOperEnabled:false];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        self.frame = CGRectMake(0, APP_FRAME_HEIGHT, self.width, self.height);
    } completion:^(BOOL finished) {
        if (self.onCloseViewEvent) {
            self.onCloseViewEvent(self);
        }
    }];
}

@end
