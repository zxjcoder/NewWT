//
//  ZMyCollectionAnswerTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCollectionAnswerTVC.h"

@interface ZMyCollectionAnswerTVC()

///问题
@property (strong, nonatomic) UILabel *lbQuestion;
///问题分割线
@property (strong, nonatomic) UIImageView *imgLine1;
///答案区域
@property (strong, nonatomic) UIView *viewAnswer;
///答案
@property (strong, nonatomic) ZRichStyleLabel *lbAnswer;
///cell分割线
@property (strong, nonatomic) UIImageView *imgLine2;
///数据对象
@property (strong, nonatomic) ModelCollectionAnswer *modelCA;

@end

@implementation ZMyCollectionAnswerTVC

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
    
    self.lbQuestion = [[UILabel alloc] init];
    [self.lbQuestion setTextColor:BLACKCOLOR];
    [self.lbQuestion setNumberOfLines:2];
    [self.lbQuestion setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbQuestion];
    
    self.viewAnswer = [[UIView alloc] init];
    UITapGestureRecognizer *tapAnswerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswerClick:)];
    [self.viewAnswer addGestureRecognizer:tapAnswerClick];
    [self.viewMain addSubview:self.viewAnswer];
    
    self.lbAnswer = [[ZRichStyleLabel alloc] init];
    [self.lbAnswer setTextColor:BLACKCOLOR1];
    [self.lbAnswer setNumberOfLines:4];
    [self.lbAnswer setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewAnswer addSubview:self.lbAnswer];
    
    self.imgLine1 = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine2];
    
    [self setCellFontSize];
}

-(void)tapAnswerClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onAnswerClick) {
            self.onAnswerClick(self.modelCA);
        }
    }
}
///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbQuestion setFont:[ZFont systemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
    [self.lbAnswer setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
}
-(void)setViewFrame
{
    [self setCellFontSize];
    
    CGRect questionFrame = CGRectMake(self.space, 8, self.cellW-self.space*2, self.lbH);
    [self.lbQuestion setFrame:questionFrame];
    
    CGFloat questionH = [self.lbQuestion getLabelHeightWithMinHeight:self.lbH];
    CGFloat questionMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbQuestion];
    if (questionH > questionMaxH) {
        questionH = questionMaxH;
    }
    questionFrame.size.height = questionH;
    [self.lbQuestion setFrame:questionFrame];
    
    [self.imgLine1 setFrame:CGRectMake(self.space, questionFrame.origin.y*2+questionH, self.cellW-self.space*2, self.lineH)];
    
    CGRect answerFrame = CGRectMake(self.space, 8, self.cellW-self.space*2, self.lbMinH);
    [self.lbAnswer setFrame:answerFrame];
    
    CGFloat answerH = [self.lbAnswer getLabelHeightWithMinHeight:self.lbH];
    CGFloat answerMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbAnswer];
    if (answerH > answerMaxH) {
        answerH = answerMaxH;
    }
    answerFrame.size.height = answerH;
    [self.lbAnswer setFrame:answerFrame];
    [self.viewAnswer setFrame:CGRectMake(0, self.imgLine1.y+self.imgLine1.height+5, self.cellW, answerH+8*2)];
    
    [self.imgLine2 setFrame:CGRectMake(0, self.viewAnswer.y+self.viewAnswer.height+8, self.cellW, self.lineMaxH)];
    
    self.cellH = self.imgLine2.y+self.imgLine2.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbAnswer);
    OBJC_RELEASE(_lbQuestion);
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
    [super setViewNil];
}

-(CGFloat)setCellDataWithModel:(ModelCollectionAnswer *)model
{
    [self setModelCA:model];
    if (model) {
        [self.lbQuestion setText:model.questions];
        
        NSString *content = model.content;
        [self.lbAnswer setText:content];
    }
    [self setViewFrame];
    
    return self.cellH;
}

-(CGFloat)getHWithModel:(ModelCollectionAnswer *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
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
