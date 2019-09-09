//
//  ZLawFirmDetailFooterView.m
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmDetailFooterView.h"

@interface ZLawFirmDetailFooterView()

@property (strong, nonatomic) UIButton *btnMore;
///分割线
@property (strong, nonatomic) UIImageView *imgLine;

@end

@implementation ZLawFirmDetailFooterView

-(id)initWithFrame:(CGRect)frame
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
    [self setBackgroundColor:WHITECOLOR];
    CGFloat btnW = 100;
    CGFloat btnH = 35;
    self.btnMore = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMore setFrame:CGRectMake(self.width/2-btnW/2, self.height/2-btnH/2, btnW, btnH)];
    [self.btnMore setTitle:[NSString stringWithFormat:@"%@ 》", kSayMore] forState:(UIControlStateNormal)];
    [self.btnMore setTitle:[NSString stringWithFormat:@"%@ 》", kSayMore] forState:(UIControlStateHighlighted)];
    [self.btnMore setTitleColor:DESCCOLOR forState:(UIControlStateNormal)];
    [[self.btnMore titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnMore addTarget:self action:@selector(btnMoreClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnMore];
    
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setFrame:CGRectMake(0, self.height-kLineHeight, self.width, kLineHeight)];
    [self addSubview:self.imgLine];
}
-(void)btnMoreClick
{
    if (self.onAllClick) {
        self.onAllClick();
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_btnMore);
}

@end
