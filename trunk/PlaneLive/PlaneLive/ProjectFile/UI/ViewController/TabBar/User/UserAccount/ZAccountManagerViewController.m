//
//  ZAccountManagerViewController.m
//  PlaneLive
//
//  Created by Daniel on 07/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountManagerViewController.h"
#import "ZNewBindAccountPhoneTVC.h"
#import "ZNewBindAccountWechatTVC.h"
#import "ZAccountBindViewController.h"
#import "ZAccountChangeViewController.h"
#import "ZAccountUnBindViewController.h"

@interface ZAccountManagerViewController ()<UITableViewDelegate,UITableViewDataSource,ZActionSheetDelegate>

@property (strong, nonatomic) ZNewBindAccountPhoneTVC *tvcBindPhone;
@property (strong, nonatomic) ZNewBindAccountWechatTVC *tvcBindBind;

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
    OBJC_RELEASE(_tvcBindPhone);
    OBJC_RELEASE(_tvcBindBind);
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
    self.tvcBindPhone = [[ZNewBindAccountPhoneTVC alloc] initWithReuseIdentifier:@"tvcBindPhone"];
    self.tvcBindBind = [[ZNewBindAccountWechatTVC alloc] initWithReuseIdentifier:@"tvcBindWeChat"];
    ZWEAKSELF
    [self.tvcBindBind setOnBindClick:^(ModelUser *model) {
        switch (model.loginType) {
            case WTAccountTypeWeChat:
                if (model.phone.length > 0) {
                    [weakSelf setUnBindPhoneNumber];
                } else {
                    [weakSelf setBindPhoneNumberToVC];
                }
                break;
            default:
                if (model.wechat_id.length > 0) {
                    [weakSelf setUnBindWeChat];
                } else {
                    [weakSelf setWeChatAuthorization];
                }
                break;
        }
    }];
    self.arrayMain = @[self.tvcBindPhone, self.tvcBindBind];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
}
-(void)innerData
{
    ModelUser *model = [AppSetting getUserLogin];
    [self.tvcBindPhone setCellDataWithModel:model];
    [self.tvcBindBind setCellDataWithModel:model];
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
                GBLog(@"rawData: %@", user.rawData);
                NSString *unionid = [user.rawData objectForKey:@"unionid"];
                NSString *nickname = [user.nickname stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                nickname = [nickname stringByReplacingOccurrencesOfString:@" " withString:kEmpty];
                nickname = [nickname stringByReplacingOccurrencesOfString:@"\r" withString:kEmpty];
                [snsV2 postBindWeChatWithUniqueCode:unionid wechatNickname:nickname resultBlock:^(NSDictionary *result) {
                    GCDMainBlock(^{
                        [ZProgressHUD dismiss];
                        [ZProgressHUD showSuccess:kBindingSuccess];
                        
                        ModelUser *model = [AppSetting getUserLogin];
                        [model setWechat_id:unionid];
                        [AppSetting setUserLogin:model];
                        [AppSetting save];
                        
                        [weakSelf.tvcBindBind setCellDataWithModel:model];
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
    [ZAlertPromptView showWithTitle:@"解除绑定" message:@"解绑微信将被注销,登录时需重新注册,确认解除绑定?" buttonText:kDetermine completionBlock:^{
        GCDMainBlock(^{
            [ZProgressHUD showMessage:kUnBinding];
        });
        ModelUser *model = [AppSetting getUserLogin];
        [snsV2 postUnBindWeChatWithUniqueCode:model.wechat_id resultBlock:^(NSDictionary *result) {
            [ZProgressHUD dismiss];
            [ZProgressHUD showSuccess:kUnBindingSuccess];
            
            ModelUser *modelU = [AppSetting getUserLogin];
            [modelU setWechat_id:kEmpty];
            
            [AppSetting setUserLogin:modelU];
            [AppSetting save];
            
            [weakSelf.tvcBindBind setCellDataWithModel:modelU];
            [weakSelf.tvcBindPhone setCellDataWithModel:modelU];
        } errorBlock:^(NSString *msg) {
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        }];
    } closeBlock:nil];
}
///解除绑定手机号 - 直接解绑
-(void)setUnBindPhoneNumber
{
    ZWEAKSELF
    [ZAlertPromptView showWithTitle:@"解除绑定" message:@"解绑账号将被注销,登录时需重新注册,确认解除绑定?" buttonText:kDetermine completionBlock:^{
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
            
            [weakSelf.tvcBindBind setCellDataWithModel:modelU];
            [weakSelf.tvcBindPhone setCellDataWithModel:modelU];
        } errorBlock:^(NSString *msg) {
            [ZProgressHUD dismiss];
            [ZProgressHUD showError:msg];
        }];
    } closeBlock:nil];
}
///绑定手机号
-(void)setBindPhoneNumberToVC
{
    ZAccountBindViewController *itemVC = [[ZAccountBindViewController alloc] init];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///更换手机号
-(void)setChangePhoneNumberToVC
{
    ZAccountChangeViewController *itemVC = [[ZAccountChangeViewController alloc] init];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///解绑手机号
-(void)setUnBindPhoneNumberToVC
{
    ZAccountUnBindViewController *itemVC = [[ZAccountUnBindViewController alloc] init];
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
                        [self setBindPhoneNumberToVC];
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
                    [self setUnBindPhoneNumberToVC];
                    break;
                case 1:///更换手机号绑定
                    [self setChangePhoneNumberToVC];
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
