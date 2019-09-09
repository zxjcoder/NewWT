//
//  ZAlertRewardView.m
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertRewardView.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "ZShadowButtonView.h"

@interface ZAlertRewardView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZLabel *lbName;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZView *viewButton;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *arrayMain;
@property (weak, nonatomic) ZButton *btnPrice;

@end

@implementation ZAlertRewardView

-(id)init
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(instancetype)initWithPlayTitle:(NSString *)title organization:(NSString *)organization
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        self.name = title;
        self.title = organization;
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.contentH = 360;
    
    self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR5];
    [self.viewBack setAlpha:kBackgroundOpacity];
    [self addSubview:self.viewBack];
    
    self.contentFrame = CGRectMake(10, self.height, self.width-20, self.contentH);
    self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
    [[self.viewContent layer] setMasksToBounds:true];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    [self sendSubviewToBack:self.viewBack];
    
    CGRect nameFrame = CGRectMake(20, 16, self.viewContent.width-40, 20);
    self.lbName = [[ZLabel alloc] initWithFrame:(nameFrame)];
    [self.lbName setText:self.name];
    [self.lbName setNumberOfLines:1];
    [self.lbName setTextColor:COLORTEXT1];
    [self.lbName setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbName setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
    [self.viewContent addSubview:self.lbName];
    
    CGRect titleFrame = CGRectMake(20, self.lbName.y+self.lbName.height+5, self.viewContent.width-40, 18);
    self.lbTitle = [[ZLabel alloc] initWithFrame:(titleFrame)];
    [self.lbTitle setText:self.title];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setTextColor:COLORTEXT3];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbTitle];
    
    self.viewButton = [[ZView alloc] initWithFrame:(CGRectMake(42, self.lbTitle.y+self.lbTitle.height+16, self.viewContent.width-84, 135))];
    [self.viewContent addSubview:self.viewButton];
    
    [self addPriceButton];
    
    CGFloat btnRewardW = 100;
    CGFloat btnRewardH = 36;
    ZShadowButtonView *viewReward = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(self.viewContent.width/2-btnRewardW/2, self.viewButton.y+self.viewButton.height+20, btnRewardW, btnRewardH))];
    [viewReward setButtonTitle:@"打赏"];
    [viewReward setButtonBGImage:@"btn_gra2"];
    ZWEAKSELF
    [viewReward setOnButtonClick:^{
        [weakSelf btnRewardClick];
    }];
    [self.viewContent addSubview:viewReward];
    
