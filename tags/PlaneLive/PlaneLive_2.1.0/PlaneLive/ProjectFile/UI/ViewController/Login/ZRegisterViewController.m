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

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@end

@implementation ZRegisterViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kRefister];
    
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
    [self.tvcAccount setCellBackGroundColor:VIEW_BACKCOLOR2];
    
    self.tvcSubmit = [[ZButtonTVC alloc] initWithReuseIdentifier:@"tvcSubmit"];
    [self.tvcSubmit setButtonText:kNowRefister];
    [self.tvcSubmit setCellBackGroundColor:VIEW_BACKCOLOR2];
    
    self.tvcAgreement = [[ZRegisterAgreementTVC alloc] initWithReuseIdentifier:@"tvcAgreement"];
    [self.tvcAgreement setCellBackGroundColor:VIEW_BACKCOLOR2];
    
    self.arrMain = @[self.tvcAccount,self.tvcSubmit,self.tvcAgreement];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain innerInit];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self innerEvent];
    
    [super innerInit];
}
///TODO:ZWW备注-单行文本输入监听事件
-(void)textFieldDidChange:(NSNotification *)sender
{
    UITextField *textField = sender.object;
    int maxLength = 0;
    switch (textField.tag) {
        case ZTextFieldIndexRegisterAccount:
            maxLength = kNumberPhomeMaxLength;
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
        
        [ZProgressHUD showSuccess:kRegisterAndLoginSuccess];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [[AppDelegate app] login];
        }];
    } else {
        [ZProgressHUD showError:kLoginFail];
    }
}

-(void)btnRegisterClick
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
    if (![self.tvcAgreement getCheckState]) {
        [ZProgressHUD showError:kPleaseAgreeToTheLiveUseAgreement];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgRegisting];
    [snsV1 postRegisterWithAccount:account password:pwd valiCode:code resultBlock:^(ModelUser *resultModel, NSDictionary *result) {
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

-(void)btnSendCodeClick
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
    ZWEAKSELF
    [ZProgressHUD showMessage:kCMsgSending];
    [snsV1 postGetCodeWithAccount:account flag:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showSuccess:kCodeSendSuccess];
            [weakSelf.tvcAccount setSendSuccess];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        });
    }];
}

-(void)btnAgreementClick
{
    [self.view endEditing:YES];
    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
    [itemVC setTitle:kMyAgreement];
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
