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
@property (strong, nonatomic) UILabel *lbLecturerDesc;
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
    
    self.btnCheck = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_normal"] forState:(UIControlStateNormal)];
    [self.btnCheck setTag:1];
    [self.btnCheck setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnCheck addTarget:self action:@selector(btnCheckClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnCheck];
    
    CGFloat imgSize = self.cellH-kSizeSpace*2;
    self.imgLogo = [[ZImageView alloc] initWithFrame:CGRectMake(kSizeSpace, kSizeSpace, imgSize, imgSize)];
    [self.imgLogo.layer setMasksToBounds:YES];
    [self.imgLogo setViewRound:kIMAGE_ROUND_SIZE borderWidth:1 borderColor:WHITECOLOR];
    self.imgLogo.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.imgLogo.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.imgLogo.layer.shadowOpacity = 0.58;//不透明度
    self.imgLogo.layer.shadowRadius = 5.0;//半径
    [self.viewMain addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[ZFont boldSystemFontOfSize:kFont_Least_Size]];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setTextColor:DESCCOLOR];
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
    [self.lbPrice setFont:[ZFont boldSystemFontOfSize:kFont_Min_Size]];
    [self.lbPrice setNumberOfLines:1];
    [self.lbPrice setTextColor:MAINCOLOR];
    [self.lbPrice setTextAlignment:(NSTextAlignmentRight)];
    [self.lbPrice setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPrice];
    
    self.imgLine = [UIImageView getTLineView];
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.cellH-self.lineH, self.cellW-kSizeSpace*2, self.lineH)];
    [self.viewMain addSubview:self.imgLine];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat checkSize = 35;
    [self.btnCheck setFrame:CGRectMake(kSize5, self.cellH/2-checkSize/2, checkSize, checkSize)];
    
    CGFloat imgSize = self.cellH-kSizeSpace*2;
    CGFloat imgX = kSize5+checkSize+kSize5;
    [self.imgLogo setFrame:CGRectMake(imgX, kSizeSpace, imgSize, imgSize)];
    
    CGFloat lbX = self.imgLogo.x+self.imgLogo.width+kSize8;
    CGFloat lbW = self.viewMain.width-lbX-kSizeSpace;
    CGFloat lbY = kSize15;
    [self.lbTitle setFrame:CGRectMake(lbX, lbY, lbW, self.lbH)];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > titleMaxH) {
        titleH = titleMaxH;
    }
    [self.lbTitle setFrame:CGRectMake(self.lbTitle.x, self.lbTitle.y, self.lbTitle.width, titleH)];
    
    CGFloat lbLY = self.lbTitle.y + titleMaxH + kSize3;
    [self.lbLecturer setFrame:CGRectMake(lbX, lbLY, lbW, self.lbMinH)];
    
    CGFloat lbLDY = self.lbLecturer.y+self.lbLecturer.height+1;
    CGFloat lbLDH = 16;
    
    [self.lbLecturerDesc setFrame:CGRectMake(lbX, lbLDY, lbW, lbLDH)];
    
    CGFloat lbUTH = 16;
    CGFloat timeY = lbLDY+lbLDH+kSize3;
    CGFloat priceY = lbLDY+kSize15;
    CGFloat priceW = 120;
    [self.lbPrice setFrame:CGRectMake(self.cellW-priceW-kSizeSpace, priceY, priceW, self.lbH)];
    
    CGFloat lbUTW = self.lbPrice.x-lbX-kSize3;
    [self.lbPlayTime setFrame:CGRectMake(lbX, timeY, lbUTW, lbUTH)];
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
        [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_select"] forState:(UIControlStateNormal)];
    } else {
        [self.btnCheck setTag:1];
        [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_normal"] forState:(UIControlStateNormal)];
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
    
    [self.imgLogo setImageURLStr:model.speech_img placeImage:[SkinManager getPracticeImage]];
    
    [self.lbTitle setText:model.title];
    
    [self.lbLecturer setText:[NSString stringWithFormat:@"%@: %@", kSpeaker, model.nickname]];
    
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getHHMMSSFromSS:model.time]]];
    
    [self.lbLecturerDesc setText:model.person_title];
    
    [self.lbPrice setText:[NSString stringWithFormat:@"%.2f%@", [model.price floatValue], kPlaneMoney]];
    
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
    return 128;
}

@end
