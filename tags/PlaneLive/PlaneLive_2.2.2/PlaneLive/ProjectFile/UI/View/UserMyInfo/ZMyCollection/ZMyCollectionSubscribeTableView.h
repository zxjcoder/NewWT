//
//  ZMyCollectionSubscribeTableView.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/5.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZMyCollectionSubscribeTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelCollection *model);

///删除按钮点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelCollection *model);

///设置分页数量
@property (copy, nonatomic) void(^onPageNumChange)(int pageNum);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

@end
