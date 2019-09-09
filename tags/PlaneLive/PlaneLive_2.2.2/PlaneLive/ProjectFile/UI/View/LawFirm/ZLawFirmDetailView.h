//
//  ZLawFirmDetailView.h
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZLawFirmDetailView : ZView

///视图高度发生改变
@property (copy, nonatomic) void(^onViewHeightChange)(CGFloat viewH);

-(void)setViewDataWithLawFirm:(ModelLawFirm *)model;

@end
