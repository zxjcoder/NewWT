//
//  ZPlayRewardView.h
//  PlaneLive
//
//  Created by Daniel on 2017/1/9.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPlayRewardView : ZView

///打赏金额
@property (copy, nonatomic) void(^onRewardPriceClick)(NSString *price);

///初始化
-(instancetype)initWithPlayTitle:(NSString *)title organization:(NSString *)organization;

///设置数据源
-(void)setPlayDataWithPriceArray:(NSArray *)priceArray;

///显示
-(void)show;
///隐藏
-(void)dismiss;

@end
