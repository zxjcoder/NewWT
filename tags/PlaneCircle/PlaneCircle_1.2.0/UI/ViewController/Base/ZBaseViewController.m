//
//  ZBaseViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"
#import "ZNavigationViewController.h"
#import "ZAnswerDetailViewController.h"
#import "ZQuestionDetailViewController.h"
#import "ZLoginViewController.h"
#import "ZUserProfileViewController.h"

#import <ShareSDK/ShareSDK.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"

#import "ZReportView.h"
#import "ZReportViewController.h"

@interface ZBaseViewController ()

@property (strong, nonatomic) ModelEntity *model;

@end

@implementation ZBaseViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerBaseInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setIsDisappear:YES];
    
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
    
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass(self.class)];
    
    [self setIsDisappear:NO];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)setViewNil
{
    
}

-(void)setViewTitle:(NSString *)title
{
    UILabel *lbTitle = [[self.view viewWithTag:10001000] viewWithTag:1000];
    if (lbTitle) {
        [lbTitle setText:title];
    }
}

-(UILabel*)getViewTitle
{
    UILabel *lbTitle = [[self.view viewWithTag:10001000] viewWithTag:1000];
    return lbTitle;
}

-(void)setViewDataWithModel:(ModelEntity *)model
{
    [self setModel:model];
}

