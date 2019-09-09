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
///收听
@property (strong, nonatomic) ZView *viewListen;
///收听ICON
@property (strong, nonatomic) UIImageView *imgListen;
///收听数量
@property (strong, nonatomic) ZLabel *lbListen;

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
        self.imgLock = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"free_of_charge"]];
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
    if (!self.viewListen) {
        self.viewListen = [[ZView alloc] init];
        [self.viewListen setBackgroundColor:BLACKCOLOR];
        [self.viewListen setAlpha:0.3];
        [self.viewLogoBG addSubview:self.viewListen];
        [self.viewLogoBG bringSubviewToFront:self.viewListen];
    }
    if (!self.imgListen) {
        self.imgListen = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"listen_icon"]];
        [self.viewLogoBG addSubview:self.imgListen];
        [self.viewLogoBG bringSubviewToFront:self.imgListen];
    }
    if (!self.lbListen) {
        self.lbListen = [[ZLabel alloc] init];
        [self.lbListen setTextColor:WHITECOLOR];
        [self.lbListen setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbListen setNumberOfLines:1];
        [self.lbListen setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
        [self.viewLogoBG addSubview:self.lbListen];
        [self.viewLogoBG bringSubviewToFront:self.lbListen];
    }
}
-(void)setViewFrame
{
    [self.viewMain setFrame:CGRectMake(0, 0, self.width, self.height)];
    
    CGFloat space = 5;
    CGFloat imgSize = self.width;
    CGFloat imgSpace = (self.viewMain.width-imgSize)/2;
    [self.viewLogoBG setFrame:CGRectMake(imgSpace, space, imgSize, imgSize)];
    [self.imgLogo setFrame:self.viewLogoBG.bounds];
    
    CGFloat lockW = 38;
    CGFloat lockH = 33;
    CGFloat lockX = 0;
    CGFloat lockY = 0;
    [self.imgLock setFrame:CGRectMake(lockX, lockY, lockW, lockH)];
    
    [self.viewListen setFrame:CGRectMake(0, self.viewLogoBG.height-18, self.viewLogoBG.width, 18)];
    CGRect lbListenFrame = CGRectMake(0, self.viewLogoBG.height-18, 10, 18);
    [self.lbListen setFrame:lbListenFrame];
    CGFloat lbListenW = [self.lbListen getLabelWidthWithMinWidth:10];
    lbListenFrame.size.width = lbListenW+2;
    lbListenFrame.origin.x = self.viewLogoBG.width-lbListenW-5;
    [self.lbListen setFrame:lbListenFrame];
    
    [self.imgListen setFrame:CGRectMake(lbListenFrame.origin.x-5-13, lbListenFrame.origin.y+18/2-11/2, 13, 11)];
    
    CGRect titleFrame = CGRectMake(self.viewLogoBG.x, self.viewLogoBG.y+self.viewLogoBG.height+kSize10, self.viewLogoBG.width, 0);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:0];
    if (titleH > titleMaxH) {
        titleFrame.size.height = titleMaxH;
    } else {
        titleFrame.size.height = titleH;
    }
    [self.lbTitle setFrame:titleFrame];
}

-(void)setCellDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
    
    [self innerInit];
    
    [self.lbTitle setText:model.title];
    [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getPracticeImage]];
    
    //[self.imgLock setHidden:model.unlock==1];
    
    if (model.hits > kNumberMaximumCount) {
        [self.lbListen setText:[NSString stringWithFormat:@"%.1f%@", (float)(model.hits/(float)(kNumberMaximumCount+1)), kMillion]];
    } else {
        [self.lbListen setText:[NSString stringWithFormat:@"%ld", model.hits]];
    }
    [self setViewFrame];
}

-(void)dealloc
{
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_imgLock);
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_viewLogoBG);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewListen);
    OBJC_RELEASE(_imgListen);
    OBJC_RELEASE(_lbListen);
    OBJC_RELEASE(_model);
}

@end
