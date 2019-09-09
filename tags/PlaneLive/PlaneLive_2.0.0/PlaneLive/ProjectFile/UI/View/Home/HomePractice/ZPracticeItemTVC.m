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
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///主持人机构名称
@property (strong, nonatomic) UILabel *lbLecturerDesc;
///更新时间
@property (strong, nonatomic) UILabel *lbUpdateTime;
///收藏ICON
@property (strong, nonatomic) UIImageView *imgCollection;
///收藏
@property (strong, nonatomic) UILabel *lbCollection;
///评论ICON
@property (strong, nonatomic) UIImageView *imgQuestion;
///评论
@property (strong, nonatomic) UILabel *lbQuestion;
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
    
    self.cellH = [ZPracticeItemTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.viewLogoBG = [[UIView alloc] init];
    [self.viewLogoBG.layer setMasksToBounds:YES];
    [self.viewLogoBG setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
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
    
    self.lbUpdateTime = [[UILabel alloc] init];
    [self.lbUpdateTime setFont:[ZFont boldSystemFontOfSize:kFont_Minimum_Size]];
    [self.lbUpdateTime setNumberOfLines:1];
    [self.lbUpdateTime setTextColor:DESCCOLOR];
    [self.lbUpdateTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbUpdateTime];
    
    self.imgCollection = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"p_collection_b"]];
    [self.viewMain addSubview:self.imgCollection];
    
    self.imgQuestion = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"practice_question"]];
    [self.viewMain addSubview:self.imgQuestion];
    
    self.imgPraise = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"p_dianzan_b"]];
    [self.viewMain addSubview:self.imgPraise];
    
    self.lbCollection = [[UILabel alloc] init];
    [self.lbCollection setFont:[ZFont systemFontOfSize:kFont_Minimum_Size]];
    [self.lbCollection setNumberOfLines:1];
    [self.lbCollection setTextColor:DESCCOLOR];
    [self.lbCollection setText:@"0"];
    [self.lbCollection setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCollection setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCollection];
    
    self.lbQuestion = [[UILabel alloc] init];
    [self.lbQuestion setFont:[ZFont systemFontOfSize:kFont_Minimum_Size]];
    [self.lbQuestion setNumberOfLines:1];
    [self.lbQuestion setTextColor:DESCCOLOR];
    [self.lbQuestion setText:@"0"];
    [self.lbQuestion setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbQuestion setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbQuestion];
    
    self.lbPraise = [[UILabel alloc] init];
    [self.lbPraise setFont:[ZFont systemFontOfSize:kFont_Minimum_Size]];
    [self.lbPraise setNumberOfLines:1];
    [self.lbPraise setTextColor:DESCCOLOR];
    [self.lbPraise setText:@"0"];
    [self.lbPraise setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbPraise setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPraise];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
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
    
    CGFloat pY = self.cellH-self.lineMaxH-self.lbMinH-kSize10;
    CGFloat pW = [self.lbPraise getLabelWidthWithMinWidth:0];
    [self.lbPraise setFrame:CGRectMake(self.cellW-pW-self.space, pY, pW, self.lbMinH)];
    CGFloat iconS = 12;
    CGFloat iconL = 3;
    CGFloat isp = 2.5;
    [self.imgPraise setFrame:CGRectMake(self.lbPraise.x-iconS-iconL, pY+isp, iconS, iconS)];
    
    CGFloat cmW = [self.lbQuestion getLabelWidthWithMinWidth:0];
    [self.lbQuestion setFrame:CGRectMake(self.imgPraise.x-cmW-iconL-isp, pY, cmW, self.lbMinH)];
    [self.imgQuestion setFrame:CGRectMake(self.lbQuestion.x-iconS-iconL, pY+isp, iconS, iconS)];
    
    CGFloat clW = [self.lbCollection getLabelWidthWithMinWidth:0];
    [self.lbCollection setFrame:CGRectMake(self.imgQuestion.x-clW-iconL-isp, pY, clW, self.lbMinH)];
    [self.imgCollection setFrame:CGRectMake(self.lbCollection.x-iconS-iconL, pY+isp, iconS, iconS)];
    
    CGFloat lbUTH = 16;
    CGFloat lbUTW = self.imgCollection.x-rightX-kSize3;
    [self.lbUpdateTime setFrame:CGRectMake(rightX, lbLDY+lbLDH+kSize3, lbUTW, lbUTH)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
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
    if (model) {
        [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getPracticeImage]];
        
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
        if (model.qcount > kNumberMaxCount) {
            [self.lbQuestion setText:[NSString stringWithFormat:@"%d",kNumberMaxCount]];
        } else {
            [self.lbQuestion setText:[NSString stringWithFormat:@"%ld",model.qcount]];
        }
        [self.lbLecturer setText:[NSString stringWithFormat:@"%@: %@", kSpeaker, model.nickname]];
        [self.lbLecturer setLabelColorWithRange:NSMakeRange(0, 4) color:DESCCOLOR];
        
        [self.lbLecturerDesc setText:model.person_title];
        
        [self.lbUpdateTime setText:[NSString stringWithFormat:@"%@: %@", kUpdateTo, model.create_time]];
    }
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_imgPraise);
    OBJC_RELEASE(_imgQuestion);
    OBJC_RELEASE(_imgCollection);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewLogoBG);
    
    OBJC_RELEASE(_lbUpdateTime);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbPraise);
    OBJC_RELEASE(_lbQuestion);
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
    return self.cellH;
}
+(CGFloat)getH
{
    return 120;
}

@end