-(void)showQuestionDetailVC:(ModelQuestionBase *)model
{
    [self.view endEditing:YES];
    ZQuestionDetailViewController *itemVC = [[ZQuestionDetailViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
    
}

-(void)showAnswerDetailVC:(ModelAnswerBase *)model
{
    [self.view endEditing:YES];
    ZAnswerDetailViewController *itemVC = [[ZAnswerDetailViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)showUserProfileVC:(ModelUserBase *)model
{
    [self.view endEditing:YES];
    ZUserProfileViewController *itemVC = [[ZUserProfileViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)showUserProfileVC:(ModelUserBase *)model preVC:(id)preVC
{
    [self.view endEditing:YES];
    ZUserProfileViewController *itemVC = [[ZUserProfileViewController alloc] init];
    [itemVC setPreVC:preVC];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

-(void)showLoginVC
{
    [self.view endEditing:YES];
    [self setIsShowLogin:YES];
    ZLoginViewController *itemVC = [[ZLoginViewController alloc] init];
    [itemVC setNavigationBarHidden:YES];
    [self presentViewController:[[ZNavigationViewController alloc] initWithRootViewController:itemVC] animated:YES completion:nil];
}

#pragma mark - PrivateMethod

-(void)innerBaseInit
{
    [self setEdgesForExtendedLayout:(UIRectEdgeNone)];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.view setBackgroundColor:VIEW_BACKCOLOR1];
}

#pragma mark - NavigationButtonMethod

-(void)setCancelButton
{
    UIButton *btnCancel = [[self.view viewWithTag:10001000] viewWithTag:10001001];
    if (btnCancel) {
        [btnCancel setImage:nil forState:(UIControlStateNormal)];
        [btnCancel removeFromSuperview];
        OBJC_RELEASE(btnCancel);
    }
    btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnCancel setTitle:@"取消" forState:(UIControlStateNormal)];
    [btnCancel setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnCancel setUserInteractionEnabled:YES];
    [btnCancel setFrame:CGRectMake(10, 20, 45, 44)];
    [btnCancel setTag:10001001];
    [[self.view viewWithTag:10001000] addSubview:btnCancel];
}

-(void)btnCancelClick
{
    
}

-(void)setRightButtonWithShare
{
    //TODO:ZWW开启AppConfig配置
    ModelAppConfig *modelAC = [sqlite getLocalAppConfigModelWithId:APP_PROJECT_VERSION];
    if (modelAC && modelAC.appStatus == 1) {
        [self setRightButtonWithImage:@"btn_more"];
    }
}

-(void)setRightButtonWithPlay
{
    UIButton *btnRight = [[self.view viewWithTag:10001000] viewWithTag:10001002];
    
    if ([AppDelegate app].isPaying) {
        if (!btnRight) {
            btnRight = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [btnRight addTarget:self action:@selector(btnRightClick) forControlEvents:(UIControlEventTouchUpInside)];
            [btnRight setTag:10001002];
            [[self.view viewWithTag:10001000] addSubview:btnRight];
            
            [btnRight setFrame:CGRectMake(self.view.width-60, 10, 60, 55)];
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setFrame:CGRectMake(17, 17, 30, 30)];
            NSMutableArray *arrImages = [NSMutableArray array];
            for (int i = 1; i < 70; i++) {
                [arrImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"p_nav_paly_btn%d",i]]];
            }
            imgView.animationImages = arrImages;
            [imgView setImage:[SkinManager getImageWithName:@"p_nav_paly_btn"]];
            [imgView setAnimationDuration:1.8f];
            [imgView setAnimationRepeatCount:0];
            [imgView setUserInteractionEnabled:NO];
            [imgView startAnimating];
            [imgView setTag:1000100011];
            
            [btnRight setUserInteractionEnabled:YES];
            [btnRight addSubview:imgView];
            [btnRight setTitle:nil forState:(UIControlStateNormal)];
        }
    } else if (btnRight) {
        UIImageView *imgView = [btnRight viewWithTag:1000100011];
        [imgView setAnimationImages:nil];
        [imgView stopAnimating];
        [imgView removeFromSuperview];
        [btnRight removeFromSuperview];
    }
}

-(void)setRightButtonWithImage:(NSString*)image
{
    UIButton *btnRight = [[self.view viewWithTag:10001000] viewWithTag:10001002];
    if (image) {
        if (!btnRight) {
            btnRight = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [btnRight addTarget:self action:@selector(btnRightClick) forControlEvents:(UIControlEventTouchUpInside)];
            [btnRight setUserInteractionEnabled:YES];
            [btnRight setTag:10001002];
            [[self.view viewWithTag:10001000] addSubview:btnRight];
        }
        [btnRight setImage:[SkinManager getImageWithName:image] forState:(UIControlStateNormal)];
        [btnRight setImage:[SkinManager getImageWithName:image] forState:(UIControlStateHighlighted)];
        [btnRight setFrame:CGRectMake(self.view.width-60, 10, 60, 55)];
        [btnRight setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 0, 10))];
        [btnRight setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [btnRight setTitle:nil forState:(UIControlStateNormal)];
        [btnRight setTitle:nil forState:(UIControlStateHighlighted)];
    } else {
        [btnRight removeFromSuperview];
    }
}

-(void)setRightButtonWithText:(NSString*)text
{
    UIButton *btnRight = [[self.view viewWithTag:10001000] viewWithTag:10001002];
    if (!btnRight) {
        btnRight = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btnRight addTarget:self action:@selector(btnRightClick) forControlEvents:(UIControlEventTouchUpInside)];
        [btnRight setUserInteractionEnabled:YES];
        [btnRight setTag:10001002];
        [[self.view viewWithTag:10001000] addSubview:btnRight];
    }
    [btnRight setImage:nil forState:(UIControlStateNormal)];
    [btnRight setImage:nil forState:(UIControlStateHighlighted)];
    [btnRight setFrame:CGRectMake(self.view.width-60, 10, 60, 55)];
    [btnRight setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [btnRight setTitleEdgeInsets:(UIEdgeInsetsMake(10, 5, 0, 5))];
    [btnRight setTitle:text forState:(UIControlStateNormal)];
    [btnRight setTitle:text forState:(UIControlStateHighlighted)];
    [btnRight setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    if (text.length == 3) {
        [[btnRight titleLabel] setFont:[UIFont boldSystemFontOfSize:kFont_Middle_Size]];
    } else {
        [[btnRight titleLabel] setFont:[UIFont boldSystemFontOfSize:kFont_Default_Size]];
    }
}

-(void)btnRightClick
{
    
}

#pragma mark - ShareEvent

///微信分享
-(void)btnWeChatClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![Utils isWXAppInstalled]) {
        SafariOpen([WXApi getWXAppInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeWeChatSession];
}
///微信朋友圈分享
-(void)btnWeChatCircleClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![Utils isWXAppInstalled]) {
        SafariOpen([WXApi getWXAppInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeWeChatTimeline];
}
///QQ好友分享
-(void)btnQQClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![QQApiInterface isQQInstalled]) {
        SafariOpen([QQApiInterface getQQInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeQQFriend];
}
///QQ空间分享
-(void)btnQZoneClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![QQApiInterface isQQInstalled]) {
        SafariOpen([QQApiInterface getQQInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeQzone];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    
}
///有道云笔记
-(void)btnYouDaoClick
{
    [self shareNotePlatform:SSDKPlatformTypeYouDaoNote];
}
///印象笔记
-(void)btnYinXiangClick
{
    [self shareNotePlatform:SSDKPlatformTypeYinXiang];
}
///分享笔记平台
-(void)shareNotePlatform:(SSDKPlatformType)type
{
    ModelPractice *modelP = (ModelPractice*)self.model;
    if (modelP) {
        if ([ShareSDK hasAuthorized:type]) {
            NSArray *imagesArr = nil;
            if (modelP.speech_img == nil || modelP.speech_img.length == 0) {
                imagesArr = @[[UIImage imageNamed:@"new_image_default"]];
            } else {
                imagesArr = @[modelP.speech_img];
            }
            NSString *url = kApp_PracticeContentUrl(modelP.ids);
            NSString *text = [NSString stringWithFormat:@"%@ \n 文本地址: %@",modelP.share_content,url];
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:text
                                             images:imagesArr
                                                url:[NSURL URLWithString:url]
                                              title:modelP.title
                                               type:SSDKContentTypeAuto];
            
            [ShareSDK setSupportedInterfaceOrientation:UIInterfaceOrientationMaskPortrait];
            [SSUIEditorViewStyle setStatusBarStyle:(UIStatusBarStyleLightContent)];
            [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:MAINCOLOR];
            [SSUIEditorViewStyle setiPadNavigationBarBackgroundColor:MAINCOLOR];
            [SSUIEditorViewStyle setCancelButtonLabelColor:WHITECOLOR];
            [SSUIEditorViewStyle setShareButtonLabelColor:WHITECOLOR];
            [SSUIEditorViewStyle setTitleColor:WHITECOLOR];
            [SSUIEditorViewStyle setSupportedInterfaceOrientation:UIInterfaceOrientationMaskPortrait];
            
            [ShareSDK showShareEditor:type
                   otherPlatformTypes:@[@(type)]
                          shareParams:shareParams
                  onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
             {
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         GCDMainBlock(^{
                             [ZProgressHUD showSuccess:kCShareTitleSuccess];
                         });
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         GCDMainBlock(^{
                             if (error.code == 205) {
                                 [ZProgressHUD showError:kCShareTitleNoAuthorizeError];
                             } else {
                                 [ZProgressHUD showError:kCShareTitleError];
                             }
                         });
                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         GCDMainBlock(^{
                             [ZProgressHUD showError:kCShareTitleCancel];
                         });
                         break;
                     }
                     default: break;
                 }
             }];
        } else {
            [ShareSDK setSupportedInterfaceOrientation:UIInterfaceOrientationMaskPortrait];
            [SSDKAuthViewStyle setStatusBarStyle:(UIStatusBarStyleLightContent)];
            [SSDKAuthViewStyle setNavigationBarBackgroundColor:MAINCOLOR];
            [SSDKAuthViewStyle setCancelButtonLabelColor:WHITECOLOR];
            [SSDKAuthViewStyle setTitleColor:WHITECOLOR];
            [SSDKAuthViewStyle setSupportedInterfaceOrientation:UIInterfaceOrientationMaskPortrait];
            
            ZWEAKSELF
            [ShareSDK authorize:type
                       settings:nil
                 onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                     switch (state) {
                         case SSDKResponseStateSuccess:
                         {
                             GCDMainBlock(^{
                                 [ZProgressHUD showSuccess:@"授权成功"];
                                 [weakSelf shareNotePlatform:type];
                             });
                             break;
                         }
                         case SSDKResponseStateFail:
                         {
                             GCDMainBlock(^{
                                 [ZProgressHUD showError:@"授权失败"];
                             });
                             break;
                         }
                         case SSDKResponseStateCancel:
                         {
                             GCDMainBlock(^{
                                 [ZProgressHUD showError:@"取消授权"];
                             });
                             break;
                         }
                         default: break;
                     }
                 }];
        }
    }
}
///举报
-(void)btnReportClickWithId:(NSString *)ids type:(ZReportType)type
{
    if ([AppSetting getAutoLogin]) {
        ZReportView *reportView = [[ZReportView alloc] init];
        [reportView setOnSubmitClick:^(NSString *content) {
            if ([content isEqualToString:kEmpty]) {
                [ZProgressHUD showError:@"请至少选择一项举报"];
            } else {
                [sns postAddReportWithUserId:[AppSetting getUserDetauleId] objId:ids type:type content:content resultBlock:^(NSDictionary *result) {
                    GCDMainBlock(^{
                        [ZProgressHUD showSuccess:@"举报成功"];
                    });
                } errorBlock:^(NSString *msg) {
                    GCDMainBlock(^{
                        [ZProgressHUD showError:msg];
                    });
                }];
            }
        }];
        ZWEAKSELF
        [reportView setOnOtherClick:^{
            ZReportViewController *itemVC = [[ZReportViewController alloc] init];
            switch (type) {
                case ZReportTypeAnswer:
                    [itemVC setTitle:@"举报回答"];
                    break;
                case ZReportTypePersion:
                    [itemVC setTitle:@"举报用户"];
                    break;
                case ZReportTypeQuestion:
                    [itemVC setTitle:@"举报问题"];
                    break;
                default:
                    break;
            }
            [itemVC setViewDataWithIds:ids type:type];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:itemVC animated:YES];
        }];
        [reportView show];
    } else {
        [self showLoginVC];
    }
}
#pragma mark - KeyboardNotification

