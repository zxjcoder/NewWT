//
//  ZMyAttentionUserTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZMyAttentionUserTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onRowSelected)(ModelUserBase *model);

///删除按钮点击
@property (copy, nonatomic) void(^onDeleteClick)(ModelUserBase *model);

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

@end
