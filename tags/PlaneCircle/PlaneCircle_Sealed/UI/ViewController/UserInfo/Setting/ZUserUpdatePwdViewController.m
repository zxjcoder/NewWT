//
//  ZUserUpdatePwdViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserUpdatePwdViewController.h"
#import "ZSettingUpdPwdTVC.h"

@interface ZUserUpdatePwdViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) ZSettingUpdPwdTVC *tvcOldPwd;
@property (strong, nonatomic) ZSettingUpdPwdTVC *tvcNewPwd;

@end

@implementation ZUserUpdatePwdViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kUpdatePassword];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:kDone];
}

- (void)setViewFrame
{
    [self.tvMain setFrame:VIEW_ITEM_FRAME];
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
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvcOldPwd);
    OBJC_RELEASE(_tvcNewPwd);
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcOldPwd = [[ZSettingUpdPwdTVC alloc] initWithReuseIdentifier:@"tvcOldPwd" cellType:(ZSettingUpdPwdTVCTypeOldPwd)];
    self.tvcNewPwd = [[ZSettingUpdPwdTVC alloc] initWithReuseIdentifier:@"tvcNewPwd" cellType:(ZSettingUpdPwdTVCTypeNewPwd)];
    
    self.arrMain = @[self.tvcOldPwd,self.tvcNewPwd];
    
    self.tvMain = [[ZTableView alloc] init];
    [self.tvMain innerInit];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
}

-(void)btnRightClick
{
    if (self.isLoaded) {return;}
    [self.view endEditing:YES];
    NSString *oldPwd = self.tvcOldPwd.getText;
    if ([oldPwd isEmpty]) {
        [ZProgressHUD showSuccess:kOriginalPasswordNotEmpty];
        return;
    }
    if (![oldPwd isPassword]) {
        [ZProgressHUD showSuccess:kOriginalPasswordLengthLimitCharacter];
        return;
    }
    NSString *newPwd = self.tvcNewPwd.getText;
    if ([newPwd isEmpty]) {
        [ZProgressHUD showSuccess:kNewPasswordNotEmpty];
        return;
    }
    if (![newPwd isPassword]) {
        [ZProgressHUD showSuccess:kNewPasswordLengthLimitCharacter];
        return;
    }
    if ([oldPwd isEqualToString:newPwd]) {
        [ZProgressHUD showSuccess:kTheNewPasswordCanNotBeConsistentWithTheOriginalPassword];
        return;
    }
    ZWEAKSELF
    [self setIsLoaded:YES];
    [ZProgressHUD showMessage:kCMsgEditing];
    [sns postUpdatePasswordWithAccount:[AppSetting getUserDetauleId] oldPwd:oldPwd newPwd:newPwd resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismiss];
            [ZAlertView showWithMessage:kPasswordHasBeenModifiedSuccessfully];
            [[AppDelegate app] logout];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
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
