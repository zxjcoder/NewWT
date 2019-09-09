//
//  ZQuestionToolbar.m
//  PlaneCircle
//
//  Created by Daniel on 6/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionToolbar.h"
#import "ClassCategory.h"

@interface ZQuestionToolbar()

@end

@implementation ZQuestionToolbar

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 40)];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    //设置背景颜色
    [self setBarTintColor:WHITECOLOR];
    //设置文字颜色
    [self setTintColor:MAINCOLOR];
    //设置样式
    [self setBarStyle:(UIBarStyleDefault)];
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.8)];
    [imgLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:imgLine];
    OBJC_RELEASE(imgLine);
    
    UIButton *btnDoneC = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnDoneC setImage:[SkinManager getImageWithName:@"btn_wentixiangqing_zhankai"] forState:(UIControlStateNormal)];
    [btnDoneC setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [btnDoneC addTarget:self action:@selector(btnDoneClick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnDoneC setFrame:CGRectMake(0, 0, 40, 40)];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithCustomView:btnDoneC];
    
    UIBarButtonItem *btnFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:self action:nil];
    
    UIButton *btnPhotoC = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnPhotoC setImage:[SkinManager getImageWithName:@"icon_tuku"] forState:(UIControlStateNormal)];
    [btnPhotoC setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [btnPhotoC addTarget:self action:@selector(btnPhotoClick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnPhotoC setFrame:CGRectMake(0, 0, 40, 40)];
    UIBarButtonItem *btnPhoto = [[UIBarButtonItem alloc] initWithCustomView:btnPhotoC];
    
//    UIButton *btnCameraC = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [btnCameraC setImage:[SkinManager getImageWithName:@"icon_paizhao"] forState:(UIControlStateNormal)];
//    [btnCameraC setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
//    [btnCameraC addTarget:self action:@selector(btnCameraClick) forControlEvents:(UIControlEventTouchUpInside)];
//    [btnCameraC setFrame:CGRectMake(0, 0, 40, 40)];
//    UIBarButtonItem *btnCamera = [[UIBarButtonItem alloc] initWithCustomView:btnCameraC];
    
    [self setItems:@[btnDone, btnFlexibleSpace, btnPhoto]];
    
    OBJC_RELEASE(btnFlexibleSpace);
    OBJC_RELEASE(btnDone);
    OBJC_RELEASE(btnPhoto);
    OBJC_RELEASE(btnDoneC);
    OBJC_RELEASE(btnPhotoC);
}

-(void)btnDoneClick
{
    if (self.onDoneClick) {
        self.onDoneClick();
    }
}

-(void)btnPhotoClick
{
    if (self.onPhotoClick) {
        self.onPhotoClick();
    }
}

-(void)btnCameraClick
{
    if (self.onCameraClick) {
        self.onCameraClick();
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_onDoneClick);
    OBJC_RELEASE(_onPhotoClick);
    OBJC_RELEASE(_onCameraClick);
}

@end
