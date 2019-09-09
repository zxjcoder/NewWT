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
@property (strong, nonatomic) UIButton *btnWeChat;

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
    [self.view setBackgroundColor:VIEW_BACKCOLOR1];
    
    self.viewUser = [[UIView alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, 140)];
    [self.viewUser setBackgroundColor:WHITECOLOR];
    [self.view addSubview:self.viewUser];
    
    self.lbUser = [[UILabel alloc] initWithFrame:CGRectMake(25, 30, self.viewUser.width-50, 16)];
    [self.lbUser setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbUser setTextColor:COLORTEXT1];
    [self.lbUser setText:kHelloUser];
    [self.viewUser addSubview:self.lbUser];
    
    CGFloat userH = [self.lbUser getLabelHeightWithMinHeight:16];
    CGRect userFrame = self.lbUser.frame;
    userFrame.size.height = userH;
    [self.lbUser setFrame:userFrame];
    
    self.lbUserDesc = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(25, self.lbUser.y+self.lbUser.height+5, self.viewUser.width-50, 16)];
    [self.lbUserDesc setLinesSpacing:4];
    [self.lbUserDesc setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbUserDesc setTextColor:COLORTEXT1];
    [self.lbUserDesc setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self.lbUserDesc setNumberOfLines:0];
    [self.lbUserDesc setText:kOfficialCustomerContactUs];
    [self.viewUser addSubview:self.lbUserDesc];
    [self.lbUserDesc sizeToFit];
    
    UIImageView *imageLine = [UIImageView getDLineView];
    imageLine.frame = CGRectMake(self.lbUser.x, self.viewUser.y + self.viewUser.height, self.lbUser.width, kLineHeight);
    [self.view addSubview:imageLine];
    
    self.viewWeChat = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewUser.y+self.viewUser.height+5, APP_FRAME_WIDTH, 55)];
    [self.viewWeChat setBackgroundColor:WHITECOLOR];
    [self.view addSubview:self.viewWeChat];
    
    self.lbWeChat = [[UILabel alloc] initWithFrame:CGRectMake(15, self.viewWeChat.height/2-10, self.viewWeChat.width-125, 20)];
    [self.lbWeChat setText:@"官方微信:  梧桐Live"];
    [self.lbWeChat setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbWeChat setTextColor:COLORTEXT1];
    self.lbWeChat.userInteractionEnabled = false;
    [self.lbWeChat setLabelColorWithRange:(NSMakeRange(5, 8)) color:COLORCONTENT1];
    [self.viewWeChat addSubview:self.lbWeChat];
    
    self.btnWeChat = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnWeChat setFrame:CGRectMake(90, self.viewWeChat.height/2-15, 90, 30)];
    [self.btnWeChat setTitle:@" " forState:(UIControlStateNormal)];
    [self.btnWeChat addTarget:self action:@selector(btnWeChatClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewWeChat addSubview:self.btnWeChat];
    
    [super innerInit];
}
-(void)btnWeChatClick
{
    if ([Utils isWXAppInstalled]) {
        [[AppDelegate app] showJumpToBizProfile];
    }
}
-(void)btnPhoneClick
{
    PhoneCall(kCustomerServiceTelephoneNumbers);
}

@end
