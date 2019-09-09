//
//  ZAnswerDetailQuestionView.m
//  PlaneLive
//
//  Created by Daniel on 20/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailQuestionView.h"
#import "ZLabel.h"
#import "ZCalculateLabel.h"

@interface ZAnswerDetailQuestionView()

///标题
@property (strong, nonatomic) ZLabel *lbTitle;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@property (assign, nonatomic) CGFloat cellH;

@property (assign, nonatomic) CGFloat cellW;

@property (assign, nonatomic) CGFloat space;

@property (assign, nonatomic) CGFloat lbH;

@property (assign, nonatomic) CGFloat lineH;

@end

@implementation ZAnswerDetailQuestionView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    self.cellW = self.width;
    self.cellH = 45;
    self.space = kSizeSpace;
    self.lbH = 20;
    self.lineH = kLineHeight;
    
    [self setBackgroundColor:WHITECOLOR];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setNumberOfLines:3];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbTitle];
    
    self.imgLine = [UIImageView getDLineView];
    [self addSubview:self.imgLine];
    
    [self setViewFrame];
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
    [self.imgLine setFrame:CGRectMake(0, self.lbTitle.y+self.lbTitle.height+kSize13, self.cellW, self.lineH)];
    
    self.cellH = self.imgLine.y+self.imgLine.height;
    
    [self setFrame:CGRectMake(self.x, self.y, self.width, self.cellH)];
}
///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    CGFloat fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbTitle setFont:[ZFont systemFontOfSize:kSet_Font_Default_Size(fontSize)]];
}

-(CGFloat)setViewDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
    
    [self.lbTitle setText:model.question_title];
    
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_modelAB);
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
