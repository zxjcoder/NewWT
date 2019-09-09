//
//  ZGlobalPlayView.m
//  PlaneLive
//
//  Created by Daniel on 27/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZGlobalPlayView.h"
#import "ZImageView.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "Utils.h"
#import "ZBaseCircleView.h"

@interface ZGlobalPlayView()

@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZImageView *imageIcon;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbTime;
@property (strong, nonatomic) ZButton *btnPlaying;
@property (strong, nonatomic) ZBaseCircleView *viewPlaying;

@property (strong, nonatomic) ZButton *btnClose;
@property (strong, nonatomic) ZView *viewPlayContent;

@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) NSInteger rowIndex;
@property (strong, nonatomic) ModelTrack *modelT;

@end

@implementation ZGlobalPlayView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
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
    [self setBackgroundColor:CLEARCOLOR];
    [self setClipsToBounds:true];
    
    if (!self.viewContent) {
        self.viewContent = [[ZView alloc] init];
        [self.viewContent setBackgroundColor:WHITECOLOR];
        [self.viewContent setAllShadowColorWithRadius:8];
        [self addSubview:self.viewContent];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setViewTap:)];
        [self.viewContent addGestureRecognizer:tapGesture];
    }
    if (!self.viewPlayContent) {
        self.viewPlayContent = [[ZView alloc] init];
        [self.viewContent addSubview:self.viewPlayContent];
    }
    if (!self.imageIcon) {
        self.imageIcon = [[ZImageView alloc] init];
        [[self.imageIcon layer] setMasksToBounds:true];
        [self.imageIcon setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
        [self.viewPlayContent addSubview:self.imageIcon];
    }
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] init];
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbTitle setNumberOfLines:1];
        [self.viewPlayContent addSubview:self.lbTitle];
    }
    if (!self.lbTime) {
        self.lbTime =  [[ZLabel alloc] init];
        [self.lbTime setTextColor:COLORTEXT3];
        [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbTime setNumberOfLines:1];
        [self.viewPlayContent addSubview:self.lbTime];
    }
    if (!self.btnPlaying) {
        self.btnPlaying = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPlaying setUserInteractionEnabled:true];
        [self.btnPlaying setTag:100];
        [self.btnPlaying addTarget:self action:@selector(btnPlayClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewContent addSubview:self.btnPlaying];
    }
    if (!self.btnClose) {
        self.btnClose = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnClose setUserInteractionEnabled:true];
        [self.btnClose setImage:[SkinManager getImageWithName:@"clear"] forState:(UIControlStateNormal)];
        [self.btnClose setImage:[SkinManager getImageWithName:@"clear"] forState:(UIControlStateHighlighted)];
        [self.btnClose setImageEdgeInsets:(UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5))];
        [self.btnClose addTarget:self action:@selector(btnCloseClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewContent addSubview:self.btnClose];
    }
    [self setViewFrame];
    
    if (!self.viewPlaying) {
        self.viewPlaying = [[ZBaseCircleView alloc] initWithFrame:(CGRectMake(5, 5, self.btnPlaying.width-10, self.btnPlaying.height-10))];
        self.viewPlaying.showTipLabel = false;
        self.viewPlaying.lineWidth = 2;
        self.viewPlaying.lineTintColor = RGBCOLORA(121, 140, 163, 0.3);
        self.viewPlaying.minLineColor = COLORCONTENT1;
        self.viewPlaying.midLineColor = COLORCONTENT2;
        self.viewPlaying.maxLineColor = COLORCONTENT1;
        self.viewPlaying.userInteractionEnabled = false;
        [self setPlayImageBG:@"download_play_d"];
        [self.btnPlaying addSubview:self.viewPlaying];
    }
}
-(void)setViewFrame
{
    self.contentFrame = CGRectMake(10, 5, self.width-20, self.height+10);
    [self.viewContent setFrame:self.contentFrame];
    
    CGFloat contentH = 44;
    CGFloat playS = 35;
    [self.btnClose setFrame:(CGRectMake(1, contentH/2-playS/2, playS, playS))];
    if (!self.btnClose.hidden) {
        CGFloat playcontentX = self.btnClose.x+self.btnClose.width;
        CGFloat playcontentW = self.viewContent.width-playS-playcontentX-5;
        [self.viewPlayContent setFrame:(CGRectMake(playcontentX, 0, playcontentW, contentH))];
    } else {
        CGFloat playcontentX = 15;
        CGFloat playcontentW = self.viewContent.width-playS-playcontentX-5;
        [self.viewPlayContent setFrame:(CGRectMake(playcontentX, 0, playcontentW, contentH))];
    }
    CGFloat iconS = 30;
    [self.imageIcon setFrame:(CGRectMake(0, contentH/2-iconS/2, iconS, iconS))];
    
    CGFloat lbX = self.imageIcon.x+self.imageIcon.width+8;
    CGFloat lbW = self.viewPlayContent.width-lbX;
    [self.lbTitle setFrame:(CGRectMake(lbX, 5, lbW, 18))];
    [self.lbTime setFrame:(CGRectMake(lbX, self.lbTitle.y+self.lbTitle.height, lbW, 18))];
    
    [self.btnPlaying setFrame:(CGRectMake(self.viewContent.width-11-playS, contentH/2-playS/2, playS, playS))];
}
-(void)btnPlayClick
{
    BOOL isPlayering = (self.btnPlaying.tag==101);
    if (self.onPlayStatusClick) {
        self.onPlayStatusClick(isPlayering);
    }
}
-(void)btnCloseClick
{
    if (self.onCloseClick) {
        self.onCloseClick();
    }
}
-(void)setViewTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onPlayViewClick) {
            self.onPlayViewClick(self.modelT, self.rowIndex);
        }
    }
}
-(void)show
{
    if (self.viewContent.alpha==1) {
        return;
    }
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewContent.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)dismiss
{
    if (self.viewContent.alpha==0) {
        return;
    }
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewContent.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)setPlayImageBG:(NSString *)imageName
{
    [self.viewPlaying setImageBackgroud:[SkinManager getImageWithName:imageName] imageSize:16];
}
///设置播放状态
-(void)setPlayStatus:(BOOL)isPlaying
{
    if ((isPlaying && self.btnPlaying.tag == 101) || (!isPlaying && self.btnPlaying.tag == 100)) {
        return;
    }
    if (isPlaying) {
        [self.btnPlaying setTag:101];
        [self setPlayImageBG:@"download_stop_d"];
    } else {
        [self.btnPlaying setTag:100];
        [self setPlayImageBG:@"download_play_d"];
    }
    [self.btnClose setHidden:isPlaying];
    
    [self setViewFrame];
}
///设置播放进度
-(void)setPlayProgress:(CGFloat)progress
{
    [self.viewPlaying setProgress:progress];
}
///设置播放对象
-(void)setViewData:(ModelTrack*)model row:(NSInteger)row
{
    self.rowIndex = row;
    self.modelT = model;
    
    NSString *nickname = model.announcer.nickname;
    NSString *time = [Utils getHHMMSSFromSSTime:model.duration];
    GBLog(@"播放时长: %@,  %ld", time, model.duration);
    NSString *strTime =[NSString stringWithFormat:@"%@  %@", time, nickname==nil?kEmpty:nickname];
    GCDMainBlock(^{
        [self.imageIcon setImageURLStr:model.coverUrlSmall placeImage:[SkinManager getDefaultImage]];
        [self.lbTitle setText:model.trackTitle];
        [self.lbTime setText:strTime];
    });
}
+(CGFloat)getH
{
    if (IsIPhoneX) {
        return 50+kIPhoneXButtonHeight;
    }
    return 50;
}
+(CGFloat)getMinH
{
    return 50;
}

@end
