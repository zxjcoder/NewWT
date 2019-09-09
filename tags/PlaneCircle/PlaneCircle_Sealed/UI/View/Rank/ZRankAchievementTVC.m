//
//  ZRankAchievementTVC.m
//  PlaneCircle
//
//  Created by Daniel on 8/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankAchievementTVC.h"

@interface ZRankAchievementTVC()

///律师事务所
@property (strong, nonatomic) UIButton *btnLawyer;
///会计事务所
@property (strong, nonatomic) UIButton *btnAccounting;
///证券公司
@property (strong, nonatomic) UIButton *btnSecurities;

@end

@implementation ZRankAchievementTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.cellH = self.getH;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.btnLawyer = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnLawyer setImage:[SkinManager getImageWithName:@"bangdan_btn_lvsuo"] forState:(UIControlStateNormal)];
    [self.btnLawyer setImage:[SkinManager getImageWithName:@"bangdan_btn_lvsuo"] forState:(UIControlStateHighlighted)];
    [self.btnLawyer setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnLawyer addTarget:self action:@selector(btnLawyerClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnLawyer setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.btnLawyer];
    
    self.btnAccounting = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnAccounting setImage:[SkinManager getImageWithName:@"bangdan_btn_kuaisuo"] forState:(UIControlStateNormal)];
    [self.btnAccounting setImage:[SkinManager getImageWithName:@"bangdan_btn_kuaisuo"] forState:(UIControlStateHighlighted)];
    [self.btnAccounting setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnAccounting addTarget:self action:@selector(btnAccountingClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnAccounting setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.btnAccounting];
    
    self.btnSecurities = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSecurities setImage:[SkinManager getImageWithName:@"bangdan_btn_zhengquangongsi"] forState:(UIControlStateNormal)];
    [self.btnSecurities setImage:[SkinManager getImageWithName:@"bangdan_btn_zhengquangongsi"] forState:(UIControlStateHighlighted)];
    [self.btnSecurities setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnSecurities addTarget:self action:@selector(btnSecuritiesClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnSecurities setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.btnSecurities];
}
-(void)btnLawyerClick
{
    if (self.onLawyerClick) {
        self.onLawyerClick();
    }
}

-(void)btnSecuritiesClick
{
    if (self.onSecuritiesClick) {
        self.onSecuritiesClick();
    }
}

-(void)btnAccountingClick
{
    if (self.onAccountingClick) {
        self.onAccountingClick();
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgW = 200/2;
    CGFloat imgH = 186/2;
    CGFloat imgY = 18;
    CGFloat space = (self.cellW-imgW*3)/6;
    [self.btnLawyer setFrame:CGRectMake(space, imgY, imgW, imgH)];
    [self.btnAccounting setFrame:CGRectMake(space*3+imgW, imgY, imgW, imgH)];
    [self.btnSecurities setFrame:CGRectMake(space*5+imgW*2, imgY, imgW, imgH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_btnLawyer);
    OBJC_RELEASE(_btnAccounting);
    OBJC_RELEASE(_btnSecurities);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 129;
}
+(CGFloat)getH
{
    return 129;
}

@end
