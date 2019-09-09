//
//  ZSubscribeContinuousSowingTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeContinuousSowingTVC.h"
#import "Utils.h"

@interface ZSubscribeContinuousSowingTVC()

@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbPlayTime;
@property (strong, nonatomic) ZImageView *imgPlay;

@end

@implementation ZSubscribeContinuousSowingTVC

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
    self.cellH = [ZSubscribeContinuousSowingTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgPlay = [[ZImageView alloc] init];
    [self.viewMain addSubview:self.imgPlay];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbPlayTime  = [[ZLabel alloc] init];
    [self.lbPlayTime setTextColor:COLORTEXT3];
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbPlayTime setNumberOfLines:1];
    [self.lbPlayTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPlayTime];
}

-(void)setViewFrame
{
    CGFloat imageSize = 32;
    [self.imgPlay setFrame:(CGRectMake(self.space, 20, imageSize, imageSize))];
    
    CGFloat lbX = self.imgPlay.x+self.imgPlay.width+10;
    CGFloat lbW = self.cellW-lbX-self.space;
    
    CGRect titleFrame = CGRectMake(lbX, 26, lbW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    [self.lbPlayTime setFrame:CGRectMake(lbX, self.lbTitle.y+self.lbTitle.height+8, 250, self.lbMinH)];
    
    self.cellH = self.lbPlayTime.y+self.lbPlayTime.height+5;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbPlayTime);
    OBJC_RELEASE(_imgPlay);
    [super setViewNil];
}
-(void)setIsPlaying:(BOOL)playing
{
    if (playing) {
        self.imgPlay.image = [SkinManager getImageWithName:@"play_stop"];
    } else {
        self.imgPlay.image = [SkinManager getImageWithName:@"play"];
    }
}
-(CGFloat)setCellDataWithModel:(ModelCurriculum *)model
{
    [self.lbTitle setText:model.ctitle];
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@  %@", [Utils getHHMMSSFromSS:model.audio_time], model.createTimeFormat]];
    
    [self setViewFrame];
    
    return self.cellH;
}

+(CGFloat)getH
{
    return 70;
}

@end