//    UIView *viewReward = [[UIView alloc] initWithFrame:CGRectMake(self.viewContent.width/2-btnRewardW/2, self.viewButton.y+self.viewButton.height+20, btnRewardW, btnRewardH)];
//    [viewReward.layer setShadowColor:RGBCOLORA(249, 152, 118, 0.2).CGColor];
//    [viewReward.layer setShadowOffset:(CGSizeMake(0, 10))];
//    [viewReward.layer setShadowRadius:10];
//    [viewReward.layer setShadowOpacity:0.2];
//    [viewReward.layer setCornerRadius:btnRewardH/2];
//    [self.viewContent addSubview:viewReward];
//
//    ZButton *btnReward = [ZButton buttonWithType:(UIButtonTypeCustom)];
//    [btnReward setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2"] forState:(UIControlStateNormal)];
//    [btnReward setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2_c"] forState:(UIControlStateHighlighted)];
//    [btnReward addTarget:self action:@selector(btnRewardClick) forControlEvents:(UIControlEventTouchUpInside)];
//    [btnReward setTitle:kRewards forState:(UIControlStateNormal)];
//    [btnReward setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
//    [[btnReward titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
//    [btnReward setFrame:viewReward.bounds];
//    [[btnReward layer] setMasksToBounds:true];
//    [btnReward setViewRound:btnRewardH/2 borderWidth:0 borderColor:CLEARCOLOR];
//    [viewReward addSubview:btnReward];
    
    ZLabel *lbDesc = [[ZLabel alloc] initWithFrame:(CGRectMake(0, viewReward.y+viewReward.height+10, self.viewContent.width, 20))];
    [lbDesc setTextColor:COLORTEXT3];
    [lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [lbDesc setTextAlignment:(NSTextAlignmentCenter)];
    [lbDesc setText:kYourAppreciationIsTheGreatestMotivationForLecturers];
    [self.viewContent addSubview:lbDesc];
    
    CGFloat btnCloseH = 46;
    UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnClose setTitle:kCancel forState:(UIControlStateNormal)];
    [btnClose setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [[btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    btnClose.userInteractionEnabled = true;
    btnClose.backgroundColor = CLEARCOLOR;
    btnClose.frame = CGRectMake(0, lbDesc.y+lbDesc.height+15, self.viewContent.width, btnCloseH);
    [self.viewContent addSubview:btnClose];
    
    UIImageView *imageLine = [UIImageView getDLineView];
    imageLine.frame = CGRectMake(0, btnClose.y, self.viewContent.width, kLineHeight);
    [self.viewContent addSubview:imageLine];
    
    //点击背景隐藏视图
    UITapGestureRecognizer *viewBGTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTapGesture:)];
    [self.viewBack addGestureRecognizer:viewBGTapGesture];
}
-(void)addPriceButton
{
    for (UIView *view in self.viewButton.subviews) {
        [view removeFromSuperview];
    }
    CGFloat btnW = 60;
    CGFloat btnH = 60;
    CGFloat btnSpace = (self.viewButton.width-btnW*3)/2;
    CGFloat btnY = 15;
    NSInteger itemCount = 6;
    for (NSInteger i = 0; i < itemCount; i++) {
        CGFloat btnX = btnW*i+btnSpace*i;
        CGFloat btnY = 0;
        if (i>=(itemCount/2)) {
            btnX = btnW*(i-itemCount/2)+btnSpace*(i-itemCount/2);
            btnY = btnH+15;
        }
        ZButton *btnItem = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [btnItem setTag:i];
        [btnItem setBackgroundColor:WHITECOLOR];
        [btnItem setUserInteractionEnabled:true];
        [btnItem setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [[btnItem layer] setMasksToBounds:true];
        [btnItem setViewRound:16 borderWidth:0 borderColor:RGBCOLORA(239,244,246,1)];
        [btnItem setBackgroundImage:[UIImage createImageWithColor:COLORVIEWBACKCOLOR3] forState:(UIControlStateNormal)];
        [btnItem setBackgroundImage:[UIImage createImageWithColor:COLORVIEWBACKCOLOR3] forState:(UIControlStateHighlighted)];
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        ZLabel *lbPirce = [[ZLabel alloc] initWithFrame:(CGRectMake(0, 10, btnW, 22))];
        [lbPirce setFont:[ZFont systemFontOfSize:20]];
        [lbPirce setTextAlignment:(NSTextAlignmentCenter)];
        [lbPirce setUserInteractionEnabled:false];
        [lbPirce setTextColor:COLORTEXT1];
        [lbPirce setTag:10];
        [btnItem addSubview:lbPirce];
        
        ZLabel *lbDesc = [[ZLabel alloc] initWithFrame:(CGRectMake(0, btnItem.height-25, btnW, 18))];
        [lbDesc setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [lbDesc setTextAlignment:(NSTextAlignmentCenter)];
        [lbDesc setUserInteractionEnabled:false];
        [lbDesc setTextColor:COLORTEXT3];
        [lbDesc setTag:11];
        [lbDesc setText:kPlaneMoney];
        [btnItem addSubview:lbDesc];
        switch (i) {
            case 1: lbPirce.text = @"5"; break;
            case 2: lbPirce.text = @"66"; break;
            case 3: lbPirce.text = @"88"; break;
            case 4: lbPirce.text = @"166"; break;
            case 5: lbPirce.text = @"188"; break;
            default:
                lbPirce.text = @"2";
                [btnItem setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2"] forState:(UIControlStateNormal)];
                [btnItem setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2_c"] forState:(UIControlStateHighlighted)];
                [lbPirce setTextColor:WHITECOLOR];
                [lbDesc setTextColor:RGBCOLORA(255, 255, 255, 0.7)];
                self.btnPrice = btnItem;
                break;
        }
        [self.viewButton addSubview:btnItem];
    }
}
-(void)btnItemClick:(UIButton*)sender
{
    for (ZButton *btnItem in self.viewButton.subviews) {
        [btnItem setBackgroundImage:[UIImage createImageWithColor:COLORVIEWBACKCOLOR3] forState:(UIControlStateNormal)];
        [btnItem setBackgroundImage:[UIImage createImageWithColor:COLORVIEWBACKCOLOR3] forState:(UIControlStateHighlighted)];
        [(ZLabel*)[btnItem viewWithTag:10] setTextColor:COLORTEXT1];
        [(ZLabel*)[btnItem viewWithTag:11] setTextColor:COLORTEXT3];
    }
    [sender setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2"] forState:(UIControlStateNormal)];
    [sender setBackgroundImage:[SkinManager getImageWithName:@"btn_gra2_c"] forState:(UIControlStateHighlighted)];
    [(ZLabel*)[sender viewWithTag:10] setTextColor:WHITECOLOR];
    [(ZLabel*)[sender viewWithTag:11] setTextColor:RGBCOLORA(255, 255, 255, 0.7)];
    self.btnPrice = sender;
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
-(void)btnCloseEvent
{
    [self dismiss];
}
-(void)viewBGTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}
-(void)setPlayDataWithPriceArray:(NSArray *)priceArray
{
    [self setArrayMain:priceArray];
    
    [self addPriceButton];
}
///显示
-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.viewBack.alpha = 0;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewBack.alpha = kBackgroundOpacity;
        CGRect contentFrame = self.contentFrame;
        if (IsIPhoneX) {
            contentFrame.origin.y -= (self.contentH+10+kIPhoneXButtonHeight);
        } else {
            contentFrame.origin.y -= (self.contentH+10);
        }
        self.viewContent.frame = contentFrame;
    } completion:^(BOOL finished) {
        
    }];
}
///隐藏
-(void)dismiss
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewContent.frame = self.contentFrame;
        self.viewBack.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
