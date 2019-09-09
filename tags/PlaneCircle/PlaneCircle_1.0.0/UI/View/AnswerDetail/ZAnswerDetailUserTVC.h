//
//  ZAnswerDetailUserTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZAnswerDetailUserTVC : ZBaseTVC

///头像
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelAnswerBase *model);
///同意
@property (copy, nonatomic) void(^onAgreeClick)(ModelAnswerBase *model);

@end
