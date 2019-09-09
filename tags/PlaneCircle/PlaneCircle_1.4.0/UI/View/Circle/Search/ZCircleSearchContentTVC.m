//
//  ZCircleSearchContentTVC.m
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleSearchContentTVC.h"
#import "ZRichStyleLabel.h"

@interface ZCircleSearchContentTVC()

@property (strong, nonatomic) ZRichStyleLabel *lbTitle;

@property (strong, nonatomic) ZRichStyleLabel *lbContent;

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
    
    self.lbTitle = [[ZRichStyleLabel alloc] init];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setHidden:YES];
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbContent = [[ZRichStyleLabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:2];
    [self.lbContent setHidden:YES];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setNumberOfLines:1];
    [self.lbCount setTextColor:MAINCOLOR];
    [self.lbCount setHidden:YES];
    [self.lbCount setText:@"0"];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbCount setBackgroundColor:RGBCOLOR(243, 243, 243)];
    [[self.lbCount layer] setMasksToBounds:YES];
    [self.lbCount setViewRound:5 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewMain addSubview:self.lbCount];
    
    self.viewL1 = [[UIView alloc] init];
    [self.viewL1 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
    [self.viewMain addSubview:self.viewL1];
    
    self.viewL2 = [[UIView alloc] init];
    [self.viewL2 setBackgroundColor:TABLEVIEWCELL_TLINECOLOR];
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
    CGFloat maxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > maxH) {
        titleH=maxH;
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
    CGFloat cmaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent];
    if (contentH > cmaxH) {
        contentH=cmaxH;
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
        [self.lbTitle setTextColor:TITLECOLOR];
        
        if (self.keyword.toTrim.length > 0 && ![self.keyword.toTrim isEqualToString:@"."]) {
            [self.lbTitle setAttributedText:self.lbTitle.text withRegularPattern:[self.lbTitle.text regularPattern:@[self.keyword.toTrim]] attributes:@{ NSForegroundColorAttributeName:MAINCOLOR}];
        } else {
            [self.lbTitle setTextColor:TITLECOLOR];
        }
        [self.lbContent setText:nil];
        [self.lbCount setText:nil];
    } else {
        [self.lbTitle setHidden:YES];
        [self.lbContent setHidden:NO];
        [self.lbCount setHidden:NO];
        [self.lbTitle setText:nil];
        
        NSString *content = self.model.content;
        [self.lbContent setText:content];
        
        if (self.keyword.toTrim.length > 0 && ![self.keyword.toTrim isEqualToString:@"."]) {
            [self.lbContent setAttributedText:self.lbContent.text withRegularPattern:[self.lbContent.text regularPattern:@[self.keyword.toTrim]] attributes:@{ NSForegroundColorAttributeName:MAINCOLOR}];
        } else {
            [self.lbContent setTextColor:BLACKCOLOR1];
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
