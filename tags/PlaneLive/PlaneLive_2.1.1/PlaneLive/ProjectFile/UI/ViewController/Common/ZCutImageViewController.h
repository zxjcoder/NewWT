//
//  ZCutImageViewController.h
//  PlaneCircle
//
//  Created by Daniel on 8/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"

@class ZCutImageViewController;

@protocol ZCutImageViewControllerDelegate <NSObject>

///裁剪结束之后的图片
-(void)cutImageViewController:(ZCutImageViewController *)cutImageVC finishClipImage:(UIImage *)editImage;
///取消
-(void)cutImageViewControllerDidCancel:(ZCutImageViewController *)cutImageVC;

@end

///裁剪图片VC
@interface ZCutImageViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<ZCutImageViewControllerDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;

- (id)initWithImage:(UIImage *)originalImage;

@end