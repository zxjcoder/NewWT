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
///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///播放时间
@property (strong, nonatomic) UILabel *lbPlayTime;
///下载描述
@property (strong, nonatomic) UILabel *lbDownloadDesc;
///下载按钮
@property (strong, nonatomic) ZButton *btnDownload;
///选中按钮
@property (strong, nonatomic) ZButton *btnCheck;
///下载百分比
@property (strong, nonatomic) UILabel *lbPercentage;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;

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
    
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.viewContent];
    
    CGFloat imgSize = self.cellH-kSizeSpace*2;
    self.imgLogo = [[ZImageView alloc] initWithFrame:CGRectMake(kSizeSpace, kSizeSpace, imgSize, imgSize)];
    [self.imgLogo.layer setMasksToBounds:YES];
    [self.imgLogo setViewRound:kIMAGE_ROUND_SIZE borderWidth:1 borderColor:WHITECOLOR];
    [self.viewContent addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.viewContent addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[ZFont boldSystemFontOfSize:kFont_Least_Size]];
    [self.lbLecturer setNumberOfLines:1];
    [self.lbLecturer setTextColor:SPEAKERCOLOR];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbLecturer];
    
    self.lbPlayTime = [[UILabel alloc] init];
    [self.lbPlayTime setFont:[ZFont boldSystemFontOfSize:kFont_Least_Size]];
    [self.lbPlayTime setNumberOfLines:1];
    [self.lbPlayTime setTextColor:DESCCOLOR];
    [self.lbPlayTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbPlayTime];
    
    self.lbDownloadDesc = [[UILabel alloc] init];
    [self.lbDownloadDesc setFont:[ZFont boldSystemFontOfSize:kFont_Minimum_Size]];
    [self.lbDownloadDesc setNumberOfLines:1];
    [self.lbDownloadDesc setTextColor:DESCCOLOR];
    [self.lbDownloadDesc setHidden:YES];
    [self.lbDownloadDesc setText:kClickToSuspendDownload];
    [self.lbDownloadDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbDownloadDesc];
    
    CGFloat btnSize = 30;
    CGFloat btnX = self.cellW-btnSize-kSizeSpace;
    CGFloat btnY = self.cellH-kSizeSpace-btnSize-self.lbH-2;
    self.btnDownload = [[ZButton alloc] initWithDownloadWithFrame:CGRectMake(btnX, btnY, btnSize, btnSize)];
    [self.btnDownload setDownloadImage:@"icon_download_pause_gray"];
    [self.btnDownload setTag:ZDownloadStatusNomral];
    [self.btnDownload setHidden:YES];
    [self.btnDownload addTarget:self action:@selector(btnDownloadClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnDownload];
    
    CGFloat lbRX = btnX-15/2;
    CGFloat lbRW = 45;
    self.lbPercentage = [[UILabel alloc] initWithFrame:CGRectMake(lbRX, btnY+btnSize+2, lbRW, self.lbMinH)];
    [self.lbPercentage setFont:[ZFont boldSystemFontOfSize:kFont_Minimum_Size]];
    [self.lbPercentage setNumberOfLines:1];
    [self.lbPercentage setTextColor:DESCCOLOR];
    [self.lbPercentage setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbPercentage setHidden:YES];
    [self.lbPercentage setText:kDownloadWaiting];
    [self.lbPercentage setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbPercentage];
    
    self.btnCheck = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCheck setImage:[SkinManager getImageWithName:@"icon_check_normal"] forState:(UIControlStateNormal)];
    [self.btnCheck setTag:1];
    [self.btnCheck setAlpha:0];
    [self.btnCheck setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnCheck addTarget:self action:@selector(btnCheckClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnCheck];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    [self.viewMain bringSubviewToFront:self.btnCheck];
    
    self.imgLine = [UIImageView getTLineView];
    [self.imgLine setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
    [self.viewMain addSubview:self.imgLine];
    
    [self setCheckShow:NO];
    
    [self setViewFrame];
}

-(void)setDownloadButtonHidden:(BOOL)hidden
{
    [self.btnDownload setHidden:hidden];
    [self.lbPercentage setHidden:hidden];
    [self.lbDownloadDesc setHidden:hidden];
    
    [self setViewFrame];
}
///下载状态改变
-(void)setChangeDownloadStatusWithModel:(ModelAudio *)model
{
    if (model.address == ZDownloadStatusStart) {
        [self.lbDownloadDesc setText:kClickToSuspendDownload];
    } else {
        [self.lbDownloadDesc setText:kHasBeenSuspendedClickToContinueToDownload];
    }
    
    [self setDownloadButtonImage:model.address];
    
    [self setNeedsDisplay];
}
-(void)setCheckShow:(BOOL)showCheck
{
    [self.btnCheck setAlpha:showCheck==YES?1:0];
    
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self setViewFrame];
    }];
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
-(BOOL)isChecked
{
    return self.btnCheck.tag==2;
}
///设置选中状态
-(void)setCheckedStatus:(BOOL)isCheck
{
    [self setIsChecked:isCheck];
}

