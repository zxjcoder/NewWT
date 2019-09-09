//
//  ZAccountPasswordViewController.m
//  PlaneLive
//
//  Created by Daniel on 01/12/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountPasswordViewController.h"
#import "ZButtonTVC.h"
#import "ZAccountSpaceTVC.h"
#import "ZAccountPasswordTVC.h"

@interface ZAccountPasswordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZAccountSpaceTVC *tvcSpace1;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace2;
@property (strong, nonatomic) ZAccountPasswordTVC *tvcPassword;
@property (strong, nonatomic) ZButtonTVC *tvcSave;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrayMain;

@property (strong, nonatomic) NSString *phone;

@property (strong, nonatomic) NSString *code;

@end

@implementation ZAccountPasswordViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kMyMobilePhoneNumberBind];
    
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
-(void)setViewNil
{
    OBJC_RELEASE(_tvcSave);
    OBJC_RELEASE(_tvcPassword);
    OBJC_RELEASE(_tvcSpace1);
    OBJC_RELEASE(_tvcSpace2);
    OBJC_RELEASE(_arrayMain);
    _tvMain.dataSource = nil;
    _tvMain.delegate = nil;
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self.view setBackgroundColor:WHITECOLOR];
    self.tvcSpace1 = [[ZAccountSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace1"];
    self.tvcPassword = [[ZAccountPasswordTVC alloc] initWithReuseIdentifier:@"tvcPassword"];
    self.tvcSave = [[ZButtonTVC alloc] initWithReuseIdentifier:@"tvcSave"];
    self.tvcSpace2 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace2"];
    [self.tvcSpace2.viewMain setBackgroundColor:WHITECOLOR];
    
    [self.tvcSave setButtonText:kDetermine];
    ZWEAKSELF
    [self.tvcSave setOnSubmitClick:^{
        [weakSelf btnSaveClick];
    }];
    self.arrayMain = @[self.tvcSpace1,self.tvcPassword,self.tvcSpace2,self.tvcSave];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain innerInit];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.tvMain setClipsToBounds:false];
    [self.view addSubview:self.tvMain];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setViewClick:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [super innerInit];
}
-(void)setViewClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}
///TODO:ZWW备注-单行文本输入监听事件
-(void)textFieldDidChange:(NSNotification *)sender
{
    UITextField *textField = sender.object;
    int maxLength = 0;
    switch (textField.tag) {
        case ZTextFieldIndexBindAccount:
            maxLength = kNumberPhomeMaxLength;
            break;
        case ZTextFieldIndexBindCode:
            maxLength = kNumberCodeMaxLength;
            break;
        case ZTextFieldIndexBindPassword:
            maxLength = kNumberPasswordMaxLength;
            break;
        default: break;
    }
    NSString *content = textField.text;
    if (maxLength > 0 && content.length > maxLength) {
        [textField setText:[content substringToIndex:maxLength]];
    }
}
-(void)btnSaveClick
{
    [self.view endEditing:YES];
    NSString *phone = self.phone;
    if ([phone isEmpty]) {
        [ZProgressHUD showError:kPhoneNotEmpty];
        return;
    }
    if (![phone isMobile]) {
        [ZProgressHUD showError:kPleaseEnterRightPhone];
        return;
    }
    NSString *pwd = self.tvcPassword.getPasswordText;
    if ([pwd isEmpty]) {
        [ZProgressHUD showError:kNewPasswordNotEmpty];
        return;
    }
    if (![pwd isPassword]) {
        [ZProgressHUD showError:kNewPasswordLengthLimitCharacter];
        return;
    }
    NSString *code = self.code;
    if ([code isEmpty]) {
        [ZProgressHUD showError:kPleaseEnterCode];
        return;
    }
    if (![code isCode]) {
        [ZProgressHUD showError:kPleaseEnterRightCode];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kBinding];
    [snsV2 postBindMobileNumberWithMobile:phone password:pwd valiCode:code resultBlock:^(NSDictionary *result) {
        [ZProgressHUD dismiss];
        
        ModelUser *modelU = [AppSetting getUserLogin];
        [modelU setPhone:phone];
        
        [AppSetting setUserLogin:modelU];
        [AppSetting save];
        
        [ZAlertPromptView showWithMessage:kBindingSuccess completionBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } closeBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    } errorBlock:^(NSString *msg) {
        [ZProgressHUD dismiss];
        [ZAlertPromptView showWithMessage:msg];
    }];
}
-(void)setViewDataWithPhone:(NSString *)phone code:(NSString *)code
{
    [self setPhone:phone];
    [self setCode:code];
}
#pragma mark - UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(ZBaseTVC*)[self.arrayMain objectAtIndex:indexPath.row] getH];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrayMain objectAtIndex:indexPath.row];
}

@end
