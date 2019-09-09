//
//  ZNewHomeFreeView.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

/// 免费专区
@interface ZNewHomeFreeView : ZView

///实务点击
@property (copy, nonatomic) void(^onPracticeClick)(NSArray *array, NSInteger row);
///更多点击
@property (copy, nonatomic) void(^onMoreClick)();

-(CGFloat)setViewData:(NSArray *)array;
-(void)setPlayObject:(ModelTrack *)model isPlaying:(BOOL)isPlaying;

@end
