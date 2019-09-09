//
//  ZPracticeDetailNavigationView.m
//  PlaneCircle
//
//  Created by Daniel on 6/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailNavigationView.h"

@interface ZPracticeDetailNavigationView()

@property (strong, nonatomic) UIView *viewBG;

//@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UIButton *btnBack;

@property (strong, nonatomic) UIButton *btnMore;

@end

@implementation ZPracticeDetailNavigationView


-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

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
    [self setBackgroundColor:CLEARCOLOR];
    
    self.viewBG = [[UIView alloc] initWithFrame:self.bounds];
    [self.viewBG setBackgroundColor:MAINCOLOR];
    [self.viewBG setAlpha:0];
    [self addSubview:self.viewBG];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, self.width-120, 25)];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbTitle];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBack setImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [self.btnBack setFrame:CGRectMake(0, 10, 60, 54)];
    [self.btnBack setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 0, 10))];
    [self.btnBack setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btnBack setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self addSubview:self.btnBack];
    
    self.btnMore = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMore setUserInteractionEnabled:YES];
    [self.btnMore setImage:[SkinManager getImageWithName:@"btn_more"] forState:(UIControlStateNormal)];
    [self.btnMore setFrame:CGRectMake(self.width-60, 10, 60, 55)];
    [self.btnMore setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 0, 10))];
    [self.btnMore setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnMore setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.btnMore setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.btnMore setTitle:nil forState:(UIControlStateNormal)];
    [self addSubview:self.btnMore];
    
    [self sendSubviewToBack:self.viewBG];
}

-(void)btnBackClick:(UIButton *)sender
{
    if (self.onBackClick) {
        self.onBackClick();
    }
}

-(void)btnMoreClick:(UIButton *)sender
{
    if (self.onMoreClick) {
        self.onMoreClick();
    }
}

-(void)setViewTitle:(NSString *)title
{
    [self.lbTitle setText:title];
}

-(void)setViewFrame
{
    [self.viewBG setFrame:self.bounds];
    [self.lbTitle setFrame:CGRectMake(60, 30, self.width-120, 25)];
    [self.btnBack setFrame:CGRectMake(0, 10, 60, 54)];
    [self.btnMore setFrame:CGRectMake(self.width-60, 10, 60, 55)];
}

-(void)setViewBGAlpha:(CGFloat)alpha
{
    [self.viewBG setAlpha:alpha];
}

-(void)setHiddenMore:(BOOL)isHidden
{
    [self.btnMore setHidden:isHidden];
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_btnBack);
    OBJC_RELEASE(_btnMore);
}

@end
