//
//  ZPracticeItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeItemTVC.h"
#import "Utils.h"

@interface ZPracticeItemTVC()

///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
///时间区域
@property (strong, nonatomic) UIView *viewTime;
///时间背景
@property (strong, nonatomic) UIView *viewTimeBg;
///时间ICON
@property (strong, nonatomic) UIImageView *imgTime;
///时间
@property (strong, nonatomic) UILabel *lbTime;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///主持人描述
@property (strong, nonatomic) UILabel *lbLecturerDesc;
///收藏ICON
@property (strong, nonatomic) UIImageView *imgCollection;
///收藏
@property (strong, nonatomic) UILabel *lbCollection;
///评论ICON
@property (strong, nonatomic) UIImageView *imgComment;
///评论
@property (strong, nonatomic) UILabel *lbComment;
///赞ICON
@property (strong, nonatomic) UIImageView *imgPraise;
///赞
@property (strong, nonatomic) UILabel *lbPraise;
///分割线
@property (strong, nonatomic) UIView *viewLine;

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
    
    self.cellH = self.getH;
    
    self.viewLogoBG = [[UIView alloc] init];
    [self.viewLogoBG setBackgroundColor:CLEARCOLOR];
    [[self.viewLogoBG layer] setMasksToBounds:YES];
    [self.viewLogoBG setViewRound:4 borderWidth:1 borderColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLogoBG];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.viewLogoBG addSubview:self.imgLogo];
    
    self.viewTime = [[UIView alloc] init];
    [self.viewTime setBackgroundColor:CLEARCOLOR];
    [self.viewTime setClipsToBounds:NO];
    [self.viewLogoBG addSubview:self.viewTime];
    
    self.viewTimeBg = [[UIView alloc] init];
    [self.viewTimeBg setBackgroundColor:BLACKCOLOR];
    [self.viewTimeBg setAlpha:0.4];
    [self.viewTime addSubview:self.viewTimeBg];
    
    self.imgTime = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"p_timeicon_wt"]];
    [self.viewTime addSubview:self.imgTime];
    
    self.lbTime = [[UILabel alloc] init];
    [self.lbTime setFont:[UIFont systemFontOfSize:10]];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTime setTextColor:WHITECOLOR];
    [self.lbTime setText:@"00:00"];
    [self.viewTime addSubview:self.lbTime];
    
    [self.viewLogoBG bringSubviewToFront:self.viewTime];
    [self.viewLogoBG sendSubviewToBack:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[UIFont boldSystemFontOfSize:kFont_Small_Size]];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setTextColor:MAINCOLOR];
    [self.lbLecturer setText:@"主持人: "];
    [self.lbLecturer setLabelColorWithRange:NSMakeRange(0, 4) color:DESCCOLOR];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturer];
    
    self.lbLecturerDesc = [[UILabel alloc] init];
    [self.lbLecturerDesc setFont:[UIFont boldSystemFontOfSize:kFont_Min_Size]];
    [self.lbLecturerDesc setNumberOfLines:1];
    [self.lbLecturerDesc setTextColor:DESCCOLOR];
    [self.lbLecturerDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturerDesc];
    
    self.imgCollection = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"p_collection_b"]];
    [self.viewMain addSubview:self.imgCollection];
    
    self.imgComment = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"p_icon_comment"]];
    [self.viewMain addSubview:self.imgComment];
    
    self.imgPraise = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"p_dianzan_b"]];
    [self.viewMain addSubview:self.imgPraise];
    
    self.lbCollection = [[UILabel alloc] init];
    [self.lbCollection setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbCollection setNumberOfLines:1];
    [self.lbCollection setTextColor:DESCCOLOR];
    [self.lbCollection setText:@"0"];
    [self.lbCollection setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCollection setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCollection];
    
    self.lbComment = [[UILabel alloc] init];
    [self.lbComment setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbComment setNumberOfLines:1];
    [self.lbComment setTextColor:DESCCOLOR];
    [self.lbComment setText:@"0"];
    [self.lbComment setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbComment setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbComment];
    
    self.lbPraise = [[UILabel alloc] init];
    [self.lbPraise setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbPraise setNumberOfLines:1];
    [self.lbPraise setTextColor:DESCCOLOR];
    [self.lbPraise setText:@"0"];
    [self.lbPraise setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbPraise setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPraise];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat sp = 8;
    CGFloat imgS = self.cellH-sp*2-self.lineMaxH-24;
    [self.viewLogoBG setFrame:CGRectMake(sp, sp+5, imgS, imgS)];
    [self.imgLogo setFrame:self.viewLogoBG.bounds];
    
     CGFloat bgH = 20;
    [self.viewTime setFrame:CGRectMake(0, self.imgLogo.y+self.imgLogo.height-bgH, imgS, bgH)];
    [self.viewTimeBg setFrame:self.viewTime.bounds];
    
    CGFloat timeS = 10;
    [self.lbTime setFrame:CGRectMake(timeS/2, self.viewTimeBg.y, imgS-timeS/2, bgH)];
    CGFloat timeW = [self.lbTime getLabelWidthWithMinWidth:0];
    CGFloat timeY = self.viewTimeBg.height/2-timeS/2;
    CGFloat timeX = imgS/2-timeW/2-timeS-2+timeS/2-2;
    [self.imgTime setFrame:CGRectMake(timeX, self.viewTimeBg.y+timeY, timeS, timeS)];
    
    [self.lbTime setFrame:CGRectMake(timeS/2, self.viewTimeBg.y, imgS-timeS/2, bgH)];
    
    CGFloat rightX = self.viewLogoBG.x+imgS+self.space;
    CGFloat rightW = self.cellW-rightX-self.space;
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    if (titleH > self.lbH) {
        titleH = 40;
    }
    [self.lbTitle setFrame:CGRectMake(rightX, self.space, rightW, titleH)];
    
    CGFloat lY = self.lbTitle.y + 40 + 2;
    [self.lbLecturer setFrame:CGRectMake(rightX, lY, rightW, self.lbMinH)];
    
    CGFloat ldY = self.lbLecturer.y+self.lbLecturer.height;
    [self.lbLecturerDesc setFrame:CGRectMake(rightX, ldY, rightW, 16)];
    
    CGFloat pY = self.cellH-self.lineMaxH-self.lbMinH-5;
    CGFloat pW = [self.lbPraise getLabelWidthWithMinWidth:0];
    [self.lbPraise setFrame:CGRectMake(self.cellW-pW-self.space, pY, pW, self.lbMinH)];
    CGFloat iconS = 12;
    CGFloat iconL = 3;
    CGFloat isp = 4;
    [self.imgPraise setFrame:CGRectMake(self.lbPraise.x-iconS-iconL, pY+isp, iconS, iconS)];
    
    CGFloat cmW = [self.lbComment getLabelWidthWithMinWidth:0];
    [self.lbComment setFrame:CGRectMake(self.imgPraise.x-cmW-iconL-isp, pY, cmW, self.lbMinH)];
    [self.imgComment setFrame:CGRectMake(self.lbComment.x-iconS-iconL, pY+isp, iconS, iconS)];
    
    CGFloat clW = [self.lbCollection getLabelWidthWithMinWidth:0];
    [self.lbCollection setFrame:CGRectMake(self.imgComment.x-clW-iconL-isp, pY, clW, self.lbMinH)];
    [self.imgCollection setFrame:CGRectMake(self.lbCollection.x-iconS-iconL, pY+isp, iconS, iconS)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
}

