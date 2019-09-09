//
//  ZUserNoticeTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserNoticeTVC.h"
#import "ZCalculateLabel.h"

@interface ZUserNoticeTVC()

///图片
@property (strong, nonatomic) UIImageView *imgIcon;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
///描述
@property (strong, nonatomic) UILabel *lbDesc;
///个数
@property (strong, nonatomic) UILabel *lbCount;
///时间
@property (strong, nonatomic) UILabel *lbTime;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZUserNoticeTVC

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
    
    self.cellH = [ZUserNoticeTVC getH];
    self.space = 20;
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update"]];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setText:@"0"];
    [self.lbCount setFont:[ZFont systemFontOfSize:8]];
    [self.lbCount setTextColor:WHITECOLOR];
    [self.lbCount setBackgroundColor:COLORCONTENT3];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setHidden:YES];
    [self.viewMain addSubview:self.lbCount];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbDesc setTextColor:COLORTEXT3];
    [self.lbDesc setNumberOfLines:1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbDesc];
    
    self.lbTime = [[UILabel alloc] init];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTime setTextColor:COLORTEXT3];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setTextAlignment:(NSTextAlignmentRight)];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTime];
    
    self.imgLine = [UIImageView getDLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat imgSize = 24;
    [self.imgIcon setFrame:CGRectMake(self.space, 15, imgSize, imgSize)];
    self.space = 20;
    CGFloat lbX = self.imgIcon.x+imgSize+10;
    CGFloat lbW = self.cellW - lbX - self.space;
    CGFloat titleY = 16;
    CGRect titleFrame = CGRectMake(lbX, titleY, lbW, self.lbMinH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat newh = [self.lbTitle getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat maxh = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (newh > maxh) {
        titleFrame.size.height = maxh;
    } else {
        titleFrame.size.height = newh;
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGFloat timeY = self.lbTitle.y + self.lbTitle.height + 10;
    [self.lbCount setFrame:CGRectMake(self.imgIcon.x+self.imgIcon.width-12, self.imgIcon.y-3, 13, 13)];
    [self.lbCount setViewRoundNoBorder];
    
    CGFloat timeW = [self.lbTime getLabelWidthWithMinWidth:10];
    CGFloat timeX = self.cellW-self.space-timeW;
    [self.lbTime setFrame:CGRectMake(timeX, timeY, timeW, self.lbMinH)];
    
    [self.lbDesc setFrame:CGRectMake(lbX, timeY, 150, self.lbMinH)];
    
    [self.imgLine setFrame:CGRectMake(lbX, self.lbDesc.y + self.lbDesc.height + 12, self.cellW-lbX-self.space, kLineHeight)];
    self.cellH = self.imgLine.y + self.imgLine.height+1;
    [self.viewMain setFrame:[self getMainFrame]];
}
-(CGFloat)setCellDataWithModel:(ModelNotice *)model
{
    if (model) {
        [self.lbTitle setText:model.noticeDesc];
        [self.lbTime setText:model.noticeTime];
        [self.lbDesc setText:model.noticeTitle];
        
        if (model.noticeType == 1) {
            [self.imgIcon setImage:[SkinManager getImageWithName:@"system"]];
        } else if (model.noticeType == 2) {
            [self.imgIcon setImage:[SkinManager getImageWithName:@"update"]];
        }
        //TODO:ZWW备注-个数设置
        [self.lbCount setHidden:model.noticeCount==0];
        if (model.noticeCount < 100) {
            [self.lbCount setText:[NSString stringWithFormat:@"%d",model.noticeCount]];
        } else {
            [self.lbCount setText:@"99"];
        }
    }
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgIcon);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 80;
}

@end
