//
//  ZUserUpdatePwdViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/6/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserUpdatePwdViewController.h"
#import "ZSettingUpdPwdTVC.h"
#import "ZButtonTVC.h"
#import "ZSpaceTVC.h"

@interface ZUserUpdatePwdViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) ZSettingUpdPwdTVC *tvcOldPwd;
@property (strong, nonatomic) ZSettingUpdPwdTVC *tvcNewPwd;
@property (strong, nonatomic) ZButtonTVC *tvcSubmit;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace1;
@property (strong, nonatomic) ZSpaceTVC *tvcSpace2;

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
    
    //[self setRightButtonWithText:kDone];
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
    self.tvcSpace1 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace1"];
    self.tvcSpace2 = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace2"];
    self.tvcSpace1.cellH = 10;
    self.tvcSpace2.cellH = 20;
    self.tvcOldPwd = [[ZSettingUpdPwdTVC alloc] initWithReuseIdentifier:@"tvcOldPwd" cellType:(ZSettingUpdPwdTVCTypeOldPwd)];
    self.tvcNewPwd = [[ZSettingUpdPwdTVC alloc] initWithReuseIdentifier:@"tvcNewPwd" cellType:(ZSettingUpdPwdTVCTypeNewPwd)];
    self.tvcSubmit = [[ZButtonTVC alloc] initWithReuseIdentifier:@"tvcSubmit"];
    ZWEAKSELF
    [self.tvcSubmit setOnSubmitClick:^{
        [weakSelf btnRightClick];
    }];
    [self.tvcSubmit setButtonText:kDetermine];
    self.arrMain = @[self.tvcSpace1,self.tvcOldPwd,self.tvcNewPwd,self.tvcSpace2,self.tvcSubmit];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
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
    [snsV1 postUpdatePasswordWithAccount:kLoginUserId oldPwd:oldPwd newPwd:newPwd resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setIsLoaded:NO];
            [ZProgressHUD dismiss];
            [ZAlertPromptView showWithMessage:kPasswordHasBeenModifiedSuccessfully];
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
