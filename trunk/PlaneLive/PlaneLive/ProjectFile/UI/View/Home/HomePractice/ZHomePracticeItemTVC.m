//
//  ZHomePracticeItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/05/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZHomePracticeItemTVC.h"

@interface ZHomePracticeItemTVC()

///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
///LOGO上锁
@property (strong, nonatomic) UIImageView *imgLock;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///价格
@property (strong, nonatomic) UILabel *lbPrice;
///时长
@property (strong, nonatomic) UILabel *lbPlayTime;
//分割线
@property (strong, nonatomic) UIImageView *imgLine;
///收听
@property (strong, nonatomic) ZView *viewListen;
///收听ICON
@property (strong, nonatomic) UIImageView *imgListen;
///收听数量
@property (strong, nonatomic) ZLabel *lbListen;

@end

@implementation ZHomePracticeItemTVC

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
    
    self.cellH = [ZHomePracticeItemTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.viewLogoBG = [[UIView alloc] init];
    [self.viewLogoBG.layer setMasksToBounds:YES];
    //[self.viewLogoBG setViewRound:kIMAGE_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.viewLogoBG];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.viewLogoBG addSubview:self.imgLogo];
    
    self.imgLock = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"free_of_charge"]];
    [self.imgLock setHidden:YES];
    [self.viewLogoBG addSubview:self.imgLock];
    
    [self.viewLogoBG bringSubviewToFront:self.imgLock];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setNumberOfLines:3];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setTextColor:DESCCOLOR];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturer];
    
    self.lbPlayTime = [[UILabel alloc] init];
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@ : 0%@", kTimeDuration, kMinute]];
    [self.lbPlayTime setTextColor:DESCCOLOR];
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Minmum_Size]];
    [self.viewMain addSubview:self.lbPlayTime];
    
    self.lbPrice = [[UILabel alloc] init];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextColor:MAINCOLOR];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine = [UIImageView getDLineView];
    [self.viewMain addSubview:self.imgLine];
    
    if (!self.viewListen) {
        self.viewListen = [[ZView alloc] init];
        [self.viewListen setBackgroundColor:BLACKCOLOR];
        [self.viewListen setAlpha:0.3];
        [self.viewLogoBG addSubview:self.viewListen];
        [self.viewLogoBG bringSubviewToFront:self.viewListen];
    }
    if (!self.imgListen) {
        self.imgListen = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"listen_icon2"]];
        [self.viewLogoBG addSubview:self.imgListen];
        [self.viewLogoBG bringSubviewToFront:self.imgListen];
    }
    if (!self.lbListen) {
        self.lbListen = [[ZLabel alloc] init];
        [self.lbListen setTextColor:WHITECOLOR];
        [self.lbListen setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbListen setNumberOfLines:1];
        [self.lbListen setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.viewLogoBG addSubview:self.lbListen];
        [self.viewLogoBG bringSubviewToFront:self.lbListen];
    }
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat sp = kSize11;
    CGFloat imgS = 100;
    CGFloat imgViewS = imgS;
    [self.viewLogoBG setFrame:CGRectMake(sp, sp, imgViewS, imgViewS)];
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
    
    CGFloat rightX = self.viewLogoBG.x+imgViewS+sp;
    CGFloat rightW = self.cellW-rightX-sp;
    CGRect titleFrame = CGRectMake(rightX, sp+2, rightW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > maxH) {
        titleFrame.size.height = maxH;
    } else {
        titleFrame.size.height = titleH;
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGFloat lbLY = self.lbTitle.y + maxH + 5;
    [self.lbLecturer setFrame:CGRectMake(rightX, lbLY, rightW, self.lbMinH)];
    
    CGFloat timeY = self.lbLecturer.y+self.lbLecturer.height+3;
    CGFloat priceY = timeY;
    CGFloat priceW = 120;
    [self.lbPrice setFrame:CGRectMake(self.cellW-priceW-kSizeSpace, priceY, priceW, self.lbH)];
    
    [self.lbPlayTime setFrame:CGRectMake(rightX, timeY, 200, 18)];
    
    [self.imgLine setFrame:CGRectMake(sp, self.cellH-self.lineH, self.cellW-sp*2, self.lineH)];
}
-(void)setIsHiddenLineView:(BOOL)hidden
{
    [self.imgLine setHidden:hidden];
}
///播放中
-(void)setModelPlayStatus:(BOOL)isPlay
{
    if (isPlay) {
        [self.lbTitle setTextColor:MAINCOLOR];
    } else {
        [self.lbTitle setTextColor:BLACKCOLOR];
    }
}

-(CGFloat)setCellDataWithModel:(ModelPractice *)model
{
    [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getDefaultImage]];
    
    [self.lbTitle setText:model.title];
    
    if (model.unlock == 1) {
        [self.lbPrice setText:[NSString stringWithFormat:@"%.2f%@", [model.price floatValue], kPlaneMoney]];
    } else {
        [self.lbPrice setText:kFreeCharge];
    }
    if (model.person_title.length > 0) {
        [self.lbLecturer setTextColor:DESCCOLOR];
        if (model.nickname.length > 0) {
            [self.lbLecturer setText:[NSString stringWithFormat:@"%@ %@",  model.nickname, model.person_title]];
            //[self.lbLecturer setLabelColorWithRange:NSMakeRange(0, model.nickname.length) color:BLACKCOLOR1];
        } else {
            [self.lbLecturer setText:[NSString stringWithFormat:@"%@", model.person_title]];
        }
    } else {
        //[self.lbLecturer setTextColor:BLACKCOLOR1];
        [self.lbLecturer setText:[NSString stringWithFormat:@"%@",  model.nickname]];
    }
    if (model.hits > kNumberMaximumCount) {
        [self.lbListen setText:[NSString stringWithFormat:@"%.1f%@", (float)(model.hits/(float)(kNumberMaximumCount+1)), kMillion]];
    } else {
        [self.lbListen setText:[NSString stringWithFormat:@"%ld", model.hits]];
    }
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getMinuteFromSS:model.time]]];
    
    //[self.imgLock setHidden:model.unlock==1];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_lbPlayTime);
    OBJC_RELEASE(_viewLogoBG);
    OBJC_RELEASE(_imgLock);
    OBJC_RELEASE(_viewListen);
    OBJC_RELEASE(_imgListen);
    OBJC_RELEASE(_lbListen);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbPrice);
    OBJC_RELEASE(_lbLecturer);
    
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 125;
}

@end
