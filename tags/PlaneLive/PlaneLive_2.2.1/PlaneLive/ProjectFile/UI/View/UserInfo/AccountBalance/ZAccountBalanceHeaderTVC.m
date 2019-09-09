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
    
    self.imgBack = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"account_balance"]];
    [self.imgBack setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    [self.viewMain addSubview:self.imgBack];
    
    self.lbMoney = [[ZLabel alloc] initWithFrame:CGRectMake(0, self.cellH/2-36/2, self.cellW, 36)];
    [self.lbMoney setFont:[ZFont systemFontOfSize:36]];
    [self.lbMoney setTextColor:WHITECOLOR];
    [self.lbMoney setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbMoney setText:@"￥0.00"];
    [self.imgBack addSubview:self.lbMoney];
}

-(CGFloat)setCellDataWithBalance:(NSString *)balance
{
    [self.lbMoney setText:[NSString stringWithFormat:@"￥%.2f", [balance floatValue]]];
    
    return self.cellH;
}

+(CGFloat)getH
{
    return 110;
}

-(void)dealloc
{
    OBJC_RELEASE(_imgBack);
    OBJC_RELEASE(_lbMoney);
    [super setViewNil];
}

@end
