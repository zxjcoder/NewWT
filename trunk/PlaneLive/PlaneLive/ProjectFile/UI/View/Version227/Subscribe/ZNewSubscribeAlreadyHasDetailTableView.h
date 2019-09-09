//
//  ZNewSubscribeAlreadyHasDetailTableView.h
//  PlaneLive
//
//  Created by WT on 30/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZNewSubscribeAlreadyHasDetailTableView : ZBaseTableView

///内容高度改变
@property (copy, nonatomic) void(^onTableViewHeightChange)(CGFloat height);
/// 设置数据源
-(void)setViewDataWithModel:(ModelSubscribeDetail *)model;

@end
