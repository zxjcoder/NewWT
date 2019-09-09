//
//  ZPlayToolView.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPlayToolView.h"

@interface ZPlayToolView()

///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;
///背景
@property (strong, nonatomic) UIView *viewBG;
///内容
@property (strong, nonatomic) UIView *viewContent;
///标题
@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UILabel *lbDesc;
///取消
@property (strong, nonatomic) UIButton *btnCancel;
///余额支付
@property (strong, nonatomic) UIButton *btnBalance;

@property (strong, nonatomic) UIView *viewLine1;
@property (strong, nonatomic) UIView *viewLine2;

///内容坐标
@property (assign, nonatomic) CGRect contentFrame;

@end

@implementation ZPlayToolView

-(id)initWithPlayTitle:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInitWithTitle:title];
    }
    return self;
}
-(id)initWithSubscribeRewardTitle:(NSString *)title speakerName:(NSString *)speakerName
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInitSubscribeRewardWithTitle:title speakerName:speakerName];
    }
    return self;
}
-(id)initWithPracticeRewardTitle:(NSString *)title speakerName:(NSString *)speakerName
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInitPracticeRewardWithTitle:title speakerName:speakerName];
    }
    return self;
}
-(id)initWithPracticeTitle:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInitWithPracticeTitle:title];
    }
    return self;
}
-(void)innerInitSubscribeRewardWithTitle:(NSString *)title speakerName:(NSString *)speakerName
{
    [self getBgView];
    
    [self getContentView];
    
    [self getLineView];
    
    [self getBalanceBtn];
    
    [self getCancelBtn];
    
    [self getTitleWithReward:(NSString *)title speakerName:speakerName];
    
    [self setViewFrame];
}
-(void)innerInitPracticeRewardWithTitle:(NSString *)title speakerName:(NSString *)speakerName
{
    [self getBgView];
    
    [self getContentView];
    
    [self getLineView];
    
    [self getBalanceBtn];
    
    [self getCancelBtn];
    
    [self getTitleWithReward:(NSString *)title speakerName:speakerName];
    
    [self setViewFrame];
}
-(void)innerInitWithTitle:(NSString *)title
{
    [self getBgView];
    
    [self getContentView];
    
    [self getLineView];
    
    [self getBalanceBtn];
    
    [self getCancelBtn];
    
    [self getTitleLBWithTitle:(NSString *)title];
    
    [self setViewFrame];
}
-(void)innerInitWithPracticeTitle:(NSString *)title
{
    [self getBgView];
    
    [self getContentView];
    
    [self getLineView];
    
    [self getBalanceBtn];
    
    [self getCancelBtn];
    
    [self getTitleLBWithPracticeTitle:(NSString *)title];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.viewBG setFrame:self.bounds];
    
    self.contentFrame = CGRectMake(0, self.viewBG.height, self.viewBG.width, 0);
    
    [self.viewContent setFrame:self.contentFrame];
    [self.viewLine1 setFrame:CGRectMake(0, 0, self.viewContent.width, kLineHeight)];
    
    CGFloat itemW = self.width-40;
    CGFloat space = 20;
    CGRect titleFrame = CGRectMake(space, kSize15, itemW, 20);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:20];
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    CGFloat btnH = 45;
    if (self.lbDesc) {
        [self.lbDesc setFrame:CGRectMake(space, self.lbTitle.y+self.lbTitle.height+3, itemW, 18)];
        
        [self.btnBalance setFrame:CGRectMake(space, self.lbDesc.y+self.lbDesc.height+kSize20, itemW, btnH)];
    } else {
        [self.btnBalance setFrame:CGRectMake(space, self.lbTitle.y+self.lbTitle.height+kSize20, itemW, btnH)];
    }
    [self.viewLine2 setFrame:CGRectMake(0, self.btnBalance.y+self.btnBalance.height+kSize20, self.width, kLineHeight)];
    
    [self.btnCancel setFrame:CGRectMake(0, self.viewLine2.y+self.viewLine2.height, self.width, btnH)];
    
    self.contentFrame = CGRectMake(0, self.viewBG.height, self.viewBG.width, self.btnCancel.y+self.btnCancel.height);
    [self.viewContent setFrame:self.contentFrame];
}

-(void)getBgView
{
    self.viewBG = [[UIView alloc] init];
    [self.viewBG setBackgroundColor:BLACKCOLOR];
    [self.viewBG setAlpha:0.4f];
    [self addSubview:self.viewBG];
    
    UITapGestureRecognizer *viewBGTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTap:)];
    [self.viewBG addGestureRecognizer:viewBGTap];
}

-(void)getContentView
{
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewContent];
    
    [self sendSubviewToBack:self.viewBG];
}

-(void)getLineView
{
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine2];
}
-(void)getTitleWithReward:(NSString *)title speakerName:(NSString *)speakerName
{
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setText:title];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbTitle];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setTextColor:DESCCOLOR];
    [self.lbDesc setNumberOfLines:1];
    [self.lbDesc setText:speakerName];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbDesc];
}
-(void)getTitleLBWithTitle:(NSString *)title
{
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbTitle];
    NSString *text = [NSString stringWithFormat:kYouWillSubscribeToTheContent,title];
    [self.lbTitle setText:text];
    NSRange range = [text rangeOfString:title];
    if (range.location != NSNotFound) {
        [self.lbTitle setLabelColorWithRange:NSMakeRange(range.location-1, range.length+2) color:MAINCOLOR];
    }
}
-(void)getTitleLBWithPracticeTitle:(NSString *)title
{
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbTitle];
    NSString *text = [NSString stringWithFormat:kYouWillPracticeToTheContent,title];
    [self.lbTitle setText:text];
    NSRange range = [text rangeOfString:title];
    if (range.location != NSNotFound) {
        [self.lbTitle setLabelColorWithRange:NSMakeRange(range.location-1, range.length+2) color:MAINCOLOR];
    }
}

-(void)getCancelBtn
{
    self.btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCancel setTitle:kCancel forState:(UIControlStateNormal)];
    [self.btnCancel setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnCancel titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewContent addSubview:self.btnCancel];
}

-(void)getBalanceBtn
{
    self.btnBalance = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnBalance setBackgroundColor:MAINCOLOR];
    [self.btnBalance addTarget:self action:@selector(btnBalanceClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBalance setTitle:kBalancePayment forState:(UIControlStateNormal)];
    [self.btnBalance setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [self.btnBalance setViewRoundWithNoBorder];
    [[self.btnBalance titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewContent addSubview:self.btnBalance];
}

-(void)btnBalanceClick
{
    [self dismiss];
    if (self.onBalanceClick) {
        self.onBalanceClick();
    }
}

-(void)viewBGTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}

-(void)btnCancelClick
{
    [self dismiss];
}

-(void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
    OBJC_RELEASE(_btnBalance);
    OBJC_RELEASE(_btnCancel);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_onBalanceClick);
}

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
