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
#import "ZLoginLogoTVC.h"
#import "ZLoginThirdTVC.h"

#import "ZForgotPWDViewController.h"
#import "ZRegisterViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"

@interface ZLoginViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGRect _tvFrame;
    NSInteger _rowIndex;
}
@property (strong, nonatomic) ZLoginLogoTVC *tvcLogo;
@property (strong, nonatomic) ZLoginAccountTVC *tvcAccount;
@property (strong, nonatomic) ZLoginButtonTVC *tvcButton;
@property (strong, nonatomic) ZLoginThirdTVC *tvcThird;

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
    
    [self setTitle:kLogin];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardNotification];
    
    [self.tvcAccount setAccountText:[AppSetting getUserAccount]];
    [self.tvcAccount setPasswordText:kEmpty];
    
    [self registerTextFieldTextDidChangeNotification];
    
    [self setLeftButtonWithDefault];
    
    [self setRightButtonWithText:kRegister];
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
    OBJC_RELEASE(_tvcThird);
    OBJC_RELEASE(_tvcButton);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcLogo = [[ZLoginLogoTVC alloc] initWithReuseIdentifier:@"tvcLogo"];
    self.tvcAccount = [[ZLoginAccountTVC alloc] initWithReuseIdentifier:@"tvcAccount"];
    self.tvcButton = [[ZLoginButtonTVC alloc] initWithReuseIdentifier:@"tvcButton"];
    self.tvcThird = [[ZLoginThirdTVC alloc] initWithReuseIdentifier:@"tvcThird"];
    [self.tvcThird setShowWeChatLogin:[Utils isWXAppInstalled]];
    [self.tvcThird setViewFrame];
    
    self.arrMain = @[self.tvcLogo,self.tvcAccount,self.tvcButton,self.tvcThird];
    
    _tvFrame = VIEW_ITEM_FRAME;
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:_tvFrame];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setViewClick:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self innerEvent];
    
    [super innerInit];
}
-(void)setViewClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
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
    [self.tvcThird setOnWeChatClick:^{
        [weakSelf btnWeChatClick];
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
    }
}
///TODO:ZWW备注-单行文本输入监听事件
-(void)textFieldDidChange:(NSNotification *)sender
{
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
        [Utils showWechatPublicNumber];
    } else {
        [ZAlertView showWithMessage:[NSString stringWithFormat:@"%@: %@", kWeChatCustomerService,kWeChatCustomerServiceNumber]];
    }
}
///返回
-(void)btnLeftClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
///注册
-(void)btnRightClick
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
    [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
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
                        NSLog(@"%@", user.rawData);
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
                [snsV1 postLoginWithOpenid:uid unionid:unionid flag:flag nickname:nickname headImg:profileImage sex:sex address:address resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
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
                    [ZProgressHUD showError:KCancelAuthorizationLogin];
                });
                break;
            }
            case SSDKResponseStateFail:
            {
                GCDMainBlock(^(void){
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:kAuthorizationLoginFail];
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
        
        [AppSetting load:modelUser.userId];
        
        [AppSetting setUserLogin:modelUser];
        [AppSetting setAutoLogin:YES];
        
        NSMutableArray *arrX = [AppSetting getHisLoginAccount];
        [arrX removeObject:modelUser.userId];
        [arrX insertObject:modelUser.userId atIndex:0];
        
        [AppSetting save];
        
        [AppSetting createFileDir];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [[AppDelegate app] login];
            
            if (modelUser.isShowAlert) {
                [ZAlertView showWithTitle:modelUser.alertTitle message:modelUser.alertContent];
            } else {
                [ZProgressHUD showSuccess:kLoginSuccess];
            }
        }];
    } else {
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
