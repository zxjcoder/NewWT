//
//  ZAnswerDetailQuestionTVC.h
//  PlaneCircle
//
//  Created by Daniel on 8/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZAnswerDetailQuestionTVC : ZBaseTVC

///根据数据模型获取高度
-(CGFloat)getHWithModel:(ModelAnswerBase *)model;

@end
