//
//  ZSubscribeTabBarView.h
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZSubscribeTabBarView : ZView

///初始化  0试读，订阅 1订阅
-(instancetype)initWithPoint:(CGPoint)point type:(int)type;

/// 试读点击
@property (copy, nonatomic) void(^onProbationClick)();

/// 订阅点击
@property (copy, nonatomic) void(^onSubscribeClick)();

///设置数据
-(void)setViewDataWithModel:(ModelSubscribe *)model;
///设置数据
-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model;
///试读按钮是否隐藏
-(void)setProbationButtonHidden:(BOOL)isHidden;
///获取高度
+(CGFloat)getViewHeight;

@end
