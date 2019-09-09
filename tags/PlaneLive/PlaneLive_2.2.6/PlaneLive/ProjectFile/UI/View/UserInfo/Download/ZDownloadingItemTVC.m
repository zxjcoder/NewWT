//
//  ZDownloadingItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 19/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZDownloadingItemTVC.h"
#import "ZBaseCircleView.h"

@interface ZDownloadingItemTVC()

@property (strong, nonatomic) UIView *viewContent;
///下载按钮
@property (strong, nonatomic) ZButton *btnDownloading;
@property (strong, nonatomic) ZBaseCircleView *viewDownloading;
///下载按钮
@property (strong, nonatomic) ZButton *btnDownload;
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
@property (assign, nonatomic) XMCacheTrackStatus ctStatus;

@end

@implementation ZDownloadingItemTVC

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
    
    self.cellH = [ZDownloadingItemTVC getH];
    self.space = 20;
    
    self.viewContent = [[UIView alloc] initWithFrame:(CGRectMake(self.space, 15, self.cellW - self.space*2, self.cellH - 30))];
    [self.viewContent setBackgroundColor:CLEARCOLOR];
    [self.viewMain addSubview:self.viewContent];
    
    CGFloat imgSize = 100;
    self.imgLogo = [[ZImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize, imgSize)];
    [self.imgLogo.layer setMasksToBounds:YES];
    [self.imgLogo setViewRound:kIMAGE_ROUND_SIZE borderWidth:1 borderColor:WHITECOLOR];
    self.imgLogo.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.imgLogo.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.imgLogo.layer.shadowOpacity = 0.58;//不透明度
    self.imgLogo.layer.shadowRadius = 5.0;//半径
    [self.viewContent addSubview:self.imgLogo];
    
    CGFloat btnSize = 35;
    CGFloat btnY = self.imgLogo.y + self.imgLogo.height - btnSize;
    self.btnDownload = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDownload setFrame:(CGRectMake(self.viewContent.width - btnSize, btnY, btnSize, btnSize))];
    [self.btnDownload setImage:[SkinManager getImageWithName:@"download_ing"] forState:(UIControlStateNormal)];
    [self.btnDownload setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnDownload addTarget:self action:@selector(btnDownloadClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnDownload];
    
    self.btnDownloading = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDownloading setFrame:self.btnDownload.frame];
    [self.btnDownloading setHidden:true];
    [self.btnDownloading setUserInteractionEnabled:true];
    [self.btnDownloading addTarget:self action:@selector(btnDownloadingClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnDownloading];
    
    self.viewDownloading = [[ZBaseCircleView alloc] initWithFrame:(CGRectMake(5, 5, self.btnDownloading.width-10, self.btnDownloading.height-10))];
    self.viewDownloading.showTipLabel = false;
    self.viewDownloading.lineWidth = 2;
    self.viewDownloading.lineTintColor = COLORVIEWBACKCOLOR3;
    self.viewDownloading.minLineColor = COLORCONTENT1;
    self.viewDownloading.midLineColor = COLORCONTENT2;
    self.viewDownloading.maxLineColor = COLORCONTENT1;
    self.viewDownloading.userInteractionEnabled = false;
    self.viewDownloading.imageBackgroud = [SkinManager getImageWithName:@"download_arrow"];
    [self.btnDownloading addSubview:self.viewDownloading];
    
    CGFloat titleY = 1;
    CGFloat lbX = self.imgLogo.x + self.imgLogo.width + 10;
    CGFloat lbW = self.viewContent.width - lbX;
    self.lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(lbX, 1, lbW, self.lbH))];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.viewContent addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbLecturer setNumberOfLines:2];
    [self.lbLecturer setTextColor:COLORTEXT3];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbLecturer];
    
    self.lbPlayTime = [[UILabel alloc] init];
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbPlayTime setNumberOfLines:1];
    [self.lbPlayTime setTextColor:COLORTEXT3];
    [self.lbPlayTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbPlayTime];
    
    self.imgLine = [UIImageView getTLineView];
    [self.imgLine setFrame:CGRectMake(self.space, self.cellH-self.lineH, self.cellW-self.space*2, self.lineH)];
    [self.viewMain addSubview:self.imgLine];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat contentX = 20;
    CGFloat contentW = self.cellW - contentX - 20;
    [self.viewContent setFrame:(CGRectMake(contentX, 15, contentW, self.cellH - 30))];
    CGFloat imgSize = 100;
    [self.imgLogo setFrame:CGRectMake(0, 0, imgSize, imgSize)];
    
    CGFloat titleY = 1;
    CGFloat lbX = self.imgLogo.x + self.imgLogo.width + 10;
    CGFloat lbW = self.viewContent.width - lbX;
    CGRect titleFrame = CGRectMake(lbX, titleY, lbW, self.lbH);
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
    
    CGFloat btnSize = 35;
    CGFloat btnY = self.imgLogo.y + self.imgLogo.height - btnSize;
    [self.btnDownload setFrame:(CGRectMake(contentW - btnSize, btnY, btnSize, btnSize))];
    
    [self.viewMain setFrame:[self getMainFrame]];
}
-(void)btnDownloadingClick
{
    if (self.onDownloadButtonClick) {
        self.onDownloadButtonClick(self.ctStatus, self.tag);
    }
}
-(void)btnDownloadClick
{
    if (self.onDownloadButtonClick) {
        self.onDownloadButtonClick(self.ctStatus, self.tag);
    }
}
///设置下载进度
-(void)setDownloadProgress:(double)progress
{
    //[self.btnDownload setDownloadProgress:progress];
    //[self.viewDownloading setProgress:progress animated:true];
    [self.viewDownloading setProgress:progress];
    //[self.viewDownloading setNeedsDisplay];
}
///设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status
{
    NSLog([NSString stringWithFormat:@"trackTitle: %@,  XMCacheTrackStatus: %d", self.modelCT.trackTitle, (int)status]);
    self.ctStatus = status;
    self.modelCT.status = status;
    switch (status) {
        case XMCacheTrackStatusPausedByUser:
        case XMCacheTrackStatusPausedBySystem:
            self.btnDownloading.hidden = true;
            self.btnDownload.hidden = false;
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download_stop"] forState:(UIControlStateNormal)];
            break;
        case XMCacheTrackStatusDownloaded:
            self.btnDownloading.hidden = true;
            self.btnDownload.hidden = false;
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download_end"] forState:(UIControlStateNormal)];
            break;
        case XMCacheTrackStatusDownloading:
            self.btnDownloading.hidden = false;
            self.btnDownload.hidden = true;
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateNormal)];
            break;
        default:
            self.btnDownloading.hidden = true;
            self.btnDownload.hidden = false;
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download_ing"] forState:(UIControlStateNormal)];
            break;
    }
}
-(CGFloat)setCellDataWithModel:(XMCacheTrack *)model
{
    [self setModelCT:model];
    
    [self.imgLogo setImageURLStr:model.coverUrlSmall placeImage:[SkinManager getDefaultImage]];
    [self.lbTitle setText:model.trackTitle];
    [self.lbLecturer setText:[NSString stringWithFormat:@"%@", model.announcer.nickname]];
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getHHMMSSFromSSTime:model.duration]]];
    
    [self setDownloadStatus:model.status];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_btnDownload);
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
