//
//  ZPurchaseSubscribeTableView.h
//  PlaneLive
//
//  Created by Daniel on 15/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZPurchaseSubscribeTableView : ZBaseTableView

///数据点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelSubscribe *model);

@end
