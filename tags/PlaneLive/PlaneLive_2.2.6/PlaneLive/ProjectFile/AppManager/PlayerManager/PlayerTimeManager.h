//
//  PlayerTimeManager.h
//  PlaneLive
//
//  Created by Daniel on 19/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerTimeManager : NSObject

/// 单例模式
+ (PlayerTimeManager *)shared;

/// 设置播放进度
-(void)setPlayTimeWithId:(NSInteger)ids playTime:(NSUInteger)playTime percent:(CGFloat)percent;
/// 设置归零
-(void)setPlayTimeWithId:(NSInteger)ids;

/// 获取播放时间
-(NSUInteger)getPlayTimeWithId:(NSInteger)ids;
/// 获取播放百分比
-(CGFloat)getPercentWithId:(NSInteger)ids;

-(void)save;

@end
