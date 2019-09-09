//
//  ZContactServiceViewController.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/5.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZContactServiceViewController.h"
#import "TYAttributedLabel.h"

@interface ZContactServiceViewController ()

@property (strong, nonatomic) UIView *viewUser;
@property (strong, nonatomic) UILabel *lbUser;
@property (strong, nonatomic) TYAttributedLabel *lbUserDesc;

@property (strong, nonatomic) UIView *viewWeChat;
@property (strong, nonatomic) UILabel *lbWeChat;

@property (strong, nonatomic) UIView *viewPhone;
@property (strong, nonatomic) UILabel *lbPhone;

@property (strong, nonatomic) UIButton *btnWeChat;
@property (strong, nonatomic) UIButton *btnPhone;

@end

@implementation ZContactServiceViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)setViewNil
{
    
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self.view setBackgroundColor:VIEW_BACKCOLOR2];
    
    self.viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, 140)];
    [self.viewUser setBackgroundColor:WHITECOLOR];
    [self.view addSubview:self.viewUser];
    
    self.lbUser = [[UILabel alloc] initWithFrame:CGRectMake(25, 30, self.viewUser.width-50, 16)];
    [self.lbUser setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbUser setTextColor:BLACKCOLOR];
    [self.lbUser setText:kHelloUser];
    [self.viewUser addSubview:self.lbUser];
    
    CGFloat userH = [self.lbUser getLabelHeightWithMinHeight:16];
    CGRect userFrame = self.lbUser.frame;
    userFrame.size.height = userH;
    [self.lbUser setFrame:userFrame];
    
    self.lbUserDesc = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(25, self.lbUser.y+self.lbUser.height+5, self.viewUser.width-50, 16)];
    [self.lbUserDesc setLinesSpacing:4];
    [self.lbUserDesc setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbUserDesc setTextColor:BLACKCOLOR];
    [self.lbUserDesc setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbUserDesc setNumberOfLines:0];
    [self.lbUserDesc setText:kOfficialCustomerContactUs];
    [self.viewUser addSubview:self.lbUserDesc];
    [self.lbUserDesc sizeToFit];
    
    self.viewWeChat = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewUser.y+self.viewUser.height+5, APP_FRAME_WIDTH, 55)];
    [self.viewWeChat setBackgroundColor:WHITECOLOR];
    [self.view addSubview:self.viewWeChat];
    
    self.lbWeChat = [[UILabel alloc] initWithFrame:CGRectMake(15, self.viewWeChat.height/2-10, self.viewWeChat.width-125, 20)];
    [self.lbWeChat setText:kOfficialWeChat];
    [self.lbWeChat setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbWeChat setTextColor:BLACKCOLOR1];
    [self.viewWeChat addSubview:self.lbWeChat];
    
    self.btnWeChat = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnWeChat setHidden:YES];
    [self.btnWeChat setFrame:CGRectMake(self.viewWeChat.width-105, self.viewWeChat.height/2-15, 90, 30)];
    [self.btnWeChat setTitle:kImmediateAttention forState:(UIControlStateNormal)];
    [self.btnWeChat setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnWeChat setViewRound:15 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnWeChat titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnWeChat addTarget:self action:@selector(btnWeChatClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewWeChat addSubview:self.btnWeChat];
    /*
    self.viewPhone = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewWeChat.y+self.viewWeChat.height+1, APP_FRAME_WIDTH, 55)];
    [self.viewPhone setBackgroundColor:WHITECOLOR];
    [self.view addSubview:self.viewPhone];
    
    self.lbPhone = [[UILabel alloc] initWithFrame:CGRectMake(15, self.viewWeChat.height/2-10, self.viewWeChat.width-125, 20)];
    [self.lbPhone setText:[NSString stringWithFormat:@"%@: %@", kCustomerServiceTelephoneNumbers, kCustomerServiceTelephoneNumberValue]];
    [self.lbPhone setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbPhone setTextColor:BLACKCOLOR1];
    [self.viewPhone addSubview:self.lbPhone];
    
    self.btnPhone = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPhone setFrame:CGRectMake(self.viewPhone.width-105, self.viewPhone.height/2-15, 90, 30)];
    [self.btnPhone setTitle:kCallImmediately forState:(UIControlStateNormal)];
    [self.btnPhone setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnPhone setViewRound:15 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnPhone titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnPhone addTarget:self action:@selector(btnPhoneClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewPhone addSubview:self.btnPhone];
    */
    [super innerInit];
}
-(void)btnWeChatClick
{
    [[AppDelegate app] showJumpToBizProfile];
}
-(void)btnPhoneClick
{
    PhoneCall(kCustomerServiceTelephoneNumbers);
}

@end
