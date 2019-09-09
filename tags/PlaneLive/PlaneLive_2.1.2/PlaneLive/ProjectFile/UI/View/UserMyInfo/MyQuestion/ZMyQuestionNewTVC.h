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
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);

///回答点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///获取CELL高度
-(CGFloat)getHWithModel:(ModelMyNewQuestion *)model;

///设置数据源
-(CGFloat)setCellDataWithModel:(ModelMyNewQuestion *)model nickNameDescType:(int)nickNameDescType;

@end
