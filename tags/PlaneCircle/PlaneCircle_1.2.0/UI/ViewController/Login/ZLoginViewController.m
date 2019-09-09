//
//  ZLoginViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZLoginViewController.h"
#import "ZLoginAccountTVC.h"
#import "ZLoginButtonTVC.h"
#import "ZLoginPwdTVC.h"
#import "ZLoginLogoTVC.h"
#import "ZLoginThirdTVC.h"

#import "ZForgotPWDViewController.h"
#import "ZRegisterViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"
#import "XGPush.h"

@interface ZLoginViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGRect _tvFrame;
    NSInteger _rowIndex;
}
@property (strong, nonatomic) ZLoginLogoTVC *tvcLogo;
@property (strong, nonatomic) ZLoginAccountTVC *tvcAccount;
@property (strong, nonatomic) ZLoginPwdTVC *tvcPwd;
@property (strong, nonatomic) ZLoginButtonTVC *tvcButton;
@property (strong, nonatomic) ZLoginThirdTVC *tvcThird;

@property (strong, nonatomic) UIImageView *imgView;

@property (strong, nonatomic) ZTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) UIButton *btnBack;

@end

@implementation ZLoginViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"登录"];
    
    [self setNavigationBarHidden:YES];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
    
    [self registerKeyboardNotification];
    
    [self.tvcAccount setText:[AppSetting getUserAccount]];
    [self.tvcPwd setText:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
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
    OBJC_RELEASE(_btnBack);
    OBJC_RELEASE(_imgView);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvcAccount);
    OBJC_RELEASE(_tvcPwd);
    OBJC_RELEASE(_tvcLogo);
    OBJC_RELEASE(_tvcThird);
    OBJC_RELEASE(_tvcButton);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcLogo = [[ZLoginLogoTVC alloc] initWithReuseIdentifier:@"tvcLogo"];
    self.tvcAccount = [[ZLoginAccountTVC alloc] initWithReuseIdentifier:@"tvcAccount"];
    self.tvcPwd = [[ZLoginPwdTVC alloc] initWithReuseIdentifier:@"tvcPwd"];
    self.tvcButton = [[ZLoginButtonTVC alloc] initWithReuseIdentifier:@"tvcButton"];
    self.tvcThird = [[ZLoginThirdTVC alloc] initWithReuseIdentifier:@"tvcThird"];
    
    [self.tvcThird setShowWeChatLogin:[Utils isWXAppInstalled]];
    [self.tvcThird setShowMobileQQLogin:[QQApiInterface isQQInstalled]];
    
    self.arrMain = @[self.tvcLogo,self.tvcAccount,self.tvcPwd,self.tvcButton,self.tvcThird];
    
    self.imgView = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"login_bg"]];
    [self.imgView setUserInteractionEnabled:NO];
    [self.imgView setFrame:VIEW_MAIN_FRAME];
    [self.view addSubview:self.imgView];
    
    self.btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnBack setImage:[SkinManager getImageWithName:@"btn_back2"] forState:(UIControlStateNormal)];
    [self.btnBack setImage:[SkinManager getImageWithName:@"btn_back2"] forState:(UIControlStateHighlighted)];
    [self.btnBack setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnBack setFrame:CGRectMake(0, 10, 60, 54)];
    [self.btnBack setImageEdgeInsets:(UIEdgeInsetsMake(15, 10, 0, 10))];
    [self.btnBack setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.view addSubview:self.btnBack];
    
    self.tvMain = [[ZTableView alloc] init];
    [self.tvMain innerInit];
    [self.tvMain setBackgroundColor:CLEARCOLOR];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    _tvFrame = self.imgView.frame;
    [self.tvMain setFrame:_tvFrame];
    
    [self.view sendSubviewToBack:self.imgView];
    [self.view bringSubviewToFront:self.btnBack];
    
    [self innerEvent];
}

-(void)innerEvent
{
    [self.tvcAccount setOnBeginEditText:^{
        _rowIndex = 1;
    }];
    [self.tvcPwd setOnBeginEditText:^{
        _rowIndex = 2;
    }];
    ZWEAKSELF
    [self.tvcButton setOnLoginClick:^{
        [weakSelf btnLoginClick];
    }];
    [self.tvcButton setOnRegisterClick:^{
        [weakSelf btnRegisterClick];
    }];
    [self.tvcButton setOnForgotPwdClick:^{
        [weakSelf btnForgotPwdClick];
    }];
    [self.tvcThird setOnQQClick:^{
        [weakSelf btnQQClick];
    }];
    [self.tvcThird setOnWeChatClick:^{
        [weakSelf btnWeChatClick];
    }];
}

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
    }
}

