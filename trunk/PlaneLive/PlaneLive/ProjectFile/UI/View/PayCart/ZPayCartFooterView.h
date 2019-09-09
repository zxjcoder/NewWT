//
//  ZPayCartFooterView.h
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPayCartFooterView : ZView

///购买选中的购物车
@property (copy, nonatomic) void(^onBuyClick)();
/// 全选按钮
@property (copy, nonatomic) void(^onCheckClick)(BOOL checkAll);

/// 设置数据源
-(void)setViewDataWithCount:(NSInteger)count maxPrice:(CGFloat)maxPrice;

/// 选中状态
-(void)setViewCheckStatus:(BOOL)check;

+(CGFloat)getH;

@end
