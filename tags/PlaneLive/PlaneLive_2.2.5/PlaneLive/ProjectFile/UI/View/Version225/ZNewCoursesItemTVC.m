//
//  ZNewCoursesItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 19/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewCoursesItemTVC.h"

@interface ZNewCoursesItemTVC()

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
///价格
@property (strong, nonatomic) ZLabel *lbPrice;
///收听
@property (strong, nonatomic) ZView *viewListen;
///收听ICON
@property (strong, nonatomic) UIImageView *imgListen;
///收听数量
@property (strong, nonatomic) ZLabel *lbListen;
@property (strong, nonatomic) UIImageView *imgLine;
@property (strong, nonatomic) ModelSubscribe *model;

@end

@implementation ZNewCoursesItemTVC

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
    
    self.cellH = [ZNewCoursesItemTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
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
    
    self.imgListen = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"listen_icon"]];
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
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[ZLabel alloc] init];
    [self.lbLecturer setTextColor:COLORTEXT3];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbLecturer];
    
    self.lbPlayTime = [[ZLabel alloc] init];
    [self.lbPlayTime setTextColor:COLORTEXT3];
    [self.lbPlayTime setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbPlayTime setNumberOfLines:1];
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbPlayTime];
    
    self.lbPrice = [[ZLabel alloc] init];
    [self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewMain addSubview:self.lbPrice];
    
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
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleNewH > titleMaxH) {
        titleFrame.size.height = titleMaxH;
    } else {
        titleFrame.size.height = titleNewH;
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGRect lecturerFrame = CGRectMake(lbRightX, self.lbTitle.y + self.lbTitle.height + 6, lbRightW, self.lbMinH);
    [self.lbLecturer setFrame:lecturerFrame];
    CGFloat lecturerNewH = [self.lbLecturer getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat lecturerMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbLecturer];
    if (lecturerNewH > lecturerMaxH) {
        lecturerFrame.size.height = lecturerMaxH;
    } else {
        lecturerFrame.size.height = lecturerNewH;
    }
    [self.lbLecturer setFrame:lecturerFrame];
    
    CGFloat priceY =self.viewLogoBG.y + self.viewLogoBG.height - self.lbH;
    CGFloat priceW = 120;
    [self.lbPrice setFrame:CGRectMake(self.cellW-priceW-self.space, priceY, priceW, self.lbH)];
    
    CGFloat timeY = self.viewLogoBG.y + self.viewLogoBG.height - self.lbMinH;
    [self.lbPlayTime setFrame:CGRectMake(lbRightX, timeY, 200, self.lbMinH)];
    
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(void)setHiddenPriceWithValue:(BOOL)isHidden
{
    [self.lbPrice setHidden:isHidden];
}
-(void)setHiddenLine:(BOOL)hidden
{
    self.imgLine.hidden = hidden;
}
-(CGFloat)setCellDataWithModel:(ModelSubscribe *)model
{
    [self setModel:model];
    
    [self.imgLogo setImageURLStr:model.illustration];
    [self.lbTitle setText:model.title];
    [self.lbLecturer setText:model.team_name];
    [self.lbPlayTime setText:model.time];
    [self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    if (model.isSubscribe == 1) {
        [self.lbPrice setTextColor:COLORTEXT3];
        [self.lbPrice setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbPrice setText:kBeenPurchased];
    } else {
        [self.lbPrice setText:[NSString stringWithFormat:@"%.2f %@", [model.price floatValue], kPlaneMoney]];
        NSRange range = NSMakeRange(self.lbPrice.text.length - kPlaneMoney.length, kPlaneMoney.length);
        ZFont *font = [ZFont systemFontOfSize:kFont_Min_Size];
        [self.lbPrice setLabelFontWithRange:range font:font color:COLORTEXT3];
    }
    if (model.hits > kNumberMaximumCount) {
        [self.lbListen setText:[NSString stringWithFormat:@"%.1f%@", (float)(model.hits/(float)(kNumberMaximumCount+1)), kMillion]];
    } else {
        [self.lbListen setText:[NSString stringWithFormat:@"%ld", model.hits]];
    }
    [self setViewFrame];
    
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_lbPrice);
    
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
