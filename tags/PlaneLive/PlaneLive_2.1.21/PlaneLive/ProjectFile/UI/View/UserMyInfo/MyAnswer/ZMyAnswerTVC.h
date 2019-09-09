//
//  ZMyAnswerTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZMyAnswerTVC : ZBaseTVC

///头像点击
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);

///回答点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///获取高度
-(CGFloat)getHWithModel:(ModelQuestionMyAnswer *)model;

@end
