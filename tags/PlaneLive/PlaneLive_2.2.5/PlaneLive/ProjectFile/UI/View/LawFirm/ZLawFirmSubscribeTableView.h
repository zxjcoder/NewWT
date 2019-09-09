//
//  ZLawFirmSubscribeTableView.h
//  PlaneLive
//
//  Created by Daniel on 13/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZLawFirmSubscribeTableView : ZBaseTableView

///数据点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelSubscribe *model);

@end
