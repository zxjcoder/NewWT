//
//  ZQuestionRelationTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionRelationTVC.h"

@interface ZQuestionRelationTVC()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbContent;

@property (strong, nonatomic) UILabel *lbCount;

@property (strong, nonatomic) UIView *viewL;

@property (strong, nonatomic) NSString *keyword;

@property (strong, nonatomic) ModelCircleSearchContent *model;

@end

@implementation ZQuestionRelationTVC

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
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setHidden:YES];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR2];
    [self.lbContent setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:2];
    [self.lbContent setHidden:YES];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setNumberOfLines:1];
    [self.lbCount setTextColor:MAINCOLOR];
    [self.lbCount setHidden:YES];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setBackgroundColor:RGBCOLOR(243, 243, 243)];
    [self.viewMain addSubview:self.lbCount];
    
    self.viewL = [[UIView alloc] init];
    [self.viewL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    if (titleH > self.lbH) {titleH=40;}
    [self.lbTitle setFrame:CGRectMake(self.space, 8, self.cellW-self.space*2, titleH)];
    
    CGFloat countW = [self.lbCount getLabelWidthWithMinWidth:0]+10;
    CGFloat countH = 25;
    CGFloat countX = self.cellW-self.space-countW;
    [self.lbCount setFrame:CGRectMake(countX, self.cellH/2-countH/2, countW, countH)];
    
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbH];
    if (contentH > self.lbH) {contentH=36;}
    [self.lbTitle setFrame:CGRectMake(self.space, 10, countX-self.space*2, contentH)];
    
    if (self.model.type == 0) {
        if (titleH > self.lbH) {
            self.cellH = 40+20;
        } else {
            self.cellH = 25+20;
        }
    } else {
        if (contentH > self.lbH) {
            self.cellH = 36+20;
        } else {
            self.cellH = 25+20;
        }
    }
    [self.viewL setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setCellDataWithModel:(ModelCircleSearchContent *)model
{
    [self setModel:model];
    
    [self setViewContent];
}

-(void)setCellKeyword:(NSString *)keyword
{
    [self setKeyword:keyword];
}

-(void)setViewContent
{
    if (self.model.type == 0) {
        [self.lbTitle setHidden:NO];
        [self.lbContent setHidden:YES];
        [self.lbCount setHidden:YES];
        [self.lbTitle setText:self.model.title];
        [self.lbTitle setTextColor:BLACKCOLOR];
        if (self.keyword.length > 0) {
            NSRange range = [self.lbTitle.text rangeOfString:self.keyword.toTrim];
            if (range.location != NSNotFound) {
                [self.lbTitle setLabelColorWithRange:range color:MAINCOLOR];
            } else {
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.lbTitle.text];
                self.lbTitle.attributedText = str;
            }
        }
        [self.lbContent setText:nil];
        [self.lbCount setText:nil];
    } else {
        [self.lbTitle setHidden:YES];
        [self.lbContent setHidden:NO];
        [self.lbCount setHidden:NO];
        [self.lbTitle setText:nil];
        
        NSString *content = self.model.title.imgReplacing;
        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithString:content];
        
        [strAttributed addAttribute:NSFontAttributeName value:self.lbContent.font range:NSMakeRange(0, strAttributed.length)];
        [strAttributed addAttribute:NSForegroundColorAttributeName value:self.lbContent.textColor range:NSMakeRange(0, strAttributed.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        [strAttributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strAttributed.length)];
        
        [self.lbContent setAttributedText:strAttributed];
        
        if (self.keyword.length > 0) {
            NSRange range = [self.lbContent.text rangeOfString:self.keyword.toTrim];
            if (range.location != NSNotFound) {
                [self.lbContent setLabelColorWithRange:range color:MAINCOLOR];
            }
        }
        [self.lbCount setText:self.model.count];
    }
}

-(CGFloat)getHWithModel:(ModelCircleSearchContent *)model
{
    [self setModel:model];
    [self setViewContent];
    [self setViewFrame];
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_viewL);
    OBJC_RELEASE(_keyword);
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
