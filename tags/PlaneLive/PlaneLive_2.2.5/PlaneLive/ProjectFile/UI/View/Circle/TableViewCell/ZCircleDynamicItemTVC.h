//
//  ZCircleDynamicItemTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZCircleDynamicItemTVC : ZBaseTVC

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);
///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///计算高度
-(CGFloat)getHWithModel:(ModelCircleDynamic *)model;

@end