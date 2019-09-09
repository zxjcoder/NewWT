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

@property (strong, nonatomic) UIImageView *imgLine;

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
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.imgLine = [UIImageView getDLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGRect titleFrame = CGRectMake(self.space, kSize10, self.cellW-self.space*2, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > titleMaxH) {
        titleH = titleMaxH;
    }
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    self.cellH = self.lbTitle.y+self.lbTitle.height+kSize10;
    
    [self.imgLine setFrame:CGRectMake(0, self.cellH-self.lineH, self.cellW, self.lineH)];
}

-(CGFloat)setCellDataWithModel:(ModelCircleSearchContent *)model
{
    [self setModel:model];
    
    [self.lbTitle setText:self.model.title];
    
    if (self.keyword.toTrim.length > 0 && ![self.keyword.toTrim isEqualToString:@"."]) {
        [self.lbTitle setAttributedText:self.lbTitle.text withRegularPattern:[self.lbTitle.text regularPattern:@[self.keyword.toTrim]] attributes:@{ NSForegroundColorAttributeName:MAINCOLOR}];
    } else {
        [self.lbTitle setTextColor:BLACKCOLOR1];
    }

    [self setViewFrame];

    return self.cellH;
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
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgLine);
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
