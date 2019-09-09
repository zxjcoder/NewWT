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

@property (strong, nonatomic) ZLabel *lbCreateTime;

@property (strong, nonatomic) ZLabel *lbPlayTime;

@property (strong, nonatomic) ZImageView *imgPlay;

@property (strong, nonatomic) UIImageView *imgLine;

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
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbCreateTime  = [[ZLabel alloc] init];
    [self.lbCreateTime setTextColor:BLACKCOLOR1];
    [self.lbCreateTime setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbCreateTime setNumberOfLines:1];
    [self.lbCreateTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCreateTime];
    
    self.imgPlay = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"subscribe_play_icon_g"]];
    [self.viewMain addSubview:self.imgPlay];
    
    self.lbPlayTime  = [[ZLabel alloc] init];
    [self.lbPlayTime setTextColor:DESCCOLOR];
    [self.lbPlayTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbPlayTime setNumberOfLines:1];
    [self.lbPlayTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbPlayTime];
    
    self.imgLine = [UIImageView getDLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGRect createTimeFrame = CGRectMake(kSizeSpace, kSize8, 10, self.lbH);
    [self.lbCreateTime setFrame:createTimeFrame];
    ///默认使用80的宽度
    createTimeFrame.size.width = 50;
    CGFloat createTimeW = [self.lbCreateTime getLabelWidthWithMinWidth:10];
    
    createTimeFrame.size.width = createTimeW;
    [self.lbCreateTime setFrame:createTimeFrame];
    
    CGFloat rightX = createTimeFrame.origin.x + createTimeFrame.size.width + kSize8;
    CGFloat rightW = self.cellW - rightX - kSizeSpace;
    CGRect titleFrame = CGRectMake(rightX, kSize8, rightW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    CGFloat playTimeY = self.lbTitle.y+self.lbTitle.height+kSize8;
    CGFloat imgSize = 17;
    [self.imgPlay setFrame:CGRectMake(self.cellW-kSizeSpace-imgSize, playTimeY, imgSize, imgSize)];
    
    [self.lbPlayTime setFrame:CGRectMake(kSizeSpace, playTimeY, 200, self.lbMinH)];
    
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.lbPlayTime.y+self.lbPlayTime.height+8, self.cellW-kSizeSpace*2, self.lineH)];
    
    self.cellH = self.imgLine.y+self.imgLine.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbPlayTime);
    OBJC_RELEASE(_lbCreateTime);
    OBJC_RELEASE(_imgPlay);
    OBJC_RELEASE(_imgLine);
    [super setViewNil];
}

-(CGFloat)setCellDataWithModel:(ModelCurriculum *)model
{
    [self.lbTitle setText:model.ctitle];
    
    [self.lbPlayTime setText:[NSString stringWithFormat:@"%@: %@", kTimeDuration, [Utils getHHMMSSFromSS:model.audio_time]]];
    
    [self.lbCreateTime setText:model.createTimeFormat];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(CGFloat)getH
{
    return self.cellH;
}

@end