-(void)setCellDataWithModel:(ModelPractice *)model
{
    if (model) {
        [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getImageWithName:@"new_p_image_default"]];
        
        NSString *strTime = [Utils getHHMMSSFromSS:model.time];
        [self.lbTime setText:strTime];
        
        [self.lbTitle setText:model.title];
        
        if (model.applauds > kNumberMaxCount) {
            [self.lbPraise setText:[NSString stringWithFormat:@"%d",kNumberMaxCount]];
        } else {
            [self.lbPraise setText:[NSString stringWithFormat:@"%ld",model.applauds]];
        }
        if (model.ccount > kNumberMaxCount) {
            [self.lbCollection setText:[NSString stringWithFormat:@"%d",kNumberMaxCount]];
        } else {
            [self.lbCollection setText:[NSString stringWithFormat:@"%ld",model.ccount]];
        }
        if (model.mcount > kNumberMaxCount) {
            [self.lbComment setText:[NSString stringWithFormat:@"%d",kNumberMaxCount]];
        } else {
            [self.lbComment setText:[NSString stringWithFormat:@"%ld",model.mcount]];
        }
        [self.lbLecturer setText:[NSString stringWithFormat:@"主持人: %@",model.nickname]];
        [self.lbLecturer setLabelColorWithRange:NSMakeRange(0, 4) color:DESCCOLOR];
        
        [self.lbLecturerDesc setText:model.person_synopsis];
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_imgTime);
    OBJC_RELEASE(_imgPraise);
    OBJC_RELEASE(_imgComment);
    OBJC_RELEASE(_imgCollection);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewLogoBG);
    OBJC_RELEASE(_viewTime);
    OBJC_RELEASE(_viewTimeBg);
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbPraise);
    OBJC_RELEASE(_lbComment);
    OBJC_RELEASE(_lbLecturer);
    OBJC_RELEASE(_lbCollection);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return 120;
}
+(CGFloat)getH
{
    return 120;
}

@end
