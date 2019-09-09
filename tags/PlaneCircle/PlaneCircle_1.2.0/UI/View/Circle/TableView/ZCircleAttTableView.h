//
//  ZCircleAttTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZCircleAttTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelCircleAtt *model);

///点击头像
@property (copy ,nonatomic) void(^onImagePhotoClick)(ModelCircleAtt *model);

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelCircleAtt *model);

@end
