//
//  ZBaseTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTableView.h"

@interface ZBaseTableView : ZTableView

///背景按钮事件
@property (copy, nonatomic) void(^onBackgroundClick)(ZBackgroundState viewBGState);
///刷新顶部数据
@property (copy, nonatomic) void(^onRefreshHeader)();
///刷新底部数据
@property (copy, nonatomic) void(^onRefreshFooter)();

///原始数据
@property (strong, nonatomic) NSDictionary *dicRawData;

///设置背景状态
-(void)setBackgroundViewWithState:(ZBackgroundState)backState;

///设置数据源
-(void)setViewDataWithDictionary:(NSDictionary *)dicResult;

@end
