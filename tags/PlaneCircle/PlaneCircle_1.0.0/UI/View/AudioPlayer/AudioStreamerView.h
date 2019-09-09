//
//  AudioStreamerView.h
//  PlaneCircle
//
//  Created by Daniel on 7/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ModelAudio.h"

@interface AudioStreamerView : UIView

///单例模式
+(AudioStreamerView *)shareAudioStreamerView;

/**
 *  播放器数据传入
 *
 *  @param array 传入所有数据model数组
 *  @param index 传入当前model在数组的下标
 */
- (void)setPlayArray:(NSArray *)array index:(NSInteger)index;

/**
 *  暂停
 */
-(void)pause;

/**
 *  开始播放
 */
-(void)play;

/**
 *  显示
 */
-(void)show;

/**
 *  隐藏
 */
-(void)dismiss;

///设置拖动时间节点
- (void)setChangeSliderValue:(NSTimeInterval)value;

///禁止上一个下一个
-(void)setOperButtonEnabled:(BOOL)isEnabled;

///清空内存
-(void)setViewNil;

///远程控制播放器
- (void)setPlayRemoteControlReceivedWithEvent:(UIEvent *)event;

@end
