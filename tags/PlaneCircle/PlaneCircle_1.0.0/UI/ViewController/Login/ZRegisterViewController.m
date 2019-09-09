//
//  ZRegisterViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRegisterViewController.h"
#import "ZButtonTVC.h"
#import "ZPromptTVC.h"
#import "ZRegisterAccountTVC.h"
#import "ZRegisterAgreementTVC.h"

#import "ZWebViewController.h"

@interface ZRegisterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZRegisterAccountTVC *tvcAccount;
@property (strong, nonatomic) ZButtonTVC *tvcSubmit;
@property (strong, nonatomic) ZRegisterAgreementTVC *tvcAgreement;
@property (strong, nonatomic) ZPromptTVC *tvcPrompt;

@property (strong, nonatomic) UIImageView *imgView;

@property (strong, nonatomic) ZTableView *tvMain;

@property (strong, nonatomic) UILabel *lbTitle;
@property (strong, nonatomic) UIView *viewNavL;
@property (strong, nonatomic) UIButton *btnBack;

@property (strong, nonatomic) NSArray *arrMain;

@end

@implementation ZRegisterViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"注册"];
    
    [self setNavigationBarHidden:YES];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)setViewFrame
{
    [self.imgView setFrame:VIEW_MAIN_FRAME];
    [self.tvMain setFrame:CGRectMake(0, APP_TOP_HEIGHT, self.imgView.width, self.imgView.height-APP_TOP_HEIGHT)];
    [self.btnBack setFrame:CGRectMake(0, 20, 45, 45)];
    [self.viewNavL setFrame:CGRectMake(0, APP_TOP_HEIGHT, self.imgView.width, 0.8)];
    [self.lbTitle setFrame:CGRectMake(45, 20, self.imgView.width-90, 45)];
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
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_imgView);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_viewNavL);
    OBJC_RELEASE(_tvcPrompt);
    OBJC_RELEASE(_tvcAccount);
    OBJC_RELEASE(_tvcAgreement);
    OBJC_RELEASE(_tvcSubmit);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcAccount = [[ZRegisterAccountTVC alloc] initWithReuseIdentifier:@"tvcAccount"];
    self.tvcSubmit = [[ZButtonTVC alloc] initWithReuseIdentifier:@"tvcSubmit"];
    [self.tvcSubmit setButtonText:@"立 即 注 册"];
    self.tvcAgreement = [[ZRegisterAgreementTVC alloc] initWithReuseIdentifier:@"tvcAgreement"];
//    self.tvcPrompt = [[ZPromptTVC alloc] initWithReuseIdentifier:@"tvcPrompt"];
    
    self.arrMain = @[self.tvcAccount,self.tvcSubmit,self.tvcAgreement];
    
    self.imgView = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"login_bg"]];
    [self.imgView setUserInteractionEnabled:NO];
    [self.view addSubview:self.imgView];
    
    self.btnBack = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnBack setImage:[SkinManager getImageWithName:@"btn_back2"] forState:(UIControlStateNormal)];
    [self.btnBack setImage:[SkinManager getImageWithName:@"btn_back2"] forState:(UIControlStateHighlighted)];
    [self.btnBack setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.btnBack];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:self.title];
    [self.lbTitle setTextColor:MAINCOLOR];
    [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Max_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.view addSubview:self.lbTitle];
    
    self.viewNavL = [[UIView alloc] init];
    [self.viewNavL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.view addSubview:self.viewNavL];
    
    self.tvMain = [[ZTableView alloc] init];
    [self.tvMain setBackgroundColor:CLEARCOLOR];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self.view sendSubviewToBack:self.imgView];
    [self.view bringSubviewToFront:self.btnBack];
    [self.view bringSubviewToFront:self.lbTitle];
    [self.view bringSubviewToFront:self.viewNavL];
    
    [self setViewFrame];
    
    [self innerEvent];
}

