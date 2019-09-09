//
//  ZAnswerDetailQuestionTVC.m
//  PlaneCircle
//
//  Created by Daniel on 8/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailQuestionTVC.h"

@interface ZAnswerDetailQuestionTVC()

///标题
@property (strong, nonatomic) ZLabel *lbTitle;

@property (strong, nonatomic) UIView *viewLine;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@end

@implementation ZAnswerDetailQuestionTVC

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
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setNumberOfLines:3];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    [self setCellFontSize];
}
///设置坐标
-(void)setViewFrame
{
    [self setCellFontSize];
    
    CGRect titleFrame = CGRectMake(self.space, kSize8, self.cellW-self.space*2, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > maxH) {titleH = maxH;}
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    //标题分割线
    [self.viewLine setFrame:CGRectMake(0, self.lbTitle.y+self.lbTitle.height+kSize13, self.cellW, self.lineH)];
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
}

-(void)setCellDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
    
    [self.lbTitle setText:model.question_title];
    
    [self setViewFrame];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_modelAB);
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
