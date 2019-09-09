//
//  ZQuestionDetailAnswerTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionDetailAnswerTVC.h"

@interface ZQuestionDetailAnswerTVC()

@property (strong, nonatomic) ZImageView *imgPhoto;

@property (strong, nonatomic) UILabel *lbNickName;

//@property (strong, nonatomic) UILabel *lbSign;

//@property (strong, nonatomic) UILabel *lbCount;

@property (strong, nonatomic) ZRichStyleLabel *lbContent;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) ModelAnswerBase *model;

@end

@implementation ZQuestionDetailAnswerTVC

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
    
    self.imgPhoto = [[ZImageView alloc] initWithFrame:CGRectMake(self.space, kSize10, 25, 25)];
    [[self.imgPhoto layer] setMasksToBounds:YES];
    [self.imgPhoto setDefaultPhoto];
    [self.imgPhoto setViewRoundNoBorder];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
    
//    self.lbCount = [[UILabel alloc] init];
//    [self.lbCount setNumberOfLines:1];
//    [self.lbCount setTextColor:MAINCOLOR];
//    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
//    [self.lbCount setBackgroundColor:RGBCOLOR(243, 243, 243)];
//    [[self.lbCount layer] setMasksToBounds:YES];
//    [self.lbCount setText:@"0"];
//    [self.lbCount setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
//    [self.viewMain addSubview:self.lbCount];
    
    CGFloat nickNameX = self.imgPhoto.x+self.imgPhoto.width+kSize6;
    CGRect nickNameFrame = CGRectMake(nickNameX, kSize10, self.cellW-nickNameX-self.space, 25);
    self.lbNickName = [[UILabel alloc] initWithFrame:nickNameFrame];
    [self.lbNickName setTextColor:BLACKCOLOR];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
//    self.lbSign = [[UILabel alloc] init];
//    [self.lbSign setTextColor:DESCCOLOR];
//    [self.lbSign setNumberOfLines:1];
//    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
//    [self.viewMain addSubview:self.lbSign];
    
    self.lbContent = [[ZRichStyleLabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.lbContent setNumberOfLines:4];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.imgLine = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
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
    
    [self.lbContent setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
}

-(void)setViewFrame
{
    [self setCellFontSize];
    
    self.cellW = APP_FRAME_WIDTH;
    
    CGFloat contentY = self.imgPhoto.y+self.imgPhoto.height+kSize10;
    CGRect contentFrame = CGRectMake(self.space, contentY, self.cellW-self.space*2, self.lbMinH);
    [self.lbContent setFrame:contentFrame];
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat contentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent];
    if (contentH> contentMaxH) {
        contentH = contentMaxH;
    }
    contentFrame.size.height = contentH;
    [self.lbContent setFrame:contentFrame];
    
    [self.imgLine setFrame:CGRectMake(0, self.lbContent.y+self.lbContent.height+kSize11, self.cellW, self.lineMaxH)];
    
    self.cellH = self.imgLine.y+self.imgLine.height;
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewContent
{
    if (self.model) {
        [self.imgPhoto setPhotoURLStr:self.model.head_img];
        
        [self.lbNickName setText:self.model.nickname];
        
        NSString *content = self.model.title.imgReplacing;
        [self.lbContent setText:content];
    }
}

-(CGFloat)setCellDataWithModel:(ModelAnswerBase *)model
{
    [self setModel:model];
    
    [self setViewContent];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_onImagePhotoClick);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_lbNickName);
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

-(CGFloat)getHWithModel:(ModelAnswerBase *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

@end
