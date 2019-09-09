//
//  ZUserNoticeDetailTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/22/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserNoticeDetailTVC.h"

@interface ZUserNoticeDetailTVC()

@property (strong, nonatomic) UILabel *lbTime;

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) UILabel *lbContent;

@property (strong, nonatomic) UILabel *lbNickName;

@end

@implementation ZUserNoticeDetailTVC

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
    
    [self.viewMain setBackgroundColor:VIEW_BACKCOLOR2];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbTime = [[UILabel alloc] init];
    [self.lbTime setTextColor:COLORTEXT3];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTime setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewMain addSubview:self.lbTime];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [[self.viewContent layer] setMasksToBounds:YES];
    [self.viewContent setViewRoundWithNoBorder];
    [self.viewMain addSubview:self.viewContent];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setTextColor:COLORTEXT1];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbContent setNumberOfLines:0];
    [self.viewContent addSubview:self.lbContent];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:COLORTEXT3];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setTextAlignment:(NSTextAlignmentRight)];
    [self.viewContent addSubview:self.lbNickName];
}
-(void)setViewFrame
{
    [self.lbTime setFrame:CGRectMake(0, kSize10, self.cellW, self.lbH)];
    
    [self.viewContent setFrame:CGRectMake(self.space, self.lbTime.y+self.lbH+15, self.cellW-self.space*2, 0)];
    
    CGFloat lbW = self.viewContent.width-15*2;
    [self.lbContent setFrame:CGRectMake(15, 15, lbW, self.lbH)];
    CGFloat lbNewH = [self.lbContent getLabelHeightWithMinHeight:self.lbH];
    [self.lbContent setFrame:CGRectMake(self.lbContent.x, self.lbContent.y, lbW, lbNewH)];
    
    [self.lbNickName setFrame:CGRectMake(self.space, self.lbContent.y+lbNewH+self.space, lbW, self.lbH)];
    
    [self.viewContent setFrame:CGRectMake(self.viewContent.x, self.viewContent.y, self.viewContent.width, self.lbNickName.y+self.lbNickName.height+15)];
    
    self.cellH = self.viewContent.y+self.viewContent.height+5;
}

-(CGFloat)setCellDataWithModel:(ModelNoticeDetail *)model
{
    if (model) {
        [self.lbTime setText:model.noticeTime];
        [self.lbContent setText:model.noticeContent];
        [self.lbNickName setText:model.noticeNickName];
        if (model.isRead) {
            [self.viewContent setBackgroundColor:WHITECOLOR];
        } else {
            [self.viewContent setBackgroundColor:MESSAGECOLOR];
        }
    }
    [self setViewFrame];
    
    return self.cellH;
}

-(CGFloat)getHWithModel:(ModelNoticeDetail *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_viewContent);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

@end
