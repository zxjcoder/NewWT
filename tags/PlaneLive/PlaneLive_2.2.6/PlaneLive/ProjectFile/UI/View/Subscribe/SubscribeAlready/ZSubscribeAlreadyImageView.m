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
#import "ZCalculateLabel.h"

#define kShowButtonHeight 40

@interface ZSubscribeAlreadyImageView()

@property (strong, nonatomic) ZView *viewContent;
/// 标题
@property (strong, nonatomic) ZLabel *lbTitle;
/// 图片
@property (strong, nonatomic) ZImageView *imgIcon;
/// 背景图片
@property (strong, nonatomic) ZImageView *imgBackground;
/// 显示详情
@property (strong, nonatomic) ZButton *btnShow;
///间隔
@property (assign, nonatomic) CGFloat space;
@property (assign, nonatomic) CGFloat lbH;

@end

@implementation ZSubscribeAlreadyImageView

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZSubscribeAlreadyImageView getH])];
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
    self.lbH = 20;
    self.space = 20;
    [self setClipsToBounds:true];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewContent = [[ZView alloc] initWithFrame:self.bounds];
    [self addSubview:self.viewContent];
    
    self.imgIcon = [[ZImageView alloc] init];
    [[self.imgIcon layer] setMasksToBounds:true];
    [self.imgIcon setViewRound:8 borderWidth:1 borderColor:RGBCOLORA(255, 255, 255, 0.1)];
    [self addSubview:self.imgIcon];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setUserInteractionEnabled:false];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Huge_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
    [self.viewContent addSubview:self.lbTitle];
    
    self.imgBackground = [[ZImageView alloc] initWithFrame:self.bounds];
    [self.imgBackground setCenter:self.center];
    [self.imgBackground setContentMode:(UIViewContentModeScaleToFill)];
    // 创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 毛玻璃视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.imgBackground.bounds;
    effectView.center = self.imgBackground.center;
    [effectView setTag:1001];
    UIView *imgViewBG = [[UIView alloc] initWithFrame:self.imgBackground.bounds];
    [imgViewBG setAlpha:0.7];
    [imgViewBG setTag:1002];
    [imgViewBG setFrame:effectView.bounds];
    
    [self.imgBackground addSubview:effectView];
    [self.imgBackground addSubview:imgViewBG];
    [self.imgBackground bringSubviewToFront:effectView];
    [self.imgBackground bringSubviewToFront:imgViewBG];
    [self addSubview:self.imgBackground];
    
    CGFloat btnSize = kShowButtonHeight;
    self.btnShow = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnShow setImage:[SkinManager getImageWithName:@"arrow_down"] forState:(UIControlStateNormal)];
    [self.btnShow setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
    [self.btnShow setFrame:CGRectMake(self.width-btnSize-5, self.height-btnSize-5, btnSize, btnSize)];
    [self.btnShow setTag:1];
    [self.btnShow setHidden:YES];
    [self.btnShow setUserInteractionEnabled:YES];
    [self.btnShow addTarget:self action:@selector(btnShowClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnShow];
    
    [self sendSubviewToBack:self.imgBackground];
    [self bringSubviewToFront:self.viewContent];
}

-(void)setViewFrame
{
    CGFloat iconSize = 96;
    CGFloat iconX = self.width/2-iconSize/2;
    CGFloat iconY = 48;
    [self.imgIcon setFrame:(CGRectMake(iconX, iconY, iconSize, iconSize))];
    
    CGFloat titleW = self.width-self.space*2;
    CGRect titleFrame = CGRectMake(self.space, self.imgIcon.y+self.imgIcon.height+20, titleW, self.lbH);
    self.lbTitle.frame = titleFrame;
    titleFrame.size.height = [self.lbTitle getLabelHeightWithMinHeight:self.lbH];
    self.lbTitle.frame = titleFrame;
    
    self.height = self.lbTitle.y+self.lbTitle.height+15;
    [self.viewContent setFrame:(CGRectMake(0, 0, self.width, self.height))];
    
    CGFloat btnSize = kShowButtonHeight;
    [self.btnShow setFrame:CGRectMake(self.width-btnSize-5, self.height-btnSize-5, btnSize, btnSize)];
    
    [self.imgBackground setFrame:self.bounds];
    [self.imgBackground setCenter:self.center];
    [[self.imgBackground viewWithTag:1001] setFrame:self.imgBackground.bounds];
    [[self.imgBackground viewWithTag:1001] setCenter:self.imgBackground.center];
    [[self.imgBackground viewWithTag:1002] setFrame:self.imgBackground.bounds];
    [[self.imgBackground viewWithTag:1002] setBackgroundColor:COLORVIEWBACKCOLOR1];
}
///设置数据源
-(CGFloat)setViewDataWithModel:(ModelCurriculum *)model
{
    [self.lbTitle setText:model.title];
    [self.imgBackground setImageURLStr:model.course_picture placeImage:[SkinManager getImageWithName:@"play_background_default"]];
    [self.imgIcon setImageURLStr:model.illustration placeImage:[SkinManager getDefaultImage]];
    
    [self setViewFrame];
    
    return self.height;
}

+(CGFloat)getH
{
    return 200;
}
-(void)btnShowClick
{
    if (self.onShowSubscribeDetail) {
        self.onShowSubscribeDetail(YES);
    }
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

@end
