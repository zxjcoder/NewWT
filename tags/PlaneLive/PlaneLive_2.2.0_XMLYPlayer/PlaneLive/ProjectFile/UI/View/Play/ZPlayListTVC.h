//
//  ZPlayListTVC.h
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"
#import "ModelTrack.h"

@interface ZPlayListTVC : ZBaseTVC

-(void)setViewTitleColor:(UIColor *)color;

-(CGFloat)setCellDataWithModel:(ModelTrack *)model;

@end
