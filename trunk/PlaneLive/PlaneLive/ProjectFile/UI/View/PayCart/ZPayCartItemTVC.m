//
//  ZPayCartItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPayCartItemTVC.h"
#import "ZButton.h"
#import "Utils.h"

@interface ZPayCartItemTVC()

///勾选按钮
@property (strong, nonatomic) ZButton *btnCheck;
///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///主持人机构名称
//@property (strong, nonatomic) UILabel *lbLecturerDesc;
///播放时间
@property (strong, nonatomic) UILabel *lbPlayTime;
///价格
@property (strong, nonatomic) UILabel *lbPrice;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) ModelPayCart *model;

@end

@implementation ZPayCartItemTVC

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
    
    self.cellH = [ZPayCartItemTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.btnCheck = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCheck setImage:[SkinManager getImageWithName:@"checkbox"] forState:(UIControlStateNormal)];
    [self.btnCheck setImage:[SkinManager getImageWithName:@"checkbox_s"] forState:(UIControlStateSelected)];
    [self.btnCheck setTag:1];
    [self.btnCheck setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnCheck addTarget:self action:@selector(btnCheckClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnCheck];
    
    CGFloat imgSize = self.cellH-self.space*2;
    self.imgLogo = [[ZImageView alloc] initWithFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
    [self.imgLogo.layer setMasksToBounds:YES];
    [self.imgLogo setViewRound:kIMAGE_ROUND_SIZE borderWidth:1 borderColor:WHITECOLOR];
    self.imgLogo.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.imgLogo.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.imgLogo.layer.shadowOpacity = 0.58;//不透明度
    self.imgLogo.layer.shadowRadius = 5.0;//半径
    [self.viewMain addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbLecturer setNumberOfLines:2];
    [self.lbLecturer setTextColor:COLORTEXT3];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbLecturer];
    
//    self.lbLecturerDesc = [[UILabel alloc] init];
//    [self.lbLecturerDesc setFont:[ZFont systemFontOfSize:kFont_Minimum_Size]];
//    [self.lbLecturerDesc setNumberOfLines:1];
//    [self.lbLecturerDesc setTextColor:DESCCOLOR];
//    [self.lbLecturerDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
//    [self.viewMain addSubview:self.lbLecturerDesc];
    
    self.lbPlayTime = [[UILabel alloc] init];
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbPlayTime setNumberOfLines:1];
    [self.lbPlayTime setTextColor:COLORTEXT3];
    [self.lbPlayTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPlayTime];
    
    self.lbPrice = [[UILabel alloc] init];
    [self.lbPrice setFont:[ZFont boldSystemFontOfSize:kFont_Small_Size]];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine = [UIImageView getTLineView];
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-self.lineH, self.cellW-self.space*2, self.lineH)];
    [self.viewMain addSubview:self.imgLine];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat checkSize = 35;
    [self.btnCheck setFrame:CGRectMake(kSize5, self.cellH/2-checkSize/2, checkSize, checkSize)];
    
    CGFloat imgSize = 100;//self.cellH-kSizeSpace*2;
    CGFloat imgX = kSize5+checkSize+kSize5;
    [self.imgLogo setFrame:CGRectMake(imgX, 15, imgSize, imgSize)];
    
    CGFloat lbX = self.imgLogo.x+self.imgLogo.width+kSize8;
    CGFloat lbW = self.viewMain.width-lbX-self.space;
    CGFloat lbY = 16;
    CGRect titleFrame = CGRectMake(lbX, lbY, lbW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleNewH = [self.lbTitle getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:self.lbTitle.font width:self.lbTitle.width]*self.lbTitle.numberOfLines;
    if (titleNewH < titleMaxH) {
        titleFrame.size.height = titleNewH;
    } else {
        titleFrame.size.height = titleMaxH;
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGRect lecturerFrame = CGRectMake(lbX, self.lbTitle.y + self.lbTitle.height + 6, lbW, self.lbMinH);
    [self.lbLecturer setFrame:lecturerFrame];
    
    CGFloat priceY = self.cellH - 15 - self.lbH;
    CGFloat priceW = 100;
    [self.lbPrice setFrame:CGRectMake(self.cellW-priceW-self.space, priceY, priceW, self.lbH)];
    
    CGFloat lbUTW = self.lbPrice.x-lbX-kSize3;
    [self.lbPlayTime setFrame:CGRectMake(lbX, priceY, lbUTW, self.lbMinH)];
}
-(void)btnCheckClick
{
    if (self.onCheckedClick) {
        self.onCheckedClick(self.btnCheck.tag==1, self.tag);
    }
    [self setIsChecked:self.btnCheck.tag==1];
}
-(void)setIsChecked:(BOOL)check
{
    if (check) {
        [self.btnCheck setTag:2];
        [self.btnCheck setSelected:true];
    } else {
        [self.btnCheck setTag:1];
        [self.btnCheck setSelected:false];
    }
}
///设置选中状态
-(void)setCheckedStatus:(BOOL)isCheck
{
    [self setIsChecked:isCheck];
}
-(CGFloat)setCellDataWithModel:(ModelPayCart *)model
{
    [self setModel:model];
    
    [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getDefaultImage]];
    
    [self.lbTitle setText:model.title];
    
    [self.lbLecturer setText:[NSString stringWithFormat:@"%@ %@", model.nickname, model.person_title]];
    /// TODO: ZWW - 购物车隐藏播放时长
    [self.lbPlayTime setHidden:kViewSace < 1];
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getHHMMSSFromSS:model.time]]];
    
    [self.lbPrice setText:[NSString stringWithFormat:@"%.2f %@", [model.price floatValue], kPlaneMoney]];
    [self.lbPrice setTextColor:COLORCONTENT3];
    [self.lbPrice setFont:[ZFont boldSystemFontOfSize:kFont_Small_Size]];
    NSRange range = NSMakeRange(self.lbPrice.text.length - kPlaneMoney.length, kPlaneMoney.length);
    UIFont *font = [ZFont systemFontOfSize:kFont_Min_Size];
    [self.lbPrice setLabelFontWithRange:range font:font color:COLORTEXT3];
    
    [self setIsChecked:YES];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_btnCheck);
    OBJC_RELEASE(_lbPrice);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbLecturer);
    OBJC_RELEASE(_lbPlayTime);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_imgLogo);
    [super setViewNil];
}
///获取数据源
-(ModelPractice *)getCellModel
{
    return self.model;
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
    return 130;
}

@end