-(void)btnBackClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnForgotPwdClick
{
    [self.view endEditing:YES];
    ZForgotPWDViewController *fpVC = [[ZForgotPWDViewController alloc] init];
    [self.navigationController pushViewController:fpVC animated:YES];
}

-(void)btnRegisterClick
{
    [self.view endEditing:YES];
    ZRegisterViewController *fpVC = [[ZRegisterViewController alloc] init];
    [self.navigationController pushViewController:fpVC animated:YES];
}

-(void)btnLoginClick
{
    [self.view endEditing:YES];
    NSString *account = self.tvcAccount.getText;
    if ([account isEmpty]) {
        [ZProgressHUD showError:@"帐号不能为空"];
        return;
    }
    if (![account isMobile] && ![account isEmail]) {
        [ZProgressHUD showError:@"帐号限制手机号或邮箱"];
        return;
    }
    NSString *pwd = self.tvcPwd.getText;
    if ([pwd isEmpty]) {
        [ZProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (![pwd isPassword]) {
        [ZProgressHUD showError:@"密码限制[6-16]数字或字母"];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:@"正在登录,请稍等..."];
    [sns postLoginWithAccount:account password:pwd resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            
            [weakSelf loginSuccess:resultModel];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}

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

-(void)loginThird:(SSDKPlatformType)type
{
    ZWEAKSELF
    [ZProgressHUD showMessage:@"正在登录,请稍等..."];
    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                GBLog(@"authorize onStateChanged rawData: %@",user.rawData);
                
                NSString *nickname = [user.nickname stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *uid = user.uid;
                NSString *profileImage = user.icon;
                NSString *unionid = [user.rawData objectForKey:@"unionid"];
                NSString *province = [user.rawData objectForKey:@"province"];
                NSString *city = [user.rawData objectForKey:@"city"];
                if (!province) {
                    province = kEmpty;
                }
                if (!city) {
                    city = kEmpty;
                }
                NSString *address = kEmpty;
                if (province && city) {
                    address = [NSString stringWithFormat:@"%@,%@",province,city];
                }
                //性别
                WTSexType sex = WTSexTypeNone;
                switch (user.gender) {
                    case SSDKGenderMale: sex = WTSexTypeMale; break;
                    case SSDKGenderFemale: sex = WTSexTypeFeMale; break;
                    default:break;
                }
                //登录平台
                int flag = 1;
                switch (type) {
                    case SSDKPlatformTypeWechat:
                    {
                        flag = 1;
                        break;
                    }
                    case SSDKPlatformTypeQQ:
                    {
                        flag = 3;
                        profileImage = [user.rawData objectForKey:@"figureurl_qq_2"];
                        if (profileImage == nil || profileImage.length == 0) {
                            profileImage = user.icon;
                        }
                        break;
                    }
                    case SSDKPlatformTypeSinaWeibo:
                    {
                        flag = 2;
                        break;
                    }
                    default: break;
                }
                [sns postLoginWithOpenid:uid unionid:unionid flag:flag nickname:nickname headImg:profileImage sex:sex address:address resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
                    GCDMainBlock(^(void){
                        [ZProgressHUD dismiss];
                        
                        [weakSelf loginSuccess:resultModel];
                    });
                } errorBlock:^(NSString *msg) {
                    GCDMainBlock(^(void){
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
                    [ZProgressHUD showError:@"取消授权登录"];
                });
                break;
            }
            case SSDKResponseStateFail:
            {
                GCDMainBlock(^(void){
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:@"授权登录失败"];
                });
                break;
            }
            default:break;
        }
    }];
}

-(void)loginSuccess:(ModelUser *)modelUser
{
    if (modelUser) {
        [AppSetting setUserId:modelUser.userId];
        
        [AppSetting setUserLogin:modelUser];
        [AppSetting setAutoLogin:YES];
        
        NSMutableArray *arrX = [AppSetting getHisLoginAccount];
        [arrX removeObject:modelUser.userId];
        [arrX insertObject:modelUser.userId atIndex:0];
        
        [AppSetting save];
        [AppSetting createFileDir];
        
        if (modelUser.qq_id && modelUser.qq_id.length > 0) {
            [MobClick profileSignInWithPUID:modelUser.userId provider:@"QQ"];
        } else if (modelUser.wechat_id && modelUser.wechat_id.length > 0) {
            [MobClick profileSignInWithPUID:modelUser.userId provider:@"WECHAT"];
        } else {
            [MobClick profileSignInWithPUID:modelUser.userId];
        }
        
        [ZProgressHUD showSuccess:@"登录成功"];
        [self postLoginChangeNotification];
        [self dismissViewControllerAnimated:YES completion:^{
            [[AppDelegate app] setXGAccount];
        }];
    } else {
        [ZProgressHUD showError:@"登录失败"];
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
