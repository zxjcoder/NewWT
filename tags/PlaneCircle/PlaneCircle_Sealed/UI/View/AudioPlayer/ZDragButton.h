//
//  ZDragButton.h
//  PlaneCircle
//
//  Created by Daniel on 8/9/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButton.h"
#import "ModelEntity.h"

@interface ZDragButton : ZButton

///单例模式
+(ZDragButton *)shareDragButton;

///点击事件回调
@property (nonatomic, copy) void(^tapClickBlock)();

///是否拖动中
- (BOOL)isDragging;

///设置播放的语音集合
-(void)setPlayArray:(NSArray *)arr rowIndex:(NSInteger)rowIndex;
///获取播放的语音集合
-(NSArray *)getPlayArray;
///获取当前播放索引
-(NSInteger)getPlayRowIndex;

///设置是否能显示
-(void)setIsCanShow:(BOOL)isShow;
///获取是否能显示
-(BOOL)getIsCanShow;

///显示
-(void)show;

///隐藏
-(void)dismiss;

@end
