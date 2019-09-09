//
//  ZPayCartFooterView.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPayCartFooterView.h"
#import "ZButton.h"

@interface ZPayCartFooterView()

/// 合计区域
@property (strong, nonatomic) UIView *viewPrice;
/// 合计金额
@property (strong, nonatomic) UILabel *lbPrice;
/// 全选
@property (strong, nonatomic) ZButton *btnSelectAll;
/// 结算
@property (strong, nonatomic) ZButton *btnMacCount;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZPayCartFooterView

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
    [self setAllShadowColor];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setFrame:CGRectMake(0, 0, self.width, kLineHeight)];
    [self addSubview:self.imgLine];
    
    self.viewPrice = [[UIView alloc] initWithFrame:CGRectMake(0, kLineHeight, self.width, self.height-kLineHeight)];
    [self.viewPrice setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewPrice];
    
    CGFloat btnSize = 45;
    self.btnSelectAll = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSelectAll setFrame:CGRectMake(kSize1, self.height/2-btnSize/2, btnSize, btnSize)];
    [self.btnSelectAll setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnSelectAll setTag:2];
    [self.btnSelectAll setSelected:true];
    [self.btnSelectAll setImage:[SkinManager getImageWithName:@"checkbox"] forState:(UIControlStateNormal)];
    [self.btnSelectAll setImage:[SkinManager getImageWithName:@"checkbox_s"] forState:(UIControlStateSelected)];
    [self.btnSelectAll addTarget:self action:@selector(btnSelectAllClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewPrice addSubview:self.btnSelectAll];
    
    CGFloat priceX = self.btnSelectAll.x+self.btnSelectAll.width;
    CGFloat priceW = self.width-priceX - 105;
    CGFloat priceH = 25;
    CGFloat priceY = self.height/2-priceH/2;
    self.lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(priceX, priceY, priceW, priceH)];
    [self.lbPrice setText:[NSString stringWithFormat:@"%@: 0.00%@", kTotalAmount, kPlaneMoney]];
    [self.lbPrice setTextColor:COLORTEXT3];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewPrice addSubview:self.lbPrice];
    
    self.btnMacCount = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMacCount setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2"] forState:(UIControlStateNormal)];
    [self.btnMacCount setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2_c"] forState:(UIControlStateHighlighted)];
    [self.btnMacCount setFrame:CGRectMake(self.width - 20 - 85, self.height / 2 - 30 / 2, 85, 30)];
    [[self.btnMacCount titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnMacCount addTarget:self action:@selector(btnMacCountClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnMacCount setTitle:[NSString stringWithFormat:kSettlement, 0] forState:(UIControlStateNormal)];
    [self.btnMacCount setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [[self.btnMacCount layer] setMasksToBounds:true];
    [self.btnMacCount setViewRound:14 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewPrice addSubview:self.btnMacCount];
}
-(void)btnMacCountClick
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
    [self.lbPrice setText:[NSString stringWithFormat:@"%@: %.2f %@", kTotalAmount, maxPrice, kPlaneMoney]];
    [self.lbPrice setTextColor:COLORTEXT3];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    NSRange range = NSMakeRange(kTotalAmount.length, self.lbPrice.text.length - kTotalAmount.length - kPlaneMoney.length);
    UIFont *font = [ZFont systemFontOfSize:kFont_Middle_Size];
    [self.lbPrice setLabelFontWithRange:range font:font color:COLORCONTENT3];
    
    [self.btnMacCount setTitle:[NSString stringWithFormat:kSettlement, (int)count] forState:UIControlStateNormal];
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
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_btnMacCount);
    OBJC_RELEASE(_btnSelectAll);
    OBJC_RELEASE(_onBuyClick);
    OBJC_RELEASE(_onCheckClick);
}
@end
