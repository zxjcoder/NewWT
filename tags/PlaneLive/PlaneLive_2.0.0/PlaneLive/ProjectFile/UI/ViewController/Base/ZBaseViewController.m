//
//  ZBaseViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"

#import "ZLoginViewController.h"
#import "ZWebViewController.h"

#import <ShareSDK/ShareSDK.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "WXApi.h"

#import "ZReportView.h"
#import "ZReportViewController.h"

#import "ZAnswerDetailViewController.h"
#import "ZQuestionDetailViewController.h"
#import "ZUserProfileViewController.h"

#import "ZPlayViewController.h"

#import "ZTaskAlertView.h"
#import "ZTaskCenterViewController.h"

@interface ZBaseViewController ()
{
    ///导航栏背景
    UIView *_navBackView;
    ///最后一次导航栏背景透明度
    CGFloat _navBackAlpha;
}
/// 导航条ViewLine
@property (nonatomic, weak) UIView *navBarViewLine;
/// 数据模型
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
    
    if (!self.isDismissPlay && [[AppDelegate app] isPlay]) {
        [self setRightPlayButton];
    } else {
        [[self navigationItem] setRightBarButtonItem:nil];
    }
    
    [StatisticsManager beginRecordPage:NSStringFromClass(self.class)];
    
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [StatisticsManager endRecordPage:NSStringFromClass(self.class)];
    
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
    return UIStatusBarStyleDefault;
}


#pragma mark - PrivateMethod

-(void)innerBaseInit
{
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    [self.view setBackgroundColor:VIEW_BACKCOLOR1];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] init];
    [btnBack setTitle:@" "];
    [self.navigationItem setBackBarButtonItem:btnBack];
}

-(void)innerInit
{
    [self.view addSubview:self.navBarView];
}

-(void)setNavBarAlpha:(CGFloat)alpha
{
    self.navBarView.alpha = alpha;
    self.navBarViewLine.alpha = alpha;
}

-(void)setNavBarLineAlpha:(CGFloat)alpha
{
    self.navBarViewLine.alpha = alpha;
}

#pragma mark - PublicMethod

-(void)setViewNil
{
    OBJC_RELEASE(_navBackView);
}

-(void)setViewDataWithModel:(ModelEntity *)model
{
    [self setModel:model];
}

- (UIView *)navBarView
{
    if (!_navBarView) {
        UIView *navBarView = [[UIView alloc] init];
        navBarView.backgroundColor = NAVIGATIONCOLOR;
        navBarView.frame = VIEW_NAVV_FRAME;
        
        [navBarView addSubview:self.navBarViewLine];
        
        [self.view addSubview:navBarView];
        self.navBarView = navBarView;
    }
    return _navBarView;
}
- (UIView *)navBarViewLine
{
    if (!_navBarViewLine) {
        UIImageView *navBarViewLine = [UIImageView getSLineView];
        navBarViewLine.frame = CGRectMake(0, APP_TOP_HEIGHT-kLineHeight, APP_FRAME_WIDTH, kLineHeight);
        [self.view addSubview:navBarViewLine];
        self.navBarViewLine = navBarViewLine;
    }
    return _navBarViewLine;
}

