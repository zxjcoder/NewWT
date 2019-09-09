//
//  ZQuestionAnswerTVC.m
//  PlaneLive
//
//  Created by Daniel on 03/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionAnswerTVC.h"
#import "ZRichStyleLabel.h"
#import "Utils.h"

@interface ZQuestionAnswerTVC()

///头像
@property (strong, nonatomic) ZImageView *imgHead;
///昵称
@property (strong, nonatomic) ZLabel *lbNickName;
///问题标题
@property (strong, nonatomic) ZLabel *lbQuestion;
///答案区域
@property (strong, nonatomic) UIView *viewAnswer;
///回答内容
@property (strong, nonatomic) ZLabel *lbAnswer;
///问题和回答分割线
@property (strong, nonatomic) UIImageView *imgTLine;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;
///数据对象
@property (strong, nonatomic) ModelQuestionItem *model;

@end

@implementation ZQuestionAnswerTVC

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.imgHead = [[ZImageView alloc] init];
    UITapGestureRecognizer *tapPhotoClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoClick:)];
    [self.imgHead addGestureRecognizer:tapPhotoClick];
    [self.viewMain addSubview:self.imgHead];
    
    self.lbNickName = [[ZLabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbNickName];
    
    self.lbQuestion = [[ZLabel alloc] init];
    [self.lbQuestion setTextColor:BLACKCOLOR];
    [self.lbQuestion setNumberOfLines:2];
    [self.lbQuestion setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbQuestion];
    
    self.viewAnswer = [[UIView alloc] init];
    UITapGestureRecognizer *tapAnswerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswerClick:)];
    [self.viewAnswer addGestureRecognizer:tapAnswerClick];
    [self.viewMain addSubview:self.viewAnswer];
    
    self.lbAnswer = [[ZLabel alloc] init];
    [self.lbAnswer setTextColor:BLACKCOLOR1];
    [self.lbAnswer setNumberOfLines:4];
    [self.lbAnswer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewAnswer addSubview:self.lbAnswer];
    
    self.imgTLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgTLine];
    
    self.imgLine = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setCellFontSize];
}
-(void)tapPhotoClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onPhotoClick) {
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:self.model.userId];
            [modelUB setNickname:self.model.nickname];
            [modelUB setHead_img:self.model.head_img];
            [modelUB setSign:self.model.sign];
            self.onPhotoClick(modelUB);
        }
    }
}
-(void)tapAnswerClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onAnswerClick) {
            ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
            [modelAB setIds:self.model.aid];
            [modelAB setQuestion_id:self.model.ids];
            [modelAB setTitle:self.model.content];
            [modelAB setQuestion_title:self.model.title];
            self.onAnswerClick(modelAB);
        }
    }
}
///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbNickName setFont:[ZFont boldSystemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
    [self.lbQuestion setFont:[ZFont boldSystemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
    [self.lbAnswer setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
}

-(void)setViewFrame
{
    [self setCellFontSize];
    
    CGFloat imgSize = 25;
    [self.imgHead setFrame:CGRectMake(self.space, self.space, imgSize, imgSize)];
    [self.imgHead setViewRound];
    
    CGFloat lbX = self.imgHead.x+self.imgHead.width+kSize8;
    CGFloat lbW = self.cellW-lbX-kSize10;
    [self.lbNickName setFrame:CGRectMake(lbX, self.space+2.5, lbW, 20)];
    
    CGFloat lbY = self.imgHead.y+self.imgHead.height+kSize8;
    CGRect questionFrame = CGRectMake(self.space, lbY, self.cellW-self.space*2, self.lbH);
    [self.lbQuestion setFrame:questionFrame];
    
    CGFloat questionH = [self.lbQuestion getLabelHeightWithMinHeight:self.lbH];
    CGFloat questionMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbQuestion];
    if (questionH > questionMaxH) {
        questionH = questionMaxH;
    }
    questionFrame.size.height = questionH;
    [self.lbQuestion setFrame:questionFrame];
    
    CGFloat tlineY = questionFrame.origin.y+questionFrame.size.height+kSize8;
    CGFloat tlineX = kSizeSpace;
    CGFloat tlineW = self.cellW-tlineX*2;
    [self.imgTLine setFrame:CGRectMake(tlineX, tlineY, tlineW, self.lineH)];
    
    CGFloat answerW = self.cellW-self.space*2;
    CGRect answerFrame = CGRectMake(self.space, kSize8, answerW, self.lbMinH);
    [self.lbAnswer setFrame:answerFrame];
    
    CGFloat answerH = [self.lbAnswer getLabelHeightWithMinHeight:self.lbH];
    CGFloat answerMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbAnswer];
    if (answerH > answerMaxH) {
        answerH = answerMaxH;
    }
    answerFrame.size.height = answerH;
    [self.lbAnswer setFrame:answerFrame];
    [self.viewAnswer setFrame:CGRectMake(0, self.imgTLine.y+self.imgTLine.height, self.cellW, answerH+kSize18)];
    
    [self.imgLine setFrame:CGRectMake(0, self.viewAnswer.y+self.viewAnswer.height, self.cellW, self.lineMaxH)];
    
    self.cellH = self.imgLine.y+self.imgLine.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)dealloc
{
    OBJC_RELEASE(_imgHead);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbAnswer);
    OBJC_RELEASE(_lbQuestion);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_imgTLine);
    
    [super setViewNil];
}

-(CGFloat)setCellDataWithModel:(ModelQuestionItem *)model
{
    [self setModel:model];
    
    [self.imgHead setPhotoURLStr:model.head_img];
    
    [self.lbNickName setText:model.nickname];
    
    [self.lbQuestion setText:model.title];
    
    [self.lbAnswer setText:[Utils getTrimImg:model.content]];
    
    [self setViewFrame];
    
    return self.cellH;
}

@end
