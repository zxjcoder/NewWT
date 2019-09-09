//
//  ZProgressHUD.m
//  Project
//
//  Created by Daniel on 15/11/30.
//  Copyright © 2015年 Z. All rights reserved.
//

#import "ZProgressHUD.h"
#import "MBProgressHUD+WJTools.h"

@implementation ZProgressHUD

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 2秒之后再消失
    [hud hideAnimated:YES afterDelay:2.0f];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self show:error icon:@"mbicon_error.png" view:view];
}

#pragma mark 显示成功信息
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"mbicon_success.png" view:view];
}

#pragma mark 显示一些信息
+ (void)showMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.2f];
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)showMessage:(NSString *)message
{
    [self showMessage:message toView:nil];
}

+ (void)dismissForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)dismiss
{
    [self dismissForView:nil];
}

@end
