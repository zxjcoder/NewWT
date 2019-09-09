//
//  ZCircleHotItemTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZCircleHotItemTVC : ZBaseTVC

///标签点击事件
@property (copy ,nonatomic) void(^onTagItemClick)(ModelTag *model);

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelCircleHot *model);

///计算高度
-(CGFloat)getHWithModel:(ModelCircleHot *)model;

@end
