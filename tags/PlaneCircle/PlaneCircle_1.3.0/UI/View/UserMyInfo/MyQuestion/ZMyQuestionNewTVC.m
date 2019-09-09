//
//  ZMyQuestionNewTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/25/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyQuestionNewTVC.h"

#define kZMyQuestionNewTVCNickNameDesc @"回答了你的问题"

@interface ZMyQuestionNewTVC()

///头像
@property (strong, nonatomic) ZImageView *imgView;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///问题标题
@property (strong, nonatomic) UILabel *lbQuestionTitle;
///问题分割线
@property (strong, nonatomic) UIView *viewLine1;
///回答区域
@property (strong, nonatomic) UIView *viewAnswer;
///回答内容
@property (strong, nonatomic) UILabel *lbAnswerContent;
///分割线
@property (strong, nonatomic) UIView *viewLine2;
///实体对象
@property (strong, nonatomic) ModelMyNewQuestion *model;


@end

@implementation ZMyQuestionNewTVC

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
    [self.lbNickName setText:kZMyQuestionNewTVCNickNameDesc];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbQuestionTitle = [[UILabel alloc] init];
    [self.lbQuestionTitle setTextColor:BLACKCOLOR];
    [self.lbQuestionTitle setNumberOfLines:1];
    [self.lbQuestionTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbQuestionTitle];
    
    self.viewAnswer = [[UIView alloc] init];
    [self.viewAnswer setBackgroundColor:WHITECOLOR];
    [self.viewAnswer setUserInteractionEnabled:YES];
    [self.viewMain addSubview:self.viewAnswer];
    
    self.lbAnswerContent = [[UILabel alloc] init];
    [self.lbAnswerContent setTextColor:BLACKCOLOR];
    [self.lbAnswerContent setNumberOfLines:2];
    [self.lbAnswerContent setUserInteractionEnabled:NO];
    [self.lbAnswerContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewAnswer addSubview:self.lbAnswerContent];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine2];
    
    UITapGestureRecognizer *answerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(answerClick:)];
    [self.viewAnswer addGestureRecognizer:answerClick];
    
    [self setCellFontSize];
}

///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbNickName setFont:[ZFont systemFontOfSize:kSet_Font_Least_Size(self.fontSize)]];
    [self.lbQuestionTitle setFont:[ZFont boldSystemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
    [self.lbAnswerContent setFont:[ZFont systemFontOfSize:kSet_Font_Least_Size(self.fontSize)]];
}

-(void)photoClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onPhotoClick) {
            self.onPhotoClick(self.model);
        }
    }
}

-(void)answerClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onAnswerClick) {
            self.onAnswerClick(self.model);
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
    
    [self.viewLine1 setFrame:CGRectMake(0, self.lbQuestionTitle.y+newH+kSize8, self.cellW, self.lineH)];
    
    [self.viewAnswer setFrame:CGRectMake(0, self.viewLine1.y+self.viewLine1.height, self.viewLine1.width, 0)];
    [self.lbAnswerContent setFrame:CGRectMake(self.space, kSize8, self.viewAnswer.width-self.space*2, self.lbH)];
    CGFloat contentH = [self.lbAnswerContent getLabelHeightWithMinHeight:self.lbH];
    CGFloat contentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbAnswerContent];
    if (contentH > contentMaxH) {
        contentH = contentMaxH;
    }
    [self.lbAnswerContent setFrame:CGRectMake(self.lbAnswerContent.x, self.lbAnswerContent.y, self.lbAnswerContent.width, contentH)];
    [self.viewAnswer setFrame:CGRectMake(self.viewAnswer.x, self.viewAnswer.y, self.viewAnswer.width, self.lbAnswerContent.y*2+contentH)];
    
    [self.viewLine2 setFrame:CGRectMake(0, self.viewAnswer.y+self.viewAnswer.height, self.cellW, self.lineMaxH)];
    
    self.cellH = self.viewLine2.y+self.viewLine2.height;
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbQuestionTitle);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_lbAnswerContent);
    OBJC_RELEASE(_viewAnswer);
    OBJC_RELEASE(_viewLine2);
    OBJC_RELEASE(_imgView);
    [super setViewNil];
}

-(void)setCellDataWithModel:(ModelMyNewQuestion *)model
{
    [self setModel:model];
    if (model) {
        [self.imgView setPhotoURLStr:model.head_img];
        
        [self.lbNickName setText:[NSString stringWithFormat:@"%@%@",model.nickname,kZMyQuestionNewTVCNickNameDesc]];
        [self.lbNickName setTextColor:RGBCOLOR(251, 107, 33)];
        [self.lbNickName setLabelColorWithRange:NSMakeRange(model.nickname.length, kZMyQuestionNewTVCNickNameDesc.length) color:BLACKCOLOR1];
        
        [self.lbQuestionTitle setText:model.title];
        
        NSString *content = model.aContent.imgReplacing;
        if (content) {
            content = [content stringByReplacingOccurrencesOfString:@"\n" withString:kEmpty];
            content = [content stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
        }
        [self.lbAnswerContent setText:content];
        
        if (model.status == 0) {
            [self.viewMain setBackgroundColor:RGBCOLOR(255, 244, 236)];
        } else {
            [self.viewMain setBackgroundColor:WHITECOLOR];
        }
    }
    [self setViewFrame];
}
-(CGFloat)getHWithModel:(ModelMyNewQuestion *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(void)dealloc
{
    [self setViewNil];
}


@end
