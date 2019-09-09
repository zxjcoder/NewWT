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
@property (strong, nonatomic) ZButton *btnBalance;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *reward;

@end

@implementation ZAlertPayView

-(id)init
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(id)initWithTitle:(NSString *)title
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        self.title = title;
        [self innerInit];
    }
    return self;
}
-(id)initWithTitle:(NSString *)title reward:(NSString *)reward;
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        self.title = title;
        self.reward = reward;
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    self.contentH = 206;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR3];
    [self.viewBack setAlpha:kBackgroundOpacity];
    [self addSubview:self.viewBack];
    
    self.contentFrame = CGRectMake(10, self.height, self.width-20, self.contentH+20);
    self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
    [[self.viewContent layer] setMasksToBounds:true];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    [self sendSubviewToBack:self.viewBack];
    
    CGRect titleFrame = CGRectMake(20, 15, self.viewContent.width-40, 20);
    self.lbTitle = [[ZLabel alloc] initWithFrame:(titleFrame)];
    [self.lbTitle setTextColor:COLORTEXT2];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    if (self.title && self.reward.length == 0) {
        [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbTitle setText:[NSString stringWithFormat:kYouWillSubscribeToTheContent, self.title]];
    } else if (self.title && self.reward) {
        [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        NSString *textTitle = [NSString stringWithFormat:@"需要支付%@梧桐币", self.reward];
        NSString *textReward = [NSString stringWithFormat:@"对\"%@\"的打赏", self.title];
        [self.lbTitle setText:[NSString stringWithFormat:@"%@\n%@", textTitle, textReward]];
        [self.lbTitle setTextColor:COLORTEXT2];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbTitle setLabelFontWithRange:(NSMakeRange(self.lbTitle.text.length-textReward.length,textReward.length)) font:[ZFont systemFontOfSize:kFont_Min_Size] color:COLORTEXT3];
    }
    [self.lbTitle setNumberOfLines:0];
    [self.viewContent addSubview:self.lbTitle];
    
    titleFrame.size.height = [self.lbTitle getLabelHeightWithMinHeight:20];
    self.lbTitle.frame = titleFrame;
    
    CGFloat btnSpace = 30;
    CGFloat btnW = 50;
    CGFloat btnH = 75;
    CGFloat btnY = self.lbTitle.y+self.lbTitle.height+20;
    CGFloat imageSize = 46;
    CGFloat btnItemBottomY = btnY+btnH;
    CGFloat itemX = self.viewContent.width/2-btnW/2;
    UIButton *btnItem = [[UIButton alloc] initWithFrame:(CGRectMake(itemX, btnY, btnW, btnH))];
    [btnItem setTag:WTPayWayTypeBalance];
    [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:btnItem];
    
    ZImageView *imageView = [[ZImageView alloc] initWithFrame:(CGRectMake(btnW/2-imageSize/2, 5, imageSize, imageSize))];
    imageView.image = [SkinManager getImageWithName:@"balance_pay"];
    imageView.userInteractionEnabled = false;
    [btnItem addSubview:imageView];
    
    UILabel *lbItem= [[UILabel alloc] initWithFrame:(CGRectMake(0, btnItem.height-20, btnItem.width, 20))];
    [lbItem setTextColor:COLORTEXT2];
    [lbItem setText:kBalance];
    [lbItem setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [lbItem setTextAlignment:(NSTextAlignmentCenter)];
    [lbItem setUserInteractionEnabled:false];
    [btnItem addSubview:lbItem];
    
    CGFloat btnCloseH = 36;
    UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnClose setTitle:kCancel forState:(UIControlStateNormal)];
    [btnClose setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [[btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    btnClose.userInteractionEnabled = true;
    btnClose.backgroundColor = CLEARCOLOR;
    btnClose.frame = CGRectMake(0, btnItemBottomY+20, self.viewContent.width, 36);
    [self.viewContent addSubview:btnClose];
    
    UIImageView *imageLine = [UIImageView getDLineView];
    imageLine.frame = CGRectMake(20, btnClose.y, self.viewContent.width-40, kLineHeight);
    [self.viewContent addSubview:imageLine];
    
    //根据标题内容多少重新计算内容区域高度
    self.contentH = btnClose.y+btnClose.height;
    CGRect contentFrame = self.contentFrame;
    contentFrame.size.height = self.contentH;
    self.contentFrame = contentFrame;
    self.viewContent.frame = contentFrame;
    
    //点击背景隐藏视图
    UITapGestureRecognizer *viewBGTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTapGesture:)];
    [self.viewBack addGestureRecognizer:viewBGTapGesture];
}
-(void)btnItemClick:(UIButton*)sender
{
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
        contentFrame.origin.y -= self.contentH;
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
