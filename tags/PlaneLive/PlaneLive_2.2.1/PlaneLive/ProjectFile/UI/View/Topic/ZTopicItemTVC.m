//
//  ZTopicItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZTopicItemTVC.h"

@interface ZTopicItemTVC()

///标题
@property (strong, nonatomic) UILabel *lbTitle;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///头像
@property (strong, nonatomic) ZImageView *imgPhoto;
///标题分割线
@property (strong, nonatomic) UIImageView *imgLine1;

///回答内容区域
@property (strong, nonatomic) UIView *viewContent;
///回答内容
@property (strong, nonatomic) ZRichStyleLabel *lbAnswerContent;
///分割线
@property (strong, nonatomic) UIImageView *imgLine2;

///实体对象
@property (strong, nonatomic) ModelQuestionTopic *model;

@end

@implementation ZTopicItemTVC

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
    
    self.imgLine1 = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine1];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.viewContent];
    
    self.lbAnswerContent = [[ZRichStyleLabel alloc] init];
    [self.lbAnswerContent setTextColor:BLACKCOLOR1];
    [self.lbAnswerContent setNumberOfLines:4];
    [self.lbAnswerContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbAnswerContent];
    
    UITapGestureRecognizer *tapAnswerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswerClick:)];
    [self.viewContent addGestureRecognizer:tapAnswerClick];
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine2];
    
    [self setCellFontSize];
}
-(void)tapAnswerClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onAnswerClick) {
            ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
            [modelAB setIds:self.model.aid];
            [modelAB setQuestion_id:self.model.ids];
            [modelAB setQuestion_title:self.model.title];
            [modelAB setTitle:self.model.content];
            self.onAnswerClick(modelAB);
        }
    }
}
-(void)imgPhotoTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onImagePhotoClick) {
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:self.model.userIdQ];
            [modelUB setHead_img:self.model.head_imgQ];
            [modelUB setNickname:self.model.nicknameQ];
            self.onImagePhotoClick(modelUB);
        }
    }
}
///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbTitle setFont:[ZFont systemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
    
    [self.lbAnswerContent setFont:[ZFont systemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
}

///设置坐标
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
    
    if (self.model.aid && self.model.aid.length > 0 && self.model.content.length > 0) {
        [self.imgLine1 setHidden:NO];
        [self.viewContent setHidden:NO];
        [self.lbAnswerContent setHidden:NO];
        
        CGFloat line1Y = self.lbTitle.y + self.lbTitle.height + kSize10;
        [self.imgLine1 setFrame:CGRectMake(self.space, line1Y, itemW, self.lineH)];
        
        CGRect contentFrame = CGRectMake(0, self.imgLine1.y+self.imgLine1.height, self.cellW, 0);
        [self.viewContent setFrame:contentFrame];
        
        CGRect answerFrame = CGRectMake(self.space, kSize10, itemW, self.lbMinH);
        [self.lbAnswerContent setFrame:answerFrame];
        CGFloat answerH = [self.lbAnswerContent getLabelHeightWithMinHeight:self.lbMinH];
        CGFloat answerMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbAnswerContent];
        if (answerH > answerMaxH) {
            answerH = answerMaxH;
        }
        answerFrame.size.height = answerH;
        [self.lbAnswerContent setFrame:answerFrame];
        
        contentFrame.size.height = self.lbAnswerContent.y+self.lbAnswerContent.height+kSize10;
        [self.viewContent setFrame:contentFrame];
        
        self.cellH = self.viewContent.y+self.viewContent.height+self.lineMaxH;
    } else {
        [self.imgLine1 setHidden:YES];
        [self.viewContent setHidden:YES];
        [self.lbAnswerContent setHidden:YES];
        
        self.cellH = self.lbTitle.y+self.lbTitle.height+kSize10+self.lineMaxH;;
    }
    
    [self.imgLine2 setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelQuestionTopic *)model
{
    [self setModel:model];
    
    if (self.model) {
        [self.imgPhoto setPhotoURLStr:model.head_imgQ];
        
        [self.lbTitle setText:self.model.title.toTrim];
        
        NSString *content = self.model.content.toTrim;
        [self.lbAnswerContent setText:content];
        
        [self.lbNickName setText:self.model.nicknameQ];
    }
    
    [self setViewFrame];
    
    return self.cellH;
}

-(CGFloat)getHWithModel:(ModelQuestionTopic *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbAnswerContent);
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_imgLine2);
    OBJC_RELEASE(_imgPhoto);
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

@end
