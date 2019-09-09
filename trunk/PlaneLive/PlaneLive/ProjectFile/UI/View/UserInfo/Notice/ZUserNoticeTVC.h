//
//  ZUserNoticeTVC.h
//  PlaneCircle
//
//  Created by Daniel on 7/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZUserNoticeTVC : ZBaseTVC

@property (copy, nonatomic) void(^onCourseEvent)(ModelNoticeCourse *model);

/// 设置是否播放状态
-(void)setAudioPlayStatus:(BOOL)isPlay;

@end
