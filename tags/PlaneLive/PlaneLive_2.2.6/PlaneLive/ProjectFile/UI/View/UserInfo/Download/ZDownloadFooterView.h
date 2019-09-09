//
//  ZDownloadFooterView.h
//  PlaneLive
//
//  Created by Daniel on 10/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZDownloadFooterView : ZView

/// 删除按钮
@property (copy, nonatomic) void(^onDeleteClick)();
/// 选择按钮改变
@property (copy, nonatomic) void(^onCheckAllClick)(BOOL isCheckAll);

/// 设置选中数量
-(void)setSelectCount:(NSInteger)count;
/// 选中状态
-(void)setViewCheckStatus:(BOOL)check;

/// 获取View高度
+(CGFloat)getH;

@end
