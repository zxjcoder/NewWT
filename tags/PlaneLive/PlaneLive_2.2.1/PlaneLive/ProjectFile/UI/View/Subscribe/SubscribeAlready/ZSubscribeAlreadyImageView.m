//
//  ZSubscribeAlreadyImageView.m
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeAlreadyImageView.h"
#import "ZLabel.h"
#import "ZImageView.h"
#import "ZButton.h"

#define kShowButtonHeight 40

@interface ZSubscribeAlreadyImageView()

/// 标题
@property (strong, nonatomic) ZLabel *lbTitle;
/// 图片
@property (strong, nonatomic) ZImageView *imgBack;
/// 阴影
@property (strong, nonatomic) ZImageView *imgShadow;
/// 显示详情
@property (strong, nonatomic) ZButton *btnShow;

@end

@implementation ZSubscribeAlreadyImageView

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_WIDTH*0.69)];
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
    CGFloat lbH = 20;
    self.imgBack = [[ZImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imgBack];
    
    self.imgShadow = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"subscribe_rss_background"]];
    [self.imgShadow setFrame:self.bounds];
    [self addSubview:self.imgShadow];
    
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace, self.height-lbH-kSize5, self.width-kSizeSpace*2, lbH)];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.imgShadow addSubview:self.lbTitle];
    
    CGFloat btnSize = kShowButtonHeight;
    self.btnShow = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnShow setImage:[SkinManager getImageWithName:@"subscribe_spread"] forState:(UIControlStateNormal)];
    [self.btnShow setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnShow setFrame:CGRectMake(self.width-btnSize, self.height-btnSize, btnSize, btnSize)];
    [self.btnShow setTag:1];
    [self.btnShow setHidden:YES];
    [self.btnShow setUserInteractionEnabled:YES];
    [self.btnShow addTarget:self action:@selector(btnShowClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnShow];
    
    [self sendSubviewToBack:self.imgBack];
    [self bringSubviewToFront:self.btnShow];
    
    [self setViewFrame];
}
-(void)btnShowClick
{
    if (self.onShowSubscribeDetail) {
        self.onShowSubscribeDetail(YES);
    }
}
-(void)setViewFrame
{
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:20];
    CGRect titleFrame = self.lbTitle.frame;
    titleFrame.size.height = titleH;
    titleFrame.origin.y = self.height-titleH-kSize5;
    [self.lbTitle setFrame:titleFrame];
}
/// 设置图片坐标
-(void)setViewImageFrame:(CGRect)frame
{
    [self.imgBack setFrame:frame];
}
/// 获取图片坐标
-(CGRect)getViewImageFrame
{
    return self.imgBack.frame;
}
///设置数据源
-(void)setViewDataWithModel:(ModelCurriculum *)model
{
    if (model) {
        [self.imgBack setImageURLStr:model.course_picture placeImage:[SkinManager getMaxImage]];
        
        [self.lbTitle setText:model.title];
    } else {
        [self.imgBack setImage:[SkinManager getMaxImage]];
        
        [self.lbTitle setText:kEmpty];
    }
    
    [self setViewFrame];
}
///显示详情按钮
-(void)setShowDetailButton
{
    [self.btnShow setHidden:NO];
    [self.btnShow setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.btnShow setAlpha:1];
        [self.lbTitle setFrame:CGRectMake(self.lbTitle.x, self.lbTitle.y, self.width-kSizeSpace-kShowButtonHeight+2, self.lbTitle.height)];
        [self setViewFrame];
    } completion:nil];
}
///隐藏详情按钮
-(void)setDismissDetailButton
{
    [self.btnShow setHidden:NO];
    [self.btnShow setAlpha:1];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.btnShow setAlpha:0];
        [self.lbTitle setFrame:CGRectMake(self.lbTitle.x, self.lbTitle.y, self.width-self.lbTitle.x*2, self.lbTitle.height)];
        [self setViewFrame];
    } completion:^(BOOL finished) {
        [self.btnShow setHidden:YES];
    }];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgBack);
    OBJC_RELEASE(_imgShadow);
}

-(void)dealloc
{
    [self setViewNil];
}


@end
