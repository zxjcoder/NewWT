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

@interface ZBaseViewController ()

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
    
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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

-(void)setViewDataWithModel:(ModelEntity *)model
{
    
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
//    [itemVC setPreVC:self];
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

-(void)showLoginVC
{
    [self.view endEditing:YES];
    ZLoginViewController *itemVC = [[ZLoginViewController alloc] init];
    [itemVC setNavigationBarHidden:YES];
    [self presentViewController:[[ZNavigationViewController alloc] initWithRootViewController:itemVC] animated:YES completion:nil];
}

#pragma mark - PrivateMethod

-(void)innerBaseInit
{
    [self setEdgesForExtendedLayout:(UIRectEdgeNone)];
    
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
        [btnRight setFrame:CGRectMake(self.view.width-60, 10, 60, 55)];
        [btnRight setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 0, 10))];
        [btnRight setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [btnRight setTitle:nil forState:(UIControlStateNormal)];
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
    [btnRight setFrame:CGRectMake(self.view.width-60, 10, 60, 55)];
    [btnRight setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [btnRight setTitleEdgeInsets:(UIEdgeInsetsMake(10, 5, 0, 5))];
    [btnRight setTitle:text forState:(UIControlStateNormal)];
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
    if (![WXApi isWXAppInstalled] ||
        ![WXApi isWXAppSupportApi]) {
        SafariOpen([WXApi getWXAppInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeWeChatSession];
}
///微信朋友圈分享
-(void)btnWeChatCircleClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![WXApi isWXAppInstalled] ||
        ![WXApi isWXAppSupportApi]) {
        SafariOpen([WXApi getWXAppInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeWeChatTimeline];
}
///QQ好友分享
-(void)btnQQClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![QQApiInterface isQQInstalled] ||
        ![QQApiInterface isQQSupportApi]) {
        SafariOpen([QQApiInterface getQQInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeQQFriend];
}
///QQ空间分享
-(void)btnQZoneClick
{
    //TODO:ZWW备注-判断是否安装了微信和QQ
    if (![QQApiInterface isQQInstalled] ||
        ![QQApiInterface isQQSupportApi]) {
        SafariOpen([QQApiInterface getQQInstallUrl]);
        return;
    }
    [self shareWithType:WTPlatformTypeQzone];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    
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

@end
