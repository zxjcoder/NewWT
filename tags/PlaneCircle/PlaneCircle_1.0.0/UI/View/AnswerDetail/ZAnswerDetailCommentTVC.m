//
//  ZAnswerDetailCommentTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailCommentTVC.h"

@interface ZAnswerDetailCommentTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

@property (strong, nonatomic) UILabel *lbCommentTime;

@property (strong, nonatomic) UILabel *lbCommentContent;

@property (strong, nonatomic) UIButton *btnMax;

@property (strong, nonatomic) UIView *viewL;

@property (assign, nonatomic) BOOL isDefaultH;

@property (strong, nonatomic) ModelAnswerComment *modelAB;

@end

@implementation ZAnswerDetailCommentTVC

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
    
    self.isDefaultH = YES;
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultImage];
    [self.viewMain addSubview:self.viewMain];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbCommentTime = [[UILabel alloc] init];
    [self.lbCommentTime setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbCommentTime setTextColor:DESCCOLOR];
    [self.lbCommentTime setNumberOfLines:1];
    [self.lbCommentTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCommentTime];
    
    self.lbCommentContent = [[UILabel alloc] init];
    [self.lbCommentContent setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbCommentContent setTextColor:BLACKCOLOR1];
    [self.lbCommentContent setNumberOfLines:1];
    [self.lbCommentContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCommentContent];
    
    [self.btnMax setUserInteractionEnabled:YES];
    [self.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateNormal)];
    [self.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateNormal)];
    [self.btnMax addTarget:self action:@selector(btnMaxClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnMax setImageEdgeInsets:(UIEdgeInsetsMake(4, 4, 4, 4))];
    [self.viewMain addSubview:self.btnMax];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)btnMaxClick
{
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        if (self.isDefaultH) {
            [self.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_"] forState:(UIControlStateNormal)];
            [self.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_"] forState:(UIControlStateNormal)];
        } else {
            [self.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateNormal)];
            [self.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateNormal)];
        }
    }];
    self.isDefaultH = !self.isDefaultH;
    if (self.onRowHeightChange) {
        self.onRowHeightChange();
    }
}

-(void)setViewFrame
{
    CGFloat imgSize = 50;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
    CGFloat rightX = self.imgPhoto.x+imgSize+self.space;
    CGFloat rightW = self.cellW-rightX-self.space;
    
    CGRect timeFrame = CGRectMake(self.cellW-rightW, self.space+3, 0, self.lbMinH);
    [self.lbCommentTime setFrame:timeFrame];
    CGFloat timeW = [self.lbCommentTime getLabelWidthWithMinWidth:0]+15;
    timeFrame.size.width = timeW;
    [self.lbCommentTime setFrame:timeFrame];
    
    [self.lbNickName setFrame:CGRectMake(rightX, self.space+3, rightW-timeW, self.lbH)];
    
    CGRect contentFrame = CGRectMake(rightX, self.imgPhoto.y+imgSize+self.space, rightW, 0);
    [self.lbCommentContent setFrame:contentFrame];
    CGFloat contentH = [self.lbCommentContent getLabelHeightWithMinHeight:self.lbMinH];
    if (self.isDefaultH) {
        if (contentH > 70) {
            contentH = 70;
        }
        [self.btnMax setHidden:contentH <= 70];
    } else {
        [self.btnMax setHidden:NO];
    }
    contentFrame.size.height = contentH;
    [self.lbCommentContent setFrame:contentFrame];
    
    CGFloat btnW = 45;
    CGFloat btnH = 30;
    if (self.btnMax.hidden) {
        btnH = 0;
    }
    CGFloat btnY = (self.imgPhoto.y+imgSize)/2-btnH/2;
    [self.btnMax setFrame:CGRectMake(self.cellW-btnW-5, btnY, btnW, btnW)];
    
    self.cellH = self.btnMax.y+self.btnMax.height+self.space;
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewContent
{
    if (self.modelAB) {
        [self.imgPhoto setPhotoURLStr:self.modelAB.head_img];
        [self.lbNickName setText:self.modelAB.nickname];
        [self.lbCommentTime setText:self.modelAB.createTime];
    }
}

-(void)setCellDataWithModel:(ModelAnswerComment *)model
{
    [self setModelAB:model];
    [self setViewContent];
    [self setViewFrame];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbCommentTime);
    OBJC_RELEASE(_lbCommentContent);
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_btnMax);
    OBJC_RELEASE(_modelAB);
    OBJC_RELEASE(_viewL);
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
-(CGFloat)getHWithModel:(ModelAnswerComment *)model
{
    [self setCellDataWithModel:model];
    return self.cellH;
}

@end