///显示登录界面
-(void)showLoginVC
{
    [self.view endEditing:YES];
    [self setIsShowLogin:YES];
    
    ZLoginViewController *itemVC = [[ZLoginViewController alloc] init];
    
    ZRootViewController *itemRVC = [[ZRootViewController alloc] initWithRootViewController:itemVC];
    [itemRVC.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    itemRVC.navigationBar.shadowImage = [UIImage new];
    [self presentViewController:itemRVC animated:YES completion:nil];
}
///显示播放界面
-(void)setShowPlayVC
{
    [self setShowPlayVC:YES];
}
///显示播放界面
-(void)setShowPlayVC:(BOOL)animated
{
    [self.view endEditing:YES];
    NSArray *arrayPlay = [[ZPlayViewController sharedSingleton] getPlayDataArray];
    if (arrayPlay && arrayPlay.count > 0) {
        ZPlayViewController *itemVC = [ZPlayViewController sharedSingleton];
        
        [self setShowPlayVC:itemVC animated:animated];
    } else {
        NSString *strPlayType =  [sqlite getSysParamWithKey:@"PlayViewLastPlayType"];
        switch (strPlayType.intValue) {
            case 1:
            {
                NSArray *arrayFoundPlay = [sqlite getLocalPlayListPracticeFoundWithUserId:[AppSetting getUserDetauleId]];
                if (arrayFoundPlay && arrayFoundPlay.count > 0) {
                    ZPlayViewController *itemVC = [ZPlayViewController sharedSingleton];
                    [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypeFound)];
                    [itemVC setViewPlayArray:arrayFoundPlay index:0];
                    
                    [self setShowPlayVC:itemVC animated:animated];
                } else {
                    [ZProgressHUD showError:kNotFoundPlayRecord];
                }
                break;
            }
            case 2:
            {
                NSArray *arraySubscribeCurriculumPlay = [sqlite getLocalPlayListSubscribeCurriculumListWithUserId:[AppSetting getUserDetauleId]];
                if (arraySubscribeCurriculumPlay && arraySubscribeCurriculumPlay.count > 0) {
                    ZPlayViewController *itemVC = [ZPlayViewController sharedSingleton];
                    [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypeSubscribe)];
                    [itemVC setViewPlayWithCurriculumArray:arraySubscribeCurriculumPlay index:0];
                    
                    [self setShowPlayVC:itemVC animated:animated];
                } else {
                    [ZProgressHUD showError:kNotFoundPlayRecord];
                }
                break;
            }
            default:
            {
                NSArray *arrayPracticePlay = [sqlite getLocalPlayListPracticeListWithUserId:[AppSetting getUserDetauleId]];
                if (arrayPracticePlay && arrayPracticePlay.count > 0) {
                    ZPlayViewController *itemVC = [ZPlayViewController sharedSingleton];
                    [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypePractice)];
                    [itemVC setViewPlayArray:arrayPracticePlay index:0];
                    
                    [self setShowPlayVC:itemVC animated:animated];
                } else {
                    [ZProgressHUD showError:kNotFoundPlayRecord];
                }
                break;
            }
        }
    }
}
///显示播放界面
-(void)setShowPlayVC:(ZPlayViewController *)itemVC animated:(BOOL)animated
{
    [itemVC setHidesBottomBarWhenPushed:YES];
    // 判断是否已经Push过播放页面了
    BOOL isPushPlay = YES;
    for (UIViewController *viewVC in self.navigationController.viewControllers) {
        if ([viewVC isKindOfClass:[itemVC class]]) {
            isPushPlay = NO;
            break;
        }
    }
    if (isPushPlay) {
        [self.navigationController pushViewController:itemVC animated:animated];
    } else {
        [self.navigationController popToViewController:itemVC animated:YES];
    }
//    ZRootViewController *itemRVC = [[ZRootViewController alloc] initWithRootViewController:itemVC];
//    [itemRVC.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
//    itemRVC.navigationBar.shadowImage = [UIImage new];
//    [self presentViewController:itemRVC animated:animated completion:nil];
}
///显示播放界面-实务
-(void)showPlayVCWithPracticeArray:(NSArray *)array index:(NSInteger)index
{
    [self.view endEditing:YES];
    if (array && array.count > 0 && array.count > index) {
        [sqlite setSysParam:@"PlayViewLastPlayType" value:@"0"];
        [sqlite setLocalPlayListPracticeListWithArray:array userId:[AppSetting getUserDetauleId]];
        
        ZPlayViewController *itemVC = [ZPlayViewController sharedSingleton];
        [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypePractice)];
        [itemVC setViewPlayArray:array index:index];
        
        [self setShowPlayVC:itemVC animated:YES];
    } else {
        [ZProgressHUD showError:kNotFoundPlayRecord];
    }
}
///显示播放界面-发现
-(void)showPlayVCWithFoundArray:(NSArray *)array index:(NSInteger)index
{
    [self.view endEditing:YES];
    if (array && array.count > 0 && array.count > index) {
        [sqlite setSysParam:@"PlayViewLastPlayType" value:@"1"];
        [sqlite setLocalPlayListPracticeFoundWithArray:array userId:[AppSetting getUserDetauleId]];
        
        ZPlayViewController *itemVC = [ZPlayViewController sharedSingleton];
        [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypeFound)];
        [itemVC setViewPlayArray:array index:index];
        
        [self setShowPlayVC:itemVC animated:YES];
    } else {
        [ZProgressHUD showError:kNotFoundPlayRecord];
    }
}
///显示播放界面-订阅
-(void)showPlayVCWithCurriculumArray:(NSArray *)array index:(NSInteger)index
{
    [self.view endEditing:YES];
    if (array && array.count > 0 && array.count > index) {
        [sqlite setSysParam:@"PlayViewLastPlayType" value:@"2"];
        [sqlite setLocalPlayListSubscribeCurriculumListWithArray:array userId:[AppSetting getUserDetauleId]];
        
        ZPlayViewController *itemVC = [ZPlayViewController sharedSingleton];
        [itemVC setInnerPlayTabbarWithType:(ZPlayTabBarViewTypeSubscribe)];
        [itemVC setViewPlayWithCurriculumArray:array index:index];
        
        [self setShowPlayVC:itemVC animated:YES];
    } else {
        [ZProgressHUD showError:kNotFoundPlayRecord];
    }
}
///显示网页界面
-(void)showWebVCWithUrl:(NSString *)url title:(NSString *)title
{
    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
    [itemVC setWebUrl:url];
    [itemVC setTitle:title];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///显示问题详情
-(void)showQuestionDetailVC:(ModelQuestionBase *)model
{
    ZQuestionDetailViewController *itemVC = [[ZQuestionDetailViewController alloc] init];
    [itemVC setPreVC:self];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///删除问题回调方法
-(void)setDeleteQuestion:(ModelQuestionBase *)model
{
    
}
///显示答案详情
-(void)showAnswerDetailVC:(ModelAnswerBase *)model
{
    ZAnswerDetailViewController *itemVC = [[ZAnswerDetailViewController alloc] init];
    [itemVC setPreVC:self];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///删除问题回调
-(void)setDeleteAnswer:(ModelAnswerBase *)model
{
    
}
///显示答案详情-默认显示带有评论的
-(void)showAnswerDetailVC:(ModelAnswerBase *)model defaultCommentModel:(ModelAnswerComment *)modelAC
{
    ZAnswerDetailViewController *itemVC = [[ZAnswerDetailViewController alloc] init];
    [itemVC setPreVC:self];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [itemVC setDefaultCommentModel:modelAC];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///显示他人用户信息
-(void)showUserProfileVC:(ModelUserBase *)model
{
    ZUserProfileViewController *itemVC = [[ZUserProfileViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///显示他人用户信息-PreVC用来处理事件回调的
-(void)showUserProfileVC:(ModelUserBase *)model preVC:(id)preVC
{
    ZUserProfileViewController *itemVC = [[ZUserProfileViewController alloc] init];
    [itemVC setPreVC:preVC];
    [itemVC setViewDataWithModel:model];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - NavigationButtonMethod

-(void)setRightPlayButtonWithAlpha:(CGFloat)alpha
{
    [[self navigationItem] setRightBarButtonItem:nil];
    if (alpha > 0) {
        if ([[ZPlayViewController sharedSingleton] isStartPlaying]) {
            UIButton *btnRight = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [btnRight addTarget:self action:@selector(btnRightClick) forControlEvents:(UIControlEventTouchUpInside)];
            [btnRight setFrame:CGRectMake(0, 0, 55, 45)];
            [btnRight setTag:1000100010];
            [btnRight setImage:[SkinManager getImageWithName:@"playing_icon"] forState:(UIControlStateNormal)];
            [btnRight setImageEdgeInsets:(UIEdgeInsetsMake(11, 34, 11, 0))];
            
            NSMutableArray *arrImages = [NSMutableArray array];
            for (int i = 1; i < 51; i++) {
                [arrImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"playing_icon_%d",i]]];
            }
            btnRight.imageView.animationImages = arrImages;
            [btnRight.imageView setAnimationDuration:1.0f];
            [btnRight.imageView setAnimationRepeatCount:0];
            [btnRight.imageView setUserInteractionEnabled:NO];
            [btnRight.imageView startAnimating];
            [btnRight setAlpha:alpha];
            
            [btnRight setUserInteractionEnabled:YES];
            [btnRight setTitle:nil forState:(UIControlStateNormal)];
            [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btnRight]];
        } else {
            UIButton *btnRight = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [btnRight addTarget:self action:@selector(btnRightClick) forControlEvents:(UIControlEventTouchUpInside)];
            [btnRight setFrame:CGRectMake(0, 0, 55, 45)];
            [btnRight setTag:1000100010];
            [btnRight setAlpha:alpha];
            [btnRight setImage:[SkinManager getImageWithName:@"playing_icon"] forState:(UIControlStateNormal)];
            [btnRight setImageEdgeInsets:(UIEdgeInsetsMake(11, 34, 11, 0))];
            [btnRight setUserInteractionEnabled:YES];
            [btnRight setTitle:nil forState:(UIControlStateNormal)];
            [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btnRight]];
        }
    }
}

-(void)setRightPlayButton
{
    [self setRightPlayButtonWithAlpha:1.0];
}

-(void)setRightShareButton
{
    //TODO:ZWW开启AppConfig配置
    ModelAppConfig *modelAC = [sqlite getLocalAppConfigModelWithId:APP_PROJECT_VERSION];
    if (modelAC && modelAC.appStatus == 1) {
        [self setRightButtonWithImage:@"more_icon"];
    }
}

-(void)setRightButtonWithImage:(NSString*)image
{
    [[self navigationItem] setRightBarButtonItem:nil];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:image] style:(UIBarButtonItemStyleDone) target:self action:@selector(btnRightClick)];
    
    [[self navigationItem] setRightBarButtonItem:btnItem];
}

-(void)setRightButtonWithText:(NSString*)text
{
    [[self navigationItem] setRightBarButtonItem:nil];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:text style:(UIBarButtonItemStyleDone) target:self action:@selector(btnRightClick)];
    [[self navigationItem] setRightBarButtonItem:btnItem];
}

-(void)setLeftButtonWithImage:(NSString*)image
{
    [[self navigationItem] setLeftBarButtonItem:nil];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:image] style:(UIBarButtonItemStyleDone) target:self action:@selector(btnLeftClick)];
    [[self navigationItem] setLeftBarButtonItem:btnItem];
}

