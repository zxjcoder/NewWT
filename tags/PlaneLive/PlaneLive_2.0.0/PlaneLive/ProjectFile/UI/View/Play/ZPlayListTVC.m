//
//  ZPlayListTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPlayListTVC.h"
#import "Utils.h"

@interface ZPlayListTVC()

///标题
@property (strong, nonatomic) ZLabel *lbTitle;
///时间
@property (strong, nonatomic) ZLabel *lbTime;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZPlayListTVC

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
    
    self.cellH = [ZPlayListTVC getH];
    
    CGFloat timeW = 65;
    CGFloat lbW = self.cellW-self.space*2;
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(self.space, kSize10, lbW, 25)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbTime = [[ZLabel alloc] initWithFrame:CGRectMake(self.cellW-kSizeSpace-timeW, kSize10, timeW, 25)];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setTextAlignment:(NSTextAlignmentRight)];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTime];
    
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
    [self.viewMain addSubview:self.imgLine];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelAudio *)model
{
    [self.lbTitle setText:model.audioTitle];
    
    [self.lbTime setText:[Utils getHHMMSSFromSS:model.totalDuration]];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(void)setViewFrame
{
    CGRect timeFrame = CGRectMake(self.cellW-10-kSize10, kSize10, 10, self.lbMinH);
    [self.lbTime setFrame:timeFrame];
    CGFloat timeW = [self.lbTime getLabelWidthWithMinWidth:10];
    timeFrame.size.width = timeW;
    timeFrame.origin.x = self.cellW-kSize10-timeW;
    [self.lbTime setFrame:timeFrame];
    
    CGFloat titleW = timeFrame.origin.x-kSizeSpace-kSize5;
    CGRect titleFrame = CGRectMake(kSizeSpace, kSize10, titleW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    self.cellH = titleFrame.origin.y+titleFrame.size.height+kSize10;
    [self.imgLine setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewTitleColor:(UIColor *)color
{
    [self.lbTitle setTextColor:color];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getH
{
    return 45;
}

@end
