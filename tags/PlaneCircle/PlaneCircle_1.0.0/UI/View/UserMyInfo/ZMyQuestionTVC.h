//
//  ZMyQuestionTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyBaseTVC.h"

@interface ZMyQuestionTVC : ZMyBaseTVC

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelQuestionDetail *model);

///删除按钮点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelQuestionDetail *model, ZMyQuestionTVC *tvc);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

@end
