//
//  ZMyAnswerCommentTVC.h
//  PlaneCircle
//
//  Created by Daniel on 7/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZMyAnswerCommentTVC : ZBaseTVC

///头像按钮点击
@property (copy, nonatomic) void(^onPhotoClick)(ModelQuestionMyAnswerComment *model);

///获取高度
-(CGFloat)getHWithModel:(ModelQuestionMyAnswerComment *)model;

@end
