//
//  ZMyQuestionTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyQuestionTVC.h"

@interface ZMyQuestionTVC()

///问题区域
@property (strong, nonatomic) UIView *viewQuestion;
///问题标题
@property (strong, nonatomic) UILabel *lbTitle;
///问题描述
@property (strong, nonatomic) UILabel *lbContent;

///实体对象
@property (strong, nonatomic) ModelMyAllQuestion *model;
///分割线
@property (strong, nonatomic) UIView *viewLine;

@end

@implementation ZMyQuestionTVC

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
    
    self.cellH = self.getH;
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.viewQuestion = [[UIView alloc] init];
    [self.viewMain addSubview:self.viewQuestion];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewQuestion addSubview:self.lbTitle];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setTextColor:DESCCOLOR];
    [self.lbContent setNumberOfLines:1];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.viewLine = [[UIView alloc] init];
    [self.viewLine setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewLine];
    
    [self setCellFontSize];
}

///TODO:ZWW备注-设置字体大小
-(void)setCellFontSize
{
    self.fontSize = [[AppSetting getFontSize] floatValue];
    
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kSet_Font_Middle_Size(self.fontSize)]];
    [self.lbContent setFont:[ZFont systemFontOfSize:kSet_Font_Least_Size(self.fontSize)]];
}

-(void)setViewFrame
{
    [self setCellFontSize];
    //右边区域
    CGFloat rightX = self.space;
    CGFloat rightW = self.cellW - rightX - self.space;
    
    [self.lbTitle setFrame:CGRectMake(rightX, kSize13, rightW, self.lbH)];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle line:2];
    if (titleH > titleMaxH) {
        titleH = titleMaxH;
    }
    [self.lbTitle setFrame:CGRectMake(self.lbTitle.x, self.lbTitle.y, rightW, titleH)];
    [self.viewQuestion setFrame:CGRectMake(0, 0, self.cellW, titleH+self.lbTitle.y)];
    
    [self.lbContent setFrame:CGRectMake(self.space, self.viewQuestion.y+self.viewQuestion.height+kSize8, rightW, 0)];
    ///有描述
    if (self.lbContent.text.length > 0) {
        CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
        CGFloat contentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent line:1];
        if (contentH > contentMaxH) {
            contentH = contentMaxH;
        }
        [self.lbContent setFrame:CGRectMake(self.lbContent.x, self.lbContent.y, self.lbContent.width, contentH)];
    }
    [self.viewLine setFrame:CGRectMake(0, self.lbContent.y+self.lbContent.height+kSize8, self.cellW, self.lineMaxH)];
    
    self.cellH = self.viewLine.y+self.viewLine.height;
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(void)setCellDataWithModel:(ModelMyAllQuestion *)model
{
    [self setModel:model];
    if (model) {
        [self.lbTitle setText:model.title];
        
        [self.lbContent setText:self.model.qContent];
    }
    [self setViewFrame];
}

///获取CELL高度
-(CGFloat)getHWithModel:(ModelMyAllQuestion *)model
{
    [self setCellDataWithModel:model];
    
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_viewLine);
    OBJC_RELEASE(_viewQuestion);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}


@end
