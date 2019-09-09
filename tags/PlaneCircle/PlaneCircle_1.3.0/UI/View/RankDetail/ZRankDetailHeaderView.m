//
//  ZRankDetailHeaderView.m
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankDetailHeaderView.h"

@interface ZRankDetailHeaderView()

@property (strong, nonatomic) ZImageView *imgLogo;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbDesc;

@property (strong, nonatomic) UIButton *btnUpd;

@property (strong, nonatomic) UIView *viewLine;

@property (assign, nonatomic) CGFloat viewHeight;

@property (strong, nonatomic) ModelEntity *model;

@end

@implementation ZRankDetailHeaderView

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
    self.viewHeight = 100;
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.imgLogo setViewRound:3 borderWidth:0.7 borderColor:TABLEVIEWCELL_LINECOLOR];
    [[self.imgLogo layer] setMasksToBounds:YES];
    [self addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbDesc setNumberOfLines:0];
    [self addSubview:self.lbDesc];
    
    self.btnUpd = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnUpd setTitle:@"修正" forState:(UIControlStateNormal)];
    [self.btnUpd setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [self.btnUpd setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnUpd titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnUpd addTarget:self action:@selector(btnUpdClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnUpd];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:self.viewLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat imgS = 70;
    CGFloat viewW = APP_FRAME_WIDTH;
    
    [self.imgLogo setFrame:CGRectMake(10, 15, 70, 70)];
    CGFloat rightX = 10+imgS+10;
    CGFloat rightW = viewW-rightX-10;
    
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
    
    [self.btnUpd setFrame:CGRectMake(viewW-65, self.lbDesc.y+self.lbDesc.height+10, 55, 28)];
    
    self.viewHeight = (self.btnUpd.y+self.btnUpd.height)+10;
    if (self.viewHeight < 100) {
        self.viewHeight = 100;
    }
    [self.viewLine setFrame:CGRectMake(0, self.viewHeight-1, viewW, 1)];
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

-(void)setViewDataWithModel:(ModelEntity *)model
{
    [self setModel:model];
    if (model) {
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
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.viewHeight;
}

@end
