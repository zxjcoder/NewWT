//
//  ZRankDetailHeaderTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankDetailHeaderTVC.h"

@interface ZRankDetailHeaderTVC()

@property (strong, nonatomic) ZImageView *imgLogo;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbDesc;

@property (strong, nonatomic) UIButton *btnUpd;

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) ModelEntity *model;

@end

@implementation ZRankDetailHeaderTVC

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
    
    self.cellH = 100;
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.imgLogo setViewRound:3 borderWidth:0.7 borderColor:TABLEVIEWCELL_LINECOLOR];
    [[self.imgLogo layer] setMasksToBounds:YES];
    [self.viewMain addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setNumberOfLines:0];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbDesc];
    
    self.btnUpd = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnUpd setTitle:kCorrection forState:(UIControlStateNormal)];
    [self.btnUpd setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [self.btnUpd setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnUpd titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnUpd addTarget:self action:@selector(btnUpdClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnUpd];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat imgS = 70;
    
    [self.imgLogo setFrame:CGRectMake(10, 15, 70, 70)];
    CGFloat rightX = 10+imgS+10;
    CGFloat rightW = self.cellW-rightX-10;
    
    CGRect titleFrame = CGRectMake(rightX, 15, rightW, 20);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:20];
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    CGRect descFrame = CGRectMake(rightX, self.lbTitle.y+self.lbTitle.height+10, rightW, 18);
    [self.lbDesc setFrame:descFrame];
    CGFloat descH = [self.lbDesc getLabelHeightWithMinHeight:18];
    descFrame.size.height = descH;
    [self.lbDesc setFrame:descFrame];
    
    [self.btnUpd setFrame:CGRectMake(self.cellW-65, self.lbDesc.y+self.lbDesc.height+10, 55, 28)];
    
    self.cellH = (self.btnUpd.y+self.btnUpd.height)+10;
    if (self.cellH < 100) {
        self.cellH = 100;
    }
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)btnUpdClick
{
    if ([self.model isKindOfClass:[ModelRankCompany class]]) {
        ModelRankCompany *modelRC = (ModelRankCompany*)self.model;
        if (self.onUpdRankCompanyClick) {
            self.onUpdRankCompanyClick(modelRC);
        }
    } else if ([self.model isKindOfClass:[ModelRankUser class]]) {
        ModelRankUser *modelRU = (ModelRankUser*)self.model;
        if (self.onUpdRankUserClick) {
            self.onUpdRankUserClick(modelRU);
        }
    }
}

-(void)setCellDataWithModel:(ModelEntity *)model
{
    [self setModel:model];
    
    if ([model isKindOfClass:[ModelRankCompany class]]) {
        ModelRankCompany *modelRC = (ModelRankCompany*)model;
        [self.imgLogo setImageURLStr:modelRC.company_img placeImage:[SkinManager getImageWithName:@"icon_orgnazation"]];
        [self.lbTitle setText:modelRC.company_name];
        [self.lbDesc setText:modelRC.synopsis];
    } else if ([model isKindOfClass:[ModelRankUser class]]) {
        ModelRankUser *modelRU = (ModelRankUser*)model;
        [self.imgLogo setPhotoURLStr:modelRU.operator_img placeImage:[SkinManager getImageWithName:@"new_user_photo"]];
        [self.lbTitle setText:modelRU.nickname];
        [self.lbDesc setText:modelRU.company_name];
    }
    [self setViewFrame];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_btnUpd);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_model);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}

@end
