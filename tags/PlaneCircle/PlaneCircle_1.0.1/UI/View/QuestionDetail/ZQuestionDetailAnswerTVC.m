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

@property (strong, nonatomic) UILabel *lbSign;

@property (strong, nonatomic) UILabel *lbCount;

@property (strong, nonatomic) UILabel *lbContent;

@property (strong, nonatomic) UIView *viewLine;

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
    
    self.imgPhoto = [[ZImageView alloc] init];
    [self.imgPhoto setDefaultPhoto];
    [self.imgPhoto setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.imgPhoto];
    
    UITapGestureRecognizer *imgPhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgPhotoTap:)];
    [self.imgPhoto addGestureRecognizer:imgPhotoTap];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setNumberOfLines:1];
    [self.lbCount setTextColor:MAINCOLOR];
    [self.lbCount setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setBackgroundColor:RGBCOLOR(243, 243, 243)];
    [[self.lbCount layer] setMasksToBounds:YES];
    [self.lbCount setText:@"0"];
    [self.lbCount setViewRound:3 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.lbCount];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR];
    [self.lbNickName setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setTextColor:RGBCOLOR(182, 182, 182)];
    [self.lbSign setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbSign];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR];
    [self.lbContent setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:4];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
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

-(void)setViewFrame
{
    self.cellW = APP_FRAME_WIDTH;
    
    CGFloat imgS = 40;
    [self.imgPhoto setFrame:CGRectMake(self.space, self.space, imgS, imgS)];
    [self.imgPhoto setViewRound];
    
    CGFloat rightX = self.imgPhoto.x+imgS+self.space;
    CGFloat rightW = self.cellW-rightX-45;
    [self.lbNickName setFrame:CGRectMake(rightX, self.imgPhoto.y+2, rightW, self.lbH)];
    [self.lbSign setFrame:CGRectMake(rightX, self.imgPhoto.y+imgS-self.lbMinH+1, rightW, self.lbMinH)];
    CGFloat countW = [self.lbCount getLabelWidthWithMinWidth:0]+15;
    [self.lbCount setFrame:CGRectMake(self.cellW-countW-self.space, self.imgPhoto.y+imgS/2-self.lbMinH/2, countW, self.lbMinH)];
    
    CGFloat contentY = self.imgPhoto.y+imgS+self.space;
    if (self.lbContent.text.length > 0) {
        CGFloat acH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
        if (acH > 70) {acH = 70;}
        [self.lbContent setFrame:CGRectMake(self.space, contentY, self.cellW-self.space*2, acH)];
    } else {
        [self.lbContent setFrame:CGRectMake(self.space, contentY, self.cellW-self.space*2, 0)];
    }
    [self.viewLine setFrame:CGRectMake(0, self.lbContent.y+self.lbContent.height+self.space, self.cellW, self.lineMaxH)];
    self.cellH = self.viewLine.y+self.viewLine.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewContent
{
    if (self.model) {
        [self.imgPhoto setPhotoURLStr:self.model.head_img];
        [self.lbNickName setText:self.model.nickname];
        
        NSString *content = self.model.title.imgReplacing;
        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:content];
        [strAttributed addAttribute:NSFontAttributeName value:self.lbContent.font range:NSMakeRange(0, strAttributed.length)];
        [strAttributed addAttribute:NSForegroundColorAttributeName value:self.lbContent.textColor range:NSMakeRange(0, strAttributed.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
        
        [self.lbContent setAttributedText:strAttributed];
        
        [self.lbSign setText:self.model.sign];
        if (self.model.agree > kNumberMaxCount) {
            [self.lbCount setText:[NSString stringWithFormat:@"%d",kNumberMaxCount]];
        } else {
            [self.lbCount setText:[NSString stringWithFormat:@"%ld",self.model.agree]];
        }
    }
}

-(void)setCellDataWithModel:(ModelAnswerBase *)model
{
    [self setModel:model];
    
    [self setViewContent];
    
    [self setViewFrame];
}

-(void)setViewNil
{
    OBJC_RELEASE(_imgPhoto);
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_viewLine);
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
    [self setModel:model];
    
    [self setViewContent];
    
    [self setViewFrame];
    
    return self.cellH;
}

@end
