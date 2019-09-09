//
//  ZSubscribeAlreadyDetailTableView.h
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZSubscribeAlreadyDetailTableView : ZBaseTableView

/// 获取高度
-(CGFloat)getTableViewHeight;
/// 设置数据源
-(void)setViewDataWithModel:(ModelSubscribeDetail *)model;

@end
