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
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbMoney = [[ZLabel alloc] init];
    NSString *strDesc = [NSString stringWithFormat:@"(%d.00%@)", (int)self.type, kPlaneMoney];
    NSString *strMoney = [NSString stringWithFormat:@"¥ %d.00", (int)self.type];
    NSString *strText = [NSString stringWithFormat:@"%@  %@", strMoney, strDesc];
    [self.lbMoney setText:strText];
    [self.lbMoney setTextColor:COLORCONTENT3];
    [self.lbMoney setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
    [self.lbMoney setLabelFontWithRange:(NSMakeRange(strMoney.length + 2, strDesc.length)) font:[ZFont systemFontOfSize:kFont_Min_Size] color:COLORTEXT3];
    [self.lbMoney setNeedsDisplay];
    [self.viewMain addSubview:self.lbMoney];
    
    self.btnRecharge = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnRecharge setTitle:kRecharge forState:(UIControlStateNormal)];
    [self.btnRecharge setBackgroundImage:[SkinManager getImageWithName:@"btn_line_gra2"] forState:(UIControlStateNormal)];
    [self.btnRecharge setBackgroundImage:[SkinManager getImageWithName:@"btn_line_gra2_c"] forState:(UIControlStateHighlighted)];
    [self.btnRecharge setTitleColor:COLORCONTENT3 forState:(UIControlStateNormal)];
    [[self.btnRecharge titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnRecharge addTarget:self action:@selector(btnRechargeClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnRecharge];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}
-(void)setViewFrame
{
    [self.lbMoney setFrame:CGRectMake(self.space, self.cellH / 2 - 13, 200, 26)];
    [self.btnRecharge setFrame:CGRectMake(self.cellW-self.space-60, self.cellH / 2 - 14, 60, 28)];
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight)];
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
