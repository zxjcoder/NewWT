//
//  ZDownloadHeaderView.h
//  PlaneLive
//
//  Created by Daniel on 10/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZDownloadHeaderView : ZView

/// 全选按钮
@property (copy, nonatomic) void(^onCheckClick)(BOOL checkAll);
/// 删除按钮
@property (copy, nonatomic) void(^onDeleteClick)();
/// 取消按钮
@property (copy, nonatomic) void(^onCancelClick)();

/// 获取总记录数
-(int)getDownloadMaxCount;

/// 设置总记录数
-(void)setDownloadMaxCount:(int)count;

/// 取消全选
-(void)setCancelCheckAll;

/// 设置选中按钮
-(void)setCheckAllStatus:(BOOL)checkAll;

/// 获取View高度
+(CGFloat)getH;

@end
