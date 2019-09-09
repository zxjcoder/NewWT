//
//  ZLawFirmDetailTVC.h
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZLawFirmDetailTVC : ZBaseTVC

///视图高度发生改变
//@property (copy, nonatomic) void(^onViewHeightChange)(CGFloat viewH);

@property (copy, nonatomic) void(^onShowDetailEvent)(ModelLawFirm *model);

-(void)setViewDataWithLawFirm:(ModelLawFirm *)model;

@end
