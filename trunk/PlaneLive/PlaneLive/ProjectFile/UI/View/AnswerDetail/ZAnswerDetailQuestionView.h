//
//  ZAnswerDetailQuestionView.h
//  PlaneLive
//
//  Created by Daniel on 20/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZAnswerDetailQuestionView : ZView

///根据数据模型获取高度
-(CGFloat)setViewDataWithModel:(ModelAnswerBase *)model;

@end
