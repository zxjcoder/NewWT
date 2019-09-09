//
//  ZMyQuestionNewTVC.h
//  PlaneCircle
//
//  Created by Daniel on 7/25/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZMyQuestionNewTVC : ZBaseTVC

///头像点击
@property (copy, nonatomic) void(^onPhotoClick)(ModelMyNewQuestion *model);

///回答点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelMyNewQuestion *model);

///获取CELL高度
-(CGFloat)getHWithModel:(ModelMyNewQuestion *)model;

@end
