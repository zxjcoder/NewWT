//
//  ZAccountBalanceItemTVC.h
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

typedef NS_ENUM(NSInteger, ZAccountBalanceItemTVCType)
{
    ZAccountBalanceItemTVCTypeNone = 6,
    ZAccountBalanceItemTVCTypeTwo = 18,
    ZAccountBalanceItemTVCTypeThree = 68,
    ZAccountBalanceItemTVCTypeFour = 128,
    ZAccountBalanceItemTVCTypeFive = 698,
};

@interface ZAccountBalanceItemTVC : ZBaseTVC

///初始化
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZAccountBalanceItemTVCType)type;

///充值点击事件
@property (copy, nonatomic) void(^onRechargeClick)(NSString *money);

@end
