//
//  ZAccountBalanceItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountBalanceItemTVC.h"

@interface ZAccountBalanceItemTVC()

/// 价格
@property (strong, nonatomic) ZLabel *lbMoney;
/// 充值
@property (strong, nonatomic) ZButton *btnRecharge;

@property (strong, nonatomic) UIImageView *imgLine;

@property (assign, nonatomic) ZAccountBalanceItemTVCType type;

@end

@implementation ZAccountBalanceItemTVC

///初始化
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier type:(ZAccountBalanceItemTVCType)type
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setType:type];
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZAccountBalanceItemTVC getH];
    
    self.lbMoney = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, kSize15, 180, 25)];
    NSString *strDesc = [NSString stringWithFormat:@"(%d.00%@)", (int)self.type, kPlaneMoney];
    NSString *strMoney = [NSString stringWithFormat:@"%d.00%@", (int)self.type, kElement];
    NSString *strText = [NSString stringWithFormat:@"%@ %@", strMoney, strDesc];
    self.lbMoney.text = strText;
    [self.lbMoney setTextColor:BLACKCOLOR];
    [self.lbMoney setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbMoney setLabelFontWithRange:(NSMakeRange(strMoney.length + 1, strDesc.length)) font:[ZFont systemFontOfSize:kFont_Min_Size] color:DESCCOLOR];
    [self.viewMain addSubview:self.lbMoney];
    
    self.btnRecharge = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnRecharge setTitle:kRecharge forState:(UIControlStateNormal)];
    [self.btnRecharge setViewRoundWithRound];
    [self.btnRecharge setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnRecharge titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnRecharge addTarget:self action:@selector(btnRechargeClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnRecharge setFrame:CGRectMake(self.cellW-70, kSize15, 55, 25)];
    [self.viewMain addSubview:self.btnRecharge];
    
    self.imgLine = [UIImageView getTLineView];
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.cellH-self.lineH, self.cellW-kSizeSpace*2, self.lineH)];
    [self.viewMain addSubview:self.imgLine];
}

-(void)btnRechargeClick
{
    if (self.onRechargeClick) {
        self.onRechargeClick([NSString stringWithFormat:@"%d", (int)self.type]);
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_lbMoney);
    OBJC_RELEASE(_btnRecharge);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_onRechargeClick);
    [super setViewNil];
}

+(CGFloat)getH
{
    return 55;
}

@end
