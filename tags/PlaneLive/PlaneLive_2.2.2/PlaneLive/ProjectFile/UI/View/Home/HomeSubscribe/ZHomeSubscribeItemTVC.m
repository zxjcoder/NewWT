//
//  ZHomeSubscribeItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 01/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeSubscribeItemTVC.h"
#import "ZCalculateLabel.h"

@interface ZHomeSubscribeItemTVC()

@property (strong, nonatomic) ZImageView *imgIcon;
///标题
@property (strong, nonatomic) ZLabel *lbTitle;
///团队
@property (strong, nonatomic) ZLabel *lbTeam;
///描述
@property (strong, nonatomic) ZLabel *lbDesc;
///时间
@property (strong, nonatomic) ZLabel *lbTime;
///价格
@property (strong, nonatomic) ZLabel *lbPrice;
@property (strong, nonatomic) UIImageView *imgLine;
@property (strong, nonatomic) ModelSubscribe *model;
///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
///收听
@property (strong, nonatomic) ZView *viewListen;
///收听ICON
@property (strong, nonatomic) UIImageView *imgListen;
///收听数量
@property (strong, nonatomic) ZLabel *lbListen;
///多少门课程图片
@property (strong, nonatomic) ZImageView *imgTotal;
///多少门课程
@property (strong, nonatomic) ZLabel *lbTotal;

@end

@implementation ZHomeSubscribeItemTVC

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
    
    self.cellH = [ZHomeSubscribeItemTVC getH];
    
    if (!self.viewLogoBG) {
        self.viewLogoBG = [[UIView alloc] init];
        [self.viewLogoBG.layer setMasksToBounds:YES];
        [self.viewLogoBG setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
        [self.viewMain addSubview:self.viewLogoBG];
    }
    self.imgIcon = [[ZImageView alloc] initWithImage:[SkinManager getDefaultImage]];
    [self.viewLogoBG addSubview:self.imgIcon];
    
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
        [self.lbListen setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
        [self.viewLogoBG addSubview:self.lbListen];
        [self.viewLogoBG bringSubviewToFront:self.lbListen];
    }
    if (!self.imgTotal) {
        self.imgTotal = [[ZImageView alloc] init];
        [self.imgTotal setUserInteractionEnabled:NO];
        [self.imgTotal setImageName:@"subscribe_title_icon"];
        [self.imgTotal setHidden:YES];
        [self.viewLogoBG addSubview:self.imgTotal];
        [self.viewLogoBG bringSubviewToFront:self.imgTotal];
    }
    if (!self.lbTotal) {
        self.lbTotal = [[ZLabel alloc] init];
        [self.lbTotal setUserInteractionEnabled:NO];
        [self.lbTotal setTextColor:WHITECOLOR];
        [self.lbTotal setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbTotal setNumberOfLines:1];
        [self.lbTotal setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
        [self.imgTotal addSubview:self.lbTotal];
    }
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[ZLabel alloc] init];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbDesc setNumberOfLines:2];
    [self.lbDesc setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbDesc];
    
    self.lbTeam = [[ZLabel alloc] init];
    [self.lbTeam setTextColor:DESCCOLOR];
    [self.lbTeam setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTeam setNumberOfLines:1];
    [self.lbTeam setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbTeam];
    
    self.lbTime = [[ZLabel alloc] init];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbTime];
    
    self.lbPrice = [[ZLabel alloc] init];
    [self.lbPrice setTextColor:PRICECOLOR];
    [self.lbPrice setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.cellH-kLineMaxHeight, self.cellW, kLineMaxHeight)];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.viewLogoBG setFrame:CGRectMake(kSizeSpace, kSizeSpace, 105, 100)];
    [self.imgIcon setFrame:self.viewLogoBG.bounds];
    
    [self.viewListen setFrame:CGRectMake(0, self.viewLogoBG.height-18, self.viewLogoBG.width, 18)];
    CGRect lbListenFrame = CGRectMake(0, self.viewLogoBG.height-18, 10, 18);
    [self.lbListen setFrame:lbListenFrame];
    CGFloat lbListenW = [self.lbListen getLabelWidthWithMinWidth:10];
    lbListenFrame.size.width = lbListenW+2;
    lbListenFrame.origin.x = self.viewLogoBG.width-lbListenW-5;
    [self.lbListen setFrame:lbListenFrame];
    
    [self.imgListen setFrame:CGRectMake(lbListenFrame.origin.x-5-13, lbListenFrame.origin.y+18/2-11/2, 13, 11)];
    
    CGFloat totalW = 68;
    CGFloat totalH = 22;
    [self.imgTotal setFrame:CGRectMake(0, 0, totalW, totalH)];
    [self.lbTotal setFrame:CGRectMake(8, 0, totalW, totalH)];
    
    CGFloat lbX = self.viewLogoBG.x+self.viewLogoBG.width+10;
    CGFloat lbW = self.cellW-lbX-kSizeSpace;
    CGRect titleFrame = CGRectMake(lbX, 14, lbW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    if (titleH > titleMaxH) { titleH = titleMaxH; }
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
   
    CGRect descFrame = CGRectMake(lbX, titleFrame.origin.y+titleMaxH+4, lbW, self.lbMinH);
    [self.lbDesc setFrame:descFrame];
    //CGFloat descMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbDesc];
    //CGFloat descH = [self.lbDesc getLabelHeightWithMinHeight:self.lbMinH];
    //if (descH > descMaxH) { descH = descMaxH; }
    //descFrame.size.height = descH;
    //[self.lbDesc setFrame:descFrame];
    
    CGRect teamFrame = CGRectMake(lbX, descFrame.origin.y+descFrame.size.height+2, lbW, self.lbMinH);
    [self.lbTeam setFrame:teamFrame];
    
    CGRect timeFrame = CGRectMake(lbX, teamFrame.origin.y+teamFrame.size.height+2, lbW, self.lbMinH);
    [self.lbTime setFrame:timeFrame];
    
    CGRect priceFrame = CGRectMake(lbX, timeFrame.origin.y, lbW, self.lbMinH);
    [self.lbPrice setFrame:priceFrame];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(void)setHiddenPriceWithValue:(BOOL)isHidden
{
    [self.lbPrice setHidden:isHidden];
}
-(void)setImageTotalHidden:(BOOL)isHidden
{
    [self.imgTotal setHidden:isHidden];
}
-(CGFloat)setCellDataWithModel:(ModelSubscribe *)model
{
    [self setModel:model];
    
    [self.imgIcon setImageURLStr:model.illustration];
    
    [self.lbTitle setText:model.title];
    
    [self.lbDesc setText:model.theme_intro];
    
    [self.lbTeam setText:model.team_name];
    
    [self.lbTime setText:model.time];
    
    //首页隐藏订阅多少门课程
    //[self.imgTotal setHidden:YES];
    [self.imgTotal setHidden:model.increasedCourseCount<=0];
    [self.lbTotal setText:[NSString stringWithFormat:kSubscribeNewCourse, model.increasedCourseCount]];
    
    if (model.units && model.units.length > 0) {
        [self.lbPrice setText:[NSString stringWithFormat:@"¥%.2f/%@", [model.price floatValue], model.units]];
    } else {
        [self.lbPrice setText:[NSString stringWithFormat:@"¥%.2f", [model.price floatValue]]];
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
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbTeam);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_lbTime);
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
