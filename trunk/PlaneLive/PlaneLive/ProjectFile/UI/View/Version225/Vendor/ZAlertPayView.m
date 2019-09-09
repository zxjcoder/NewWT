//
//  ZAlertPayView.m
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertPayView.h"
#import "ZButton.h"
#import "ZLabel.h"

@interface ZAlertPayView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbDesc;
@property (strong, nonatomic) ZButton *btnBalance;
@property (strong, nonatomic) ZImageView *imageBalance;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *reward;
@property (assign, nonatomic) CGRect imageBalanceFrame;

@end

@implementation ZAlertPayView

-(id)init
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(id)initWithTitle:(NSString *)title
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        self.title = title;
        [self innerInitItem];
    }
    return self;
}
-(id)initWithTitle:(NSString *)title reward:(NSString *)reward;
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        self.title = title;
        self.reward = reward;
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.contentH = 210;
   
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
    
    CGRect titleFrame = CGRectMake(20, 16, self.viewContent.width-40, 20);
    self.lbTitle = [[ZLabel alloc] initWithFrame:(titleFrame)];
    if (self.title && self.reward.length == 0) {
        [self.lbTitle setTextColor:COLORTEXT2];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbTitle setText:[NSString stringWithFormat:kYouWillSubscribeToTheContent, self.title]];
        [self.lbTitle setNumberOfLines:0];
    } else if (self.title && self.reward) {
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.lbTitle setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
        [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        NSString *textTitle = [NSString stringWithFormat:@"需要支付%@梧桐币", self.reward];
        [self.lbTitle setText:textTitle];
        [self.lbTitle setNumberOfLines:1];
        
        self.lbDesc = [[ZLabel alloc] init];
        [self.lbDesc setTextAlignment:(NSTextAlignmentCenter)];
        [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbDesc setTextColor:COLORTEXT3];
        [self.viewContent addSubview:self.lbDesc];
    }
    [self.viewContent addSubview:self.lbTitle];
    titleFrame.size.height = [self.lbTitle getLabelHeightWithMinHeight:20];
    self.lbTitle.frame = titleFrame;
    CGFloat btnY = self.lbTitle.y+self.lbTitle.height+18;
    if (self.lbDesc) {
        NSString *textReward = [NSString stringWithFormat:@"对\"%@\"的打赏", self.title];
        self.lbDesc.text = textReward;
        self.lbDesc.frame = CGRectMake(self.lbTitle.x, self.lbTitle.y+self.lbTitle.height+5, self.lbTitle.width, 18);
        btnY = self.lbDesc.y+self.lbDesc.height+18;
    }
    CGFloat btnSpace = 30;
    CGFloat btnW = 55;
    CGFloat btnH = 75;
    CGFloat imageSize = 46;
    CGFloat btnItemBottomY = btnY+btnH;
    CGFloat itemX = self.viewContent.width/2-btnW/2;
    self.btnBalance = [[UIButton alloc] initWithFrame:(CGRectMake(itemX, btnY, btnW, btnH))];
    [self.btnBalance setTag:WTPayWayTypeBalance];
    [self.btnBalance addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnBalance addTarget:self action:@selector(btnItemUp) forControlEvents:(UIControlEventTouchUpOutside)];
    [self.btnBalance addTarget:self action:@selector(btnItemDown) forControlEvents:(UIControlEventTouchDown)];
    [self.viewContent addSubview:self.btnBalance];
    
    self.imageBalanceFrame = CGRectMake(self.btnBalance.width/2-imageSize/2, 5, imageSize, imageSize);
    self.imageBalance = [[ZImageView alloc] initWithFrame:(self.imageBalanceFrame)];
    self.imageBalance.image = [SkinManager getImageWithName:@"balance_pay"];
    self.imageBalance.userInteractionEnabled = false;
    [self.imageBalance setTag:1];
    [self.btnBalance addSubview:self.imageBalance];
    
    UILabel *lbItem= [[UILabel alloc] initWithFrame:(CGRectMake(0, self.imageBalance.x+self.imageBalance.height+6, self.btnBalance.width, 18))];
    [lbItem setTextColor:COLORTEXT2];
    [lbItem setText:kBalance];
    [lbItem setTag:2];
    [lbItem setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [lbItem setTextAlignment:(NSTextAlignmentCenter)];
    [lbItem setUserInteractionEnabled:false];
    [self.btnBalance addSubview:lbItem];
    
    CGFloat btnCloseH = 46;
    UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnClose setTitle:kCancel forState:(UIControlStateNormal)];
    [btnClose setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [[btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    btnClose.userInteractionEnabled = true;
    btnClose.backgroundColor = CLEARCOLOR;
    btnClose.frame = CGRectMake(0, self.viewContent.height-btnCloseH, self.viewContent.width, btnCloseH);
    [self.viewContent addSubview:btnClose];
    
    UIImageView *imageLine = [UIImageView getDLineView];
    imageLine.frame = CGRectMake(20, btnClose.y, self.viewContent.width-40, kLineHeight);
    [self.viewContent addSubview:imageLine];
    
    //根据标题内容多少重新计算内容区域高度
    self.contentH = btnClose.y+btnClose.height;
    CGRect contentFrame = self.contentFrame;
    contentFrame.size.height = (self.contentH);
    self.contentFrame = contentFrame;
    self.viewContent.frame = contentFrame;
    
    //点击背景隐藏视图
    UITapGestureRecognizer *viewBGTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTapGesture:)];
    [self.viewBack addGestureRecognizer:viewBGTapGesture];
}
-(void)btnItemClick:(UIButton*)sender
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [self.imageBalance setFrame:self.imageBalanceFrame];
    } completion:^(BOOL finished) {
        switch (sender.tag) {
            case WTPayWayTypeBalance:
                if (self.onBalanceClick) {
                    self.onBalanceClick();
                }
                break;
            default:
                if (self.onItemClick) {
                    self.onItemClick(sender.tag);
                }
                break;
        }
        [self dismiss];
    }];
}
-(void)btnItemUp
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [self.imageBalance setFrame:self.imageBalanceFrame];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)btnItemDown
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        CGRect imageFrame = self.imageBalanceFrame;
        CGFloat itemX = imageFrame.origin.x+(imageFrame.size.width - imageFrame.size.width*0.9)/2;
        CGFloat itemY = imageFrame.origin.y+(imageFrame.size.height - imageFrame.size.height*0.9)/2;
        CGFloat itemW = imageFrame.size.width*0.9;
        CGFloat itemH = imageFrame.size.height*0.9;
        [self.imageBalance setFrame:(CGRectMake(itemX, itemY, itemW, itemH))];
    } completion:^(BOOL finished) {
        
    }];
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
