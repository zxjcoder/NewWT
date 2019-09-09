//
//  ZPurchaseAllItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZPurchaseAllItemTVC.h"

@interface ZPurchaseAllItemTVC()

///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
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
///分割线
@property (strong, nonatomic) UIImageView *imgLine;
///收听
@property (strong, nonatomic) ZView *viewListen;
///收听ICON
@property (strong, nonatomic) UIImageView *imgListen;
///收听数量
@property (strong, nonatomic) ZLabel *lbListen;

@end

@implementation ZPurchaseAllItemTVC

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
    
    self.cellH = [ZPurchaseAllItemTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
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
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbPlayTime];
    
    self.lbUpdateTime = [[UILabel alloc] init];
    [self.lbUpdateTime setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbUpdateTime setNumberOfLines:1];
    [self.lbUpdateTime setTextColor:COLORTEXT3];
    [self.lbUpdateTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbUpdateTime];
    
    self.lbPraise = [[UILabel alloc] init];
    [self.lbPraise setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbPraise setNumberOfLines:1];
    [self.lbPraise setTextColor:COLORTEXT3];
    [self.lbPraise setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPraise setText:[NSString stringWithFormat:@"0%@", kPeoplePointPraise]];
    [self.lbPraise setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPraise];
    
    self.lbPrice = [[UILabel alloc] init];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPrice];
    
    self.viewListen = [[ZView alloc] init];
    [self.viewListen setBackgroundColor:COLORVIEWBACKCOLOR1];
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
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:self.lbTitle.font width:self.lbTitle.width]*self.lbTitle.numberOfLines;
    if (titleNewH < titleMaxH) {
        titleFrame.size.height = titleNewH;
    } else {
        titleFrame.size.height = titleMaxH;
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGRect lecturerFrame = CGRectMake(lbRightX, self.lbTitle.y + self.lbTitle.height + 6, lbRightW, self.lbMinH);
    [self.lbLecturer setFrame:lecturerFrame];
//    CGFloat lecturerNewH = [self.lbLecturer getLabelHeightWithMinHeight:self.lbMinH];
//    CGFloat lecturerMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbLecturer];
//    if (lecturerNewH > lecturerMaxH) {
//        lecturerFrame.size.height = lecturerMaxH;
//    } else {
//        lecturerFrame.size.height = lecturerNewH;
//    }
//    [self.lbLecturer setFrame:lecturerFrame];
    
    CGFloat priceY =self.viewLogoBG.y + self.viewLogoBG.height - self.lbH;
    CGFloat priceW = 120;
    [self.lbPrice setFrame:CGRectMake(self.cellW-priceW-self.space, priceY, priceW, self.lbH)];
    
    CGFloat timeY = self.viewLogoBG.y + self.viewLogoBG.height - self.lbMinH;
    [self.lbPlayTime setFrame:CGRectMake(lbRightX, timeY, 200, self.lbMinH)];
    
    CGFloat buttomY = self.viewLogoBG.y + self.viewLogoBG.height + 12;
    [self.lbUpdateTime setFrame:CGRectMake(self.space, buttomY, 200, 20)];
    
    CGRect praiseFrame = CGRectMake(0, buttomY, 10, self.lbMinH);
    [self.lbPraise setFrame:praiseFrame];
    CGFloat praiseW = [self.lbPraise getLabelWidthWithMinWidth:10];
    praiseFrame.origin.x = self.cellW - self.space - praiseW;
    praiseFrame.size.width = praiseW;
    [self.lbPraise setFrame:praiseFrame];
    
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight)];
    [self.viewMain setFrame:self.getMainFrame];
}

///播放中
-(void)setModelPlayStatus:(BOOL)isPlay
{
    if (isPlay) {
        [self.lbTitle setTextColor:COLORCONTENT3];
    } else {
        [self.lbTitle setTextColor:COLORTEXT1];
    }
}
-(void)setHiddenPrice
{
    [self.lbPrice setHidden:YES];
}

