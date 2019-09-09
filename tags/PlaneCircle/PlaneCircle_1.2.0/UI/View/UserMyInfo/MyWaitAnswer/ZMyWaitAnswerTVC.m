//
//  ZMyWaitAnswerTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/25/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyWaitAnswerTVC.h"

#define kZMyWaitAnswerTVCNickNameDesc @"邀请你回答问题"

@interface ZMyWaitAnswerTVC()

@property (strong, nonatomic) ZImageView *imgView;

@property (strong, nonatomic) UILabel *lbNickName;

@property (strong, nonatomic) UILabel *lbQuestionTitle;

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) ModelWaitAnswer *modelWA;

@end

@implementation ZMyWaitAnswerTVC

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
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.imgView = [[ZImageView alloc] initWithImage:[SkinManager getDefaultPhoto]];
    [self.imgView setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgView];
    
    UITapGestureRecognizer *photoClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
    [self.imgView addGestureRecognizer:photoClick];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setText:kZMyWaitAnswerTVCNickNameDesc];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbQuestionTitle = [[UILabel alloc] init];
    [self.lbQuestionTitle setTextColor:BLACKCOLOR];
    [self.lbQuestionTitle setNumberOfLines:2];
    [self.lbQuestionTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbQuestionTitle];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    [self setCellFontSize];
}

///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbQuestionTitle setFont:[UIFont boldSystemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
    [self.lbNickName setFont:[UIFont systemFontOfSize:kSet_Font_Least_Size(self.fontSize)]];
}

-(void)photoClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onPhotoClick) {
            self.onPhotoClick(self.modelWA);
        }
    }
}

-(void)setViewFrame
{
    [self setCellFontSize];
    
    CGFloat imgS = 25;
    [self.imgView setFrame:CGRectMake(self.space, kSize8, imgS, imgS)];
    [self.imgView setViewRoundNoBorder];
    
    CGFloat nickNameX = self.imgView.x+5+imgS;
    CGFloat nickNameY = self.imgView.y+self.imgView.height/2-self.lbH/2;
    CGFloat nickNameW = self.cellW-self.space-nickNameX;
    [self.lbNickName setFrame:CGRectMake(nickNameX, nickNameY, nickNameW, self.lbH)];
    
    CGRect titleFrame = CGRectMake(self.space, self.imgView.y+imgS+kSize8, self.cellW-self.space*2, self.lbH);
    [self.lbQuestionTitle setFrame:titleFrame];
    
    CGFloat newH = [self.lbQuestionTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat newMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbQuestionTitle];
    if (newH > newMaxH) {
        newH = newMaxH;
    }
    titleFrame.size.height = newH;
    [self.lbQuestionTitle setFrame:titleFrame];
    
    [self.viewLine setFrame:CGRectMake(0, self.lbQuestionTitle.y+newH+kSize8, self.cellW, self.lineMaxH)];
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbQuestionTitle);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_imgView);
    [super setViewNil];
}

-(void)setCellDataWithModel:(ModelWaitAnswer *)model
{
    [self setModelWA:model];
    if (model) {
        [self.imgView setPhotoURLStr:model.head_img];
        
        [self.lbNickName setText:[NSString stringWithFormat:@"%@%@",model.nickname,kZMyWaitAnswerTVCNickNameDesc]];
        [self.lbNickName setTextColor:RGBCOLOR(251, 107, 33)];
        [self.lbNickName setLabelColorWithRange:NSMakeRange(model.nickname.length, kZMyWaitAnswerTVCNickNameDesc.length) color:BLACKCOLOR1];
        
        [self.lbQuestionTitle setText:model.title];
        
        if (model.status == 0) {
            [self.viewMain setBackgroundColor:RGBCOLOR(255, 244, 236)];
        } else {
            [self.viewMain setBackgroundColor:WHITECOLOR];
        }
    }
    [self setViewFrame];
}
-(CGFloat)getHWithModel:(ModelWaitAnswer *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(void)dealloc
{
    [self setViewNil];
}

@end
