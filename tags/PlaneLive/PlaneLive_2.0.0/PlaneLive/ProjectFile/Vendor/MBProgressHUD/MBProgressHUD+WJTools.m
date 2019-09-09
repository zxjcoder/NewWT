//
//  MBProgressHUD+WJTools.m
//  Kevin
//
//  Created by Kevin on 13/1/14.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//  封装MBProgressHUD常用方法

#import "MBProgressHUD+WJTools.h"

@implementation MBProgressHUD (WJTools)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
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
    [hud hideAnimated:YES afterDelay:2.0];
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
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.2f];
    
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)dismissForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)dismiss
{
    [self dismissForView:nil];
}

@end
