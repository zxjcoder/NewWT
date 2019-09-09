//
//  ZNewCommonCourseTVC.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZNewCommonCourseTVC : ZBaseTVC

-(CGFloat)setCellDataWithPracticeModel:(ModelPractice *)model;
-(CGFloat)setCellDataWithCourseModel:(ModelSubscribe *)model;
+(CGFloat)getCourseH;
+(CGFloat)getPracticeH;

@end
