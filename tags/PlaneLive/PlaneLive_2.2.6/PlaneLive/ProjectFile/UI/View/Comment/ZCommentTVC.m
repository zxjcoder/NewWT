//
//  ZCommentTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCommentTVC.h"

@interface ZCommentTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

@property (strong, nonatomic) UILabel *lbCommentTime;

@property (strong, nonatomic) UILabel *lbCommentContent;

@property (strong, nonatomic) UIButton *btnMax;

@property (strong, nonatomic) UIView *viewL;

@property (assign, nonatomic) BOOL isDefaultH;

@property (strong, nonatomic) ModelComment *modelAB;

@end
@implementation ZCommentTVC

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
    self.cellH = 0;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultImage];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgPhotoClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoClick:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoClick];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbCommentTime = [[UILabel alloc] init];
    [self.lbCommentTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbCommentTime setTextColor:DESCCOLOR];
    [self.lbCommentTime setNumberOfLines:1];
    [self.lbCommentTime setTextAlignment:(NSTextAlignmentRight)];
    [self.lbCommentTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCommentTime];
    
    self.lbCommentContent = [[UILabel alloc] init];
    [self.lbCommentContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbCommentContent setTextColor:BLACKCOLOR1];
    [self.lbCommentContent setNumberOfLines:0];
    [self.lbCommentContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCommentContent];
    
    self.btnMax = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMax setUserInteractionEnabled:YES];
    [self.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateNormal)];
    [self.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateHighlighted)];
    [self.btnMax addTarget:self action:@selector(btnMaxClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnMax setImageEdgeInsets:(UIEdgeInsetsMake(4, 4, 4, 4))];
    [self.viewMain addSubview:self.btnMax];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)btnMaxClick
{
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        if (ws.isDefaultH) {
            [ws.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_"] forState:(UIControlStateNormal)];
            [ws.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_"] forState:(UIControlStateHighlighted)];
        } else {
            [ws.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateNormal)];
            [ws.btnMax setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateHighlighted)];
        }
    }];
    self.isDefaultH = !self.isDefaultH;
    if (self.onRowHeightChange) {
        self.onRowHeightChange(self.tag, self.isDefaultH);
    }
}

-(void)imgPhotoClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onImagePhotoClick) {
            self.onImagePhotoClick(self.modelAB);
        }
    }
}

-(void)setViewFrame
{
    CGFloat imgSize = 35;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
    [self.imgPhoto setViewRound];
    
    CGFloat rightX = self.imgPhoto.x+imgSize+self.space;
    CGFloat rightW = self.cellW-rightX-self.space;
    
    CGRect timeFrame = CGRectMake(self.cellW-rightW, self.space, 0, self.lbMinH);
    [self.lbCommentTime setFrame:timeFrame];
    CGFloat timeW = [self.lbCommentTime getLabelWidthWithMinWidth:0]+15;
    timeFrame.size.width = timeW;
    timeFrame.origin.x = self.cellW-timeW-self.space;
    [self.lbCommentTime setFrame:timeFrame];
    
    [self.lbNickName setFrame:CGRectMake(rightX, self.space+3, rightW-timeW, self.lbH)];
    
    CGRect contentFrame = CGRectMake(rightX, self.lbNickName.y+self.lbNickName.height+kSize11, rightW, 0);
    [self.lbCommentContent setFrame:contentFrame];
    CGFloat contentH = [self.lbCommentContent getLabelHeightWithMinHeight:self.lbMinH];
    if (self.isDefaultH) {
        CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbCommentContent line:3];
        [self.btnMax setHidden:contentH < maxH];
        if (contentH > maxH) {
            contentH = maxH;
        }
    } else {
        [self.btnMax setHidden:NO];
    }
    contentFrame.size.height = contentH;
    [self.lbCommentContent setFrame:contentFrame];
    
    CGFloat btnW = 45;
    CGFloat btnH = 30;
    CGFloat btnY = self.lbCommentContent.y+self.lbCommentContent.height;
    if (self.btnMax.hidden) {
        btnH = 0;
        if (self.isDefaultH) {
            btnY = self.lbCommentContent.y+self.lbCommentContent.height;
        } else {
            btnY = self.lbCommentContent.y+self.lbCommentContent.height+self.space;
        }
    }
    [self.btnMax setFrame:CGRectMake(self.cellW-btnW-10, btnY, btnW, btnH)];
    
    if (btnH == 0) {
        self.cellH = self.btnMax.y+self.btnMax.height+kSize13;
    } else {
        self.cellH = self.btnMax.y+self.btnMax.height+kSize5;
    }
    
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewContent
{
    if (self.modelAB) {
        [self.imgPhoto setPhotoURLStr:self.modelAB.head_img];
        [self.lbNickName setText:self.modelAB.nickname];
        [self.lbCommentTime setText:self.modelAB.createTime];
        [self.lbCommentContent setText:self.modelAB.content];
    }
}

-(CGFloat)setCellDataWithModel:(ModelComment *)model
{
    [self setModelAB:model];
    
    [self setViewContent];
    
    [self setViewFrame];
    
    return self.cellH;
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
-(void)setCellIsDefaultH:(BOOL)isDF
{
    [self setIsDefaultH:isDF];
}
-(CGFloat)getHWithModel:(ModelComment *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

@end
