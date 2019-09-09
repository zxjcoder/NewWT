//
//  ZNewSubscribeToolView.m
//  PlaneLive
//
//  Created by Daniel on 27/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewSubscribeToolView.h"
#import "ZButton.h"
#import "ZLabel.h"

@interface ZNewSubscribeToolView()

/// 试读
@property (strong, nonatomic) ZButton *btnProbation;
/// 购买
@property (strong, nonatomic) ZButton *btnPay;
/// 金额
@property (strong, nonatomic) ZLabel *lbPrice;
@property (strong, nonatomic) ModelSubscribe *model;
@property (assign, nonatomic) int viewType;

@end

@implementation ZNewSubscribeToolView

///初始化
-(instancetype)initWithPoint:(CGPoint)point
{
    self = [super initWithFrame:(CGRectMake(point.x, point.y, APP_FRAME_WIDTH, [ ZNewSubscribeToolView getH]))];
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
    CGFloat space = 20;
    CGFloat btnW = 80;
    CGFloat btnH = 32;
    CGFloat btnY = self.height/2-btnH/2;
    self.btnProbation = [ZButton buttonWithType:(UIButtonTypeCustom)];
    self.btnProbation.hidden = true;
    [self.btnProbation setUserInteractionEnabled:true];
    [self.btnProbation addTarget:self action:@selector(btnProbationClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnProbation setFrame:(CGRectMake(space, btnY, btnW, btnH))];
    [self addSubview:self.btnProbation];
    CGFloat imageSize = 24;
    ZImageView *imageIcon = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"read"]];
    [imageIcon setFrame:(CGRectMake(0, btnH/2-imageSize/2, imageSize, imageSize))];
    imageIcon.userInteractionEnabled = false;
    [self.btnProbation addSubview:imageIcon];
    
    CGFloat lbPX = imageIcon.x+imageIcon.width+6;
    CGFloat lbPW = self.btnProbation.width-lbPX;
    ZLabel *lbProbation = [[ZLabel alloc] initWithFrame:(CGRectMake(lbPX, btnH/2-10, lbPW, 20))];
    [lbProbation setTextColor:COLORTEXT3];
    [lbProbation setText:kProbation];
    [lbProbation setUserInteractionEnabled:false];
    [lbProbation setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnProbation addSubview:lbProbation];
    
    self.lbPrice = [[ZLabel alloc] init];
    [self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbPrice setText:@"0.00 梧桐币"];
    [self.lbPrice setLabelFontWithRange:(NSMakeRange(self.lbPrice.text.length-3,3)) font:[ZFont systemFontOfSize:kFont_Min_Size] color:COLORTEXT3];
    [self addSubview:self.lbPrice];
    
    CGFloat payW = 80;
    CGFloat payH = 32;
    self.btnPay = [[ZButton alloc] initWithFrame:(CGRectMake(self.width-space-payW, self.height/2-payH/2, payW, payH))];
    [self.btnPay setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2"] forState:(UIControlStateNormal)];
    [self.btnPay setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2_c"] forState:(UIControlStateHighlighted)];
    [self.btnPay setTitle:kPayCartMoney forState:(UIControlStateNormal)];
    [[self.btnPay layer] setMasksToBounds:true];
    [self.btnPay setViewRound:payH/2 borderWidth:0 borderColor:CLEARCOLOR];
    [[self.btnPay titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnPay setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnPay addTarget:self action:@selector(btnPayClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPay];
}
-(void)setViewFrame
{
    self.btnProbation.hidden = !self.model.isExistFreeRead;
    CGRect priceFrame = CGRectMake(20, self.height/2-12, 160, 24);
    /// 非试读
    if (self.model.isExistFreeRead) {
        self.lbPrice.textAlignment = NSTextAlignmentRight;
        priceFrame.origin.x = self.btnPay.x-priceFrame.size.width-10;
    } else {///需要购买
        self.lbPrice.textAlignment = NSTextAlignmentLeft;
        priceFrame.origin.x = 20;
    }
    self.lbPrice.frame = priceFrame;
}
-(void)btnProbationClick
{
    if (self.onProbationClick) {
        self.onProbationClick();
    }
}
-(void)btnPayClick
{
    if (self.onSubscribeClick) {
        self.onSubscribeClick();
    }
}
///设置数据
-(void)setViewDataWithModel:(ModelSubscribe *)model
{
    [self setModel:model];
    
    NSString *moneyText = [NSString stringWithFormat:@"%.2f %@", [model.price floatValue], kPlaneMoney];
    [self.lbPrice setText:moneyText];
    [self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbPrice setLabelFontWithRange:(NSMakeRange(self.lbPrice.text.length-3,3)) font:[ZFont systemFontOfSize:kFont_Min_Size] color:COLORTEXT3];
    
    [self setViewFrame];
}

///获取高度
+(CGFloat)getH
{
    return 50;
}

@end
