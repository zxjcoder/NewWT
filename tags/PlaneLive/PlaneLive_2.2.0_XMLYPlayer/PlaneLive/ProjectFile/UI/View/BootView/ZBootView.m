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

#define kBootImageCount 4

@interface ZBootView()<UIScrollViewDelegate>

@property (strong, nonatomic) ZScrollView *scrollView;

@property (strong, nonatomic) UIImageView *imgView1;
@property (strong, nonatomic) UIImageView *imgView2;
@property (strong, nonatomic) UIImageView *imgView3;
@property (strong, nonatomic) UIImageView *imgView4;

@property (strong, nonatomic) UIButton *btnStart;

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
    
    CGFloat iconWidth = 1536;
    CGFloat iconHeight = 2048;
    if (IsIPhoneDevice) {
        if (APP_FRAME_HEIGHT == 480) {
            iconWidth = 320;
            iconHeight = 480;
        } else {
            iconWidth = 414;
            iconHeight = 736;
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
    
    self.imgView4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.width*3, 0, self.scrollView.width, self.scrollView.height)];
    [self.imgView4 setImage:[SkinManager getImageWithName:[NSString stringWithFormat:@"%.fx%.f-4.png", iconWidth, iconHeight]]];
    [self.scrollView addSubview:self.imgView4];
    
    CGFloat space = APP_FRAME_WIDTH/320;
    CGFloat btnWidth = 120*space;
    CGFloat btnHeight = 40;
    CGFloat btnY = self.height- 85;
    if (IsIPadDevice) {
        btnY = self.height-120;
        btnHeight = 60;
    }
    CGFloat btnX = self.width*(kBootImageCount-1)+self.width/2-btnWidth/2;
    
    self.btnStart = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnStart setFrame:CGRectMake(btnX, btnY, btnWidth, btnHeight)];
    [self.btnStart setUserInteractionEnabled:YES];
    [self.btnStart setBackgroundColor:CLEARCOLOR];
    [self.btnStart addTarget:self action:@selector(btnStartClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scrollView addSubview:self.btnStart];
    [self.scrollView bringSubviewToFront:self.btnStart];
}

-(void)btnStartClick
{    
    if (self.onStartClick) {
        self.onStartClick();
    }
}

-(void)setViewNil
{
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_imgView1);
    OBJC_RELEASE(_imgView2);
    OBJC_RELEASE(_imgView3);
    OBJC_RELEASE(_imgView4);
    OBJC_RELEASE(_btnStart);
    [self removeFromSuperview];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
