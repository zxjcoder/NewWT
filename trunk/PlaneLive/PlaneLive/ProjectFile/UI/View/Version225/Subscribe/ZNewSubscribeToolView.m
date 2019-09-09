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
#import "ZShadowButtonView.h"

@interface ZNewSubscribeToolView()

@property (strong, nonatomic) ZView *viewContent;
/// 试读
@property (strong, nonatomic) ZButton *btnProbation;
/// 购买
@property (strong, nonatomic) ZShadowButtonView *btnPay;
/// 金额
@property (strong, nonatomic) ZLabel *lbPrice;
@property (strong, nonatomic) ModelSubscribe *model;
@property (assign, nonatomic) int viewType;

@end

@implementation ZNewSubscribeToolView

///初始化
-(instancetype)initWithPoint:(CGPoint)point
{
    self = [super initWithFrame:(CGRectMake(point.x, point.y, APP_FRAME_WIDTH, [ZNewSubscribeToolView getH]))];
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
    
    CGFloat space = 20;
    self.btnProbation = [ZButton buttonWithType:(UIButtonTypeCustom)];
    self.btnProbation.hidden = true;
    [self.btnProbation setUserInteractionEnabled:true];
    [self.btnProbation addTarget:self action:@selector(btnProbationClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnProbation setFrame:(CGRectMake(space, 0, 45, 45))];
    [self.viewContent addSubview:self.btnProbation];
    
    CGFloat imageSize = 24;
    ZImageView *imageIcon = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"read"]];
    [imageIcon setFrame:(CGRectMake(0, self.btnProbation.height/2-imageSize/2, imageSize, imageSize))];
    imageIcon.userInteractionEnabled = false;
    [self.btnProbation addSubview:imageIcon];
    
//    CGFloat lbPX = imageIcon.x+imageIcon.width+6;
//    CGFloat lbPW = self.btnProbation.width-lbPX;
//    ZLabel *lbProbation = [[ZLabel alloc] initWithFrame:(CGRectMake(lbPX, btnH/2-10, lbPW, 20))];
//    [lbProbation setTextColor:COLORTEXT3];
//    [lbProbation setText:kProbation];
//    [lbProbation setUserInteractionEnabled:false];
//    [lbProbation setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
//    [self.btnProbation addSubview:lbProbation];
    
    self.lbPrice = [[ZLabel alloc] initWithFrame:(CGRectMake(20, self.viewContent.height/2-28/2, 150, 28))];
    [self.lbPrice setText:@"0.00 梧桐币"];
    [self setLabelPayStyle];
    [self.viewContent addSubview:self.lbPrice];
    
    CGFloat payW = 80;
    CGFloat payH = 32;
    self.btnPay = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(self.width-space-payW, self.height/2-payH/2, payW, payH))];
    [self.btnPay setButtonTitle:kPayCartMoney];
    [self.btnPay setButtonBGImage:@"btn_gra2"];
    ZWEAKSELF
    [self.btnPay setOnButtonClick:^{
        [weakSelf btnPayClick];
    }];
    [self.viewContent addSubview:self.btnPay];
}
-(void)setLabelPayStyle
{
    [self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setFont:[ZFont boldSystemFontOfSize:20]];
    [self.lbPrice setLabelFontWithRange:(NSMakeRange(self.lbPrice.text.length-3,3)) font:[ZFont systemFontOfSize:kFont_Small_Size] color:COLORTEXT3];
}
-(void)setViewFrame
{
    self.btnProbation.hidden = !self.model.isExistFreeRead;
    CGRect priceFrame = CGRectMake(20, self.viewContent.height/2-28/2, 150, 28);
    if (self.model.isExistFreeRead) {
        priceFrame.origin.x = self.btnProbation.x+self.btnProbation.width-10;
    } else {
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
    
//    self.model.isExistFreeRead = true;
    
    NSString *moneyText = [NSString stringWithFormat:@"%.2f %@", [model.price floatValue], kPlaneMoney];
    [self.lbPrice setText:moneyText];
    [self setLabelPayStyle];
    
    [self setViewFrame];
}

///获取高度
+(CGFloat)getH
{
    if (IsIPhoneX) {
        return 50+kIPhoneXButtonHeight;
    }
    return 50;
}

@end