-(void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - KeyboardNotificationMethod

-(void)keyboardWillShow:(NSNotification*)sender
{
    [self keyboardFrameChange:[[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height];
}

-(void)keyboardWillHide:(NSNotification*)sender
{
    [self keyboardFrameChange:0];
}

-(void)keyboardFrameChange:(CGFloat)height
{
    GBLog(@"keyboardHeight:%.2f",height);
}

#pragma mark - LoginChangeNotification

-(void)registerLoginChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginChange) name:ZLoginChangeNotification object:nil];
}

-(void)removeLoginChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZLoginChangeNotification object:nil];
}

-(void)postLoginChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLoginChangeNotification object:nil];
}

-(void)setLoginChange
{
    
}

#pragma mark - UserInfoChangeNotification

-(void)registerUserInfoChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserInfoChange) name:ZUserInfoChangeNotification object:nil];
}

-(void)removeUserInfoChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZUserInfoChangeNotification object:nil];
}

-(void)postUserInfoChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZUserInfoChangeNotification object:nil];
}

-(void)setUserInfoChange
{
    
}

#pragma mark - PublishQuestionNotification

-(void)registerPublishQuestionNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPublishQuestion:) name:ZPublishQuestionNotification object:nil];
}

-(void)removePublishQuestionNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPublishQuestionNotification object:nil];
}

-(void)postPublishQuestionNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPublishQuestionNotification object:nil];
}

-(void)postPublishQuestionNotificationWithIndex:(int)index
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPublishQuestionNotification object:[NSString stringWithFormat:@"%d",index]];
}

-(void)setPublishQuestion:(NSNotification *)sender
{
    [self setPublishQuestion];
}

-(void)setPublishQuestion
{

}

#pragma mark - FontSizeChangeNotification

-(void)registerFontSizeChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFontSizeChange) name:ZFontSizeChangeNotification object:nil];
}

-(void)removeFontSizeChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPublishQuestionNotification object:nil];
}

-(void)postFontSizeChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPublishQuestionNotification object:nil];
}

-(void)setFontSizeChange
{
    
}

@end
