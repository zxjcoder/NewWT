//
//  ZPracticeDetailNavigationView.h
//  PlaneCircle
//
//  Created by Daniel on 6/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPracticeDetailNavigationView : ZView

///初始化对象
-(id)initWithScrollFrame:(CGRect)frame;
///返回按钮
@property (copy, nonatomic) void(^onBackClick)();
///更多按钮
@property (copy, nonatomic) void(^onMoreClick)();
///标题点击事件
@property (copy, nonatomic) void(^onViewClick)();
///设置标题文本
-(void)setViewTitle:(NSString *)title;
///设置标题背景透明度
-(void)setViewBGAlpha:(CGFloat)alpha;
///是否隐藏更多按钮
-(void)setHiddenMore:(BOOL)isHidden;
///停止标题动画
-(void)setStopScroll;

@end
