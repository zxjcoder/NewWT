//
//  ZMyAnswerTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyBaseTVC.h"

@interface ZMyAnswerTVC : ZMyBaseTVC

///删除按钮点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelQuestionMyAnswer *model, ZMyAnswerTVC *tvc);

///获取高度
-(CGFloat)getHWithModel:(ModelQuestionMyAnswer *)model;

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

@end
