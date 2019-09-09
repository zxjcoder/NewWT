//
//  ZAnswerDetailCommentTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZAnswerDetailCommentTVC : ZBaseTVC

///高度改变
@property (copy, nonatomic) void(^onRowHeightChange)();
///头像
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelAnswerComment *model);

-(CGFloat)getHWithModel:(ModelAnswerComment *)model;

@end
