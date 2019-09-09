//
//  ZPracticePayFooterView.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticePayFooterView.h"
#import "ZButton.h"

@interface ZPracticePayFooterView()

/// 加入购物车
@property (strong, nonatomic) ZButton *btnJoin;
/// 购买
@property (strong, nonatomic) ZButton *btnPay;

@property (strong, nonatomic) UIImageView *imgLine;

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
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setFrame:CGRectMake(0, 0, self.width, kLineHeight)];
    [self addSubview:self.imgLine];
    
    self.btnJoin = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnJoin setFrame:CGRectMake(0, kLineHeight, self.width/2, self.height-kLineHeight)];
    [[self.btnJoin titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.btnJoin setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnJoin setBackgroundColor:WHITECOLOR];
    [self.btnJoin addTarget:self action:@selector(btnJoinClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnJoin setTitle:kJoinPayCart forState:(UIControlStateNormal)];
    [self addSubview:self.btnJoin];
    
    self.btnPay = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPay setBackgroundColor:MAINCOLOR];
    [self.btnPay setFrame:CGRectMake(self.width/2, 0, self.width/2, self.height)];
    [[self.btnPay titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.btnPay addTarget:self action:@selector(btnPayClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnPay setTitle:[NSString stringWithFormat:@"%@ ¥0.00", kPayCartMoney] forState:(UIControlStateNormal)];
    [self.btnPay setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self addSubview:self.btnPay];
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
    if (model.joinCart == 0) {
        [self.btnJoin setEnabled:YES];
        [self.btnJoin setBackgroundColor:VIEW_BACKCOLOR1];
        [self.btnJoin setTitle:kJoinPayCart forState:(UIControlStateNormal)];
    } else {
        [self.btnJoin setEnabled:NO];
        [self.btnJoin setBackgroundColor:VIEW_BACKCOLOR2];
        [self.btnJoin setTitle:kJoinedPayCart forState:(UIControlStateNormal)];
    }
    [self.btnPay setTitle:[NSString stringWithFormat:@"%@ ¥%.2f", kPayCartMoney, [model.price floatValue]] forState:UIControlStateNormal];
}

@end
