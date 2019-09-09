//
//  ZForgotPWDViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/2/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZForgotPWDViewController.h"
#import "ZButtonTVC.h"
#import "ZPromptTVC.h"
#import "ZRegisterAccountTVC.h"

@interface ZForgotPWDViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZRegisterAccountTVC *tvcAccount;
@property (strong, nonatomic) ZButtonTVC *tvcSubmit;
@property (strong, nonatomic) ZPromptTVC *tvcPrompt;

@property (strong, nonatomic) UIImageView *imgView;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) UIView *viewNavL;

@property (strong, nonatomic) NSArray *arrMain;

@end

@implementation ZForgotPWDViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kFontBackPassword];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerTextFieldTextDidChangeNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeTextFieldTextDidChangeNotification];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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

-(void)setViewNil
{
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_imgView);
    OBJC_RELEASE(_viewNavL);
    OBJC_RELEASE(_tvcPrompt);
    OBJC_RELEASE(_tvcAccount);
    OBJC_RELEASE(_tvcSubmit);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcAccount = [[ZRegisterAccountTVC alloc] initWithReuseIdentifier:@"tvcAccount"];
    self.tvcSubmit = [[ZButtonTVC alloc] initWithReuseIdentifier:@"tvcSubmit"];
    [self.tvcSubmit setButtonText:kNowForget];
    
    self.arrMain = @[self.tvcAccount,self.tvcSubmit];
    
    self.imgView = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"login_bg"]];
    [self.imgView setUserInteractionEnabled:NO];
    [self.imgView setFrame:VIEW_MAIN_FRAME];
    [self.view addSubview:self.imgView];
    
    self.viewNavL = [[UIView alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT, self.imgView.width, 0.8)];
    [self.viewNavL setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.view addSubview:self.viewNavL];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT, self.imgView.width, self.imgView.height-APP_TOP_HEIGHT)];
    [self.tvMain innerInit];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self.view sendSubviewToBack:self.imgView];
    [self.view bringSubviewToFront:self.viewNavL];
    
    [self innerEvent];
    
    [super innerInit];
    
    [self setNavBarAlpha:0];
}
///TODO:ZWW备注-单行文本输入监听事件
-(void)textFieldDidChange:(NSNotification *)sender
{
    UITextField *textField = sender.object;
    int maxLength = 0;
    switch (textField.tag) {
        case ZTextFieldIndexRegisterAccount:
            maxLength = kNumberAccountMaxLength;
            break;
        case ZTextFieldIndexRegisterCode:
            maxLength = kNumberCodeMaxLength;
            break;
        case ZTextFieldIndexRegisterPwd:
            maxLength = kNumberPasswordMaxLength;
            break;
        default: break;
    }
    NSString *content = textField.text;
    if (maxLength > 0 && content.length > maxLength) {
        [textField setText:[content substringToIndex:maxLength]];
    }
}
-(void)innerEvent
{
    ZWEAKSELF
    [self.tvcSubmit setOnSubmitClick:^{
        [weakSelf btnRegisterClick];
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

-(void)btnRegisterClick
{
    [self.view endEditing:YES];
    NSString *account = self.tvcAccount.getAccountText;
    if ([account isEmpty]) {
        [ZProgressHUD showError:kPhoneOrEmailNotEmpty];
        return;
    }
    if (![account isMobile] && ![account isEmail]) {
        [ZProgressHUD showError:kPleaseEnterRightPhoneOrEmail];
        return;
    }
    NSString *pwd = self.tvcAccount.getPasswordText;
    if ([pwd isEmpty]) {
        [ZProgressHUD showError:kNewPasswordNotEmpty];
        return;
    }
    if (![pwd isPassword]) {
        [ZProgressHUD showError:kNewPasswordLengthLimitCharacter];
        return;
    }
    NSString *code = self.tvcAccount.getCodeText;
    if ([code isEmpty]) {
        [ZProgressHUD showError:kPleaseEnterCode];
        return;
    }
    if (![code isCode]) {
        [ZProgressHUD showError:kPleaseEnterRightCode];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgFotgeting];
    [DataOper postForgotPasswordWithAccount:account password:pwd valiCode:code resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [AppSetting setUserAccount:account];
            [AppSetting save];
            
            [ZProgressHUD dismiss];
            [ZProgressHUD showSuccess:kPasswordForgetSuccess];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}

-(void)btnSendCodeClick
{
    [self.view endEditing:YES];
    NSString *account = self.tvcAccount.getAccountText;
    if ([account isEmpty]) {
        [ZProgressHUD showError:kPhoneOrEmailNotEmpty];
        return;
    }
    if (![account isMobile] && ![account isEmail]) {
        [ZProgressHUD showError:kPleaseEnterRightPhoneOrEmail];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgSending];
    [DataOper postGetCodeWithAccount:account flag:2 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvcAccount setSendSuccess];
            [ZProgressHUD dismiss];
            [ZProgressHUD showSuccess:kCodeSendSuccess];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
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
