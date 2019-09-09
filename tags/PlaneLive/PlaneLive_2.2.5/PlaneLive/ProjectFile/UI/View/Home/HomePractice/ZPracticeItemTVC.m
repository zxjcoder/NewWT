//
//  ZPracticeItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeItemTVC.h"
#import "Utils.h"

@interface ZPracticeItemTVC()

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
///更新时间
@property (strong, nonatomic) UILabel *lbUpdateTime;
///价格
@property (strong, nonatomic) UILabel *lbPrice;
///时长
@property (strong, nonatomic) UILabel *lbPlayTime;
///点赞
@property (strong, nonatomic) UILabel *lbPraise;
///回答
@property (strong, nonatomic) UILabel *lbAnswer;
///分割线
@property (strong, nonatomic) UIImageView *imgLine1;
@property (strong, nonatomic) UIImageView *imgLine2;
///收听
@property (strong, nonatomic) ZView *viewListen;
///收听ICON
@property (strong, nonatomic) UIImageView *imgListen;
///收听数量
@property (strong, nonatomic) ZLabel *lbListen;

@end

@implementation ZPracticeItemTVC

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
    
    self.cellH = [ZPracticeItemTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.viewLogoBG = [[UIView alloc] init];
    [self.viewLogoBG.layer setMasksToBounds:YES];
    [self.viewMain addSubview:self.viewLogoBG];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.viewLogoBG addSubview:self.imgLogo];
    
    self.imgLock = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"free_of_charge"]];
    [self.imgLock setHidden:YES];
    [self.viewLogoBG addSubview:self.imgLock];
    
    [self.viewLogoBG bringSubviewToFront:self.imgLock];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setNumberOfLines:3];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setTextColor:DESCCOLOR];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturer];
    
    self.lbPlayTime = [[UILabel alloc] init];
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@ : 0%@", kTimeDuration, kMinute]];
    [self.lbPlayTime setTextColor:DESCCOLOR];
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.viewMain addSubview:self.lbPlayTime];
    
    self.lbUpdateTime = [[UILabel alloc] init];
    [self.lbUpdateTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbUpdateTime setNumberOfLines:1];
    [self.lbUpdateTime setTextColor:DESCCOLOR];
    [self.lbUpdateTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbUpdateTime];
    
    self.lbAnswer = [[UILabel alloc] init];
    [self.lbAnswer setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbAnswer setNumberOfLines:1];
    [self.lbAnswer setTextColor:DESCCOLOR];
    [self.lbAnswer setText:[NSString stringWithFormat:@"0%@", kQuestionAndAnswer]];
    [self.lbAnswer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbAnswer];
    
    self.lbPraise = [[UILabel alloc] init];
    [self.lbPraise setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbPraise setNumberOfLines:1];
    [self.lbPraise setTextColor:DESCCOLOR];
    [self.lbPraise setText:[NSString stringWithFormat:@"0%@", kPeoplePointPraise]];
    [self.lbPraise setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPraise];
    
    self.lbPrice = [[UILabel alloc] init];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextColor:MAINCOLOR];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine1 = [UIImageView getDLineView];
    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine2];
    
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
    
    [self.imgLine1 setFrame:CGRectMake(11, self.lbPrice.y+self.lbPrice.height+14, self.cellW-11*2, kLineHeight)];
    
    CGFloat buttomY = self.imgLine1.y+self.imgLine1.height+5;
    [self.lbUpdateTime setFrame:CGRectMake(kSizeSpace, buttomY, 120, 20)];
    
    CGRect answerFrame = CGRectMake(0, buttomY, 10, 20);
    [self.lbAnswer setFrame:answerFrame];
    CGFloat answerW = [self.lbAnswer getLabelWidthWithMinWidth:10];
    answerFrame.origin.x = self.cellW-kSizeSpace-answerW;
    answerFrame.size.width = answerW;
    [self.lbAnswer setFrame:answerFrame];
    
    CGRect praiseFrame = CGRectMake(0, buttomY, 10, 20);
    [self.lbPraise setFrame:praiseFrame];
    CGFloat praiseW = [self.lbPraise getLabelWidthWithMinWidth:10];
    praiseFrame.origin.x = self.lbAnswer.x-10-praiseW;
    praiseFrame.size.width = praiseW;
    [self.lbPraise setFrame:praiseFrame];
    
    [self.imgLine2 setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
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
-(void)setHiddenPrice
{
    [self.lbPrice setHidden:YES];
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
        } else {
            [self.lbLecturer setText:[NSString stringWithFormat:@"%@", model.person_title]];
        }
    } else {
        [self.lbLecturer setText:[NSString stringWithFormat:@"%@",  model.nickname]];
    }
    if (model.hits > kNumberMaximumCount) {
        [self.lbListen setText:[NSString stringWithFormat:@"%.1f%@", (float)(model.hits/(float)(kNumberMaximumCount+1)), kMillion]];
    } else {
        [self.lbListen setText:[NSString stringWithFormat:@"%ld", model.hits]];
    }
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@ : %@", kTimeDuration, [Utils getMinuteFromSS:model.time]]];
    [self.lbPraise setText:[NSString stringWithFormat:@"%ld%@", (long)model.applauds, kPeoplePointPraise]];
    [self.lbAnswer setText:[NSString stringWithFormat:@"%ld%@", (long)model.qcount, kQuestionAndAnswer]];
    [self.lbUpdateTime setText:model.create_time];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
    OBJC_RELEASE(_lbPraise);
    OBJC_RELEASE(_lbAnswer);
    OBJC_RELEASE(_lbPlayTime);
    OBJC_RELEASE(_viewLogoBG);
    OBJC_RELEASE(_imgLock);
    OBJC_RELEASE(_viewListen);
    OBJC_RELEASE(_imgListen);
    OBJC_RELEASE(_lbListen);
    OBJC_RELEASE(_lbUpdateTime);
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
    return 160;
}

@end
