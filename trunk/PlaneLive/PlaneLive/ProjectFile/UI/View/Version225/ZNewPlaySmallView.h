//
//  ZNewPlaySmallView.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

/// 最新的底部播放器
@interface ZNewPlaySmallView : UIView

-(id)initWithPoint:(CGRect)point;
+(ZNewPlaySmallView *)sharedSingleton;

-(void)setViewPlayStatus:(BOOL)isPlaying;
-(void)setViewDataWithPModel:(ModelPractice *)model;
-(void)setViewDataWithSModel:(ModelSubscribe *)model;

@end
