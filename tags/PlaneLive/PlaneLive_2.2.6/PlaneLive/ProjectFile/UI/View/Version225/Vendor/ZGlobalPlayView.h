//
//  ZGlobalPlayView.h
//  PlaneLive
//
//  Created by Daniel on 27/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

/// 全局播放器
@interface ZGlobalPlayView : ZView

///视图点击事件
@property (copy, nonatomic) void(^onPlayViewClick)(ModelTrack *model, NSInteger row);
///播放状态点击事件
@property (copy, nonatomic) void(^onPlayStatusClick)(BOOL isPlay);
///关闭点击事件
@property (copy, nonatomic) void(^onCloseClick)();

///设置播放状态
-(void)setPlayStatus:(BOOL)isPlaying;
///设置播放对象
-(void)setViewData:(ModelTrack*)model row:(NSInteger)row;
///显示
-(void)show;
///隐藏
-(void)dismiss;
///获取高度
+(CGFloat)getH;


@end