-(void)innerEvent
{
    ZWEAKSELF
    [self.tvcSubmit setOnSubmitClick:^{
        [weakSelf btnRegisterClick];
    }];
    [self.tvcAgreement setOnAgreementClick:^{
        [weakSelf btnAgreementClick];
    }];
    [self.tvcAccount setOnSendCodeClick:^{
        [weakSelf btnSendCodeClick];
    }];
}

-(void)btnBackClick
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loginSuccess:(NSDictionary *)result
{
    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"result"]];
    [dicUser setObject:result[@"myFunsCount"] forKey:@"myFunsCount"];
    [dicUser setObject:result[@"myWaitAnsCount"] forKey:@"myWaitAnsCount"];
    [dicUser setObject:result[@"myQuesCount"] forKey:@"myQuesCount"];
    ModelUser *modelUser = [[ModelUser alloc] initWithCustom:dicUser];
    
    [AppSetting setUserId:modelUser.userId];
    
    [AppSetting setUserLogin:modelUser];
    [AppSetting setAutoLogin:YES];
    
    NSMutableArray *arrX = [AppSetting getHisLoginAccount];
    [arrX removeObject:modelUser.userId];
    [arrX insertObject:modelUser.userId atIndex:0];
    
    [AppSetting save];
    [AppSetting createPersonalFileDir];
    
    [ZProgressHUD showSuccess:@"注册并登录成功"];
    [self postLoginChangeNotification];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnRegisterClick
{
    [self.view endEditing:YES];
    NSString *account = self.tvcAccount.getAccountText;
    if ([account isEmpty]) {
        [ZProgressHUD showError:@"手机号或邮箱不能为空" toView:self.view];
        return;
    }
    if (![account isMobile] && ![account isEmail]) {
        [ZProgressHUD showError:@"请输入手机号或邮箱" toView:self.view];
        return;
    }
    NSString *pwd = self.tvcAccount.getPasswordText;
    if ([pwd isEmpty]) {
        [ZProgressHUD showError:@"新密码不能为空" toView:self.view];
        return;
    }
    if (![pwd isPassword]) {
        [ZProgressHUD showError:@"新密码限制[6-16]数字或字母" toView:self.view];
        return;
    }
    NSString *code = self.tvcAccount.getCodeText;
    if ([code isEmpty]) {
        [ZProgressHUD showError:@"请输入验证码" toView:self.view];
        return;
    }
    if (![code isCode]) {
        [ZProgressHUD showError:@"请输入6位数字的验证码" toView:self.view];
        return;
    }
    if (![self.tvcAgreement getCheckState]) {
        [ZProgressHUD showError:@"请同意梧桐圈使用协议" toView:self.view];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:@"正在注册,请稍等..." toView:self.view];
    [sns postRegisterWithAccount:account password:pwd valiCode:code resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismissForView:weakSelf.view];
            [weakSelf loginSuccess:result];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismissForView:weakSelf.view];
            [ZProgressHUD showError:msg toView:weakSelf.view];
        });
    }];
}

-(void)btnSendCodeClick
{
    [self.view endEditing:YES];
    NSString *account = self.tvcAccount.getAccountText;
    if ([account isEmpty]) {
        [ZProgressHUD showError:@"手机号或邮箱不能为空" toView:self.view];
        return;
    }
    if (![account isMobile] && ![account isEmail]) {
        [ZProgressHUD showError:@"请输入手机号或邮箱" toView:self.view];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:@"正在发送,请稍等..." toView:self.view];
    [sns postGetCodeWithAccount:account flag:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismissForView:weakSelf.view];
            [ZProgressHUD showSuccess:@"验证码发送成功" toView:weakSelf.view];
            [weakSelf.tvcAccount setSendSuccess];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismissForView:weakSelf.view];
            [ZProgressHUD showError:msg toView:weakSelf.view];
        });
    }];
}

-(void)btnAgreementClick
{
    [self.view endEditing:YES];
    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
    [itemVC setTitle:kCUseAgreement];
    [itemVC setWebUrl:kApp_ProtocolUrl];
    [self.navigationController pushViewController:itemVC animated:YES];
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
