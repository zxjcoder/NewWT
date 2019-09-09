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
@property (strong, nonatomic) UIView *viewLine1;
///答案区域
@property (strong, nonatomic) UIView *viewAnswer;
///答案
@property (strong, nonatomic) ZRichStyleLabel *lbAnswer;
///cell分割线
@property (strong, nonatomic) UIView *viewLine2;
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
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine2];
    
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
    
    [self.lbQuestion setFont:[ZFont boldSystemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
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
    
    [self.viewLine1 setFrame:CGRectMake(0, questionFrame.origin.y*2+questionH, self.cellW, self.lineH)];
    
    CGRect answerFrame = CGRectMake(self.space, 8, self.cellW-self.space*2, self.lbMinH);
    [self.lbAnswer setFrame:answerFrame];
    
    CGFloat answerH = [self.lbAnswer getLabelHeightWithMinHeight:self.lbH];
    CGFloat answerMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbAnswer];
    if (answerH > answerMaxH) {
        answerH = answerMaxH;
    }
    answerFrame.size.height = answerH;
    [self.lbAnswer setFrame:answerFrame];
    [self.viewAnswer setFrame:CGRectMake(0, self.viewLine1.y+self.viewLine1.height, self.cellW, answerH+8*2)];
    
    [self.viewLine2 setFrame:CGRectMake(0, self.viewAnswer.y+self.viewAnswer.height, self.cellW, self.lineMaxH)];
    
    self.cellH = self.viewLine2.y+self.viewLine2.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbAnswer);
    OBJC_RELEASE(_lbQuestion);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
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
