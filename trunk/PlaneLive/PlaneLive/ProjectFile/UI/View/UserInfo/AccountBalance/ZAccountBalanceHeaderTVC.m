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

@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbMoney;
@property (strong, nonatomic) ZLabel *lbUnit;
@property (strong, nonatomic) ZLabel *lbContent;

@end

@implementation ZAccountBalanceHeaderTVC

///初始化
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.cellH = [ZAccountBalanceHeaderTVC getH];
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    CGFloat imageBGHeight = 130;
    self.imgBack = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"bg_balance"]];
    [self.imgBack setFrame:CGRectMake(0, 0, self.cellW, imageBGHeight)];
    [self.viewMain addSubview:self.imgBack];
    
    self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(20, imageBGHeight-22-26, 100, 26))];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:26]];
    [self.lbTitle setText:@"余额"];
    [self.imgBack addSubview:self.lbTitle];
    
    self.lbUnit = [[ZLabel alloc] initWithFrame:(CGRectMake(self.cellW-20-52, imageBGHeight-22-26, 52, 26))];
    [self.lbUnit setTextColor:WHITECOLOR];
    [self.lbUnit setAlpha:0.6];
    [self.lbUnit setText:@"梧桐币"];
    [self.lbUnit setTextAlignment:(NSTextAlignmentRight)];
    [self.lbUnit setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.imgBack addSubview:self.lbUnit];
    
    self.lbMoney = [[ZLabel alloc] initWithFrame:(CGRectMake(self.lbUnit.x-150, imageBGHeight-22-35, 150, 35))];
    [self.lbMoney setFont:[ZFont boldSystemFontOfSize:36]];
    [self.lbMoney setText:@"0.00"];
    [self.lbMoney setTextAlignment:(NSTextAlignmentRight)];
    [self.lbMoney setTextColor:WHITECOLOR];
    [self.imgBack addSubview:self.lbMoney];
    
    self.lbContent = [[ZLabel alloc] initWithFrame:(CGRectMake(20, self.imgBack.y+self.imgBack.height+18, 200, 22))];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbContent setTextColor:COLORTEXT2];
    [self.lbContent setText:@"梧桐币充值"];
    [self.imgBack addSubview:self.lbContent];
}

-(CGFloat)setCellDataWithBalance:(NSString *)balance
{
    [self.lbMoney setText:[NSString stringWithFormat:@"%.2f", [balance floatValue]]];
    
    return self.cellH;
}

+(CGFloat)getH
{
    return 175;
}

-(void)dealloc
{
    OBJC_RELEASE(_imgBack);
    OBJC_RELEASE(_lbMoney);
    [super setViewNil];
}

@end
