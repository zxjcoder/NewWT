//
//  ZSubscribeDetailTableView.h
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZSubscribeDetailTableView : ZBaseTableView

///偏移量
@property (copy, nonatomic) void(^onContentOffsetY)(CGFloat alpha);

/// 设置数据源
-(void)setViewDataWithModel:(ModelSubscribeDetail *)model;

@end
