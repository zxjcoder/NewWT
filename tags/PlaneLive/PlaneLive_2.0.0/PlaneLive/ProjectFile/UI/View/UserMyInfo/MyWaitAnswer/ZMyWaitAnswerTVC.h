//
//  ZMyWaitAnswerTVC.h
//  PlaneCircle
//
//  Created by Daniel on 7/25/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZMyWaitAnswerTVC : ZBaseTVC

///头像点击
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);

///获取CELL高度
-(CGFloat)getHWithModel:(ModelWaitAnswer *)model;

@end
