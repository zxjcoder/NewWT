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
    
    CGFloat descH = 25;
    self.imgBack = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"account_balance"]];
    [self.imgBack setFrame:CGRectMake(0, 0, self.cellW, self.cellH-descH)];
    [self.viewMain addSubview:self.imgBack];
    
    CGFloat moneyH = 36;
    self.lbMoney = [[ZLabel alloc] initWithFrame:CGRectMake(0, (self.cellH-descH)/2-moneyH/2, self.cellW, moneyH)];
    [self.lbMoney setFont:[ZFont systemFontOfSize:36]];
    [self.lbMoney setTextColor:WHITECOLOR];
    [self.lbMoney setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbMoney setText:@"0.00"];
    [self.imgBack addSubview:self.lbMoney];
    
    self.lbDesc = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, self.cellH-descH+10, 200, 18)];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbDesc setTextColor:DESCCOLOR];
    [self.lbDesc setText:[NSString stringWithFormat:@"%@", kHasBeenPrepaidDesc]];
    [self.viewMain addSubview:self.lbDesc];
}

-(CGFloat)setCellDataWithBalance:(NSString *)balance
{
    [self.lbMoney setText:[NSString stringWithFormat:@"%.2f %@", [balance floatValue], kPlaneMoney]];
    [self.lbMoney setFont:[ZFont systemFontOfSize:36]];
    [self.lbMoney setLabelFontWithRange:(NSMakeRange(self.lbMoney.text.length - kPlaneMoney.length, kPlaneMoney.length)) font:[ZFont systemFontOfSize:kFont_Min_Size]];
    
    return self.cellH;
}

+(CGFloat)getH
{
    return 120;
}

-(void)dealloc
{
    OBJC_RELEASE(_imgBack);
    OBJC_RELEASE(_lbMoney);
    OBJC_RELEASE(_lbDesc);
    [super setViewNil];
}

@end
