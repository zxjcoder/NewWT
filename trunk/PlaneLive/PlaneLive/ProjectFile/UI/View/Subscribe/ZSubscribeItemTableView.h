//
//  ZSubscribeItemTableView.h
//  PlaneLive
//
//  Created by Daniel on 05/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

///订阅推荐TV
@interface ZSubscribeItemTableView : ZBaseTableView

///数据点击事件
@property (copy, nonatomic) void(^onSubscribeClick)(ModelSubscribe *model);

@end
