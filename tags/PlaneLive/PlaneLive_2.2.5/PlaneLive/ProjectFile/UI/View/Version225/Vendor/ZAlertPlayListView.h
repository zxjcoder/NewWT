//
//  ZAlertPlayListView.h
//  PlaneLive
//
//  Created by Daniel on 27/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZAlertPlayListView : ZView

///播放列表点击
@property (copy, nonatomic) void(^onPlayItemClick)(ModelTrack *model, NSInteger row);

///初始化
-(instancetype)initWithPlayListArray:(NSArray *)playListArray index:(NSInteger)index;

///设置数据源
-(void)setPlayListArray:(NSArray *)playListArray index:(NSInteger)index;

///改变播放列表
-(void)setChangePlayIndex:(NSInteger)index;
///设置是否播放中
-(void)setPlayStatus:(BOOL)isPlaying;

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