-(void)setLeftButtonWithImg:(UIImage*)img
{
    [[self navigationItem] setLeftBarButtonItem:nil];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithImage:img style:(UIBarButtonItemStyleDone) target:self action:@selector(btnLeftClick)];
    [[self navigationItem] setLeftBarButtonItem:btnItem];
}

-(void)setLeftButtonWithText:(NSString*)text
{
    [[self navigationItem] setLeftBarButtonItem:nil];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:text style:(UIBarButtonItemStyleDone) target:self action:@selector(btnLeftClick)];
    [[self navigationItem] setLeftBarButtonItem:btnItem];
}

-(void)btnRightClick
{
    [self setShowPlayVC];
}

-(void)btnLeftClick
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
            NSString *text = [NSString stringWithFormat:@"%@ \n %@: %@",modelP.share_content, kFilePath, url];
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
                                 [ZProgressHUD showSuccess:kAuthorSuccess];
                                 [weakSelf shareNotePlatform:type];
                             });
                             break;
                         }
                         case SSDKResponseStateFail:
                         {
                             GCDMainBlock(^{
                                 [ZProgressHUD showError:kAuthorFail];
                             });
                             break;
                         }
                         case SSDKResponseStateCancel:
                         {
                             GCDMainBlock(^{
                                 [ZProgressHUD showError:kAuthorCancel];
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
            [DataOper postAddReportWithUserId:[AppSetting getUserDetauleId] objId:ids type:type content:content resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:kReportSuccess];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                });
            }];
        }];
        ZWEAKSELF
        [reportView setOnOtherClick:^{
            ZReportViewController *itemVC = [[ZReportViewController alloc] init];
            switch (type) {
                case ZReportTypeAnswer:
                    [itemVC setTitle:kReportAnswer];
                    break;
                case ZReportTypePersion:
                    [itemVC setTitle:kReportUser];
                    break;
                case ZReportTypeQuestion:
                    [itemVC setTitle:kReportQuestion];
                    break;
                case ZReportTypeComment:
                    [itemVC setTitle:kReportComment];
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
    
}

#pragma mark - TextFieldTextDidChangeNotification

-(void)registerTextFieldTextDidChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)removeTextFieldTextDidChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - TextFieldTextDidChangeNotificationMethod

-(void)textFieldDidChange:(NSNotification *)sender
{
    [self textFieldTextDidChange:sender.object];
}

-(void)textFieldTextDidChange:(UITextField *)textField
{
    
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

-(void)postPublishQuestionNotificationWithModel:(ModelQuestion *)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPublishQuestionNotification object:model];
}

-(void)setPublishQuestion:(NSNotification *)sender
{
    [self setPublishQuestion];
}

-(void)setPublishQuestion
{
    
}

@end
