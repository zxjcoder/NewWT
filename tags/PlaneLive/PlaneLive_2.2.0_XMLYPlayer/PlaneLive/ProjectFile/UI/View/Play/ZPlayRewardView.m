//
//  ZPlayRewardView.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/9.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZPlayRewardView.h"

@interface ZPlayRewardView()

///背景
@property (strong, nonatomic) UIView *viewBG;

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UILabel *lbOrganization;
@property (strong, nonatomic) UILabel *lbDesc;

@property (strong, nonatomic) UIView *viewButton;

@property (weak, nonatomic) UIButton *btnPrice;

@property (strong, nonatomic) UIButton *btnReward;

@property (strong, nonatomic) NSArray *arrayMain;
///内容坐标
@property (assign, nonatomic) CGRect contentFrame;
///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;

@end

@implementation ZPlayRewardView

///初始化
-(instancetype)initWithPlayTitle:(NSString *)title organization:(NSString *)organization
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInitWithTitle:title organization:organization];
    }
    return self;
}
-(void)innerInitWithTitle:(NSString *)title organization:(NSString *)organization
{
    [self getBgView];
    
    self.contentFrame = CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, 316);
    self.viewContent = [[UIView alloc] initWithFrame:self.contentFrame];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewContent];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.viewContent.width, 20)];
    [self.lbTitle setText:title];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Huge_Size]];
    [self.viewContent addSubview:self.lbTitle];
    
    self.lbOrganization = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lbTitle.y+self.lbTitle.height+5, self.viewContent.width, 20)];
    [self.lbOrganization setText:organization];
    [self.lbOrganization setTextColor:DESCCOLOR];
    [self.lbOrganization setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbOrganization setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbOrganization];
    
    self.viewButton = [[UIView alloc] initWithFrame:CGRectMake(0, self.lbOrganization.y+self.lbOrganization.height, self.viewContent.width, 155)];
    [self.viewContent addSubview:self.viewButton];
    
    [self addPriceButton];
    
    self.lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, self.viewButton.y+self.viewButton.height, self.viewContent.width, 20)];
    [self.lbDesc setText:kYourAppreciationIsTheGreatestMotivationForLecturers];
    [self.lbDesc setTextColor:DESCCOLOR];
    [self.lbDesc setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbDesc];
    
    self.btnReward = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnReward setTitle:kRewards forState:(UIControlStateNormal)];
    [self.btnReward setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnReward setBackgroundColor:MAINCOLOR];
    [self.btnReward setFrame:CGRectMake(25, self.lbDesc.y+self.lbDesc.height+15, self.viewContent.width-50, 45)];
    [self.btnReward.layer setMasksToBounds:YES];
    [self.btnReward setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
    [self.btnReward addTarget:self action:@selector(btnRewardClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnReward];
}
-(void)addPriceButton
{
    for (UIView *view in self.viewButton.subviews) {
        [view removeFromSuperview];
    }
    CGFloat btnW = 80;
    CGFloat btnH = 54;
    CGFloat btnX = (self.viewButton.width-270)/2;
    CGFloat btnSpace = 17;
    CGFloat btnY = 15;
    for (int i = 0; i < 6; i++) {
        UIButton *btnItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btnItem setTag:i];
        [[btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
        [btnItem setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        switch (i) {
            case 1:
            {
                [btnItem setFrame:CGRectMake(btnX+btnSpace+btnW, btnY, btnW, btnH)];
                [btnItem setBackgroundColor:RGBCOLOR(243, 243, 243)];
                [btnItem setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                [btnItem setTitle:[NSString stringWithFormat:@"5%@", kElement] forState:(UIControlStateNormal)];
                break;
            }
            case 2:
            {
                [btnItem setFrame:CGRectMake(btnX+btnSpace*2+btnW*2, btnY, btnW, btnH)];
                [btnItem setBackgroundColor:RGBCOLOR(243, 243, 243)];
                [btnItem setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                [btnItem setTitle:[NSString stringWithFormat:@"66%@", kElement] forState:(UIControlStateNormal)];
                break;
            }
            case 3:
            {
                [btnItem setFrame:CGRectMake(btnX, btnY+btnH+btnSpace, btnW, btnH)];
                [btnItem setBackgroundColor:RGBCOLOR(243, 243, 243)];
                [btnItem setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                [btnItem setTitle:[NSString stringWithFormat:@"88%@", kElement] forState:(UIControlStateNormal)];
                break;
            }
            case 4:
            {
                [btnItem setFrame:CGRectMake(btnX+btnSpace+btnW, btnY+btnH+btnSpace, btnW, btnH)];
                [btnItem setBackgroundColor:RGBCOLOR(243, 243, 243)];
                [btnItem setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                [btnItem setTitle:[NSString stringWithFormat:@"166%@", kElement] forState:(UIControlStateNormal)];
                break;
            }
            case 5:
            {
                [btnItem setFrame:CGRectMake(btnX+btnSpace*2+btnW*2, btnY+btnH+btnSpace, btnW, btnH)];
                [btnItem setBackgroundColor:RGBCOLOR(243, 243, 243)];
                [btnItem setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
                [btnItem setTitle:[NSString stringWithFormat:@"188%@", kElement] forState:(UIControlStateNormal)];
                break;
            }
            default:
                [btnItem setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
                [btnItem setBackgroundColor:MAINCOLOR];
                [btnItem setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
                [btnItem setTitle:[NSString stringWithFormat:@"2%@", kElement] forState:(UIControlStateNormal)];
                self.btnPrice = btnItem;
                break;
        }
        [self.viewButton addSubview:btnItem];
    }
}
-(void)btnItemClick:(UIButton *)sender
{
    for (UIButton *btnItem in self.viewButton.subviews) {
        [btnItem setBackgroundColor:RGBCOLOR(243, 243, 243)];
        [btnItem setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    }
    [sender setBackgroundColor:MAINCOLOR];
    [sender setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    self.btnPrice = sender;
}
///设置数据源
-(void)setPlayDataWithPriceArray:(NSArray *)priceArray
{
    [self setArrayMain:priceArray];
    
    [self addPriceButton];
}
-(void)btnRewardClick
{
    if (self.btnPrice) {
        NSString *price = @"2";
        switch (self.btnPrice.tag) {
            case 1: price = @"5"; break;
            case 2: price = @"66"; break;
            case 3: price = @"88"; break;
            case 4: price = @"168"; break;
            case 5: price = @"188"; break;
            default: price = @"2"; break;
        }
        if (self.onRewardPriceClick) {
            self.onRewardPriceClick(price);
        }
        [self dismiss];
    }
}
-(void)getBgView
{
    self.viewBG = [[UIView alloc] initWithFrame:self.bounds];
    [self.viewBG setBackgroundColor:BLACKCOLOR];
    [self.viewBG setAlpha:0.4f];
    [self addSubview:self.viewBG];
    
    UITapGestureRecognizer *viewBGTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTap:)];
    [self.viewBG addGestureRecognizer:viewBGTap];
}
-(void)viewBGTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}
-(void)setViewNil
{
    for (UIView *view in self.viewButton.subviews) {
        [view removeFromSuperview];
    }
    OBJC_RELEASE(_arrayMain);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbOrganization);
    OBJC_RELEASE(_btnReward);
    OBJC_RELEASE(_viewButton);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_onRewardPriceClick);
}
///显示
-(void)show
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [self.viewBG setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        CGRect cFrame = self.contentFrame;
        cFrame.origin.y = cFrame.origin.y-cFrame.size.height;
        [self.viewBG setAlpha:0.4f];
        [self.viewContent setFrame:cFrame];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
    }];
}
///隐藏
-(void)dismiss
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.viewBG setAlpha:0];
        [self.viewContent setFrame:CGRectMake(0, self.viewBG.height, self.viewContent.width, self.viewContent.height)];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
        [self setViewNil];
        [self removeFromSuperview];
    }];
}

@end
