//
//  ZMyCollectionAnswerTVC.h
//  PlaneCircle
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZMyCollectionAnswerTVC : ZBaseTVC

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelCollectionAnswer *model);

///计算高度
-(CGFloat)getHWithModel:(ModelCollectionAnswer *)model;

@end
