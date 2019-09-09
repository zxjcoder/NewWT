//
//  ZMyAnswerTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAnswerTVC.h"

@interface ZMyAnswerTVC()

///问题区域
@property (strong, nonatomic) UIView *viewQuestion;
///问题标题
@property (strong, nonatomic) UILabel *lbTitle;
///回答内容
@property (strong, nonatomic) UILabel *lbContent;
///回答数量
@property (strong, nonatomic) UILabel *lbCount;
///问题分割线
@property (strong, nonatomic) UIView *viewL1;
///CELL分割线
@property (strong, nonatomic) UIView *viewL2;

@property (strong, nonatomic) ModelQuestionMyAnswer *model;

@end

@implementation ZMyAnswerTVC

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
    
    self.viewQuestion = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewQuestion];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewQuestion addSubview:self.lbTitle];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:2];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setNumberOfLines:1];
    [self.lbCount setTextColor:MAINCOLOR];
    [self.lbCount setText:@"0"];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setBackgroundColor:RGBCOLOR(243, 243, 243)];
    [[self.lbCount layer] setMasksToBounds:YES];
    [self.lbCount setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.lbCount];
    
    self.viewL1 = [[UIView alloc] init];
    [self.viewL1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL1];
    
    self.viewL2 = [[UIView alloc] init];
    [self.viewL2 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewL2];
    
    UITapGestureRecognizer *questionClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(questionClick:)];
    [self.viewQuestion addGestureRecognizer:questionClick];
}

-(void)questionClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onQuestionClick) {
            self.onQuestionClick(self.model);
        }
    }
}

-(void)setViewFrame
{
    CGRect titleFrame = CGRectMake(self.space, kSize10, self.cellW-self.space*2, 0);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > titleMaxH) {
        titleH = titleMaxH;
    }
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    [self.viewQuestion setFrame:CGRectMake(0, 0, self.cellW, titleH+kSize10*2)];
    
    [self.viewL1 setFrame:CGRectMake(0, self.viewQuestion.y+self.viewQuestion.height, self.cellW, self.lineH)];
    
    CGFloat countW = [self.lbCount getLabelWidthWithMinWidth:0]+kSize15;
    CGFloat countX = self.cellW-self.space-countW;
    
    CGFloat contentW = self.cellW-self.space*2-countW-kSize10;
    CGFloat contentY = self.viewL1.y+self.viewL1.height+kSize10;
    CGRect contentFrame = CGRectMake(self.space, contentY, contentW, 0);
    [self.lbContent setFrame:contentFrame];
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
    CGFloat contentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent];
    if (contentH > contentMaxH) {
        contentH = contentMaxH;
    }
    contentFrame.size.height = contentH;
    [self.lbContent setFrame:contentFrame];
    
    CGFloat countH = 23;
    CGFloat countY = contentFrame.origin.y-8+(contentH+8*2)/2-countH/2;
    [self.lbCount setFrame:CGRectMake(countX, countY, countW, countH)];
    
    [self.viewL2 setFrame:CGRectMake(0, self.lbContent.y+self.lbContent.height+kSize10, self.cellW, self.lineMaxH)];
    
    self.cellH = self.viewL2.y+self.viewL2.height;
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelQuestionMyAnswer *)model
{
    [self setModel:model];
    
    [self setViewContent];
    
    [self setViewFrame];
}

-(void)setViewContent
{
    [self.lbTitle setText:self.model.title];
    
    NSString *content = self.model.content.imgReplacing;
    if (content) {
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:kEmpty];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
    }
    [self.lbContent setText:content];
    
    [self.lbCount setText:self.model.count];
}

-(CGFloat)getHWithModel:(ModelQuestionMyAnswer *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_viewL1);
    OBJC_RELEASE(_viewL2);
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
