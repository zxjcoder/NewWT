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

@interface ZPracticePayFooterView()

/// 加入购物车
@property (strong, nonatomic) ZButton *btnJoin;
/// 购买
@property (strong, nonatomic) ZButton *btnPay;
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
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    [self setAllShadowColor];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.btnJoin = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnJoin setFrame:CGRectMake(20, 2, 100, 45)];
    self.btnJoin.userInteractionEnabled = true;
    [self.btnJoin addTarget:self action:@selector(btnJoinClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnJoin];
    
    CGFloat cartSize = 24;
    self.imageJoin = [[ZImageView alloc] initWithFrame:(CGRectMake(0, self.btnJoin.height/2-cartSize/2, cartSize, cartSize))];
    self.imageJoin.image = [SkinManager getImageWithName:@"cart01"];
    [self.imageJoin setUserInteractionEnabled:false];
    [self.btnJoin addSubview:self.imageJoin];
    
//    CGFloat joinX = imgIcon.x+imgIcon.width+6;
//    CGFloat joinW = self.btnJoin.width-joinX;
//    self.lbJoin = [[ZLabel alloc] initWithFrame:(CGRectMake(joinX, self.btnJoin.height/2-10, joinW, 20))];
//    [self.lbJoin setTag:1];
//    self.lbJoin.text = kJoinPayCart;
//    [self.lbJoin setTextColor:COLORTEXT3];
//    self.lbJoin.userInteractionEnabled = false;
//    [self.lbJoin setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
//    [self.btnJoin addSubview:self.lbJoin];
    
    CGFloat payW = 80;
    CGFloat payH = 32;
    self.btnPay = [[ZButton alloc] initWithFrame:(CGRectMake(self.width-20-payW, self.height/2-payH/2, payW, payH))];
    [self.btnPay setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2"] forState:(UIControlStateNormal)];
    [self.btnPay setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2_c"] forState:(UIControlStateHighlighted)];
    [self.btnPay setTitle:kPayCartMoney forState:(UIControlStateNormal)];
    [[self.btnPay layer] setMasksToBounds:true];
    self.btnPay.userInteractionEnabled = true;
    [self.btnPay setViewRound:payH/2 borderWidth:0 borderColor:CLEARCOLOR];
    [[self.btnPay titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnPay setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnPay addTarget:self action:@selector(btnPayClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPay];
    
    CGFloat lbPayX = self.btnJoin.x+self.btnJoin.width-10;
    CGFloat lbPayW = self.btnPay.x-lbPayX-10;
    self.lbPay = [[ZLabel alloc] initWithFrame:(CGRectMake(lbPayX, self.height/2-12, lbPayW, 24))];
    [self.lbPay setUserInteractionEnabled:false];
    [self.lbPay setText:[NSString stringWithFormat:@"0.00 %@", kPlaneMoney]];
    [self.lbPay setTextColor:COLORCONTENT3];
    [self.lbPay setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbPay setLabelFontWithRange:(NSMakeRange(self.lbPay.text.length-3,3)) font:[ZFont systemFontOfSize:kFont_Min_Size] color:COLORTEXT3];
    [self.lbPay setTextAlignment:(NSTextAlignmentRight)];
    [self addSubview:self.lbPay];
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
        self.imageJoin.image = [SkinManager getImageWithName:@"cart01_s"];
    }
    NSString *moneyText = [NSString stringWithFormat:@"%.2f %@", [model.price floatValue], kPlaneMoney];
    [self.lbPay setText:moneyText];
    [self.lbPay setTextColor:COLORCONTENT3];
    [self.lbPay setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbPay setLabelFontWithRange:(NSMakeRange(self.lbPay.text.length-3,3)) font:[ZFont systemFontOfSize:kFont_Min_Size] color:COLORTEXT3];
    
}

@end
