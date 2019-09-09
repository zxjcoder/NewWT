//
//  ZMyWaitAnswerTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/25/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyWaitAnswerTVC.h"

@interface ZMyWaitAnswerTVC()

///标题
@property (strong, nonatomic) UILabel *lbTitle;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///头像
@property (strong, nonatomic) ZImageView *imgPhoto;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;

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
    
    CGFloat imgSize = 25;
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(self.space, kSize10, imgSize, imgSize)];
    [self.imgPhoto setFrame:CGRectMake(self.space, kSize10, imgSize, imgSize)];
    [self.imgPhoto setViewRoundNoBorder];
    [[self.imgPhoto layer] setMasksToBounds:YES];
    [self.imgPhoto setDefaultImage];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.imgLine = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setCellFontSize];
}
-(void)imgPhotoTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onImagePhotoClick) {
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:self.modelWA.userId];
            [modelUB setHead_img:self.modelWA.head_img];
            [modelUB setNickname:self.modelWA.nickname];
            self.onImagePhotoClick(modelUB);
        }
    }
}
///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbTitle setFont:[ZFont systemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
}
///设置坐标
-(void)setViewFrame
{
    [self setCellFontSize];
    
    CGRect nickNameFrame = CGRectMake(self.imgPhoto.x+self.imgPhoto.width+kSize6, kSize10, 10, 25);
    [self.lbNickName setFrame:nickNameFrame];
    CGFloat nickNameW = [self.lbNickName getLabelWidthWithMinWidth:10];
    CGFloat nickNameMaxW = self.cellW-nickNameFrame.origin.x-kSizeSpace;
    if (nickNameW > nickNameMaxW) {
        nickNameW = nickNameMaxW;
    }
    nickNameFrame.size.width = nickNameW;
    [self.lbNickName setFrame:nickNameFrame];
    
    CGFloat titleY = self.imgPhoto.y+self.imgPhoto.height+kSize8;
    CGFloat titleW = self.cellW - self.space*2;
    CGRect titleFrame = CGRectMake(self.space, titleY, titleW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > titleMaxH) {
        titleH = titleMaxH;
    }
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    self.cellH = self.lbTitle.y+self.lbTitle.height+kSize10+self.lineMaxH;
    
    [self.imgLine setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelWaitAnswer *)model
{
    [self setModelWA:model];
    
    [self.imgPhoto setPhotoURLStr:model.head_img];
    
    [self.lbNickName setText:[NSString stringWithFormat:@"%@%@",model.nickname,kInvitationYourAnswerQuestion]];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    if (model.nickname.length > 0) {
        [self.lbNickName setLabelColorWithRange:NSMakeRange(0, model.nickname.length) color:MAINCOLOR];
    }
    
    [self.lbTitle setText:model.title.toTrim];
    
    if (model.status == 0) {
        [self.viewMain setBackgroundColor:MESSAGECOLOR];
    } else {
        [self.viewMain setBackgroundColor:WHITECOLOR];
    }
    
    [self setViewFrame];
    
    return self.cellH;
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
