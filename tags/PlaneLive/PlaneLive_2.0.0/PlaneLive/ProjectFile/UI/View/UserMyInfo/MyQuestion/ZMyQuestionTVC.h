//
//  ZMyQuestionTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZMyQuestionTVC : ZBaseTVC

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);

///获取CELL高度
-(CGFloat)getHWithModel:(ModelMyAllQuestion *)model;

@end
