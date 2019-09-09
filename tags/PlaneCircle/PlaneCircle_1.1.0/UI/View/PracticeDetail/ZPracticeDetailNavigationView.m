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

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) UILabel *lbTitleBack;

@property (strong, nonatomic) UIButton *btnBack;

@property (strong, nonatomic) UIButton *btnMore;

@property (assign, nonatomic) CGFloat newTitleWidth;

@property (assign, nonatomic) CGRect title1Frame;
@property (assign, nonatomic) CGRect title2Frame;

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

-(id)initWithScrollFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitScroll];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:CLEARCOLOR];
    
    self.viewBG = [[UIView alloc] init];
    [self.viewBG setBackgroundColor:MAINCOLOR];
    [self.viewBG setAlpha:0];
    [self addSubview:self.viewBG];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kFont_Max_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbTitle];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBack setImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [self.btnBack setImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateHighlighted];
    [self.btnBack setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 0, 10))];
    [self.btnBack setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBack setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btnBack setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self addSubview:self.btnBack];
    
    self.btnMore = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMore setUserInteractionEnabled:YES];
    [self.btnMore setImage:[SkinManager getImageWithName:@"btn_more"] forState:(UIControlStateNormal)];
    [self.btnMore setImage:[SkinManager getImageWithName:@"btn_more"] forState:(UIControlStateHighlighted)];
    [self.btnMore setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 0, 10))];
    [self.btnMore setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnMore setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.btnMore setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self addSubview:self.btnMore];
    
    [self setViewFrame];
    
    [self sendSubviewToBack:self.viewBG];
}

-(void)setViewFrame
{
    [self.viewBG setFrame:self.bounds];
    [self.lbTitle setFrame:CGRectMake(60, 30, self.width-120, 25)];
    [self.btnBack setFrame:CGRectMake(0, 10, 60, 54)];
    [self.btnMore setFrame:CGRectMake(self.width-60, 10, 60, 55)];
}

-(void)innerInitScroll
{
    [self setBackgroundColor:CLEARCOLOR];
    
    self.viewBG = [[UIView alloc] initWithFrame:self.bounds];
    [self.viewBG setBackgroundColor:MAINCOLOR];
    [self.viewBG setAlpha:0];
    [self addSubview:self.viewBG];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(60, 30, self.width-120, 25)];
    [self.scrollView setBounces:NO];
    [self.scrollView setPagingEnabled:NO];
    [self.scrollView setUserInteractionEnabled:NO];
    [self.scrollView setBackgroundColor:MAINCOLOR];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setScrollEnabled:NO];
    [self addSubview:self.scrollView];
    
    self.btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnBack setImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [self.btnBack setImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateHighlighted];
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
    [self.btnMore setImage:[SkinManager getImageWithName:@"btn_more"] forState:(UIControlStateHighlighted)];
    [self.btnMore setFrame:CGRectMake(self.width-60, 10, 60, 55)];
    [self.btnMore setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 0, 10))];
    [self.btnMore setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnMore setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.btnMore setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self addSubview:self.btnMore];
    
    [self sendSubviewToBack:self.viewBG];
}

-(void)createTitleLable
{
    OBJC_RELEASE(_lbTitle);
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setFont:[UIFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setFrame:self.scrollView.bounds];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.scrollView addSubview:self.lbTitle];
}

-(void)createTitleBackLable
{
    OBJC_RELEASE(_lbTitleBack);
    self.lbTitleBack = [[UILabel alloc] init];
    [self.lbTitleBack setFont:[UIFont boldSystemFontOfSize:kFont_Default_Size]];
    [self.lbTitleBack setFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
    [self.lbTitleBack setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitleBack setTextColor:WHITECOLOR];
    [self.lbTitleBack setNumberOfLines:1];
    [self.lbTitleBack setUserInteractionEnabled:NO];
    [self.lbTitleBack setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.scrollView addSubview:self.lbTitleBack];
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
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view.layer removeAllAnimations];
            [view removeFromSuperview];
        }
    }
    [self createTitleLable];
    [self createTitleBackLable];
    
    [self.lbTitle setText:title];
    [self.lbTitleBack setText:title];
    
    CGFloat newTitleW = [self.lbTitle getLabelWidthWithMinWidth:self.scrollView.width];
    self.newTitleWidth = newTitleW;
    if (newTitleW > self.scrollView.width) {
        newTitleW = newTitleW + 15;
        
        self.newTitleWidth = newTitleW;
        
        [self.lbTitle setFrame:CGRectMake(0, 0, newTitleW, self.lbTitle.height)];
        [self.lbTitleBack setFrame:CGRectMake(newTitleW, 0, newTitleW, self.lbTitle.height)];
        
        [self setStartScrollTitle];
    }
}

-(void)setViewBGAlpha:(CGFloat)alpha
{
    [self.viewBG setAlpha:alpha];
}

-(void)setHiddenMore:(BOOL)isHidden
{
    [self.btnMore setHidden:isHidden];
}

-(void)setStartScrollTitle
{
    CGFloat offset = self.newTitleWidth;
    __weak typeof(self) weakSelf = self;
    ///动画速度
    CGFloat duration = 6.0*(self.newTitleWidth/self.scrollView.width);
    [UIView animateWithDuration:duration
                          delay:0.5
                        options: UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear
                     animations:^{
                         weakSelf.lbTitle.transform = CGAffineTransformMakeTranslation(-offset, 0);
                         weakSelf.lbTitleBack.transform = CGAffineTransformMakeTranslation(-offset, 0);
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

-(void)setStopScroll
{
    [self.lbTitle.layer removeAllAnimations];
    [self.lbTitleBack.layer removeAllAnimations];
}

-(void)dealloc
{
    [self.lbTitle.layer removeAllAnimations];
    [self.lbTitleBack.layer removeAllAnimations];
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbTitleBack);
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_btnBack);
    OBJC_RELEASE(_btnMore);
}

@end
