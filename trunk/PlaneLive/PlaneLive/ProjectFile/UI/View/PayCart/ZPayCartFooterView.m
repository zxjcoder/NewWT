//
//  ZPayCartFooterView.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPayCartFooterView.h"
#import "ZButton.h"
#import "ZShadowButtonView.h"
#import "ZLabel.h"
#import "ZImageView.h"

@interface ZPayCartFooterView()

@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbPrice;
@property (strong, nonatomic) ZButton *btnSelectAll;
@property (strong, nonatomic) ZShadowButtonView *btnClearing;

@end

@implementation ZPayCartFooterView

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
    [self setAllShadowColor];
    [self setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 55)];
    [self addSubview:self.viewContent];
    
    CGFloat btnSize = 45;
    self.btnSelectAll = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSelectAll setFrame:CGRectMake(kSize1, self.viewContent.height/2-btnSize/2, btnSize, btnSize)];
    [self.btnSelectAll setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnSelectAll setTag:2];
    [self.btnSelectAll setSelected:true];
    [self.btnSelectAll setImage:[SkinManager getImageWithName:@"checkbox"] forState:(UIControlStateNormal)];
    [self.btnSelectAll setImage:[SkinManager getImageWithName:@"checkbox_s"] forState:(UIControlStateSelected)];
    [self.btnSelectAll addTarget:self action:@selector(btnSelectAllClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnSelectAll];
    
    CGFloat titleX = self.btnSelectAll.x+self.btnSelectAll.width-2;
    CGFloat titleH = 24;
    CGFloat titleY = self.viewContent.height/2-titleH/2;
    self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(titleX, titleY, 40, titleH))];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setTextColor:COLORTEXT3];
    [self.lbTitle setText:@"合计:"];
    [self.lbTitle setUserInteractionEnabled:false];
    [self.viewContent addSubview:self.lbTitle];
    
    CGFloat priceX = self.lbTitle.x+self.lbTitle.width;
    CGFloat priceW = 250;
    CGFloat priceH = 25;
    CGFloat priceY = self.viewContent.height/2-priceH/2;
    self.lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(priceX, priceY, priceW, priceH)];
    [self.lbPrice setText:[NSString stringWithFormat:@"0.00%@", kPlaneMoney]];
    [self.lbPrice setTextColor:COLORTEXT3];
    [self.lbPrice setUserInteractionEnabled:false];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbPrice];
    
    self.btnClearing = [[ZShadowButtonView alloc] initWithFrame:CGRectMake(self.viewContent.width - 20 - 85, self.viewContent.height / 2 - 32 / 2, 85, 32)];
    [self.btnClearing setButtonBGImage:@"btn_gra2"];
    [self.btnClearing setButtonTitle:@"结算"];
    ZWEAKSELF
    [self.btnClearing setOnButtonClick:^{
        [weakSelf btnClearingClick];
    }];
    [self.viewContent addSubview:self.btnClearing];
}
-(void)btnClearingClick
{
    if (self.onBuyClick) {
        self.onBuyClick();
    }
}
-(void)btnSelectAllClick
{
    [self setViewCheckStatus:self.btnSelectAll.tag==1];
    if (self.onCheckClick) {
        self.onCheckClick(self.btnSelectAll.tag==2);
    }
}
-(void)setViewDataWithCount:(NSInteger)count maxPrice:(CGFloat)maxPrice
{
    [self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
    
    NSString *priceRightText = kPlaneMoney;
    NSString *priceText = [NSString stringWithFormat:@"%.2f %@", maxPrice, priceRightText];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceText];
    
    NSRange rightRange = NSMakeRange(priceText.length-priceRightText.length, priceRightText.length);
    [str addAttribute:NSFontAttributeName value:[ZFont systemFontOfSize:kFont_Min_Size] range:rightRange];
    [str addAttribute:NSForegroundColorAttributeName value:COLORTEXT3 range:rightRange];
    self.lbPrice.attributedText = str;
    
    [self.btnClearing setButtonTitle:[NSString stringWithFormat:kSettlement, (int)count]];
}
/// 选中状态
-(void)setViewCheckStatus:(BOOL)check
{
    if (check) {
        [self.btnSelectAll setTag:2];
        [self.btnSelectAll setSelected:true];
    } else {
        [self.btnSelectAll setTag:1];
        [self.btnSelectAll setSelected:false];
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_lbPrice);
    OBJC_RELEASE(_btnSelectAll);
    OBJC_RELEASE(_onBuyClick);
    OBJC_RELEASE(_onCheckClick);
}
+(CGFloat)getH
{
    if (IsIPhoneX) {
        return 55+kIPhoneXButtonHeight;
    }
    return 55;
}
@end
