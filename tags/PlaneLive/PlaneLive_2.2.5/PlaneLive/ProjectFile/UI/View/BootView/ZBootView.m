//
//  ZBootView.m
//  PlaneLive
//
//  Created by Daniel on 14/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBootView.h"
#import "SQLiteOper.h"
#import "ZScrollView.h"

#define kBootImageCount 3

@interface ZBootView()<UIScrollViewDelegate>

@property (strong, nonatomic) ZScrollView *scrollView;

@property (strong, nonatomic) UIImageView *imgView1;
@property (strong, nonatomic) UIImageView *imgView2;
@property (strong, nonatomic) UIImageView *imgView3;
//@property (strong, nonatomic) UIImageView *imgView4;

@property (strong, nonatomic) UIButton *btnStart;
@property (strong, nonatomic) UIButton *btnSkip;

@end

@implementation ZBootView

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInit];
    }
    return self;
}

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
    if (!self.scrollView) {
        self.scrollView = [[ZScrollView alloc] initWithFrame:self.bounds];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setBounces:NO];
        [self.scrollView setDelegate:self];
        [self.scrollView setBackgroundColor:CLEARCOLOR];
        [self.scrollView setContentSize:CGSizeMake(APP_FRAME_WIDTH*kBootImageCount, self.height)];
        [self.scrollView setUserInteractionEnabled:YES];
        [self addSubview:self.scrollView];
        
        CGFloat iconWidth = 640;
        CGFloat iconHeight = 960;
        if (IsIPadDevice) {
            iconWidth = 1536;
            iconHeight = 2028;
        } else {
            if (APP_FRAME_HEIGHT >= 480 && APP_FRAME_HEIGHT < 812) {
                iconWidth = 1242;
                iconHeight = 2208;
            } else if (APP_FRAME_HEIGHT >= 812) {
                iconWidth = 1125;
                iconHeight = 2436;
            } else {
                iconWidth = 640;
                iconHeight = 960;
            }
        }
        self.imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        [self.imgView1 setImage:[SkinManager getImageWithName:[NSString stringWithFormat:@"%.fx%.f-1.png", iconWidth, iconHeight]]];
        [self.scrollView addSubview:self.imgView1];
        
        self.imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
        [self.imgView2 setImage:[SkinManager getImageWithName:[NSString stringWithFormat:@"%.fx%.f-2.png", iconWidth, iconHeight]]];
        [self.scrollView addSubview:self.imgView2];
        
        self.imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.width*2, 0, self.scrollView.width, self.scrollView.height)];
        [self.imgView3 setImage:[SkinManager getImageWithName:[NSString stringWithFormat:@"%.fx%.f-3.png", iconWidth, iconHeight]]];
        [self.scrollView addSubview:self.imgView3];
        
//        self.imgView4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.width*3, 0, self.scrollView.width, self.scrollView.height)];
//        [self.imgView4 setImage:[SkinManager getImageWithName:[NSString stringWithFormat:@"%.fx%.f-4.png", iconWidth, iconHeight]]];
//        [self.scrollView addSubview:self.imgView4];
        
        CGFloat space = APP_FRAME_WIDTH/320;
        CGFloat btnWidth = 125;
        CGFloat btnHeight = 40;
        CGFloat btnY = self.height- 105*kViewSace;
        if (IsIPadDevice) {
            btnY = self.height-150;
            btnWidth = 150;
        }
        CGFloat btnX = self.width*(kBootImageCount-1)+self.width/2-btnWidth/2;
        
        self.btnStart = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnStart setTitle:@"立即体验" forState:(UIControlStateNormal)];
        [self.btnStart setTitle:@"立即体验" forState:(UIControlStateHighlighted)];
        [self.btnStart setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
        [self.btnStart setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1"] forState:(UIControlStateNormal)];
        [self.btnStart setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1_c"] forState:(UIControlStateHighlighted)];
        [[self.btnStart titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnStart setFrame:CGRectMake(btnX, btnY, btnWidth, btnHeight)];
        [[self.btnStart layer] setMasksToBounds:true];
        [self.btnStart setViewRound:btnHeight/2 borderWidth:0 borderColor:CLEARCOLOR];
        [self.btnStart setUserInteractionEnabled:YES];
        [self.btnStart addTarget:self action:@selector(btnStartClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.scrollView addSubview:self.btnStart];
        [self.scrollView bringSubviewToFront:self.btnStart];
        
        self.btnSkip = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnSkip setImage:[SkinManager getImageWithName:@"skip"] forState:(UIControlStateNormal)];
        [self.btnSkip setImage:[SkinManager getImageWithName:@"skip"] forState:(UIControlStateHighlighted)];
        [self.btnSkip setFrame:CGRectMake(self.width-50, APP_STATUS_HEIGHT+10, 50, 32)];
        [self.btnSkip setUserInteractionEnabled:YES];
        [self.btnSkip addTarget:self action:@selector(btnSkipClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnSkip];
        [self bringSubviewToFront:self.btnSkip];
    }
}
-(void)btnSkipClick
{
    if (self.onSkipClick) {
        self.onSkipClick();
    }
    [self dissmiss];
}
-(void)btnStartClick
{
    if (self.onStartClick) {
        self.onStartClick();
    }
    [self dissmiss];
}
-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.alpha = 1;
}
-(void)dissmiss
{
    self.alpha = 1;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)setViewNil
{
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_imgView1);
    OBJC_RELEASE(_imgView2);
    OBJC_RELEASE(_imgView3);
    OBJC_RELEASE(_btnStart);
    [self removeFromSuperview];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
