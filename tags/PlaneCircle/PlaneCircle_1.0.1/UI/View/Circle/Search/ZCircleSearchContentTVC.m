//
//  ZCircleSearchContentTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleSearchContentTVC.h"

@interface ZCircleSearchContentTVC()

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbContent;

@property (strong, nonatomic) UILabel *lbCount;

@property (strong, nonatomic) UIView *viewL1;
@property (strong, nonatomic) UIView *viewL2;

@property (strong, nonatomic) ModelCircleSearchContent *model;

@property (strong, nonatomic) NSString *keyword;

@end

@implementation ZCircleSearchContentTVC

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
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
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
    [self.lbCount setText:@"0"];
    [self.lbCount setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setBackgroundColor:RGBCOLOR(243, 243, 243)];
    [[self.lbCount layer] setMasksToBounds:YES];
    [self.lbCount setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.lbCount];
    
    self.viewL1 = [[UIView alloc] init];
    [self.viewL1 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewL1];
    
    self.viewL2 = [[UIView alloc] init];
    [self.viewL2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewMain addSubview:self.viewL2];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGRect titleFrame = CGRectMake(self.space, 8, self.cellW-self.space*2, 0);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    if (titleH > self.lbH) {
        titleH=42;
    }
    titleFrame.size.height = titleH;
    if (self.model.type == 0) {
        [self.viewL1 setFrame:CGRectMake(0, 0, self.cellW, self.lineMaxH)];
        titleFrame.origin.y = 13;
        [self.lbTitle setFrame:titleFrame];
    } else {
        [self.viewL1 setFrame:CGRectMake(0, 0, self.cellW, 0)];
    }
    [self.lbTitle setFrame:titleFrame];
    
    CGRect contentFrame = CGRectMake(self.space, 10, self.cellW-self.space*2-30, 0);
    [self.lbContent setFrame:contentFrame];
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
    if (contentH > self.lbMinH) {
        contentH=39;
    }
    contentFrame.size.height = contentH;
    
    if (self.model.type == 0) {
        self.cellH = titleH+20;
    } else {
        self.cellH = contentH+20;
    }
    CGFloat countW = [self.lbCount getLabelWidthWithMinWidth:0]+15;
    CGFloat countH = 23;
    CGFloat countX = self.cellW-self.space-countW;
    [self.lbCount setFrame:CGRectMake(countX, self.cellH/2-countH/2, countW, countH)];
    
    contentFrame.size.width = countX-self.space*2;
    [self.lbContent setFrame:contentFrame];
    
    [self.viewL2 setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(void)setCellDataWithModel:(ModelCircleSearchContent *)model
{
    [self setModel:model];
    
    [self setViewContent];
    
    [self setViewFrame];
}

-(void)setViewContent
{
    ///提问
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
        
        NSString *content = self.model.content.imgReplacing;
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
        
        if ([self.model.count intValue] > 999) {
            [self.lbCount setText:@"999"];
        } else {
            [self.lbCount setText:self.model.count];
        }
    }
}
-(void)setCellKeyword:(NSString *)keyword
{
    [self setKeyword:keyword];
}
-(CGFloat)getHWithModel:(ModelCircleSearchContent *)model
{
    [self setCellDataWithModel:model];
    return self.cellH;
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewL1);
    OBJC_RELEASE(_viewL2);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_keyword);
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
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