-(CGFloat)setCellDataWithPracticeModel:(ModelPractice *)model
{
    [self.lbUpdateTime setHidden:YES];
    [self.lbPraise setHidden:YES];
    [self.lbPrice setHidden:YES];
    self.cellH = [ZPurchaseAllItemTVC getPracticeH];
    
    [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getDefaultImage]];
    
    [self.lbTitle setText:model.title];
    [self.lbPrice setText:kEmpty];
    /*[self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    if (model.unlock == 1) {
        if (model.buyStatus == 1) {
            [self.lbPrice setTextColor:COLORTEXT3];
            [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
            [self.lbPrice setText:kBeenPurchased];
        } else {
            [self.lbPrice setText:[NSString stringWithFormat:@"%.2f %@", [model.price floatValue], kPlaneMoney]];
            NSRange range = NSMakeRange(self.lbPrice.text.length - kPlaneMoney.length, kPlaneMoney.length);
            UIFont *font = [ZFont systemFontOfSize:kFont_Min_Size];
            [self.lbPrice setLabelFontWithRange:range font:font color:COLORTEXT3];
        }
    } else {
        [self.lbPrice setTextColor:COLORTEXT3];
        [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
        [self.lbPrice setText:kFreeCharge];
    }*/
    ///主讲人
    if (model.person_title.length > 0) {
        if (model.nickname.length > 0) {
            [self.lbLecturer setText:[NSString stringWithFormat:@"%@ %@",  model.nickname, model.person_title]];
        } else {
            [self.lbLecturer setText:[NSString stringWithFormat:@"%@", model.person_title]];
        }
    } else {
        [self.lbLecturer setText:[NSString stringWithFormat:@"%@",  model.nickname]];
    }
    /// 处理万人级别的显示
    if (model.hits > kNumberMaximumCount) {
        [self.lbListen setText:[NSString stringWithFormat:@"%.1f%@", (float)(model.hits/(float)(kNumberMaximumCount+1)), kMillion]];
    } else {
        [self.lbListen setText:[NSString stringWithFormat:@"%ld", model.hits]];
    }
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getMinuteFromSS:model.time]]];
    
    [self.lbPraise setText:[NSString stringWithFormat:@"%ld%@", (long)model.applauds, kPeoplePointPraise]];
    [self.lbUpdateTime setText:model.create_time];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(CGFloat)setCellDataWithCourseModel:(ModelSubscribe *)model
{
    [self.lbUpdateTime setHidden:YES];
    [self.lbPraise setHidden:YES];
    [self.lbPrice setHidden:YES];
    self.cellH = [ZPurchaseAllItemTVC getCourseH];
    
    [self.imgLogo setImageURLStr:model.illustration];
    [self.lbTitle setText:model.title];
    [self.lbLecturer setText:model.team_name];
    [self.lbPlayTime setText:model.time];
    [self.lbPrice setText:kEmpty];
    /*[self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    if (model.isSubscribe == 1) {
        [self.lbPrice setTextColor:COLORTEXT3];
        [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
        [self.lbPrice setText:kBeenPurchased];
    } else {
        [self.lbPrice setText:[NSString stringWithFormat:@"%.2f %@", [model.price floatValue], kPlaneMoney]];
        NSRange range = NSMakeRange(self.lbPrice.text.length - kPlaneMoney.length, kPlaneMoney.length);
        UIFont *font = [ZFont systemFontOfSize:kFont_Min_Size];
        [self.lbPrice setLabelFontWithRange:range font:font color:COLORTEXT3];
    }*/
    if (model.hits > kNumberMaximumCount) {
        [self.lbListen setText:[NSString stringWithFormat:@"%.1f%@", (float)(model.hits/(float)(kNumberMaximumCount+1)), kMillion]];
    } else {
        [self.lbListen setText:[NSString stringWithFormat:@"%ld", model.hits]];
    }
    [self.lbPraise setText:kEmpty];
    [self.lbUpdateTime setText:kEmpty];
    [self setNeedsDisplay];
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_lbPraise);
    OBJC_RELEASE(_lbPlayTime);
    OBJC_RELEASE(_viewLogoBG);
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
    return 130;
}
+(CGFloat)getCourseH
{
    return 130;
}
+(CGFloat)getPracticeH
{
    return 130;//155;
}

@end
