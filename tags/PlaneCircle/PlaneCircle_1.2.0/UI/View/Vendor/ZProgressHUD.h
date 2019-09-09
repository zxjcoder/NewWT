//
//  ZProgressHUD.h
//  Project
//
//  Created by Daniel on 15/11/30.
//  Copyright © 2015年 Z. All rights reserved.
//

#import <UIKit/UIKit.h>

///状态提示控件
@interface ZProgressHUD : UIView

/**
 *  显示成功信息提示框
 *
 *  @param success 成功信息
 *  @param view    指定显示信息的view
 */
//+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
/**
 *  显示失败信息提示框
 *
 *  @param success 失败信息
 *  @param view    指定显示信息的view
 */
//+ (void)showError:(NSString *)error toView:(UIView *)view;
/**
 *  显示消息提示框
 *
 *  @param message 消息
 *  @param view    指定显示信息的view
 */
//+ (void)showMessage:(NSString *)message toView:(UIView *)view;
/**
 *  显示成功信息提示框
 *
 *  @param success 成功信息
 */
+ (void)showSuccess:(NSString *)success;
/**
 *  显示失败信息提示框
 *
 *  @param success 失败信息
 */
+ (void)showError:(NSString *)error;
/**
 *  显示消息提示框
 *
 *  @param message 消息
 */
+ (void)showMessage:(NSString *)message;
/**
 *  隐藏提示框
 *
 *  @param view 指定隐藏提示框的view
 */
//+ (void)dismissForView:(UIView *)view;
/**
 *  隐藏提示框
 */
+ (void)dismiss;

/**
 *  用于创建下载使用的消息弹框
 */
+ (void)showDownload:(NSString *)message;
//+ (void)showDownload:(NSString *)message toView:(UIView *)view;
/**
 *  用于改变下载使用的消息弹框
 */
+ (void)changeDownload:(NSString *)message;
//+ (void)changeDownload:(NSString *)message withView:(UIView *)view;
/**
 *  用于下载进度改变
 */
+ (void)downloadForProgress:(NSProgress *)progress;
//+ (void)downloadForProgress:(NSProgress *)progress withView:(UIView *)view;
/**
 *  用于下载结束显示
 */
+ (void)endDownload:(NSString *)message isSuccess:(BOOL)isSuccess;
//+ (void)endDownload:(NSString *)message isSuccess:(BOOL)isSuccess withView:(UIView *)view;
@end
