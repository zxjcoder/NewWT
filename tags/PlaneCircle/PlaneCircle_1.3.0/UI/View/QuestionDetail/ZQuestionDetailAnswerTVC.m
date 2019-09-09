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

@property (strong, nonatomic) ZLabel *lbContent;

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
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setBackgroundColor:RGBCOLOR(243, 243, 243)];
    [[self.lbCount layer] setMasksToBounds:YES];
    [self.lbCount setText:@"0"];
    [self.lbCount setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.lbCount];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setTextColor:DESCCOLOR];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbSign];
    
    self.lbContent = [[ZLabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR];
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

///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbNickName setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
    [self.lbSign setFont:[ZFont systemFontOfSize:kSet_Font_Min_Size(self.fontSize)]];
    
    [self.lbContent setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
}

-(void)setViewFrame
{
    [self setCellFontSize];
    
    self.cellW = APP_FRAME_WIDTH;
    
    CGFloat imgS = 40;
    [self.imgPhoto setFrame:CGRectMake(self.space, kSize10, imgS, imgS)];
    [self.imgPhoto setViewRound];
    
    CGFloat rightX = self.imgPhoto.x+imgS+self.space;
    CGFloat rightW = self.cellW-rightX-45;
    [self.lbSign setHidden:self.lbSign.text.length==0];
    if (self.lbSign.text.toTrim.length > 0) {
        [self.lbNickName setFrame:CGRectMake(rightX, kSize10, rightW, self.lbH)];
        [self.lbSign setFrame:CGRectMake(rightX, self.lbNickName.y+self.lbNickName.height+3, rightW, self.lbMinH)];
    } else {
        [self.lbNickName setFrame:CGRectMake(rightX, self.imgPhoto.y+(imgS/2-self.lbH/2), rightW, self.lbH)];
    }
    
    [self.lbCount setFrame:CGRectMake(self.cellW-15-self.space, self.imgPhoto.y+imgS/2-self.lbMinH/2, 15, self.lbMinH)];
    CGFloat countW = [self.lbCount getLabelWidthWithMinWidth:0]+15;
    [self.lbCount setFrame:CGRectMake(self.cellW-countW-self.space, self.lbCount.y, countW, self.lbCount.height)];
    
    CGFloat contentY = self.imgPhoto.y+imgS+self.space;
    [self.lbContent setFrame:CGRectMake(self.space, contentY, self.cellW-self.space*2, 0)];
    if (self.lbContent.text.length > 0) {
        CGFloat acH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
        CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent];
        if (acH > maxH) {acH = maxH;}
        [self.lbContent setFrame:CGRectMake(self.lbContent.x, self.lbContent.y, self.lbContent.width, acH)];
    }
    [self.viewLine setFrame:CGRectMake(0, self.lbContent.y+self.lbContent.height+kSize13, self.cellW, self.lineMaxH)];
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewContent
{
    if (self.model) {
        [self.imgPhoto setPhotoURLStr:self.model.head_img];
        [self.lbNickName setText:self.model.nickname];
        
        NSString *content = self.model.title.imgReplacing;
        if (content) {
            content = [content stringByReplacingOccurrencesOfString:@"\n" withString:kEmpty];
            content = [content stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
        }
        [self.lbContent setText:content];
        
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
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

@end
