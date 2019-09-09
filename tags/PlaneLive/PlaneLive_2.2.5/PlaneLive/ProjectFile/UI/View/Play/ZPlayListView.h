//
//  ZPlayListView.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"
#import "ModelTrack.h"

@interface ZPlayListView : ZView

///播放列表点击
@property (copy, nonatomic) void(^onPlayItemClick)(ModelTrack *model, NSInteger row);

///初始化
-(instancetype)initWithPlayListArray:(NSArray *)playListArray index:(NSInteger)index;

///设置数据源
-(void)setPlayListArray:(NSArray *)playListArray index:(NSInteger)index;

///改变播放列表
-(void)setChangePlayIndex:(NSInteger)index;

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
