//
//  ZNewHomeFreeItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 24/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewHomeFreeItemTVC.h"

@interface ZNewHomeFreeItemTVC()

@property (strong, nonatomic) ZButton *btnPlay;
@property (strong, nonatomic) ZLabel *lbTitle;

@end

@implementation ZNewHomeFreeItemTVC

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
    self.cellH = [ZNewHomeFreeItemTVC getH];
    self.space = 20;
  
    CGFloat playSize = 26;
    if (!self.btnPlay) {
        self.btnPlay = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"audio"] forState:(UIControlStateNormal)];
        [self.btnPlay setImage:[SkinManager getImageWithName:@"audio_stop"] forState:(UIControlStateSelected)];
        [self.btnPlay setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [self.viewMain addSubview:self.btnPlay];
    }
    [self.btnPlay setFrame:(CGRectMake(18, self.cellH/2-playSize/2, playSize, playSize))];
    
    CGFloat lbX = self.btnPlay.x+self.btnPlay.width+3;
    CGFloat lbW = self.cellW - lbX - self.space;
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(lbX, self.cellH/2-self.lbH/2, lbW, self.lbH))];
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.lbTitle setNumberOfLines:1];
        [self.viewMain addSubview:self.lbTitle];
    }
    [self.viewMain setFrame:[self getMainFrame]];
}
-(void)setIsPlaying:(BOOL)isPlaying
{
    self.btnPlay.selected = isPlaying;
    if (isPlaying) {
        [self.lbTitle setTextColor:COLORCONTENT1];
    } else {
        [self.lbTitle setTextColor:COLORTEXT1];
    }
}
-(CGFloat)setCellDataWithModel:(ModelPractice *)model
{
    self.lbTitle.text = model.title;
    
    return self.cellH;
}
-(void)setViewNil
{
    _lbTitle = nil;
    _btnPlay = nil;
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 30;
}

@end
