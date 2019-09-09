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

@property (strong, nonatomic) ZLabel *lbNickName;

@property (strong, nonatomic) ZLabel *lbTitle;

@property (strong, nonatomic) ZLabel *lbDesc;

@property (strong, nonatomic) UIImageView *imgLine;

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
    
    CGFloat imgSize = 25;
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(self.space, kSize10, imgSize, imgSize)];
    [self.imgPhoto setFrame:CGRectMake(self.space, kSize10, imgSize, imgSize)];
    [self.imgPhoto setViewRoundNoBorder];
    [[self.imgPhoto layer] setMasksToBounds:YES];
    [self.imgPhoto setDefaultImage];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
    
    self.lbNickName = [[ZLabel alloc] init];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setTextColor:BLACKCOLOR];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbDesc = [[ZLabel alloc] init];
    [self.lbDesc setNumberOfLines:0];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbDesc];
    
    self.btnIcon = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnIcon setTitle:kOpen forState:(UIControlStateNormal)];
    [self.btnIcon setTitleColor:BLUECOLOR forState:(UIControlStateNormal)];
    [self.btnIcon setTag:1];
    [[self.btnIcon titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnIcon addTarget:self action:@selector(btnIconClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnIcon];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)btnIconClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        [sender setTag:2];
        [self setIsMinHeight:NO];
        [self.btnIcon setTitle:kPackUp forState:(UIControlStateNormal)];
    } else {
        [sender setTag:1];
        [self setIsMinHeight:YES];
        [self.btnIcon setTitle:kOpen forState:(UIControlStateNormal)];
    }
    [self setViewFrame];
    
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
    
    [self.lbTitle setFont:[ZFont systemFontOfSize:kSet_Font_Max_Size(self.fontSize)]];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
}

-(void)setViewFrame
{
    [self setCellFontSize];
    
    CGFloat itemW = self.cellW-self.space*2;
    
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
    CGRect titleFrame = CGRectMake(self.space, titleY, itemW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    if (self.model.qContent && self.model.qContent.length > 0) {
        [self.lbDesc setHidden:NO];
        [self.imgLine setHidden:NO];
        
        [self.imgLine setFrame:CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+kSize8, self.cellW, self.lineH)];
        
        CGFloat contentY = self.imgLine.y+self.imgLine.height+kSize8;
        CGRect contentFrame = CGRectMake(self.space, contentY, itemW, self.lbMinH);
        [self.lbDesc setFrame:contentFrame];
        CGFloat contentH = [self.lbDesc getLabelHeightWithMinHeight:self.lbMinH];
        CGFloat contentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbDesc line:4];
        if (contentH > contentMaxH) {
            [self.btnIcon setHidden:NO];
            if (self.isMinHeight) {
                contentFrame.size.height = contentMaxH;
                [self.lbDesc setFrame:contentFrame];
            } else {
                contentFrame.size.height = contentH;
                [self.lbDesc setFrame:contentFrame];
            }
            CGFloat btnW = 40;
            CGFloat btnH = 25;
            [self.btnIcon setFrame:CGRectMake(self.cellW-btnW-self.space, self.lbDesc.y+self.lbDesc.height, btnW, btnH)];
            
            self.cellH = self.btnIcon.y+self.btnIcon.height;
        } else {
            [self.btnIcon setHidden:YES];
            
            contentFrame.size.height = contentH;
            [self.lbDesc setFrame:contentFrame];
            
            self.cellH = self.lbDesc.y+self.lbDesc.height+kSize13;
        }
    } else {
        [self.lbDesc setHidden:YES];
        [self.imgLine setHidden:YES];
        [self.btnIcon setHidden:YES];
        
        self.cellH = self.lbTitle.y+self.lbTitle.height+kSize13;
    }
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelQuestionDetail *)model
{
    [self setModel:model];
    
    [self.imgPhoto setPhotoURLStr:model.head_img];
    
    [self.lbNickName setText:model.nickname];
    
    [self.lbTitle setText:model.title];
    
    [self.lbDesc setText:model.qContent];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbNickName);
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
