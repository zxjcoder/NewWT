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
    [self.viewLogoBG setViewRound:kIMAGE_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.viewLogoBG];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.viewLogoBG addSubview:self.imgLogo];
    
    self.imgLock = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"free_of_charge"]];
    [self.imgLock setHidden:YES];
    [self.viewLogoBG addSubview:self.imgLock];
    
    [self.viewLogoBG bringSubviewToFront:self.imgLock];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setNumberOfLines:2];
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
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@ : 0分钟", kTimeDuration]];
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
    [self.lbAnswer setText:@"0个问答"];
    [self.lbAnswer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbAnswer];
    
    self.lbPraise = [[UILabel alloc] init];
    [self.lbPraise setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbPraise setNumberOfLines:1];
    [self.lbPraise setTextColor:DESCCOLOR];
    [self.lbPraise setText:@"0人点赞"];
    [self.lbPraise setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPraise];
    
    self.lbPrice = [[UILabel alloc] init];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextColor:MAINCOLOR];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine1 = [UIImageView getDLineView];
    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine2];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat sp = kSize11;
    CGFloat imgS = 100;
    CGFloat imgViewS = imgS;
    [self.viewLogoBG setFrame:CGRectMake(sp, sp, imgViewS, imgViewS)];
    [self.imgLogo setFrame:self.viewLogoBG.bounds];
    
    CGFloat lockW = 33;
    CGFloat lockH = 36;
    CGFloat lockX = 0;
    CGFloat lockY = 0;
    [self.imgLock setFrame:CGRectMake(lockX, lockY, lockW, lockH)];
    
    CGFloat rightX = self.viewLogoBG.x+imgViewS+sp;
    CGFloat rightW = self.cellW-rightX-sp;
    [self.lbTitle setFrame:CGRectMake(rightX, sp+2, rightW, self.lbH)];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > maxH) {
        titleH = maxH;
    }
    [self.lbTitle setFrame:CGRectMake(self.lbTitle.x, self.lbTitle.y, self.lbTitle.width, titleH)];
    
    CGFloat lbLY = self.lbTitle.y + titleH + 10;
    [self.lbLecturer setFrame:CGRectMake(rightX, lbLY, rightW, self.lbMinH)];
    
    CGFloat timeY = self.lbLecturer.y+self.lbLecturer.height+8;
    CGFloat priceY = self.cellH-70;
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

-(CGFloat)setCellDataWithModel:(ModelPractice *)model
{
    [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getPracticeImage]];
    
    [self.lbTitle setText:model.title];
    
    if (model.unlock == 1) {
        [self.lbPrice setText:[NSString stringWithFormat:@"¥%.2f", [model.price floatValue]]];
    } else {
        [self.lbPrice setText:kFreeCharge];
    }
    if (model.person_title.length > 0) {
        [self.lbLecturer setTextColor:DESCCOLOR];
        if (model.nickname.length > 0) {
            [self.lbLecturer setText:[NSString stringWithFormat:@"%@  %@",  model.nickname, model.person_title]];
            [self.lbLecturer setLabelColorWithRange:NSMakeRange(0, model.nickname.length) color:BLACKCOLOR1];
        } else {
            [self.lbLecturer setText:[NSString stringWithFormat:@"%@", model.person_title]];
        }
    } else {
        [self.lbLecturer setTextColor:BLACKCOLOR1];
        [self.lbLecturer setText:[NSString stringWithFormat:@"%@",  model.nickname]];
    }
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@ : %@", kTimeDuration, [Utils getMinuteFromSS:model.time]]];
    [self.lbPraise setText:[NSString stringWithFormat:@"%ld人点赞", model.applauds]];
    [self.lbAnswer setText:[NSString stringWithFormat:@"%ld个问答", model.qcount]];
    [self.lbUpdateTime setText:model.create_time];
    
    [self.imgLock setHidden:model.unlock==1];
    
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
