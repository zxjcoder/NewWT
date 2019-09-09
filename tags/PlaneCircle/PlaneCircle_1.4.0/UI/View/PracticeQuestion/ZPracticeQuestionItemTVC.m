//
//  ZPracticeQuestionItemTVC.m
//  PlaneCircle
//
//  Created by Daniel on 8/24/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeQuestionItemTVC.h"

@interface ZPracticeQuestionItemTVC()

///标题
@property (strong, nonatomic) UILabel *lbTitle;
///标题分割线
@property (strong, nonatomic) UIView *viewTitleLine;
///回答内容区域
@property (strong, nonatomic) UIView *viewContent;
///昵称
@property (strong, nonatomic) UILabel *lbNickName;
///个性签名
@property (strong, nonatomic) UILabel *lbSign;
///回答内容
@property (strong, nonatomic) ZRichStyleLabel *lbAnswerContent;

///实体对象
@property (strong, nonatomic) ModelPracticeQuestion *model;
///分割线
@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZPracticeQuestionItemTVC

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
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.viewTitleLine = [[UIView alloc] init];
    [self.viewTitleLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewTitleLine];
    
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewMain addSubview:self.viewContent];
    
    self.lbNickName = [[UILabel alloc] init];
    [self.lbNickName setTextColor:BLACKCOLOR1];
    [self.lbNickName setNumberOfLines:1];
    [self.lbNickName setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbNickName];
    
    self.lbSign = [[UILabel alloc] init];
    [self.lbSign setTextColor:DESCCOLOR];
    [self.lbSign setNumberOfLines:1];
    [self.lbSign setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbSign];
    
    self.lbAnswerContent = [[ZRichStyleLabel alloc] init];
    [self.lbAnswerContent setTextColor:BLACKCOLOR1];
    [self.lbAnswerContent setNumberOfLines:3];
    [self.lbAnswerContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbAnswerContent];
    
    UITapGestureRecognizer *tapAnswerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswerClick:)];
    [self.viewContent addGestureRecognizer:tapAnswerClick];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    [self setCellFontSize];
}
///回答区域点击事件
-(void)tapAnswerClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onAnswerClick) {
            self.onAnswerClick(self.model);
        }
    }
}
///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kSet_Font_Default_Size(self.fontSize)]];
    
    [self.lbNickName setFont:[ZFont systemFontOfSize:kSet_Font_Least_Size(self.fontSize)]];
    [self.lbSign setFont:[ZFont systemFontOfSize:kSet_Font_Minimum_Size(self.fontSize)]];
    
    [self.lbAnswerContent setFont:[ZFont systemFontOfSize:kSet_Font_Small_Size(self.fontSize)]];
}
///设置坐标
-(void)setViewFrame
{
    [self setCellFontSize];
    
    self.cellW = APP_FRAME_WIDTH;

    CGRect titleFrame = CGRectMake(self.space, kSize8, self.cellW-self.space*2, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > maxH) {titleH = maxH;}
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    //标题分割线
    [self.viewTitleLine setFrame:CGRectMake(0, self.lbTitle.y+self.lbTitle.height+kSize8, self.cellW, self.lineH)];
    
    ///没有回答的情况
    if ([self.model.aid intValue] == 0) {
        [self.viewContent setHidden:YES];
        [self.viewContent setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, 0)];
        [self.lbNickName setHidden:YES];
        [self.lbSign setHidden:YES];
        [self.lbAnswerContent setHidden:YES];
        [self.viewTitleLine setHidden:YES];
        
        [self.viewLine setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, self.lineMaxH)];
    } else {
        [self.viewContent setHidden:NO];
        [self.lbNickName setHidden:NO];
        [self.lbSign setHidden:NO];
        [self.lbAnswerContent setHidden:NO];
        [self.viewTitleLine setHidden:NO];
        
        [self.viewContent setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, self.lbH)];
        //昵称
        CGFloat nickNameW = [self.lbNickName getLabelWidthWithMinWidth:0];
        [self.lbNickName setFrame:CGRectMake(self.space, kSize10, nickNameW, self.lbH)];
        
        CGFloat imgSize = 0;
        CGFloat signX = self.lbNickName.x+self.lbNickName.width+kSize8;
        CGFloat signW = self.viewContent.width-signX-imgSize-kSize13-kSize5;
        CGFloat signY = self.lbNickName.y+self.lbNickName.height-self.lbMinH;
        [self.lbSign setFrame:CGRectMake(signX, signY, signW, self.lbMinH)];
       
        //回答内容
        CGFloat lbW = self.viewContent.width-self.space*2;
        CGRect answerContentFrame = CGRectMake(self.space, self.lbNickName.y+self.lbNickName.height, lbW, 0);
        [self.lbAnswerContent setFrame:answerContentFrame];
        if (self.lbAnswerContent.text.length > 0) {
            CGFloat acH = [self.lbAnswerContent getLabelHeightWithMinHeight:self.lbMinH];
            CGFloat amaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbAnswerContent];
            if (acH > amaxH) {acH = amaxH;}
            answerContentFrame.size.height = acH;
            answerContentFrame.origin.y = answerContentFrame.origin.y+kSize8;
            
            [self.lbAnswerContent setFrame:answerContentFrame];
        }
        //内容区域
        [self.viewContent setFrame:CGRectMake(0, self.viewTitleLine.y+self.viewTitleLine.height, self.cellW, self.lbAnswerContent.y+self.lbAnswerContent.height+kSize12)];
        
        [self.viewLine setFrame:CGRectMake(0, self.viewContent.y+self.viewContent.height, self.cellW, self.lineMaxH)];
    }
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelPracticeQuestion *)model
{
    [self setModel:model];
    
    [self setViewValue];
}

-(void)setViewValue
{
    if (self.model) {
        [self.lbTitle setText:self.model.title];
        
        NSString *content = self.model.answerContent;
        [self.lbAnswerContent setText:content];
        
        [self.lbNickName setText:self.model.nickname];
        [self.lbSign setText:self.model.sign];
    }
    [self setViewFrame];
}

-(CGFloat)getHWithModel:(ModelPracticeQuestion *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbSign);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbNickName);
    OBJC_RELEASE(_lbAnswerContent);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewTitleLine);
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
