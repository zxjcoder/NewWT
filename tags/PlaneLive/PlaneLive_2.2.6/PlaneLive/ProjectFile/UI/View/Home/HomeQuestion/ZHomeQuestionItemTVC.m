//
//  ZHomeQuestionItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZHomeQuestionItemTVC.h"
#import "ZCalculateLabel.h"

@interface ZHomeQuestionItemTVC()

@property (strong, nonatomic) ZLabel *lbTitle;

@property (strong, nonatomic) ZLabel *lbContent;

@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZHomeQuestionItemTVC

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
    
    self.cellH = [ZHomeQuestionItemTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setNumberOfLines:2];
    [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewMain addSubview:self.lbTitle];
    
    self.lbContent = [[ZLabel alloc] init];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbContent setNumberOfLines:4];
    [self.lbContent setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.viewMain addSubview:self.lbContent];
    
    self.imgLine = [UIImageView getTLineView];
    [self.viewMain addSubview:self.imgLine];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    CGFloat contentW = self.cellW-kSizeSpace*2;
    CGRect titleFrame = CGRectMake(kSizeSpace, 20, contentW, self.lbH);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    if (titleH > titleMaxH) { titleH = titleMaxH; }
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    CGRect contentFrame = CGRectMake(kSizeSpace, titleFrame.origin.y+titleFrame.size.height+15, contentW, self.lbH);
    [self.lbContent setFrame:contentFrame];
    CGFloat contentMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbContent];
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:self.lbH];
    if (contentH > contentMaxH) { contentH = contentMaxH; }
    contentFrame.size.height = contentH;
    [self.lbContent setFrame:contentFrame];
    
    self.cellH = contentFrame.origin.y+contentFrame.size.height+18;
    
    [self.imgLine setFrame:CGRectMake(kSizeSpace, self.cellH-kLineHeight, contentW, kLineHeight)];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(CGFloat)setCellDataWithModel:(ModelQuestionBoutique *)model
{
    [self.lbTitle setText:model.title];
    
    [self.lbContent setText:model.content];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_imgLine);
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
+(CGFloat)getH
{
    return 45;
}

@end
