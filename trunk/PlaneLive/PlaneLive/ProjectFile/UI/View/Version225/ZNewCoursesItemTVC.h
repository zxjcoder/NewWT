//
//  ZNewCoursesItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 19/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZNewCoursesItemTVC : ZBaseTVC

-(void)setHiddenPrice;
-(void)setHiddenListen;
-(void)setHiddenLine:(BOOL)hidden;

-(CGFloat)setCellDataWithCurriculumModel:(ModelCurriculum *)model;

@end
