//
//  ZPurchasePracticeTVC.m
//  PlaneLive
//
//  Created by Daniel on 16/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPurchasePracticeTVC.h"
#import "Utils.h"

@interface ZPurchasePracticeTVC()

///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///主持人机构名称
@property (strong, nonatomic) UILabel *lbLecturerDesc;
///播放时间
@property (strong, nonatomic) UILabel *lbPlayTime;
///价格
@property (strong, nonatomic) UILabel *lbPrice;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZPurchasePracticeTVC

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
    
    self.cellH = [ZPurchasePracticeTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.viewLogoBG = [[UIView alloc] init];
    [self.viewLogoBG.layer setMasksToBounds:YES];
    [self.viewLogoBG setViewRound:kIMAGE_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.viewLogoBG];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.viewLogoBG addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[ZFont boldSystemFontOfSize:kFont_Least_Size]];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setTextColor:SPEAKERCOLOR];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturer];
    
    self.lbLecturerDesc = [[UILabel alloc] init];
    [self.lbLecturerDesc setFont:[ZFont boldSystemFontOfSize:kFont_Minimum_Size]];
    [self.lbLecturerDesc setNumberOfLines:1];
    [self.lbLecturerDesc setTextColor:DESCCOLOR];
    [self.lbLecturerDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturerDesc];
    
    self.lbPlayTime = [[UILabel alloc] init];
    [self.lbPlayTime setFont:[ZFont boldSystemFontOfSize:kFont_Minimum_Size]];
    [self.lbPlayTime setNumberOfLines:1];
    [self.lbPlayTime setTextColor:DESCCOLOR];
    [self.lbPlayTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPlayTime];
    
    self.lbPrice = [[UILabel alloc] init];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextColor:MAINCOLOR];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat sp = kSize11;
    CGFloat imgS = self.cellH-sp*2-self.lineMaxH;
    CGFloat imgViewS = imgS;
    [self.viewLogoBG setFrame:CGRectMake(sp, sp, imgViewS, imgViewS)];
    [self.imgLogo setFrame:self.viewLogoBG.bounds];
    
    CGFloat rightX = self.viewLogoBG.x+imgViewS+sp;
    CGFloat rightW = self.cellW-rightX-sp;
    [self.lbTitle setFrame:CGRectMake(rightX, sp, rightW, self.lbH)];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > maxH) {
        titleH = maxH;
    }
    [self.lbTitle setFrame:CGRectMake(self.lbTitle.x, self.lbTitle.y, self.lbTitle.width, titleH)];
    
    CGFloat lbLY = self.lbTitle.y + maxH + kSize3;
    [self.lbLecturer setFrame:CGRectMake(rightX, lbLY, rightW, self.lbMinH)];
    
    CGFloat lbLDY = self.lbLecturer.y+self.lbLecturer.height+1;
    CGFloat lbLDH = 16;
    
    [self.lbLecturerDesc setFrame:CGRectMake(rightX, lbLDY, rightW, lbLDH)];
    
    CGFloat lbUTH = 16;
    CGFloat timeY = lbLDY+lbLDH+kSize3;
    CGFloat priceY = lbLDY+kSize15;
    CGFloat priceW = 120;
    [self.lbPrice setFrame:CGRectMake(self.cellW-priceW-kSizeSpace, priceY, priceW, self.lbH)];
    
    CGFloat lbUTW = self.lbPrice.x-rightX-kSize3;
    [self.lbPlayTime setFrame:CGRectMake(rightX, timeY, lbUTW, lbUTH)];
    
    [self.imgLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
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
    
    [self.lbPrice setText:[NSString stringWithFormat:@"¥%.2f", [model.price floatValue]]];
    
    [self.lbLecturer setText:[NSString stringWithFormat:@"%@: %@", kSpeaker, model.nickname]];
    [self.lbLecturer setLabelColorWithRange:NSMakeRange(0, 4) color:DESCCOLOR];
    
    [self.lbLecturerDesc setText:model.person_title];
    
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getHHMMSSFromSS:model.time]]];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_viewLogoBG);
    
    OBJC_RELEASE(_lbPlayTime);
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
    return 120;
}

@end
