//
//  ZActionSheet.h
//  Product
//
//  Created by Daniel on 15/8/3.
//  Copyright (c) 2015年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZActionSheet;

@protocol ZActionSheetDelegate <NSObject>

@required
- (void)actionSheet:(ZActionSheet*)actionSheet didButtonClickWithIndex:(NSInteger)buttonIndex;

@optional
- (void)actionSheetDidClickOnDestructiveButton;
- (void)actionSheetDidClickOnCancelButton;

@end

///多选控件
@interface ZActionSheet : UIView

///初始化控件
- (id)initWithTitle:(NSString *)title delegate:(id<ZActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;

///初始化系统控件
- (id)initSystemWithTitle:(NSString *)title delegate:(id<ZActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;

///图片选择
- (id)initWithPictureSelectionDelegate:(id<ZActionSheetDelegate>)delegate;

///显示
- (void)show;
///显示在某个View中
- (void)showInView:(UIView *)view;

@end
