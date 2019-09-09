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

@interface ZGlobalPlayView()

@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZImageView *imageIcon;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbTime;
@property (strong, nonatomic) ZButton *btnPlay;
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
        [self innerInit];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit
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
    if (!self.btnPlay) {
        self.btnPlay = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPlay setUserInteractionEnabled:true];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"play"] forState:(UIControlStateNormal)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"play_stop"] forState:(UIControlStateSelected)];
        [self.btnPlay setImageEdgeInsets:(UIEdgeInsetsMake(4, 4, 4, 4))];
        [self.btnPlay addTarget:self action:@selector(btnPlayClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewContent addSubview:self.btnPlay];
    }
    if (!self.btnClose) {
        self.btnClose = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnClose setUserInteractionEnabled:true];
        [self.btnClose setImage:[SkinManager getImageWithName:@"close"] forState:(UIControlStateNormal)];
        [self.btnClose setImage:[SkinManager getImageWithName:@"close"] forState:(UIControlStateHighlighted)];
        [self.btnClose setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
        [self.btnClose addTarget:self action:@selector(btnCloseClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewContent addSubview:self.btnClose];
    }
    [self setViewFrame];
}
-(void)dealloc
{
    _viewContent = nil;
    _viewPlayContent = nil;
    _lbTime = nil;
    _lbTitle = nil;
    _imageIcon = nil;
    _btnPlay = nil;
    _btnClose = nil;
}
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    [self setViewFrame];
//}
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
    
    [self.btnPlay setFrame:(CGRectMake(self.viewContent.width-11-playS, contentH/2-playS/2, playS, playS))];
}
-(void)btnPlayClick
{
    [self setPlayStatus:!self.btnPlay.selected];
    if (self.onPlayStatusClick) {
        self.onPlayStatusClick(self.btnPlay.selected);
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
///设置播放状态
-(void)setPlayStatus:(BOOL)isPlaying
{
    if (self.btnPlay.selected == isPlaying) {
        return;
    }
    [self.btnClose setHidden:isPlaying];
    [self.btnPlay setSelected:isPlaying];
    
    [self setViewFrame];
}
///设置播放对象
-(void)setViewData:(ModelTrack*)model row:(NSInteger)row
{
    self.rowIndex = row;
    self.modelT = model;
    
    NSString *nickname = model.announcer.nickname;
    NSString *time = [Utils getHHMMSSFromSSTime:model.duration];
    NSLog(@"播放时长: %@,  %ld", time, model.duration);
    NSString *strTime =[NSString stringWithFormat:@"%@  %@", time, nickname==nil?kEmpty:nickname];
    GCDMainBlock(^{
        [self.imageIcon setImageURLStr:model.coverUrlSmall placeImage:[SkinManager getDefaultImage]];
        [self.lbTitle setText:model.trackTitle];
        [self.lbTime setText:strTime];
    });
}
+(CGFloat)getH
{
    return 50;
}

@end
