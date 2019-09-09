//
//  ZCutImageViewController.h
//  PlaneCircle
//
//  Created by Daniel on 8/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseViewController.h"

@class ZCutImageViewController;

typedef NS_ENUM(NSInteger, ZClipType)
{
    ZClipTypeCircular   = 0,   //圆形裁剪
    ZClipTypeSquare     = 1,   //方形裁剪
};

@protocol ZCutImageViewControllerDelegate <NSObject>

///裁剪结束之后的图片
-(void)cutImageViewController:(ZCutImageViewController *)cutImageVC finishClipImage:(UIImage *)editImage;

@end

///裁剪图片VC
@interface ZCutImageViewController : ZBaseViewController<UIGestureRecognizerDelegate>

///回调协议
@property (nonatomic, strong)id<ZCutImageViewControllerDelegate> delegate;
///初始化对象
-(instancetype)initWithImage:(UIImage *)image;

@end
