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

///问题标题
@property (strong, nonatomic) ZRichStyleLabel *lbTitle;
///回答内容
@property (strong, nonatomic) ZRichStyleLabel *lbContent;
///赞同数量
@property (strong, nonatomic) UILabel *lbCount;
///分割线
@property (strong, nonatomic) UIImageView *imgLine1;
///分割线
@property (strong, nonatomic) UIImageView *imgLine2;
///搜索关键字
@property (strong, nonatomic) NSString *keyword;
///数据对象
@property (strong, nonatomic) ModelCircleSearchContent *model;

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
    [self.lbTitle setTextColor:TITLECOLOR];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbContent = [[ZRichStyleLabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:4];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbContent];
    
    self.lbCount = [[UILabel alloc] init];
    [self.lbCount setTextColor:DESCCOLOR];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbCount setNumberOfLines:1];
    [self.lbCount setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewMain addSubview:self.lbCount];
    
    self.imgLine1 = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine2];
}

-(void)setViewFrame
{
    CGFloat itemW = self.cellW-self.space*2;
    
    CGRect titleFrame = CGRectMake(self.space, 8, itemW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleH > titleMaxH) {
        titleH = titleMaxH;
    }
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    if (self.model.content && self.model.content.length > 0) {
        [self.imgLine1 setHidden:NO];
        [self.lbContent setHidden:NO];
        [self.lbCount setHidden:NO];
        
        CGFloat lineY = self.lbTitle.y+self.lbTitle.height+kSize8;
        [self.imgLine1 setFrame:CGRectMake(self.space, lineY, itemW, self.lineH)];
        
        CGRect contentFrame = CGRectMake(self.space, self.imgLine1.y+self.imgLine1.height+kSize8, itemW, self.lbMinH);
        [self.lbContent setFrame:contentFrame];
        CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbMinH];
        CGFloat contentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent];
        if (contentH > contentMaxH) {
            contentH = contentMaxH;
        }
        contentFrame.size.height = contentH;
        [self.lbContent setFrame:contentFrame];
        
        [self.lbCount setFrame:CGRectMake(self.space, self.lbContent.y + self.lbContent.height + kSize8, itemW, self.lbMinH)];
        
        self.cellH = self.lbCount.y + self.lbCount.height + kSize8 + self.lineMaxH;
    } else {
        [self.imgLine1 setHidden:YES];
        [self.lbContent setHidden:YES];
        [self.lbCount setHidden:YES];
        
        self.cellH = self.lbTitle.y + self.lbTitle.height + kSize10 + self.lineMaxH;
    }
    [self.imgLine2 setFrame:CGRectMake(0, self.cellH-self.lineMaxH, self.cellW, self.lineMaxH)];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelCircleSearchContent *)model
{
    [self setModel:model];
    
    [self.lbTitle setText:model.title];
    if (self.keyword.toTrim.length > 0 && ![self.keyword.toTrim isEqualToString:@"."]) {
        [self.lbTitle setAttributedText:self.lbTitle.text withRegularPattern:[self.lbTitle.text regularPattern:@[self.keyword.toTrim]] attributes:@{ NSForegroundColorAttributeName:MAINCOLOR}];
    } else {
        [self.lbTitle setTextColor:TITLECOLOR];
    }
    
    if (model.content && model.content.length > 0) {
        NSString *content = self.model.content.imgReplacing;
        [self.lbContent setText:content];
        
        if (self.keyword.toTrim.length > 0 && ![self.keyword.toTrim isEqualToString:@"."]) {
            [self.lbContent setAttributedText:self.lbContent.text withRegularPattern:[self.lbContent.text regularPattern:@[self.keyword.toTrim]] attributes:@{ NSForegroundColorAttributeName:MAINCOLOR}];
        } else {
            [self.lbContent setTextColor:BLACKCOLOR1];
        }
    }
    
    [self.lbCount setText:[NSString stringWithFormat:@"%ld%@", model.count, kPraiseCountKey]];
    
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
    OBJC_RELEASE(_keyword);
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
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
