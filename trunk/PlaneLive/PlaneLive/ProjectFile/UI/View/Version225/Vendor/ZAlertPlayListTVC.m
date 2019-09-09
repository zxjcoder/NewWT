//
//  ZAlertPlayListTVC.m
//  PlaneLive
//
//  Created by Daniel on 27/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertPlayListTVC.h"

@interface ZAlertPlayListTVC()

///图片
@property (strong, nonatomic) ZImageView *imageIcon;
///标题
@property (strong, nonatomic) ZLabel *lbTitle;
///时间
@property (strong, nonatomic) ZLabel *lbTime;

@end

@implementation ZAlertPlayListTVC

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
    
    self.cellW = APP_FRAME_WIDTH-40;
    self.cellH = [ZAlertPlayListTVC getH];
    
    if (!self.imageIcon) {
        self.imageIcon = [[ZImageView alloc] init];
        [self.viewMain addSubview:self.imageIcon];
    }
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] init];
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
        [self.lbTitle setNumberOfLines:0];
        [self.viewMain addSubview:self.lbTitle];
    }
    if (!self.lbTime) {
        self.lbTime = [[ZLabel alloc] init];
        [self.lbTime setTextColor:COLORTEXT3];
        [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.viewMain addSubview:self.lbTime];
    }
}

-(CGFloat)setCellDataWithModel:(ModelTrack *)model
{
    [self.lbTitle setText:model.trackTitle];
    [self.lbTime setText:[Utils getHHMMSSFromSSTime:model.duration]];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(void)setViewFrame
{
    CGFloat imageSize = 16;
    [self.imageIcon setFrame:(CGRectMake(15, 7, imageSize, imageSize))];
    
    CGFloat titleX = self.imageIcon.x+self.imageIcon.width+10;
    CGFloat titleW = self.cellW-titleX-15;
    CGRect titleFrame = CGRectMake(titleX, 5, titleW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    CGRect timeFrame = CGRectMake(titleX, self.lbTitle.y+self.lbTitle.height+5, 200, self.lbMinH);
    [self.lbTime setFrame:timeFrame];
    
    self.cellH = self.lbTime.y+self.lbTime.height+10;
    [self.viewMain setFrame:(CGRectMake(0, 0, self.cellW, self.cellH))];
}
-(void)setStartPlay:(BOOL)playing
{
    if (playing) {
        [self.lbTitle setTextColor:COLORCONTENT1];
        self.imageIcon.image = [SkinManager getImageWithName:@"audio_stop"];
    } else {
        [self.lbTitle setTextColor:COLORTEXT1];
        self.imageIcon.image = [SkinManager getImageWithName:@"audio"];
    }
}
+(CGFloat)getH
{
    return 40;
}

@end
