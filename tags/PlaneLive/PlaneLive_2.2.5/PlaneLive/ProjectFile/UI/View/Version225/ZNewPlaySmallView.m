//
//  ZNewPlaySmallView.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewPlaySmallView.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "ZImageView.h"
#import "ZView.h"
#import "ZPlayerViewController.h"

@interface ZNewPlaySmallView()

@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZImageView *imageIcon;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbDesc;

@property (strong, nonatomic) ZButton *btnPlay;

@end

@implementation ZNewPlaySmallView

static ZNewPlaySmallView *newPlaySmallView;
+(ZNewPlaySmallView *)sharedSingleton
{
    static dispatch_once_t onceTokenPlayView;
    dispatch_once(&onceTokenPlayView, ^{
        newPlaySmallView = [[ZNewPlaySmallView alloc] init];
        [newPlaySmallView innerInit];
    });
    return newPlaySmallView;
}

-(id)init
{
    self = [super initWithFrame:(CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, [ZNewPlaySmallView getH]))];
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
-(id)initWithPoint:(CGRect)point
{
    self = [super initWithFrame:(CGRectMake(point.origin.x, point.origin.y, APP_FRAME_WIDTH, [ZNewPlaySmallView getH]))];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self setBackgroundColor:CLEARCOLOR];
    self.viewContent = [[ZView alloc] initWithFrame:(CGRectMake(5, 1, APP_FRAME_WIDTH-10, [ZNewPlaySmallView getH]-1))];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewContent];
    
    CGFloat imgSize = 28;
    CGFloat imgY = (self.viewContent.height - imgSize)/2;
    self.imageIcon = [[ZImageView alloc] initWithFrame:(CGRectMake(15, imgY, imgSize, imgSize))];
    [[self.imageIcon layer] setMasksToBounds:true];
    [self.imageIcon setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewContent addSubview:self.imageIcon];
    
    CGFloat btnSize = 34;
    CGFloat btnX = self.viewContent.width-btnSize-10;
    CGFloat lbX = self.imageIcon.width+self.imageIcon.x+8;
    CGFloat lbW = btnX-lbX;
    CGFloat lbTitleY = 5;
    self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(lbX, lbTitleY, lbW, 18))];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbTitle];
    
    self.lbDesc = [[ZLabel alloc] initWithFrame:(CGRectMake(lbX, lbTitleY, lbW, 16))];
    [self.lbDesc setTextColor:COLORTEXT3];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewContent addSubview:self.lbDesc];
    
    self.btnPlay = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play"] forState:(UIControlStateNormal)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_stop"] forState:(UIControlStateSelected)];
    [self.btnPlay setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnPlay addTarget:self action:@selector(btnPlayEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnPlay];
}
-(void)btnPlayEvent
{
    if (self.btnPlay.selected) {
        [[ZPlayerViewController sharedSingleton] setPausePlay];
    } else {
        [[ZPlayerViewController sharedSingleton] setStartPlay];
    }
    [self.btnPlay setSelected:!self.btnPlay];
}
-(void)setViewPlayStatus:(BOOL)isPlaying
{
    [self.btnPlay setSelected:isPlaying];
}
-(void)setViewDataWithPModel:(ModelPractice *)model
{
    [self.imageIcon setImageURLStr:model.speech_img placeImage:[SkinManager getDefaultImage]];
    [self.lbTitle setText:model.title];
    [self.lbDesc setText:[NSString stringWithFormat:@"%@ %@", [Utils getMinuteFromSS:model.time], model.nickname]];
}
-(void)setViewDataWithSModel:(ModelSubscribe *)model
{
    [self.imageIcon setImageURLStr:model.illustration placeImage:[SkinManager getDefaultImage]];
    [self.lbTitle setText:model.title];
    [self.lbDesc setText:[NSString stringWithFormat:@"%@ %@", [Utils getMinuteFromSS:model.time], model.team_name]];
}
+(CGFloat)getH
{
    return 45;
}

@end
