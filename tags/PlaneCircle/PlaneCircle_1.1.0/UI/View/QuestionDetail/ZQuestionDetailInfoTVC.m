//
//  ZQuestionDetailInfoTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionDetailInfoTVC.h"

@interface ZQuestionDetailInfoTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbContent;

@property (strong, nonatomic) UIButton *btnIcon;

@property (strong, nonatomic) ModelQuestionDetail *model;

@property (assign, nonatomic) BOOL isMinHeight;

@end

@implementation ZQuestionDetailInfoTVC

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
    
    self.isMinHeight = YES;
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultImage];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setNumberOfLines:0];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.btnIcon = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnIcon setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateNormal)];
    [self.btnIcon setImageEdgeInsets:(UIEdgeInsetsMake(4, 4, 4, 4))];
    [self.btnIcon setTag:1];
    [self.btnIcon setHidden:YES];
    [self.btnIcon addTarget:self action:@selector(btnIconClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnIcon];
    
    [self setViewFrame];
}

-(void)btnIconClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        [sender setTag:2];
        [self setIsMinHeight:NO];
        [self.btnIcon setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_"] forState:(UIControlStateNormal)];
    } else {
        [sender setTag:1];
        [self setIsMinHeight:YES];
        [self.btnIcon setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateNormal)];
    }
    [self setViewContentFrame];
    
    if (self.onHeightClick) {
        self.onHeightClick(self.cellH);
    }
}

-(void)imgPhotoTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onImagePhotoClick) {
            self.onImagePhotoClick(self.model);
        }
    }
}

///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kSet_Font_Huge_Size(self.fontSize)]];
    [self.lbContent setFont:[UIFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
}

-(void)setCellDataWithModel:(ModelQuestionDetail *)model
{
    [self setModel:model];
    
    [self setViewContent];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self setCellFontSize];
    
    self.cellW = APP_FRAME_WIDTH;
    CGFloat imgS = 40;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgS, imgS)];
    [self.imgPhoto setViewRound];
    
    CGFloat titleX = self.imgPhoto.x+imgS+self.space;
    CGFloat titleW = self.cellW-titleX-self.space;
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbMinH];
    [self.lbTitle setFrame:CGRectMake(titleX, self.space, titleW, titleH)];
    
    [self setViewContentFrame];
}
-(void)setViewContentFrame
{
    CGFloat contentY = self.lbTitle.y+self.lbTitle.height+self.space;
    CGFloat contentMinY = (self.imgPhoto.y+self.imgPhoto.height+self.space);
    if (contentY < contentMinY) {contentY = contentMinY; }
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent line:4];
    if (self.isMinHeight) {
        if (contentH > maxH) {
            contentH = maxH;
            [self.btnIcon setHidden:NO];
        } else {
            [self.btnIcon setHidden:YES];
        }
    } else {
        [self.btnIcon setHidden:contentH < maxH];
    }
    [self.lbContent setFrame:CGRectMake(self.space, contentY, self.cellW-self.space*2, contentH)];
    
    CGFloat btnW = 45;
    if (self.btnIcon.hidden) {
        CGFloat btnY = self.lbContent.y+self.lbContent.height;
        [self.btnIcon setFrame:CGRectMake(self.cellW/2-btnW/2, btnY, btnW, 0)];
    } else {
        CGFloat btnH = 30;
        CGFloat btnY = self.lbContent.y+self.lbContent.height+5;
        [self.btnIcon setFrame:CGRectMake(self.cellW/2-btnW/2, btnY, btnW, btnH)];
    }
    
    self.cellH = self.btnIcon.y+self.btnIcon.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(void)setViewContent
{
    if (self.model) {
        [self.imgPhoto setPhotoURLStr:self.model.head_img];
        [self.lbTitle setText:self.model.title];
        [self.lbContent setText:self.model.qContent];
    }
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_btnIcon);
    OBJC_RELEASE(_model);
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

-(CGFloat)getHWithModel:(ModelQuestionDetail *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

@end
