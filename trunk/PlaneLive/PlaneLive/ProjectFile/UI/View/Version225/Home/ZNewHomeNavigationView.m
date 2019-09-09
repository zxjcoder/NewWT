//
//  ZNewHomeNavigationView.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewHomeNavigationView.h"
#import "ZButton.h"
#import "ZView.h"
#import "ZLabel.h"
#import "ZImageView.h"

@interface ZNewHomeNavigationView()

@property (strong, nonatomic) ZView *viewBackground;
@property (strong, nonatomic) ZButton *btnSearch;
@property (strong, nonatomic) ZLabel *lbSearch;
@property (strong, nonatomic) ZImageView *imageSearch;
@property (strong, nonatomic) ZView *viewDownload;
@property (strong, nonatomic) ZButton *btnDownload;

@end

@implementation ZNewHomeNavigationView

-(id)init
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, [ZNewHomeNavigationView getH]))];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.backgroundColor = CLEARCOLOR;
    
    CGFloat space = 20;
    CGFloat btnSize = 44;
    CGFloat btnX = self.width-btnSize-space;
    CGFloat contentW = btnX-15;
    if (!self.viewBackground) {
        self.viewBackground = [[UIView alloc] initWithFrame:(CGRectMake(5, 6, contentW, 32))];
        [self.viewBackground setBackgroundColor:RGBCOLORA(209, 216, 223, 0.4)];
        [self.viewBackground setUserInteractionEnabled:false];
        [self.viewBackground setViewRound:8];
        [self addSubview:self.viewBackground];
        
        self.btnSearch = [[ZButton alloc] initWithFrame:(self.viewBackground.frame)];
        [self.btnSearch setBackgroundColor:CLEARCOLOR];
        [self.btnSearch setUserInteractionEnabled:true];
        [self.btnSearch addTarget:self action:@selector(btnSearchEvent) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnSearch];
        
        CGFloat imageSize = 24;
        self.imageSearch = [[ZImageView alloc] initWithFrame:(CGRectMake(10, self.btnSearch.height/2-imageSize/2, imageSize, imageSize))];
        [self.imageSearch setImageName:@"search"];
        [self.imageSearch setUserInteractionEnabled:false];
        [self.btnSearch addSubview:self.imageSearch];
        
        self.lbSearch = [[ZLabel alloc] initWithFrame:(CGRectMake(self.imageSearch.x+self.imageSearch.width+5, self.btnSearch.height/2-11, 180, 22))];
        [self.lbSearch setText:@"搜索微课、系列课"];
        [self.lbSearch setTextColor:COLORTEXT3];
        [self.lbSearch setUserInteractionEnabled:false];
        [self.lbSearch setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnSearch addSubview:self.lbSearch];
        
        [self sendSubviewToBack:self.viewBackground];
        
        self.btnDownload = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnDownload setFrame:CGRectMake(btnX, self.height/2-btnSize/2, btnSize, btnSize)];
        [self.btnDownload setBackgroundColor:CLEARCOLOR];
        [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateNormal)];
        [self.btnDownload setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [self.btnDownload addTarget:self action:@selector(btnDownloadEvent) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnDownload];
        
//        CGFloat viewDownloadSize = 32;
//        self.viewDownload = [[ZView alloc] initWithFrame:(CGRectMake(btnX+btnSize/2-viewDownloadSize/2, self.height/2-btnSize/2+btnSize/2-viewDownloadSize/2, viewDownloadSize, viewDownloadSize))];
//        [self.viewDownload setBackgroundColor:self.viewBackground.backgroundColor];
//        [self.viewDownload setViewRoundNoBorder];
//        [self addSubview:self.viewDownload];
    }
//    [self sendSubviewToBack:self.viewDownload];
}
-(void)btnSearchEvent
{
    if (self.onSearchClick) {
        self.onSearchClick();
    }
}
-(void)btnDownloadEvent
{
    if (self.onDownloadClick) {
        self.onDownloadClick();
    }
}
-(void)setViewBackAlpha:(CGFloat)alpha
{
//    if (alpha >= 0.5) {
//        [self.viewDownload setBackgroundColor:COLORVIEWBACKCOLOR3];
//        [self.viewBackground setBackgroundColor:COLORVIEWBACKCOLOR3];
//        [self.lbSearch setTextColor:COLORTEXT3];
//        [self.viewDownload setAlpha:1];
//        [self.viewBackground setAlpha:1];
//        [self.lbSearch setAlpha:1];
//        [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault) animated:false];
//    } else {
//        [self.viewDownload setBackgroundColor:COLORVIEWBACKCOLOR1];
//        [self.viewBackground setBackgroundColor:COLORVIEWBACKCOLOR1];
//        [self.lbSearch setTextColor:WHITECOLOR];
//        [self.lbSearch setAlpha:0.5];
//        [self.viewDownload setAlpha:0.3];
//        [self.viewBackground setAlpha:0.3];
//        [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:false];
//    }
}
+(CGFloat)getH
{
    return 45;
}

@end
