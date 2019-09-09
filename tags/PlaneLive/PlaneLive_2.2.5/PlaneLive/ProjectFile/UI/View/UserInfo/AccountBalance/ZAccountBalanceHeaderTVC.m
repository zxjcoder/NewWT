//
//  ZAccountBalanceHeaderTVC.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountBalanceHeaderTVC.h"

@interface ZAccountBalanceHeaderTVC()

@property (strong, nonatomic) ZImageView *imgBack;

@property (strong, nonatomic) ZLabel *lbMoney;
@property (strong, nonatomic) ZLabel *lbDesc;
@property (strong, nonatomic) ZLabel *lbTitle;

@end

@implementation ZAccountBalanceHeaderTVC

///初始化
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZAccountBalanceHeaderTVC getH];
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    CGFloat descH = 25;
    self.imgBack = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"bg_balance"]];
    [self.imgBack setFrame:CGRectMake(0, 0, self.cellW, 150)];
    [self.viewMain addSubview:self.imgBack];
    
    CGFloat moneyH = 36;
    self.lbMoney = [[ZLabel alloc] initWithFrame:CGRectMake(self.cellW / 2 - 100, 80, 200, moneyH)];
    [self.lbMoney setFont:[ZFont boldSystemFontOfSize:32]];
    [self.lbMoney setTextColor:WHITECOLOR];
    [self.lbMoney setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbMoney setText:@"0.00"];
    [self.imgBack addSubview:self.lbMoney];
    
    self.lbDesc = [[ZLabel alloc] initWithFrame:CGRectMake(self.cellW / 2 - 50, self.lbMoney.y + self.lbMoney.height + 10, 100, 18)];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Minmum_Size]];
    [self.lbDesc setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbDesc setTextColor:WHITECOLOR];
    [self.lbDesc setText:kPlaneMoney];
    [self.imgBack addSubview:self.lbDesc];
    
    self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(20, self.imgBack.y + self.imgBack.height + 23, 200, self.lbH))];
    [self.lbTitle setTextColor:COLORTEXT2];
    [self.lbTitle setText:kHasBeenPrepaidDesc];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
}

-(CGFloat)setCellDataWithBalance:(NSString *)balance
{
    [self.lbMoney setText:[NSString stringWithFormat:@"%.2f", [balance floatValue]]];
    
    return self.cellH;
}

+(CGFloat)getH
{
    return 200;
}

-(void)dealloc
{
    OBJC_RELEASE(_imgBack);
    OBJC_RELEASE(_lbMoney);
    OBJC_RELEASE(_lbDesc);
    [super setViewNil];
}

@end
