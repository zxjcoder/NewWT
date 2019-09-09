//
//  ZPracticePayInfoTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticePayInfoTVC.h"
#import "Utils.h"

@interface ZPracticePayInfoTVC()

///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///标题
@property (strong, nonatomic) ZLabel *lbTitle;
///团队
@property (strong, nonatomic) ZLabel *lbLecturer;
///时间
@property (strong, nonatomic) ZLabel *lbPlayTime;
///收听
@property (strong, nonatomic) ZView *viewListen;
///收听ICON
@property (strong, nonatomic) UIImageView *imgListen;
///收听数量
@property (strong, nonatomic) ZLabel *lbListen;
@property (strong, nonatomic) UIImageView *imgLine;
@property (strong, nonatomic) ModelPractice *model;

@end

@implementation ZPracticePayInfoTVC

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
    
    self.cellH = [ZPracticePayInfoTVC getH];
    self.space = 20;
    self.viewLogoBG = [[UIView alloc] init];
    [self.viewLogoBG.layer setMasksToBounds:YES];
    [self.viewLogoBG setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.viewLogoBG];
    
    self.imgLogo = [[ZImageView alloc] initWithImage:[SkinManager getDefaultImage]];
    [self.viewLogoBG addSubview:self.imgLogo];
    
    self.viewListen = [[ZView alloc] init];
    [self.viewListen setBackgroundColor:BLACKCOLOR];
    [self.viewListen setAlpha:0.3];
    [self.viewLogoBG addSubview:self.viewListen];
    [self.viewLogoBG bringSubviewToFront:self.viewListen];
    
    self.imgListen = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"listen_icon2"]];
    [self.viewLogoBG addSubview:self.imgListen];
    [self.viewLogoBG bringSubviewToFront:self.imgListen];
    
    self.lbListen = [[ZLabel alloc] init];
    [self.lbListen setTextColor:WHITECOLOR];
    [self.lbListen setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbListen setNumberOfLines:1];
    [self.lbListen setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewLogoBG addSubview:self.lbListen];
    [self.viewLogoBG bringSubviewToFront:self.lbListen];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTitle setNumberOfLines:3];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[ZLabel alloc] init];
    [self.lbLecturer setTextColor:COLORTEXT3];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbLecturer setNumberOfLines:2];
    [self.lbLecturer setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbLecturer];
    
    self.lbPlayTime = [[ZLabel alloc] init];
    [self.lbPlayTime setTextColor:COLORTEXT3];
    [self.lbPlayTime setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbPlayTime setNumberOfLines:1];
    [self.lbPlayTime setUserInteractionEnabled:false];
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbPlayTime];
    
    self.imgLine = [UIImageView getDLineView];
    [self.viewMain addSubview:self.imgLine];
    
    //[self setViewFrame];
}

-(void)setViewFrame
{
    self.space = 20;
    CGFloat imgS = 100;
    CGFloat imgViewS = imgS;
    [self.viewLogoBG setFrame:CGRectMake(self.space, 15, imgViewS, imgViewS)];
    [self.imgLogo setFrame:self.viewLogoBG.bounds];
    
    [self.viewListen setFrame:CGRectMake(0, self.viewLogoBG.height-20, self.viewLogoBG.width, 20)];
    
    CGFloat imgListenSize = 13;
    CGRect lbListenFrame = CGRectMake(0, self.viewListen.y+1, 0, 18);
    [self.lbListen setFrame:(lbListenFrame)];
    CGFloat lbListenW = [self.lbListen getLabelWidthWithMinWidth:10];
    lbListenFrame.size.width = lbListenW;
    lbListenFrame.origin.x = self.viewListen.width/2-lbListenW/2+imgListenSize/2;
    [self.lbListen setFrame:(lbListenFrame)];
    
    [self.imgListen setFrame:(CGRectMake(self.lbListen.x-3-imgListenSize, self.viewListen.y+20/2-imgListenSize/2, imgListenSize, imgListenSize))];
    
    CGFloat lbRightX = self.viewLogoBG.x + self.viewLogoBG.width + 15;
    CGFloat lbRightW = self.cellW - lbRightX - self.space;
    CGRect titleFrame = CGRectMake(lbRightX, self.viewLogoBG.y-1, lbRightW, self.lbMinH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleNewH = [self.lbTitle getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:self.lbTitle.font width:self.lbTitle.width]*3;
    if (titleNewH <= titleMaxH) {
        titleFrame.size.height = titleNewH;
    } else {
        titleFrame.size.height = titleMaxH;
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGRect lecturerFrame = CGRectMake(lbRightX, self.lbTitle.y + self.lbTitle.height + 6, lbRightW, self.lbMinH);
    [self.lbLecturer setFrame:lecturerFrame];
    CGFloat lecturerNewH = [self.lbLecturer getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat lecturerMaxH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:self.lbLecturer.font width:self.lbLecturer.width]*2;
    if (lecturerNewH <= lecturerMaxH) {
        lecturerFrame.size.height = lecturerNewH;
    } else {
        lecturerFrame.size.height = lecturerMaxH;
    }
    [self.lbLecturer setFrame:lecturerFrame];
    
    CGFloat timeY = lecturerFrame.origin.y+lecturerFrame.size.height+6;
    CGFloat timeBottomY = self.viewLogoBG.y + self.viewLogoBG.height - self.lbMinH;
    if (timeY <= timeBottomY) {
        [self.lbPlayTime setFrame:CGRectMake(lbRightX, timeBottomY, 200, self.lbMinH)];
    } else {
        [self.lbPlayTime setFrame:CGRectMake(lbRightX, timeY, 200, self.lbMinH)];
    }
    CGFloat bottomHeight = self.lbPlayTime.y+self.lbPlayTime.height+10;
    if (bottomHeight >= [ZPracticePayInfoTVC getH]) {
        self.cellH = bottomHeight;
    } else {
        self.cellH = [ZPracticePayInfoTVC getH];
    }
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(CGFloat)setCellDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
    
    [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getDefaultImage]];
    [self.lbTitle setText:model.title];
    ///主讲人
    [self.lbLecturer setText:[NSString stringWithFormat:@"主讲人: %@",  model.nickname]];
    /// 处理万人级别的显示
    if (model.hits > kNumberMaximumCount) {
        [self.lbListen setText:[NSString stringWithFormat:@"%.1f%@", (float)(model.hits/(float)(kNumberMaximumCount+1)), kMillion]];
    } else {
        [self.lbListen setText:[NSString stringWithFormat:@"%ld", model.hits]];
    }
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getMinuteFromSS:model.time]]];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_model);
    
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
