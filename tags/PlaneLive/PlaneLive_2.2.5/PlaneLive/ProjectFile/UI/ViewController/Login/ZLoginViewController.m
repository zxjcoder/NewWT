//
//  ZLoginViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "ZLoginAccountTVC.h"
#import "ZLoginButtonTVC.h"
#import "ZLoginLogoTVC.h"
#import "ZLoginThirdTVC.h"
#import "ZForgotPWDViewController.h"
#import "ZRegisterViewController.h"
#import "ZAlertHintView.h"
#import "ZAccountManagerViewController.h"
#import "ZEditUserInfoViewController.h"

@interface ZLoginViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGRect _tvFrame;
    NSInteger _rowIndex;
}
@property (strong, nonatomic) ZBaseTVC *tvcSpace;
@property (strong, nonatomic) ZLoginLogoTVC *tvcLogo;
@property (strong, nonatomic) ZLoginAccountTVC *tvcAccount;
@property (strong, nonatomic) ZLoginButtonTVC *tvcButton;
//@property (strong, nonatomic) ZLoginThirdTVC *tvcThird;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@end

@implementation ZLoginViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self setTitle:kLogin];
    [self innerInit];
    //TODO:ZWW备注设置页面不允许全屏返回
    //[self setFd_interactivePopDisabled:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardNotification];
    
    if (self.strAccount.length > 0) {
        [self.tvcAccount setAccountText:self.strAccount];
    }
    [self.tvcAccount setPasswordText:kEmpty];
    [self registerTextFieldTextDidChangeNotification];
    
    //[self setBackButtonWithClose];
    //[self setRightButtonWithText:kRegister];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [self removeKeyboardNotification];
    [self removeTextFieldTextDidChangeNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)dealloc
{
    [self setViewNil];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
-(void)setViewNil
{
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvcAccount);
    OBJC_RELEASE(_tvcLogo);
//    OBJC_RELEASE(_tvcThird);
    OBJC_RELEASE(_tvcButton);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcSpace = [[ZBaseTVC alloc] initWithReuseIdentifier:@"tvcSpace"];
    self.tvcSpace.cellH = 60 * kViewSace;
    if (IsIPhone4) {
        self.tvcSpace.cellH = 10;
    } else {
        self.tvcSpace.cellH = 60 * kViewSace;
    }
    self.tvcLogo = [[ZLoginLogoTVC alloc] initWithReuseIdentifier:@"tvcLogo"];
    self.tvcAccount = [[ZLoginAccountTVC alloc] initWithReuseIdentifier:@"tvcAccount"];
    self.tvcButton = [[ZLoginButtonTVC alloc] initWithReuseIdentifier:@"tvcButton"];
    
    self.arrMain = @[self.tvcSpace,self.tvcLogo,self.tvcAccount,self.tvcButton];
    [self.view setBackgroundColor:WHITECOLOR];
    
    _tvFrame = VIEW_ITEM_FRAME;
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:_tvFrame];
    [self.tvMain setDataSource:self];
    self.tvMain.scrollEnabled = false;
    [self.tvMain setBackgroundColor:CLEARCOLOR];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    UIImageView *imageBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg"]];
    imageBG.frame = CGRectMake(0, APP_FRAME_HEIGHT - 180, APP_FRAME_WIDTH, 200);
    [self.view addSubview:imageBG];
    
    [self.view bringSubviewToFront:self.tvMain];
    if ([Utils isWXAppInstalled]) {
        UIButton *btnWeChat = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btnWeChat.userInteractionEnabled = true;
        [btnWeChat addTarget:self action:@selector(btnWeChatClick) forControlEvents:(UIControlEventTouchUpInside)];
        CGFloat wechatW = 60;
        CGFloat wechatH = 75;
        [btnWeChat setFrame:(CGRectMake(APP_FRAME_WIDTH/2-wechatW/2, APP_FRAME_HEIGHT-30-wechatH, wechatW, wechatH))];
        
        UIImageView *imageWechat = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"login_weixin"]];
        imageWechat.frame = CGRectMake(wechatW/2-20, 5, 40, 40);
        imageWechat.userInteractionEnabled = false;
        [btnWeChat addSubview:imageWechat];
        
        UILabel *lbWechat = [[UILabel alloc] initWithFrame:(CGRectMake(-5, btnWeChat.height-25, btnWeChat.width+10, 20))];
        lbWechat.userInteractionEnabled = false;
        [lbWechat setTextColor:COLORTEXT3];
        [lbWechat setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [lbWechat setTextAlignment:(NSTextAlignmentCenter)];
        [lbWechat setText:@"微信登录"];
        [btnWeChat addSubview:lbWechat];
        
        [self.view addSubview:btnWeChat];
        [self.view bringSubviewToFront:btnWeChat];
    }
    [self.view sendSubviewToBack:imageBG];
    
    UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnClose setImage:[UIImage imageNamed:@"arrow_down"] forState:(UIControlStateNormal)];
    [btnClose setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [btnClose setFrame:(CGRectMake(0, 10, 45, 45))];
    [btnClose addTarget:self action:@selector(btnLeftClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navigationItem setTitleView:btnClose];
    
    /// 点击屏幕结束编辑
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setTapGestureClick:)];
    [self.view addGestureRecognizer:tapGesture];
    /// 下滑关闭
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setSwipeGestureClick:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGesture];
    
    [self innerEvent];
    [super innerInit];
}
-(void)setTapGestureClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}
-(void)setSwipeGestureClick:(UIGestureRecognizer *)sender
{
    [self btnLeftClick];
}
-(void)innerEvent
{
    [self.tvcAccount setOnAccountBeginEditText:^{
        _rowIndex = 1;
    }];
    [self.tvcAccount setOnPasswordBeginEditText:^{
        _rowIndex = 2;
    }];
    ZWEAKSELF
    [self.tvcButton setOnLoginClick:^{
        [weakSelf btnLoginClick];
    }];
    [self.tvcButton setOnForgotPwdClick:^{
        [weakSelf btnForgotPwdClick];
    }];
//    [self.tvcThird setOnWeChatClick:^{
//        [weakSelf btnWeChatClick];
//    }];
    [self.tvcButton setOnRegisterClick:^{
        [weakSelf btnRegisterClick];
    }];
}
///键盘高度改变
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    if (height > kKeyboard_Min_Height) {
        CGRect tvFrame = _tvFrame;
        tvFrame.size.height -= height;
        [self.tvMain setFrame:tvFrame];
        [self.tvMain scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_rowIndex inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    } else {
        [self.tvMain setFrame:_tvFrame];
        self.tvMain.contentOffset = CGPointZero;
    }
}
///TODO:ZWW备注-单行文本输入监听事件
-(void)textFieldDidChange:(NSNotification *)sender
{
    self.strAccount = nil;
    UITextField *textField = sender.object;
    int maxLength = 0;
    switch (textField.tag) {
        case ZTextFieldIndexLoginAccount:
            maxLength = kNumberPhomeMaxLength;
            break;
        case ZTextFieldIndexLoginPwd:
            maxLength = kNumberPasswordMaxLength;
            break;
        default: break;
    }
    NSString *content = textField.text;
    if (maxLength > 0 && content.length > maxLength) {
        [textField setText:[content substringToIndex:maxLength]];
    }
}
///联系客服
-(void)btnServiceClick
{
    if ([Utils isWXAppInstalled]) {
        JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc] init];
        req.profileType =WXBizProfileType_Normal;
        req.username = kWeChatCustomerServiceNumber;
        [WXApi sendReq:req];
    } else {
        [ZAlertPromptView showWithMessage:[NSString stringWithFormat:@"%@: %@", kWeChatCustomerService,kWeChatCustomerServiceNumber]];
    }
}
///返回
-(void)btnLeftClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
///注册
-(void)btnRegisterClick
{
    [self.view endEditing:YES];
    ZRegisterViewController *itemVC = [[ZRegisterViewController alloc] init];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///找回密码
-(void)btnForgotPwdClick
{
    [self.view endEditing:YES];
    ZForgotPWDViewController *itemVC = [[ZForgotPWDViewController alloc] init];
    [itemVC setPreVC:self];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///登录
-(void)btnLoginClick
{
    [self.view endEditing:YES];
    NSString *account = self.tvcAccount.getAccountText;
    if ([account isEmpty]) {
        [ZProgressHUD showError:kPhoneNotEmpty];
        return;
    }
    if (![account isMobile]) {
        [ZProgressHUD showError:kPleaseEnterRightPhone];
        return;
    }
    NSString *pwd = self.tvcAccount.getPasswordText;
    if ([pwd isEmpty]) {
        [ZProgressHUD showError:kPasswordNotEmpty];
        return;
    }
    if (![pwd isPassword]) {
        [ZProgressHUD showError:kPasswordLengthLimitCharacter];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgLoging];
    [snsV1 postLoginWithAccount:account password:pwd resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            
            [weakSelf loginSuccess:resultModel];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            
            NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
            [dicParams setObject:msg == nil ? kEmpty : msg forKey:kZhugeIOFailCauseKey];
            [StatisticsManager eventIOTrackWithKey:kZhugeIOUserLoginFailKey dictionary:dicParams];
            
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}
///微信登录
-(void)btnWeChatClick
{
    [self.view endEditing:YES];
    if (![Utils isWXAppInstalled]) {
        [ZProgressHUD showError:kCWeChatNoInstalled];
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        [ZProgressHUD showError:kCWeChatNoSupportApi];
        return;
    }
    [self loginThird:(SSDKPlatformTypeWechat)];
}
///QQ登录
-(void)btnQQClick
{
    [self.view endEditing:YES];
    if (![QQApiInterface isQQInstalled]) {
        [ZProgressHUD showError:kCQQNoInstalled];
        return;
    }
    if (![QQApiInterface isQQSupportApi]) {
        [ZProgressHUD showError:kCQQNoSupportApi];
        return;
    }
    [self loginThird:(SSDKPlatformTypeQQ)];
}
///第三方登录
-(void)loginThird:(SSDKPlatformType)type
{
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgLoging];
    if ([ShareSDK hasAuthorized:type]) {
        [ShareSDK cancelAuthorize:type];
    }
    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        GBLog(@"第三方授权账号信息: %@", user.rawData);
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSString *nickname = [user.nickname stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                nickname = [nickname stringByReplacingOccurrencesOfString:@" " withString:kEmpty];
                nickname = [nickname stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
                NSString *uid = user.uid;
                NSString *profileImage = user.icon;
                NSString *unionid = [user.rawData objectForKey:@"unionid"];
                NSString *province = [user.rawData objectForKey:@"province"];
                NSString *city = [user.rawData objectForKey:@"city"];
                
                NSString *address = kEmpty;
                if (province.length>0 && city.length>0) {
                    address = [NSString stringWithFormat:@"%@,%@",province,city];
                }
                //性别
                WTSexType sex = WTSexTypeNone;
                switch (user.gender) {
                    case SSDKGenderMale: sex = WTSexTypeMale; break;
                    case SSDKGenderFemale: sex = WTSexTypeFeMale; break;
                    default:break;
                }
                //登录平台 1:微信  2:新浪  3:QQ
                int flag = 1;
                switch (type) {
                    case SSDKPlatformTypeWechat:
                    {
                        flag = 1;
                        break;
                    }
                    case SSDKPlatformTypeQQ:
                    {
                        flag = 2;
                        profileImage = [user.rawData objectForKey:@"figureurl_qq_2"];
                        if (profileImage == nil || profileImage.length == 0) {
                            profileImage = user.icon;
                        }
                        break;
                    }
                    case SSDKPlatformTypeSinaWeibo:
                    {
                        flag = 3;
                        break;
                    }
                    default: break;
                }
                profileImage = [profileImage stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
                [snsV1 postLoginWithOpenid:uid unionid:unionid flag:flag nickname:nickname headImg:profileImage sex:sex address:address resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
                    GCDMainBlock(^(void){
                        
                        [ZProgressHUD dismiss];
                        [weakSelf loginSuccess:resultModel];
                    });
                } errorBlock:^(NSString *msg) {
                    GCDMainBlock(^(void){
                        
                        NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
                        [dicParams setObject:msg == nil ? kEmpty : msg forKey:kZhugeIOFailCauseKey];
                        [StatisticsManager eventIOTrackWithKey:kZhugeIOUserLoginFailKey dictionary:dicParams];
                        
                        [ZProgressHUD dismiss];
                        [ZProgressHUD showError:msg];
                    });
                }];
                break;
            }
            case SSDKResponseStateCancel:
            {
                GCDMainBlock(^(void){
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:KCancelAuthorizationLogin];
                });
                break;
            }
            case SSDKResponseStateFail:
            {
                GCDMainBlock(^(void){
                    NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
                    [dicParams setObject:kAuthorizationLoginFail forKey:kZhugeIOFailCauseKey];
                    [StatisticsManager eventIOTrackWithKey:kZhugeIOUserLoginFailKey dictionary:dicParams];
                    
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:kAuthorizationLoginFail];
                });
                break;
            }
            default:break;
        }
    }];
}
/// 登录成功
-(void)loginSuccess:(ModelUser *)modelUser
{
    if (modelUser) {
        [AppSetting setAutoLogin:YES];
        [AppSetting setUserId:modelUser.userId];
        [AppSetting setUserLogin:modelUser];
        [AppSetting save];
        
        [AppSetting createFileDir];
        [[AppDelegate app] login];
        
        [StatisticsManager eventIOUserInfo];
        [StatisticsManager eventIOTrackWithKey:kZhugeIOUserLoginSuccessKey dictionary:[StatisticsManager getIOUserInfoParams]];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [ZProgressHUD showSuccess:kLoginSuccess];
        }];
    } else {
        [StatisticsManager eventIOTrackWithKey:kZhugeIOUserLoginFailKey dictionary:nil];
        
        [ZProgressHUD showError:kLoginFail];
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBaseTVC *cell = [self.arrMain objectAtIndex:indexPath.row];
    return [cell getH];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrMain objectAtIndex:indexPath.row];
}

@end
