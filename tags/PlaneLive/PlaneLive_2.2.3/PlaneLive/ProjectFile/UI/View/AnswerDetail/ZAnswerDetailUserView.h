//
//  ZAnswerDetailUserView.h
//  PlaneLive
//
//  Created by Daniel on 14/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZAnswerDetailUserView : ZView

///头像
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelAnswerBase *model);
///同意
@property (copy, nonatomic) void(^onAgreeClick)(ModelAnswerBase *model);

-(CGFloat)setCellDataWithModel:(ModelAnswerBase *)model;

+(CGFloat)getH;

@end
