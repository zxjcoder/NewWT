//
//  ZQuestionSelectTagTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

///添加话题CELL
@interface ZQuestionSelectTagTVC : ZBaseTVC

///选中数据
@property (copy ,nonatomic) void(^onCheckClick)(ZQuestionSelectTagTVC *selTagTVC, ModelTag *model);

///设置选中
-(void)setTVCCheckTag:(BOOL)isCheck;

@end
