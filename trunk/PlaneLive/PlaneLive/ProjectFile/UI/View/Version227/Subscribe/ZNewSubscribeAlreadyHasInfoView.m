//
//  ZNewSubscribeAlreadyHasInfoView.m
//  PlaneLive
//
//  Created by WT on 02/04/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewSubscribeAlreadyHasInfoView.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "ZImageView.h"
#import "ZCalculateLabel.h"

@interface ZNewSubscribeAlreadyHasInfoView()

///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///LOGO区域
@property (strong, nonatomic) UIView *viewLogoBG;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///主持人
@property (strong, nonatomic) UILabel *lbLecturer;
///时长
@property (strong, nonatomic) UILabel *lbPlayTime;
///收听
@property (strong, nonatomic) ZView *viewListen;
///收听ICON
@property (strong, nonatomic) UIImageView *imgListen;
///收听数量
@property (strong, nonatomic) ZLabel *lbListen;
///批量下载
@property (strong, nonatomic) ZButton *btnDownload;
@property (strong, nonatomic) ModelSubscribe *model;

@end

@implementation ZNewSubscribeAlreadyHasInfoView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    [self setBackgroundColor:WHITECOLOR];
    
    self.viewLogoBG = [[UIView alloc] init];
    [self.viewLogoBG.layer setMasksToBounds:YES];
    [self.viewLogoBG setViewRound:kIMAGE_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewLogoBG];
    
    self.imgLogo = [[ZImageView alloc] init];
    [self.viewLogoBG addSubview:self.imgLogo];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:3];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self addSubview:self.lbTitle];
    
    self.lbLecturer = [[UILabel alloc] init];
    [self.lbLecturer setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbLecturer setNumberOfLines:2];
    [self.lbLecturer setTextColor:COLORTEXT3];
    [self.lbLecturer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbLecturer];
    
    self.lbPlayTime = [[UILabel alloc] init];
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@ : 0%@", kTimeDuration, kMinute]];
    [self.lbPlayTime setTextColor:COLORTEXT3];
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self addSubview:self.lbPlayTime];
    
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
    
    self.btnDownload = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDownload setImage:[SkinManager getImageWithName:@"downloaddata"] forState:(UIControlStateNormal)];
    [self.btnDownload setImage:[SkinManager getImageWithName:@"downloaddata"] forState:(UIControlStateHighlighted)];
    [self.btnDownload setTitle:@"批量下载" forState:(UIControlStateNormal)];
    [self.btnDownload setTitle:@"批量下载" forState:(UIControlStateHighlighted)];
    [self.btnDownload setTitleColor:RGBCOLOR(42, 160, 233) forState:(UIControlStateNormal)];
    [self.btnDownload setTitleColor:RGBCOLOR(42, 160, 233) forState:(UIControlStateHighlighted)];
    [[self.btnDownload titleLabel] setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    //    [self.btnDownload setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    //    [self.btnDownload setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnDownload addTarget:self action:@selector(btnDownloadClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnDownload];
    
    [self setViewFrame];
}
-(void)btnDownloadClick
{
    if (self.onDownloadEvent) {
        self.onDownloadEvent(self.model);
    }
}
-(void)setViewFrame
{
    CGFloat space = 20;
    CGFloat imgS = 100;
    CGFloat imgViewS = imgS;
    [self.viewLogoBG setFrame:CGRectMake(space, 17, imgViewS, imgViewS)];
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
    CGFloat lbRightW = self.width - lbRightX - space;
    CGRect titleFrame = CGRectMake(lbRightX, self.viewLogoBG.y, lbRightW, 20);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleNewH = [self.lbTitle getLabelHeightWithMinHeight:20];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:self.lbTitle.font width:self.lbTitle.width]*3;
    if (titleNewH <= titleMaxH) {
        titleFrame.size.height = titleNewH;
    } else {
        titleFrame.size.height = titleMaxH;
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGRect lecturerFrame = CGRectMake(lbRightX, self.lbTitle.y + self.lbTitle.height + 6, lbRightW, 18);
    [self.lbLecturer setFrame:lecturerFrame];
    CGFloat lecturerNewH = [self.lbLecturer getLabelHeightWithMinHeight:18];
    CGFloat lecturerMaxH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:self.lbLecturer.font width:self.lbLecturer.width]*2;
    if (lecturerNewH <= lecturerMaxH) {
        lecturerFrame.size.height = lecturerNewH;
    } else {
        lecturerFrame.size.height = lecturerMaxH;
    }
    [self.lbLecturer setFrame:lecturerFrame];
    
    CGFloat timeY = self.viewLogoBG.y + self.viewLogoBG.height - 18;
    [self.lbPlayTime setFrame:CGRectMake(lbRightX, timeY, 200, 18)];
    
    CGFloat downloadW = 90;
    CGFloat downloadH = 34;
    CGFloat downloadY = timeY-(downloadH-self.lbPlayTime.height)/2;
    CGFloat downlaodX = self.width-downloadW-space+2;
    [self.btnDownload setFrame:(CGRectMake(downlaodX, downloadY, downloadW, downloadH))];
}
-(void)setHiddenDownloadButton:(BOOL)isHidden
{
    [self.btnDownload setHidden:isHidden];
}
-(void)setCellDataWithModel:(ModelSubscribe *)model
{
    [self setModel:model];
    
    [self.imgLogo setImageURLStr:model.illustration placeImage:[SkinManager getDefaultImage]];
    [self.lbTitle setText:model.title];
    [self.lbLecturer setText:model.team_name];
    [self.lbPlayTime setText:model.time];
    
    if (model.hits > kNumberMaximumCount) {
        [self.lbListen setText:[NSString stringWithFormat:@"%.1f%@", (float)(model.hits/(float)(kNumberMaximumCount+1)), kMillion]];
    } else {
        [self.lbListen setText:[NSString stringWithFormat:@"%ld", model.hits]];
    }
    [self setViewFrame];
}
+(CGFloat)getH
{
    return 122;
}

@end
