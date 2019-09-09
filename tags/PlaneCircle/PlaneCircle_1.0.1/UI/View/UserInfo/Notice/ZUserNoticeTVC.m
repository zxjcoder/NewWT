//
//  ZUserNoticeTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserNoticeTVC.h"

@interface ZUserNoticeTVC()

@property (strong, nonatomic) UIImageView *imgIcon;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbDesc;

@property (strong, nonatomic) UILabel *lbTime;

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
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_notice_icon"]];
    [self.viewMain addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Max_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setLineBreakMode:1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setTextColor:BLACKCOLOR2];
    [self.lbDesc setLineBreakMode:1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbDesc];
    
    
    self.lbTime = [[UILabel alloc] init];
    [self.lbTime setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setLineBreakMode:1];
    [self.lbTime setTextAlignment:(NSTextAlignmentRight)];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTime];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imgSize = 50;
    [self.imgIcon setFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
    
    CGFloat timeW = [self.lbTime getLabelWidthWithMinWidth:10];
    CGFloat timeX = self.cellW-self.space-timeW;
    [self.lbTime setFrame:CGRectMake(timeX, self.space, timeW, self.lbMinH)];
    
    CGFloat lbX = self.imgIcon.x+imgSize+self.space;
    CGFloat titleW = timeX-lbX-self.space;
    [self.lbTitle setFrame:CGRectMake(lbX, self.space, titleW, self.lbH)];
    
    [self.lbDesc setFrame:CGRectMake(lbX, self.imgIcon.y+self.imgIcon.height-self.lbMinH, self.cellW-lbX-self.space, self.lbMinH)];
    
    [self.viewLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
}

-(void)setCellDataWithModel:(ModelNotice *)model
{
    if (model) {
        [self.lbTitle setText:model.noticeTitle];
        [self.lbTime setText:model.noticeTime];
        [self.lbDesc setText:model.noticeDesc];
    }
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
    return 75;
}
+(CGFloat)getH
{
    return 75;
}

@end
