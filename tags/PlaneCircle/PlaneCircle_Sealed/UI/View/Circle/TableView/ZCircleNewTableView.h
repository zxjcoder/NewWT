//
//  ZCircleNewTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZCircleNewTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelCircleNew *model);

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelCircleNew *model);

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelCircleNew *model);

///添加一条最新的问题
-(void)addViewModelWithNewQuestion:(ModelQuestion *)modelQ;

@end
