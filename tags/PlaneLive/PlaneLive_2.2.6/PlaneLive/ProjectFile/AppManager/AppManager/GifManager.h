//
//  GifManager.h
//  PlaneLive
//
//  Created by Daniel on 10/05/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GifManager : NSObject

/// 刷新中的GIF
+ (NSArray *)getRefreshImagesGif;

/// 播放中的GIF
//+ (NSArray *)getPlayingImagesGif;

/// 播放中的GIF
//+ (UIImage *)getPlayingImageGif;

/// 播放动画时间
//+ (NSTimeInterval)getPlayingDuration;

/// 刷新动画时间
+ (NSTimeInterval)getRefreshDuration;

/// 清除内存
+ (void)cancelMemory;

@end
