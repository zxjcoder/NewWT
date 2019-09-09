//
//  ZUserNoticeTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserNoticeTVC.h"

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
@property (strong, nonatomic) UIView *viewLine;

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
    
    self.cellH = self.getH;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_notice_icon"]];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setText:@"0"];
    [self.lbCount setFont:[ZFont systemFontOfSize:10]];
    [self.lbCount setTextColor:WHITECOLOR];
    [self.lbCount setBackgroundColor:TOPICCOLOR];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setHidden:YES];
    [self.viewMain addSubview:self.lbCount];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Max_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setLineBreakMode:1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setLineBreakMode:1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbDesc];
    
    self.lbTime = [[UILabel alloc] init];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setLineBreakMode:1];
    [self.lbTime setTextAlignment:(NSTextAlignmentRight)];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTime];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 50;
    [self.imgIcon setFrame:CGRectMake(self.space, 15, imgSize, imgSize)];
    
    [self.lbCount setFrame:CGRectMake(self.imgIcon.x+self.imgIcon.width-12, self.imgIcon.y-3, 15, 15)];
    [self.lbCount setViewRoundNoBorder];
    
    CGFloat timeW = [self.lbTime getLabelWidthWithMinWidth:10];
    CGFloat timeX = self.cellW-self.space-timeW;
    [self.lbTime setFrame:CGRectMake(timeX, self.imgIcon.y, timeW, self.lbMinH)];
    
    CGFloat lbX = self.imgIcon.x+imgSize+self.space;
    CGFloat titleW = timeX-lbX-self.space;
    [self.lbTitle setFrame:CGRectMake(lbX, self.imgIcon.y, titleW, self.lbH)];
    
    [self.lbDesc setFrame:CGRectMake(lbX, self.imgIcon.y+self.imgIcon.height-self.lbMinH, self.cellW-lbX-self.space, self.lbMinH)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
}

-(CGFloat)setCellDataWithModel:(ModelNotice *)model
{
    if (model) {
        [self.lbTitle setText:model.noticeTitle];
        [self.lbTime setText:model.noticeTime];
        [self.lbDesc setText:model.noticeDesc];
        if (model.noticeType == 1) {
            [self.imgIcon setImage:[SkinManager getImageWithName:@"my_message_manager"]];
        } else if (model.noticeType == 2) {
            [self.imgIcon setImage:[SkinManager getImageWithName:@"message_icon_update"]];
        }
        //TODO:ZWW备注-个数设置
        [self.lbCount setHidden:model.noticeCount==0];
        if (model.noticeCount < 100) {
            [self.lbCount setText:[NSString stringWithFormat:@"%d",model.noticeCount]];
        } else {
            [self.lbCount setText:@"99"];
        }
    }
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewLine);
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

-(CGFloat)getH
{
    return 80;
}
+(CGFloat)getH
{
    return 80;
}

@end
