//
//  ZUserFeedbackFooter.m
//  PlaneLive
//
//  Created by Daniel on 28/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserFeedbackFooter.h"

@interface ZUserFeedbackFooter()

@property (strong, nonatomic) UILabel *lbCount;

@property (strong, nonatomic) UILabel *lbDesc;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) UIButton *btnIcon;

@end

@implementation ZUserFeedbackFooter

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
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setFrame:CGRectMake(0, 0, self.width, kLineHeight)];
    [self addSubview:self.imgLine];
    
    CGFloat btnS = 40;
    CGFloat btnY = self.height-btnS;
    
    CGFloat lbW = 150;
    CGFloat lbY = 10;
    CGFloat lbH = 20;
    self.lbCount = [[UILabel alloc] initWithFrame:CGRectMake(kSizeSpace, lbY, lbW, lbH)];
    [self.lbCount setTextColor:BLACKCOLOR1];
    [self.lbCount setText:[NSString stringWithFormat:@"0/%d", kFeedbackContentMaxLength]];
    [self.lbCount setNumberOfLines:1];
    [self.lbCount setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbCount setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbCount setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self addSubview:self.lbCount];
    
    self.lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(self.width-lbW-kSize10-btnS, lbY, lbW, lbH)];
    [self.lbDesc setTextColor:DESCCOLOR];
    [self.lbDesc setText:kFeedbackYouCanAddThreePictures];
    [self.lbDesc setNumberOfLines:1];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbDesc setTextAlignment:(NSTextAlignmentRight)];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self addSubview:self.lbDesc];
    
    self.btnIcon = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnIcon setImage:[SkinManager getImageWithName:@"icon_tuku"] forState:(UIControlStateNormal)];
    [self.btnIcon setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnIcon addTarget:self action:@selector(btnIconClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnIcon setFrame:CGRectMake(self.width-btnS-kSize10, btnY, btnS, btnS)];
    [self addSubview:self.btnIcon];
}
-(void)btnIconClick
{
    if (self.onImageClick) {
        self.onImageClick();
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_lbCount);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_btnIcon);
    OBJC_RELEASE(_onImageClick);
}
///设置输入多少字
-(void)setChangeTextLength:(NSInteger)textLength
{
    [self.lbCount setText:[NSString stringWithFormat:@"%ld/%d", (long)textLength, kFeedbackContentMaxLength]];
    [self.lbCount setLabelColorWithRange:NSMakeRange(self.lbCount.text.length-4, 4) color:DESCCOLOR];
}
+(CGFloat)getViewH
{
    return 40;
}

@end
