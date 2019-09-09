//
//  ZCircleHotItemTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZCircleHotItemTVC : ZBaseTVC

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelAnswerBase *model);

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelUserBase *model);

///计算高度
-(CGFloat)getHWithModel:(ModelCircleHot *)model;

///获取问题区域的坐标
-(CGRect)getQuestionFrame;

///获取回答区域的坐标
-(CGRect)getAnswerFrame;

@end
