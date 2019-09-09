//
//  ZQuestionDetailAnswerTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZQuestionDetailAnswerTVC : ZBaseTVC

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelAnswerBase *model);

-(CGFloat)getHWithModel:(ModelAnswerBase *)model;

@end
