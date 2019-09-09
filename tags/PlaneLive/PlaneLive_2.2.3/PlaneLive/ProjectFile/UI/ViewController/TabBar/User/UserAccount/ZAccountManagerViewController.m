//
//  ZAccountManagerViewController.m
//  PlaneLive
//
//  Created by Daniel on 07/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountManagerViewController.h"
#import "ZAccountHeaderTVC.h"
#import "ZAccountBindPhoneTVC.h"
#import "ZAccountBindWeChatTVC.h"
#import "ZAccountBindViewController.h"
#import "ZAccountChangeViewController.h"

@interface ZAccountManagerViewController ()<UITableViewDelegate,UITableViewDataSource,ZActionSheetDelegate>

@property (strong, nonatomic) ZAccountHeaderTVC *tvcHeader;

@property (strong, nonatomic) ZAccountBindPhoneTVC *tvcBindPhone;
@property (strong, nonatomic) ZAccountBindWeChatTVC *tvcBindWeChat;

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrayMain;

@end

@implementation ZAccountManagerViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kAccountManager];
    
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self innerData];
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
    OBJC_RELEASE(_tvcHeader);
    OBJC_RELEASE(_tvcBindPhone);
    OBJC_RELEASE(_tvcBindWeChat);
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
    self.tvcHeader = [[ZAccountHeaderTVC alloc] initWithReuseIdentifier:@"tvcHeader"];
    ModelUser *model = [AppSetting getUserLogin];
    switch (model.loginType) {
        case WTAccountTypeWeChat:
            self.tvcBindPhone = [[ZAccountBindPhoneTVC alloc] initWithReuseIdentifier:@"tvcBindPhone"];
            self.arrayMain = @[self.tvcHeader,self.tvcBindPhone];
            break;
        default:
            self.tvcBindWeChat = [[ZAccountBindWeChatTVC alloc] initWithReuseIdentifier:@"tvcBindWeChat"];
            self.arrayMain = @[self.tvcHeader,self.tvcBindWeChat];
            break;
    }
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain innerInit];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
}
-(void)innerData
{
    ModelUser *model = [AppSetting getUserLogin];
    [self.tvcHeader setCellDataWithModel:model];
    switch (model.loginType) {
        case WTAccountTypeWeChat:
            [self.tvcBindPhone setCellDataWithModel:model];
            break;
        default:
            [self.tvcBindWeChat setCellDataWithModel:model];
            break;
    }
}
///绑定微信授权
-(void)setWeChatAuthorization
{
    if (![Utils isWXAppInstalled]) {
        [ZProgressHUD showError:kCWeChatNoInstalled];
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        [ZProgressHUD showError:kCWeChatNoSupportApi];
        return;
    }
    ZWEAKSELF
    [ZProgressHUD showMessage:kAuthorizationing];
    [ShareSDK authorize:SSDKPlatformTypeWechat settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                NSString *unionid = [user.rawData objectForKey:@"unionid"];
                [snsV2 postBindWeChatWithUniqueCode:unionid resultBlock:^(NSDictionary *result) {
                    GCDMainBlock(^{
                        [ZProgressHUD dismiss];
                        [ZProgressHUD showSuccess:kBindingSuccess];
                        
                        ModelUser *model = [AppSetting getUserLogin];
                        [model setWechat_id:unionid];
                        [AppSetting setUserLogin:model];
                        [AppSetting save];
                        
                        [weakSelf.tvcBindWeChat setCellDataWithModel:model];
                    });
                } errorBlock:^(NSString *msg) {
                    GCDMainBlock(^{
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
                    [ZProgressHUD showError:KCancelAuthorization];
                });
                break;
            }
            case SSDKResponseStateFail:
            {
                GCDMainBlock(^(void){
                    [ZProgressHUD dismiss];
                    [ZProgressHUD showError:kAuthorizationFail];
                });
                break;
            }
            default:break;
        }
    }];
}
///解除绑定微信
-(void)setUnBindWeChat
{
    ZWEAKSELF
    [ZAlertView showWithTitle:kRemoveBinding message:kWillNotBeAbleToUseThisWechatLogin doneCompletion:^{
        GCDMainBlock(^{
            [ZProgressHUD showMessage:kUnBinding];
        });
        ModelUser *model = [AppSetting getUserLogin];
        [snsV2 postUnBindWeChatWithUniqueCode:model.wechat_id resultBlock:^(NSDictionary *result) {
            [ZProgressHUD dismiss];
            [ZProgressHUD showSuccess:kUnBindingSuccess];
            
            ModelUser *model = [AppSetting getUserLogin];
            [model setWechat_id:kEmpty];
            [AppSetting setUserLogin:model];
            [AppSetting save];
            
            [weakSelf.tvcBindWeChat setCellDataWithModel:model];
        } errorBlock:^(NSString *msg) {
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        }];
    }];
}
///解除绑定手机号
-(void)setUnBindPhoneNumber
{
    ZWEAKSELF
    [ZAlertView showWithTitle:kRemoveBinding message:kWillNotBeAbleToUseThisPhoneNumberToLogIn doneCompletion:^{
        GCDMainBlock(^{
            [ZProgressHUD showMessage:kUnBinding];
        });
        ModelUser *model = [AppSetting getUserLogin];
        [snsV2 postUnBindMobileWithMobile:model.phone valiCode:nil resultBlock:^(NSDictionary *result) {
            [ZProgressHUD dismiss];
            [ZProgressHUD showSuccess:kUnBindingSuccess];
            
            ModelUser *modelU = [AppSetting getUserLogin];
            [modelU setPhone:kEmpty];
            
            [AppSetting setUserLogin:modelU];
            [AppSetting save];
            
            [weakSelf.tvcBindPhone setCellDataWithModel:modelU];
        } errorBlock:^(NSString *msg) {
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        }];
    }];
}
///绑定手机号
-(void)setBindPhoneNumber
{
    ZAccountBindViewController *itemVC = [[ZAccountBindViewController alloc] init];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///更换手机号
-(void)setChangePhoneNumber
{
    ZAccountChangeViewController *itemVC = [[ZAccountChangeViewController alloc] init];
    [self.navigationController pushViewController:itemVC animated:YES];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            ModelUser *model = [AppSetting getUserLogin];
            switch (model.loginType) {
                case WTAccountTypeWeChat://微信登录
                {
                    if (model.phone == nil || model.phone.length == 0) {
                        [self setBindPhoneNumber];
                    } else {
                        ZActionSheet *actionSheet = [[ZActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kCancel destructiveButtonTitle:nil otherButtonTitles:@[kRemoveBinding,kMyMobilePhoneNumberChange]];
                        [actionSheet setTag:11];
                        [actionSheet show];
                    }
                    break;
                }
                default:
                {
                    if (model.wechat_id == nil || model.wechat_id.length == 0) {
                        [self setWeChatAuthorization];
                    } else {
                        ZActionSheet *actionSheet = [[ZActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kCancel destructiveButtonTitle:nil otherButtonTitles:@[kRemoveBinding]];
                        [actionSheet setTag:12];
                        [actionSheet show];
                    }
                    break;
                }
            }
            break;
        }
        default: break;
    }
}

#pragma mark - ZActionSheetDelegate

-(void)actionSheet:(ZActionSheet *)actionSheet didButtonClickWithIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 11:///解除绑定手机号
            switch (buttonIndex) {
                case 0:///解除绑定手机号
                    [self setUnBindPhoneNumber];
                    break;
                case 1:///更换手机号绑定
                    [self setChangePhoneNumber];
                    break;
                default: break;
            }
            break;
        case 12:///解除绑定微信
            switch (buttonIndex) {
                case 0:
                    [self setUnBindWeChat];
                    break;
                default: break;
            }
        default: break;
    }
}

@end
