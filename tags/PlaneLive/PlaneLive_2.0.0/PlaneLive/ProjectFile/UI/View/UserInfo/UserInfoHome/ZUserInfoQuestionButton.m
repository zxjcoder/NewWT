//
//  ZUserInfoQuestionButton.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoQuestionButton.h"
#import "ZLabel.h"

@interface ZUserInfoQuestionButton()

@property (strong, nonatomic) ZLabel *lbTitle;

@property (strong, nonatomic) ZLabel *lbMaxCount;

@property (strong, nonatomic) ZLabel *lbReadCount;

@end

@implementation ZUserInfoQuestionButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setUserInteractionEnabled:YES];
    [self setBackgroundColor:WHITECOLOR];
    
    CGFloat lbH = 25;
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(0, 10, self.width, lbH)];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setTextColor:DESCCOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbTitle];
    
    CGFloat maxCountY = self.lbTitle.y+self.lbTitle.height+10;
    self.lbMaxCount = [[ZLabel alloc] initWithFrame:CGRectMake(0, maxCountY, self.width, 20)];
    [self.lbMaxCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbMaxCount setTextColor:BLACKCOLOR];
    [self.lbMaxCount setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbMaxCount setNumberOfLines:1];
    [self.lbMaxCount setUserInteractionEnabled:NO];
    [self.lbMaxCount setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbMaxCount];
    
    CGFloat minCountY = self.lbTitle.y+self.lbTitle.height;
    CGFloat minCountSize = 15;
    CGFloat minCountX = self.width/2 + 15;
    self.lbReadCount = [[ZLabel alloc] initWithFrame:CGRectMake(minCountX, minCountY, minCountSize, minCountSize)];
    [self.lbReadCount setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbReadCount setTextColor:WHITECOLOR];
    [self.lbReadCount setBackgroundColor:MAINCOLOR];
    [self.lbReadCount setViewRoundNoBorder];
    [self.lbReadCount setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbReadCount setNumberOfLines:1];
    [self.lbReadCount setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbReadCount];
}

-(void)setViewDataWithTitle:(NSString *)title maxCount:(long)maxCount minCount:(long)minCount
{
    [self.lbTitle setText:title];
    
    [self.lbMaxCount setText:[NSString stringWithFormat:@"%ld", maxCount]];
    if (minCount > kNumberReadMaxCount) {
        minCount = kNumberReadMaxCount;
    }
    [self.lbReadCount setHidden:minCount==0];
    [self.lbReadCount setText:[NSString stringWithFormat:@"%ld", minCount]];
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbMaxCount);
    OBJC_RELEASE(_lbReadCount);
}

@end
