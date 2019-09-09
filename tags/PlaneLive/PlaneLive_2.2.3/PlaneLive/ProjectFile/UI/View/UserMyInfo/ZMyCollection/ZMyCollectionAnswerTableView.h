//
//  ZMyCollectionAnswerTableView.h
//  PlaneCircle
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZMyCollectionAnswerTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelCollectionAnswer *model);

///删除按钮点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelCollectionAnswer *model);

///回答区域点击
@property (copy, nonatomic) void(^onAnswerClick)(ModelCollectionAnswer *model);

///设置分页数量
@property (copy, nonatomic) void(^onPageNumChange)(int pageNum);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

@end
