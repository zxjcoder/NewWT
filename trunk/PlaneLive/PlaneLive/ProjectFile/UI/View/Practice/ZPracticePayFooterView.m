//
//  ZPracticePayFooterView.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticePayFooterView.h"
#import "ZButton.h"
#import "ZLabel.h"
#import "ZShadowButtonView.h"

@interface ZPracticePayFooterView()

@property (strong, nonatomic) ZView *viewContent;
/// 购买
@property (strong, nonatomic) ZShadowButtonView *btnPay;
/// 金额
@property (strong, nonatomic) ZLabel *lbPay;
/// 加入购物车
@property (strong, nonatomic) ZLabel *lbJoin;
@property (strong, nonatomic) ZImageView *imageJoin;
@property (strong, nonatomic) ModelPractice *modelP;

@end

@implementation ZPracticePayFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    [self setBackgroundColor:WHITECOLOR];
    [self setAllShadowColor];
    
    self.viewContent = [[ZView alloc] initWithFrame:(CGRectMake(0, 2, self.width, 45))];
    [self addSubview:self.viewContent];
    
    self.btnJoin = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnJoin setFrame:CGRectMake(20, 0, 45, 45)];
    self.btnJoin.userInteractionEnabled = true;
    [self.btnJoin addTarget:self action:@selector(btnJoinClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnJoin];
    
    CGFloat cartSize = 24;
    self.imageJoin = [[ZImageView alloc] initWithFrame:(CGRectMake(0, self.btnJoin.height/2-cartSize/2, cartSize, cartSize))];
    self.imageJoin.image = [SkinManager getImageWithName:@"cart01"];
    [self.imageJoin setUserInteractionEnabled:false];
    [self.btnJoin addSubview:self.imageJoin];
    
    CGFloat payW = 80;
    CGFloat payH = 32;
    self.btnPay = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(self.width-20-payW, self.height/2-payH/2, payW, payH))];
    [self.btnPay setButtonTitle:kPayCartMoney];
    [self.btnPay setButtonBGImage:@"btn_gra2"];
    ZWEAKSELF
    [self.btnPay setOnButtonClick:^{
        [weakSelf btnPayClick];
    }];
    [self.viewContent addSubview:self.btnPay];
    
    CGFloat lbPayX = self.btnJoin.x+self.btnJoin.width-10;
    CGFloat lbPayW = self.btnPay.x-lbPayX-10;
    self.lbPay = [[ZLabel alloc] initWithFrame:(CGRectMake(lbPayX, self.height/2-14, lbPayW, 28))];
    [self.lbPay setUserInteractionEnabled:false];
    [self.lbPay setText:[NSString stringWithFormat:@"0.00 %@", kPlaneMoney]];
    [self setLabelPayStyle];
    [self.viewContent addSubview:self.lbPay];
}
-(void)setLabelPayStyle
{
    [self.lbPay setTextColor:COLORCONTENT3];
    [self.lbPay setFont:[ZFont boldSystemFontOfSize:20]];
    [self.lbPay setLabelFontWithRange:(NSMakeRange(self.lbPay.text.length-3,3)) font:[ZFont systemFontOfSize:kFont_Small_Size] color:COLORTEXT3];
}
-(void)btnJoinClick
{
    if (self.onJoinCartClick) {
        self.onJoinCartClick();
    }
}
-(void)btnPayClick
{
    if (self.onBuyClick) {
        self.onBuyClick();
    }
}
-(void)setViewDataWithModel:(ModelPractice *)model
{
    self.modelP = model;
    [self.btnJoin setEnabled:model.joinCart==0];
    if (model.joinCart == 0) {
        self.imageJoin.image = [SkinManager getImageWithName:@"cart01"];
    } else {
        self.imageJoin.image = [SkinManager getImageWithName:@"cart_s"];
    }
    NSString *moneyText = [NSString stringWithFormat:@"%.2f %@", [model.price floatValue], kPlaneMoney];
    [self.lbPay setText:moneyText];
    [self setLabelPayStyle];
}
+(CGFloat)getH
{
    if (IsIPhoneX) {
        return 50+kIPhoneXButtonHeight;
    }
    return 50;
}
@end
