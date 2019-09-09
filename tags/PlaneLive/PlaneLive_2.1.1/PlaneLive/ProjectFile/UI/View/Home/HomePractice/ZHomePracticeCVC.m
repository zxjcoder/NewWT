//
//  ZHomePracticeCVC.m
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomePracticeCVC.h"
#import "ZImageView.h"
#import "ZView.h"
#import "ZLabel.h"
#import "ZCalculateLabel.h"

@interface ZHomePracticeCVC()

///内容区域
@property (strong, nonatomic) ZView *viewMain;
///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
///LOGO上锁
@property (strong, nonatomic) UIImageView *imgLock;
///游戏名称
@property (strong, nonatomic) ZLabel *lbTitle;
///数据源
@property (strong, nonatomic) ModelPractice *model;

@end

@implementation ZHomePracticeCVC

-(void)innerInit
{
    if (!self.viewMain) {
        self.viewMain = [[ZView alloc] init];
        [self.viewMain setBackgroundColor:WHITECOLOR];
        [self.viewMain setUserInteractionEnabled:YES];
        [self.contentView addSubview:self.viewMain];
    }
    if (!self.viewLogoBG) {
        self.viewLogoBG = [[UIView alloc] init];
        [self.viewLogoBG.layer setMasksToBounds:YES];
        [self.viewLogoBG setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
        [self.viewMain addSubview:self.viewLogoBG];
    }
    if (!self.imgLogo) {
        self.imgLogo = [[ZImageView alloc] init];
        [self.viewLogoBG addSubview:self.imgLogo];
    }
    if (!self.imgLock) {
        self.imgLock = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_practice_charge"]];
        [self.imgLock setHidden:YES];
        [self.viewLogoBG addSubview:self.imgLock];
    }
    
    [self.viewLogoBG bringSubviewToFront:self.imgLock];
    
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] init];
        [self.lbTitle setTextColor:BLACKCOLOR1];
        [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbTitle setNumberOfLines:2];
        [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
        [self.viewMain addSubview:self.lbTitle];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewMain setFrame:self.contentView.bounds];
    
    CGFloat space = 5;
    CGFloat imgSize = self.width;
    CGFloat imgSpace = (self.viewMain.width-imgSize)/2;
    [self.viewLogoBG setFrame:CGRectMake(imgSpace, space, imgSize, imgSize)];
    [self.imgLogo setFrame:self.viewLogoBG.bounds];
    
    CGFloat lockW = 33;
    CGFloat lockH = 36;
    CGFloat lockX = 0;
    CGFloat lockY = 0;
    [self.imgLock setFrame:CGRectMake(lockX, lockY, lockW, lockH)];
    
    CGRect titleFrame = CGRectMake(self.viewLogoBG.x, self.viewLogoBG.y+self.viewLogoBG.height+kSize3, self.viewLogoBG.width, 0);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleHeight = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    titleFrame.size.height = titleHeight;
    [self.lbTitle setFrame:titleFrame];
}

-(void)setCellDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
    
    [self innerInit];
    
    [self.lbTitle setText:model.title];
    [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getPracticeImage]];
    
    [self.imgLock setHidden:model.unlock==0];
    
    [self setNeedsDisplay];
}

-(void)dealloc
{
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_imgLock);
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_viewLogoBG);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_model);
}

@end
