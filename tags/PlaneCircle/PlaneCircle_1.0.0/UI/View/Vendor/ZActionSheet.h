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

- (id)initWithTitle:(NSString *)title delegate:(id<ZActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;

- (void)show;

@end
