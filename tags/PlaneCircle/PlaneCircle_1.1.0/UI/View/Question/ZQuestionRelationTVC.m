//
//  ZQuestionRelationTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionRelationTVC.h"
#import "ZRichStyleLabel.h"

@interface ZQuestionRelationTVC()

@property (strong, nonatomic) ZRichStyleLabel *lbTitle;

//@property (strong, nonatomic) UILabel *lbContent;
//
//@property (strong, nonatomic) UILabel *lbCount;

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
    
    self.lbTitle = [[ZRichStyleLabel alloc] init];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setHidden:YES];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
//    self.lbContent = [[UILabel alloc] init];
//    [self.lbContent setTextColor:BLACKCOLOR1];
//    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
//    [self.lbContent setNumberOfLines:2];
//    [self.lbContent setHidden:YES];
//    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
//    [self.viewMain addSubview:self.lbContent];
    
//    self.lbCount = [[UILabel alloc] init];
//    [self.lbCount setNumberOfLines:1];
//    [self.lbCount setTextColor:MAINCOLOR];
//    [self.lbCount setHidden:YES];
//    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
//    [self.lbCount setBackgroundColor:RGBCOLOR(243, 243, 243)];
//    [self.viewMain addSubview:self.lbCount];
    
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
    [self.lbTitle setFrame:CGRectMake(self.space, kSize10, self.cellW-self.space*2, self.lbH)];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > titleMaxH) {titleH=titleMaxH;}
    [self.lbTitle setFrame:CGRectMake(self.lbTitle.x, self.lbTitle.y, self.lbTitle.width, titleH)];
    
//    CGFloat countW = [self.lbCount getLabelWidthWithMinWidth:0]+10;
//    CGFloat countH = 25;
//    CGFloat countX = self.cellW-self.space-countW;
//    [self.lbCount setFrame:CGRectMake(countX, self.cellH/2-countH/2, countW, countH)];
//    
//    [self.lbContent setFrame:CGRectMake(self.space, 10, countX-self.space*2, self.lbH)];
//    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbH];
//    CGFloat contentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent];
//    if (contentH > contentMaxH) {contentH=contentMaxH;}
//    [self.lbContent setFrame:CGRectMake(self.space, 10, countX-self.space*2, contentH)];
    
    ///当前内容类型 0提问,1回答
//    if (self.model.type == 0) {
//        if (titleH > titleMaxH) {
//            self.cellH = titleMaxH+20;
//        } else {
//            self.cellH = 25+20;
//        }
//    } else {
//        if (contentH > contentMaxH) {
//            self.cellH = contentMaxH+20;
//        } else {
//            self.cellH = 25+20;
//        }
//    }
    self.cellH = self.lbTitle.y+self.lbTitle.height+kSize10;
    
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
    [self.lbTitle setHidden:NO];
    [self.lbTitle setText:self.model.title];
    if (self.keyword.length > 0) {
        if (self.keyword.toTrim.length > 0) {
            [self.lbTitle setAttributedText:self.lbTitle.text withRegularPattern:[self.lbTitle.text regularPattern:@[self.keyword.toTrim]] attributes:@{ NSForegroundColorAttributeName:MAINCOLOR}];
        }
    }
//    if (self.model.type == 0) {
//        [self.lbTitle setHidden:NO];
//        [self.lbContent setHidden:YES];
//        [self.lbCount setHidden:YES];
//        [self.lbTitle setText:self.model.title];
//        [self.lbTitle setTextColor:BLACKCOLOR];
//        if (self.keyword.length > 0) {
//            NSRange range = [self.lbTitle.text rangeOfString:self.keyword.toTrim];
//            if (range.location != NSNotFound) {
//                [self.lbTitle setLabelColorWithRange:range color:MAINCOLOR];
//            } else {
//                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.lbTitle.text];
//                self.lbTitle.attributedText = str;
//            }
//        }
//        [self.lbContent setText:nil];
//        [self.lbCount setText:nil];
//    } else {
//        [self.lbTitle setHidden:YES];
//        [self.lbContent setHidden:NO];
//        [self.lbCount setHidden:NO];
//        [self.lbTitle setText:nil];
//        
//        NSString *content = self.model.content.imgReplacing;
//        if (content) {
//            content = [content stringByReplacingOccurrencesOfString:@"\n" withString:kEmpty];
//            content = [content stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
//        }
//        [self.lbContent setText:content];
//        
//        if (self.keyword.length > 0) {
//            NSRange range = [self.lbContent.text rangeOfString:self.keyword.toTrim];
//            if (range.location != NSNotFound) {
//                [self.lbContent setLabelColorWithRange:range color:MAINCOLOR];
//            }
//        }
//        [self.lbCount setText:self.model.count];
//    }
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
//    OBJC_RELEASE(_lbCount);
//    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_lbTitle);
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
