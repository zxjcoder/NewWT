//
//  ZNewHomeLawView.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

/// 律所
@interface ZNewHomeLawView : ZView

///律所点击
@property (copy, nonatomic) void(^onLawFirmClick)(ModelLawFirm *model);
///更多点击
@property (copy, nonatomic) void(^onMoreClick)();

-(CGFloat)setViewData:(NSArray *)array;

@end
