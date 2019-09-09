//
//  ZTopicItemTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZTopicItemTVC : ZBaseTVC

///头像区域点击
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);
///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///计算高度
-(CGFloat)getHWithModel:(ModelQuestionTopic *)model;

@end
