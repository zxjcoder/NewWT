//
//  ZDownloadItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 09/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDownloadItemTVC.h"
#import "ZButton.h"
#import "ModelAudio.h"
#import "Utils.h"

@interface ZDownloadItemTVC()

@property (strong, nonatomic) UIView *viewContent;
///勾选按钮
@property (strong, nonatomic) ZButton *btnCheck;
///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///播放时间
@property (strong, nonatomic) UILabel *lbPlayTime;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;
@property (strong, nonatomic) XMCacheTrack *modelCT;

@end

@implementation ZDownloadItemTVC

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
    
    self.cellH = [ZDownloadItemTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    if (!self.btnCheck) {
        self.btnCheck = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnCheck setImage:[SkinManager getImageWithName:@"checkbox"] forState:(UIControlStateNormal)];
        [self.btnCheck setImage:[SkinManager getImageWithName:@"checkbox_s"] forState:(UIControlStateSelected)];
        [self.btnCheck setTag:1];
        [self.btnCheck setHidden:true];
        [self.btnCheck setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [self.btnCheck addTarget:self action:@selector(btnCheckClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewMain addSubview:self.btnCheck];
    }
    if (!self.viewContent) {
        self.viewContent = [[UIView alloc] init];
        [self.viewContent setBackgroundColor:CLEARCOLOR];
        [self.viewMain addSubview:self.viewContent];
    }
    CGFloat imgSize = self.cellH-self.space*2;
    if (!self.imgLogo) {
        self.imgLogo = [[ZImageView alloc] initWithFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
        [self.imgLogo.layer setMasksToBounds:YES];
        [self.imgLogo setViewRound:kIMAGE_ROUND_SIZE borderWidth:1 borderColor:WHITECOLOR];
        self.imgLogo.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        self.imgLogo.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        self.imgLogo.layer.shadowOpacity = 0.58;//不透明度
        self.imgLogo.layer.shadowRadius = 5.0;//半径
        [self.viewContent addSubview:self.imgLogo];
    }
    if (!self.lbTitle) {
        self.lbTitle = [[UILabel alloc] init];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.lbTitle setNumberOfLines:2];
        [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.viewContent addSubview:self.lbTitle];
    }
    if (!self.lbLecturer) {
        self.lbLecturer = [[UILabel alloc] init];
        [self.lbLecturer setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbLecturer setNumberOfLines:2];
        [self.lbLecturer setTextColor:COLORTEXT3];
        [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.viewContent addSubview:self.lbLecturer];
    }
    if (!self.lbPlayTime) {
        self.lbPlayTime = [[UILabel alloc] init];
        [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbPlayTime setNumberOfLines:1];
        [self.lbPlayTime setTextColor:COLORTEXT3];
        [self.lbPlayTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.viewContent addSubview:self.lbPlayTime];
    }
    if (!self.imgLine) {
        self.imgLine = [UIImageView getTLineView];
        [self.imgLine setFrame:CGRectMake(self.space, self.cellH-self.lineH, self.cellW-self.space*2, self.lineH)];
        [self.viewMain addSubview:self.imgLine];
    }
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat checkSize = 35;
    [self.btnCheck setFrame:CGRectMake(kSize5, self.cellH/2-checkSize/2, checkSize, checkSize)];
    CGFloat contentX = 20;
    if (self.isChecking) {
        contentX = kSize5+checkSize+kSize5;
    }
    CGFloat contentW = self.cellW - contentX - 20;
    [self.viewContent setFrame:(CGRectMake(contentX, 15, contentW, self.cellH - 20))];
    CGFloat imgSize = 100;
    [self.imgLogo setFrame:CGRectMake(0, 0, imgSize, imgSize)];
    
    CGFloat lbX = self.imgLogo.x+self.imgLogo.width+10;
    CGFloat lbW = contentW - lbX;//self.viewMain.width-lbX-self.space;
    CGFloat lbY = 1;
    CGRect titleFrame = CGRectMake(lbX, lbY, lbW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > titleMaxH) {
        titleFrame.size.height = titleMaxH;
    } else {
        titleFrame.size.height = titleH;
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGFloat lbLY = self.lbTitle.y + self.lbTitle.height + kSize3;
    CGRect lecturerFrame = CGRectMake(lbX, lbLY, lbW, self.lbMinH);
    [self.lbLecturer setFrame:lecturerFrame];
    CGFloat lecturerNewH = [self.lbLecturer getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat lecturerMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbLecturer];
    if (lecturerNewH > lecturerMaxH) {
        lecturerFrame.size.height = lecturerMaxH;
    } else {
        lecturerFrame.size.height = lecturerNewH;
    }
    [self.lbLecturer setFrame:lecturerFrame];
    
    CGFloat timeY = self.imgLogo.y + self.imgLogo.height - self.lbH - 3;
    CGFloat timeW = lbW;
    [self.lbPlayTime setFrame:CGRectMake(lbX, timeY, timeW, self.lbH)];
    
    [self.viewMain setFrame:[self getMainFrame]];
}
-(void)btnCheckClick
{
    [self setCheckedStatus:!self.btnCheck.selected];
    if (self.onCheckedClick) {
        self.onCheckedClick(self.btnCheck.selected, self.tag);
    }
}
-(void)setCheckedStatus:(BOOL)isCheck
{
    [self.btnCheck setSelected:isCheck];
    [self setIsChecked:isCheck];
}
///设置勾选中
-(void)setIsCheckingStatus:(BOOL)isCheck
{
    self.isChecking = isCheck;
    if (isCheck) {
        [self.btnCheck setHidden:false];
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self setViewFrame];
        }];
    } else {
        [self.btnCheck setHidden:true];
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self setViewFrame];
        }];
    }
}
-(CGFloat)setCellDataWithModel:(XMCacheTrack *)model
{
    [self setModelCT:model];
    
    [self.imgLogo setImageURLStr:model.coverUrlSmall placeImage:[SkinManager getDefaultImage]];
    [self.lbTitle setText:model.trackTitle];
    [self.lbLecturer setText:[NSString stringWithFormat:@"%@", model.announcer.nickname]];
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getHHMMSSFromSSTime:model.duration]]];
    
    [self.btnCheck setSelected:self.isChecked];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_btnCheck);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbLecturer);
    OBJC_RELEASE(_lbPlayTime);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_imgLogo);
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
