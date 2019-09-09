//
//  ZRankAchievementView.m
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankAchievementView.h"

@interface ZRankAchievementView()

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) UIImageView *imgIcon;
///业绩清单
@property (strong, nonatomic) UILabel *lbTitle;
///律师事务所
@property (strong, nonatomic) UIImageView *imgLawyer;
///证券公司
@property (strong, nonatomic) UIImageView *imgSecurities;
///会计事务所
@property (strong, nonatomic) UIImageView *imgAccounting;
///律师事务所
@property (strong, nonatomic) UILabel *lbLawyer;
///证券公司
@property (strong, nonatomic) UILabel *lbSecurities;
///会计事务所
@property (strong, nonatomic) UILabel *lbAccounting;

@end

@implementation ZRankAchievementView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
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
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"bangdan_icon_bangdan"]];
    [self addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:@"业绩清单"];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self addSubview:self.lbTitle];
    
    self.imgLawyer = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"bangdan_btn_lvsuo"]];
    [self.imgLawyer setUserInteractionEnabled:YES];
    [self addSubview:self.imgLawyer];
    
    self.imgSecurities = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"bangdan_btn_zhengquangongsi"]];
    [self.imgSecurities setUserInteractionEnabled:YES];
    [self addSubview:self.imgSecurities];
    
    self.imgAccounting = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"bangdan_btn_kuaisuo"]];
    [self.imgAccounting setUserInteractionEnabled:YES];
    [self addSubview:self.imgAccounting];
    
    UITapGestureRecognizer *tapLawyer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLawyer:)];
    [self.imgLawyer addGestureRecognizer:tapLawyer];
    
    UITapGestureRecognizer *tapSecurities = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSecurities:)];
    [self.imgSecurities addGestureRecognizer:tapSecurities];
    
    UITapGestureRecognizer *tapAccounting = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAccounting:)];
    [self.imgAccounting addGestureRecognizer:tapAccounting];
    
    self.lbLawyer = [[UILabel alloc] init];
    [self.lbLawyer setText:@"律师事务所"];
    [self.lbLawyer setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbLawyer setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbLawyer setTextColor:BLACKCOLOR1];
    [self addSubview:self.lbLawyer];
    
    self.lbSecurities = [[UILabel alloc] init];
    [self.lbSecurities setText:@"证券公司"];
    [self.lbSecurities setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbSecurities setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbSecurities setTextColor:BLACKCOLOR1];
    [self addSubview:self.lbSecurities];
    
    self.lbAccounting = [[UILabel alloc] init];
    [self.lbAccounting setText:@"会计事务所"];
    [self.lbAccounting setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbAccounting setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbAccounting setTextColor:BLACKCOLOR1];
    [self addSubview:self.lbAccounting];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewLine];
    
    [self setViewFrame];
}

-(void)tapLawyer:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onLawyerClick) {
            self.onLawyerClick();
        }
    }
}

-(void)tapSecurities:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onSecuritiesClick) {
            self.onSecuritiesClick();
        }
    }
}

-(void)tapAccounting:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onAccountingClick) {
            self.onAccountingClick();
        }
    }
}

-(void)setViewFrame
{
    CGFloat iconW = 38/2;
    CGFloat iconH = 36/2;
    CGFloat titleH = 35;
    CGFloat lbH = 25;
    CGFloat viewW = APP_FRAME_WIDTH;
    [self.imgIcon setFrame:CGRectMake(10, titleH/2-iconH/2, iconW, iconH)];
    [self.lbTitle setFrame:CGRectMake(self.imgIcon.x*2+iconW, 5, 150, lbH)];
    
    [self.viewLine setFrame:CGRectMake(0, titleH, viewW, 1)];
    
    CGFloat imgS = 80;
    CGFloat imgY = titleH+15;
    CGFloat space = (viewW-imgS*3)/4;
    [self.imgLawyer setFrame:CGRectMake(space, imgY, imgS, imgS)];
    [self.imgSecurities setFrame:CGRectMake(space*2+imgS, imgY, imgS, imgS)];
    [self.imgAccounting setFrame:CGRectMake(space*3+imgS*2, imgY, imgS, imgS)];
    
    CGFloat lbY = self.imgLawyer.y+imgS+5;
    [self.lbLawyer setFrame:CGRectMake(self.imgLawyer.x, lbY, imgS, lbH)];
    [self.lbSecurities setFrame:CGRectMake(self.imgSecurities.x, lbY, imgS, lbH)];
    [self.lbAccounting setFrame:CGRectMake(self.imgAccounting.x, lbY, imgS, lbH)];
}

+(CGFloat)getViewH
{
    return 180;
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbLawyer);
    OBJC_RELEASE(_lbAccounting);
    OBJC_RELEASE(_lbSecurities);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_imgLawyer);
    OBJC_RELEASE(_imgAccounting);
    OBJC_RELEASE(_imgSecurities);
    OBJC_RELEASE(_viewLine);
}

@end
