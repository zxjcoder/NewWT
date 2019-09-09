//
//  ZPurchaseAllTableView.h
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZPurchaseAllTableView : ZBaseTableView

///选中行事件
@property (copy, nonatomic) void(^onPracticeSelected)(NSArray *array, NSInteger row);
///选中行事件
@property (copy, nonatomic) void(^onSubscribeSelected)(ModelSubscribe *model);
///绑定事件点击
@property (copy, nonatomic) void(^onBindEvent)();
///偏移量改变
@property (copy, nonatomic) void(^onContentOffsetChange)(CGFloat contentOffsetY);

/// 是否显示未登录背景
-(void)setViewDataWithNoLogin;
-(void)setViewDataWithNoData;
/// 是否显示绑定手机号
-(void)setShowBindCell:(BOOL)isShow;

@end