-(void)setViewFrame
{
    CGFloat checkSize = 35;
    CGFloat imgSize = self.cellH-kSizeSpace*2;
    if (self.btnCheck.alpha == 0) {
        [self.viewContent setFrame:self.viewMain.bounds];
        [self.btnCheck setFrame:CGRectMake(-checkSize, self.cellH/2-checkSize/2, checkSize, checkSize)];
        
        [self.imgLogo setFrame:CGRectMake(kSizeSpace, kSizeSpace, imgSize, imgSize)];
    } else {
        [self.viewContent setFrame:CGRectMake(checkSize, 0, self.cellW-35, self.cellH)];
        [self.btnCheck setFrame:CGRectMake(0, self.cellH/2-checkSize/2, checkSize, checkSize)];
        
        [self.imgLogo setFrame:CGRectMake(5, kSizeSpace, imgSize, imgSize)];
    }
    CGFloat lbX = self.imgLogo.x+self.imgLogo.width+kSize8;
    CGFloat lbW = self.viewContent.width-lbX-kSizeSpace;
    CGFloat lbY = kSize15;
    [self.lbTitle setFrame:CGRectMake(lbX, lbY, lbW, self.lbH)];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > titleMaxH) {
        titleH = titleMaxH;
    }
    [self.lbTitle setFrame:CGRectMake(self.lbTitle.x, self.lbTitle.y, self.lbTitle.width, titleH)];
    
    CGFloat rightW = lbW-50;
    if (self.btnCheck.alpha == 1) {
        rightW = lbW;
    }
    CGFloat lbLY = self.lbTitle.y + titleMaxH + kSize3;
    [self.lbLecturer setFrame:CGRectMake(lbX, lbLY, rightW, self.lbMinH)];
    
    CGFloat lbPTY = self.lbLecturer.y+self.lbLecturer.height+2;
    CGFloat lbPTH = 16;
    [self.lbPlayTime setFrame:CGRectMake(lbX, lbPTY, rightW, lbPTH)];
    
    CGFloat lbDDY = self.lbPlayTime.y+self.lbPlayTime.height+2;
    CGFloat lbDDH = 16;
    [self.lbDownloadDesc setFrame:CGRectMake(lbX, lbDDY, rightW, lbDDH)];
}

-(void)btnDownloadClick:(ZButton *)sender
{
    if (self.onDownloadClick) {
        self.onDownloadClick(sender.tag, self.tag);
    }
}
/// 设置播放按钮状态
-(void)setDownloadButtonImage:(ZDownloadStatus)status
{
    [self.btnDownload setTag:status];
    switch (status) {
        case ZDownloadStatusNomral:
            [self.btnDownload setDownloadImage:@"icon_download_pause_gray"];
            break;
        case ZDownloadStatusStart:
            [self.btnDownload setDownloadImage:@"icon_download_start_gray"];
            break;
        case ZDownloadStatusEnd:
            [self.btnDownload setDownloadProgress:1];
            [self.btnDownload setDownloadImage:@"icon_download_pause_gray"];
            break;
        default: break;
    }
}
/// 获取播放按钮状态
-(ZDownloadStatus)getDownloadStatus
{
    return self.btnDownload.tag;
}
/// 设置下载进度
-(void)setDownloadProgress:(CGFloat)progress
{
    [self.btnDownload setDownloadProgress:progress];
    NSString *percentageText = [NSString stringWithFormat:@"%d%%",(int)(progress*100)];
    if (progress == 0) {
        [self.lbPercentage setTextColor:DESCCOLOR];
        [self.lbPercentage setText:kDownloadWaiting];
    } else {
        [self.lbPercentage setTextColor:MAINCOLOR];
        [self.lbPercentage setText:percentageText];
    }
    [self setNeedsDisplay];
}

-(CGFloat)setCellDataWithModel:(ModelAudio *)model
{
    [self.imgLogo setImageURLStr:model.audioImage placeImage:[SkinManager getPracticeImage]];
    
    [self.lbTitle setText:model.audioTitle];
    
    [self.lbLecturer setText:[NSString stringWithFormat:@"%@: %@", kSpeaker, model.audioAuthor]];
    [self.lbLecturer setLabelColorWithRange:NSMakeRange(0, 4) color:DESCCOLOR];
    
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getHHMMSSFromSS:model.totalDuration]]];
    
    if (model.address == ZDownloadStatusStart) {
        [self.lbDownloadDesc setText:kClickToSuspendDownload];
    } else {
        [self.lbDownloadDesc setText:kHasBeenSuspendedClickToContinueToDownload];
    }
    
    [self setDownloadButtonImage:model.address];
    
    [self setDownloadProgress:model.progress];
    
    [self setViewFrame];
    
    [self setNeedsDisplay];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_btnCheck);
    OBJC_RELEASE(_btnDownload);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbLecturer);
    OBJC_RELEASE(_lbPlayTime);
    OBJC_RELEASE(_lbPercentage);
    OBJC_RELEASE(_lbDownloadDesc);
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
    return 128;
}

@end
