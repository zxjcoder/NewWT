//
//  ZAlertRewardView.h
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

///打赏弹框
@interface ZAlertRewardView : ZView

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
