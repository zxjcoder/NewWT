//
//  ZCircleAttItemTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZCircleAttItemTVC : ZBaseTVC

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelCircleAtt *model);

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelCircleAtt *model);

///计算高度
-(CGFloat)getHWithModel:(ModelCircleAtt *)model;

@end
