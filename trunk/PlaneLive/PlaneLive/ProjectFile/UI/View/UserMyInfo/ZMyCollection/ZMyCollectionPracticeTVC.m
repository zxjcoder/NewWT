//
//  ZMyCollectionPracticeTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCollectionPracticeTVC.h"
#import "Utils.h"

@interface ZMyCollectionPracticeTVC()

///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///价格
@property (strong, nonatomic) UILabel *lbPrice;
///时长
@property (strong, nonatomic) UILabel *lbPlayTime;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) ModelPractice *modelP;

@end

@implementation ZMyCollectionPracticeTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.cellH = [ZMyCollectionPracticeTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.viewLogoBG = [[UIView alloc] init];
    [self.viewLogoBG.layer setMasksToBounds:YES];
    [self.viewLogoBG setViewRound:kIMAGE_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.viewLogoBG];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.viewLogoBG addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setTextColor:COLORTEXT3];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturer];
    
    self.lbPlayTime = [[UILabel alloc] init];
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@ : 0%@", kTimeDuration, kMinute]];
    [self.lbPlayTime setTextColor:COLORTEXT3];
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbPlayTime];
    
    self.lbPrice = [[UILabel alloc] init];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setHidden:true];
    [self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine = [UIImageView getDLineView];
    [self.viewMain addSubview:self.imgLine];
    [self setViewFrame];
}

-(void)setViewFrame
{
    self.space = 20;
    CGFloat imgS = 100;
    CGFloat imgViewS = imgS;
    [self.viewLogoBG setFrame:CGRectMake(self.space, 15, imgViewS, imgViewS)];
    [self.imgLogo setFrame:self.viewLogoBG.bounds];
    
    CGFloat lbRightX = self.viewLogoBG.x + self.viewLogoBG.width + 15;
    CGFloat lbRightW = self.cellW - lbRightX - self.space;
    CGRect titleFrame = CGRectMake(lbRightX, self.viewLogoBG.y-1, lbRightW, self.lbMinH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleNewH = [self.lbTitle getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:self.lbTitle.font width:self.lbTitle.width]*self.lbTitle.numberOfLines;
    if (titleNewH < titleMaxH) {
        titleFrame.size.height = titleNewH;
    } else {
        titleFrame.size.height = titleMaxH;
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGRect lecturerFrame = CGRectMake(lbRightX, self.lbTitle.y + self.lbTitle.height + 6, lbRightW, self.lbMinH);
    [self.lbLecturer setFrame:lecturerFrame];
  
    CGFloat priceY =self.viewLogoBG.y + self.viewLogoBG.height - self.lbH;
    CGFloat priceW = 120;
    [self.lbPrice setFrame:CGRectMake(self.cellW-priceW-self.space, priceY, priceW, self.lbH)];
    
    CGFloat timeY = self.viewLogoBG.y + self.viewLogoBG.height - self.lbMinH;
    [self.lbPlayTime setFrame:CGRectMake(lbRightX, timeY, 200, self.lbMinH)];
    
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight)];
    
    [self.viewMain setFrame:self.getMainFrame];
}
///隐藏分割线
-(void)setHiddenLine:(BOOL)hidden
{
    [self.imgLine setHidden:hidden];
}
-(CGFloat)setCellDataWithModel:(ModelPractice *)model
{
    self.modelP = model;
    [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getDefaultImage]];
    
    [self.lbTitle setText:model.title];
  
    ///主讲人
    if (model.person_title.length > 0) {
        if (model.nickname.length > 0) {
            [self.lbLecturer setText:[NSString stringWithFormat:@"%@ %@",  model.nickname, model.person_title]];
        } else {
            [self.lbLecturer setText:model.person_title];
        }
    } else {
        [self.lbLecturer setText:model.nickname];
    }
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getMinuteFromSS:model.time]]];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_lbPlayTime);
    OBJC_RELEASE(_viewLogoBG);
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
    return 130;
}

@end
