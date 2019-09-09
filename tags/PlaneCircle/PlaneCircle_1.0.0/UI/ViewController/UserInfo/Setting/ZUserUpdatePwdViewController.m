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
    
    [self setTitle:@"修改密码"];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"完成"];
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
        [ZProgressHUD showSuccess:@"原始密码不能为空" toView:self.view];
        return;
    }
    if (![oldPwd isPassword]) {
        [ZProgressHUD showSuccess:@"原始密码限制[6-16]数字或字母" toView:self.view];
        return;
    }
    NSString *newPwd = self.tvcNewPwd.getText;
    if ([newPwd isEmpty]) {
        [ZProgressHUD showSuccess:@"新密码不能为空" toView:self.view];
        return;
    }
    if (![newPwd isPassword]) {
        [ZProgressHUD showSuccess:@"新密码限制[6-16]数字或字母" toView:self.view];
        return;
    }
    if ([oldPwd isEqualToString:newPwd]) {
        [ZProgressHUD showSuccess:@"新密码不能与原始密码一致" toView:self.view];
        return;
    }
    ZWEAKSELF
    [self setIsLoaded:YES];
    [ZProgressHUD showMessage:@"正在修改,请稍等..." toView:self.view];
    [sns postUpdatePasswordWithAccount:[AppSetting getUserDetauleId] oldPwd:oldPwd newPwd:newPwd resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismissForView:weakSelf.view];
            [ZAlertView showWithMessage:@"密码已修改成功,请重新登录"];
            [[AppDelegate app] logout];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismissForView:weakSelf.view];
            [ZProgressHUD showError:msg toView:weakSelf.view];
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
