//
//  ZNewSubscribeAlreadyHasItemTVC.m
//  PlaneLive
//
//  Created by WT on 29/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewSubscribeAlreadyHasItemTVC.h"
#import "ZBaseCircleView.h"

@interface ZNewSubscribeAlreadyHasItemTVC()

@property (strong, nonatomic) ZView *viewIcon;
@property (strong, nonatomic) ZImageView *imageIcon;
@property (strong, nonatomic) ZButton *btnPlay;

@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbTime;

///下载按钮
@property (strong, nonatomic) ZButton *btnDownloading;
@property (strong, nonatomic) ZBaseCircleView *viewDownloading;
///下载按钮
@property (strong, nonatomic) ZButton *btnDownload;
@property (strong, nonatomic) ZButton *btnCourse;

@property (strong, nonatomic) ZImageView *imageLine;

@property (strong, nonatomic) ModelCurriculum *modelC;
@property (assign, nonatomic) XMCacheTrackStatus ctStatus;
@property (assign, nonatomic) BOOL isPlayClick;

@end

@implementation ZNewSubscribeAlreadyHasItemTVC

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
    self.cellH = [ZNewSubscribeAlreadyHasItemTVC getH];
    self.space = 20;
    CGFloat imageSize = 44;
    self.viewIcon = [[ZView alloc] initWithFrame:(CGRectMake(self.space, 18, imageSize, imageSize))];
    [self.viewIcon setViewRound:8];
    [self.viewMain addSubview:self.viewIcon];
    
    self.imageIcon = [[ZImageView alloc] initWithFrame:(CGRectMake(0, 0, imageSize, imageSize))];
    [self.viewIcon addSubview:self.imageIcon];
    
    self.btnPlay = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_ing"] forState:(UIControlStateNormal)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_ing"] forState:(UIControlStateHighlighted)];
    [self.btnPlay setFrame:(CGRectMake(0, 0, imageSize, imageSize))];
    [self.btnPlay setImageEdgeInsets:(UIEdgeInsetsMake(16, 16, 16, 16))];
    [self.btnPlay setBackgroundColor:RGBCOLORA(44, 50, 65, 0.4)];
    [self.btnPlay setTag:100];
    [self.btnPlay addTarget:self action:@selector(btnPlayClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewIcon addSubview:self.btnPlay];
    
    CGFloat titleX = self.viewIcon.x+self.viewIcon.width+10;
    CGFloat titleW = self.cellW-self.space-titleX;
    self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(titleX, 15, titleW, 26))];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewMain addSubview:self.lbTitle];
    
    CGFloat btnSize = 34;
    CGFloat timeW = titleW-btnSize*2;
    CGFloat timeY = self.lbTitle.y+self.lbTitle.height+6;
    self.lbTime = [[ZLabel alloc] initWithFrame:(CGRectMake(titleX, timeY, timeW, 18))];
    [self.lbTime setTextColor:COLORTEXT3];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewMain addSubview:self.lbTime];
    
    CGFloat btnY = self.cellH-btnSize-5;
    self.btnCourse = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCourse setImage:[SkinManager getImageWithName:@"matter"] forState:(UIControlStateNormal)];
    [self.btnCourse setFrame:(CGRectMake(self.cellW-btnSize+7-self.space, btnY, btnSize, btnSize))];
    [self.btnCourse setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnCourse addTarget:self action:@selector(btnCourseClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnCourse];
    
    self.btnDownload = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDownload setFrame:CGRectMake(self.btnCourse.x-btnSize, self.btnCourse.y, btnSize, btnSize)];
    [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateNormal)];
    [self.btnDownload setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnDownload addTarget:self action:@selector(btnDownloadClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnDownload];
    
    self.btnDownloading = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDownloading setFrame:self.btnDownload.frame];
    [self.btnDownloading setHidden:true];
    [self.btnDownloading setUserInteractionEnabled:true];
    [self.btnDownloading addTarget:self action:@selector(btnDownloadingClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnDownloading];
    
    self.viewDownloading = [[ZBaseCircleView alloc] initWithFrame:(CGRectMake(5, 5, self.btnDownloading.width-10, self.btnDownloading.height-10))];
    self.viewDownloading.showTipLabel = false;
    self.viewDownloading.lineWidth = 2;
    self.viewDownloading.lineTintColor = RGBCOLORA(121, 140, 163, 0.3);
    self.viewDownloading.minLineColor = COLORCONTENT1;
    self.viewDownloading.midLineColor = COLORCONTENT2;
    self.viewDownloading.maxLineColor = COLORCONTENT1;
    self.viewDownloading.userInteractionEnabled = false;
    [self.btnDownloading addSubview:self.viewDownloading];
    
    self.imageLine = [ZImageView getDLineView];
    [self.imageLine setFrame:(CGRectMake(self.space, self.cellH-kLineHeight, self.cellW-self.space*2, kLineHeight))];
    [self.viewMain addSubview:self.imageLine];
    
    [self sendSubviewToBack:self.btnDownload];
}
-(void)btnPlayClick:(ZButton *)sender
{
    if (self.isPlayClick) {
        return;
    }
    self.isPlayClick = true;
    if (sender.tag == 100) {
        if (self.onStartPlayClick) {
            self.onStartPlayClick(self.tag);
        }
    } else {
        if (self.onStopPlayClick) {
            self.onStopPlayClick(self.modelC);
        }
    }
    self.isPlayClick = false;
}
-(void)btnCourseClick
{
    if (self.onCourseClick) {
        self.onCourseClick(self.modelC);
    }
}
-(void)btnDownloadClick
{
    if (self.onDownloadClick) {
        self.onDownloadClick(self.tag, self.modelC);
    }
}
-(void)btnDownloadingClick
{
    [self btnDownloadClick];
}
///设置是否播放中
-(void)setIsPlayStatus:(BOOL)status
{
    [self setIsPlayClick:false];
    if (status) {
        [self.btnPlay setTag:101];
        [self.lbTitle setTextColor:COLORCONTENT1];
        [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
        
        [self.btnPlay setBackgroundColor:RGBCOLORA(106, 205, 108, 0.4)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"play_stop2"] forState:(UIControlStateNormal)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"play_stop2"] forState:(UIControlStateHighlighted)];
    } else {
        [self.btnPlay setTag:100];
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        
        [self.btnPlay setBackgroundColor:RGBCOLORA(44, 50, 65, 0.4)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"play_ing"] forState:(UIControlStateNormal)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"play_ing"] forState:(UIControlStateHighlighted)];
    }
}
///设置下载进度
-(void)setDownloadProgress:(double)progress
{
    GBLog([NSString stringWithFormat:@"title: %@,  downloadProgress: %lf", self.modelC.title, progress]);
    [self.viewDownloading setProgress:progress];
}
///设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status
{
    GBLog([NSString stringWithFormat:@"title: %@,  XMCacheTrackStatus: %d", self.modelC.title, (int)status]);
    self.ctStatus = status;
    switch (status) {
        case XMCacheTrackStatusPausedByUser:
        case XMCacheTrackStatusPausedBySystem:
            if (self.modelC.downloadProgress > 0) {
                self.btnDownloading.hidden = false;
                [self.viewDownloading setProgress:self.modelC.downloadProgress];
                [self.viewDownloading setImageBackgroud:[SkinManager getImageWithName:@"download_arrow_h"]];
                
                self.btnDownload.hidden = true;
                [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateNormal)];
            } else {
                self.btnDownloading.hidden = true;
                
                self.btnDownload.hidden = false;
                [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateNormal)];
            }
            break;
        case XMCacheTrackStatusDownloaded:
            self.btnDownloading.hidden = true;
            
            self.btnDownload.hidden = false;
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download_end"] forState:(UIControlStateNormal)];
            break;
        case XMCacheTrackStatusDownloading:
            self.btnDownloading.hidden = false;
            [self.viewDownloading setImageBackgroud:[SkinManager getImageWithName:@"download_stop_h2"]];
            
            self.btnDownload.hidden = true;
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateNormal)];
            break;
        default:
            self.btnDownloading.hidden = true;
            
            self.btnDownload.hidden = false;
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateNormal)];
            break;
    }
}
-(CGFloat)setCellDataWithModel:(ModelCurriculum *)model
{
    [self setModelC:model];
    
    [self.imageIcon setImageURLStr:model.audio_picture placeImage:[SkinManager getDefaultImage]];
    [self.lbTitle setText:model.ctitle];
    [self.lbTime setText:[NSString stringWithFormat:@"%@ %@", [Utils getHHMMSSFromSS:model.audio_time], model.create_time]];
    
    return self.cellH;
}
+(CGFloat)getH
{
    return 80;
}

@end
