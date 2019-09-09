//
//  ZPracticeQuestionItemTVC.h
//  PlaneCircle
//
//  Created by Daniel on 8/24/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZPracticeQuestionItemTVC : ZBaseTVC

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);

///计算高度
-(CGFloat)getHWithModel:(ModelPracticeQuestion *)model;

@end
