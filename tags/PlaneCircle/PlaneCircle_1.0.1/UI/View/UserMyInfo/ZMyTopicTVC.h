//
//  ZMyTopicTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyBaseTVC.h"

@interface ZMyTopicTVC : ZMyBaseTVC

///删除按钮点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelTag *model, ZMyTopicTVC *tvc);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

@end