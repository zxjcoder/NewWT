//
//  ZToolbar.m
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZToolbar.h"
#import "ClassCategory.h"

@implementation ZToolbar

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
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.8)];
    [imgLine setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self addSubview:imgLine];
    OBJC_RELEASE(imgLine);
    
    UIBarButtonItem *btnFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:self action:nil];
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@  ", kDone] style:(UIBarButtonItemStyleDone) target:self action:@selector(btnDoneClick)];
    [self setItems:@[btnFlexibleSpace, btnDone]];
    OBJC_RELEASE(btnFlexibleSpace);
    OBJC_RELEASE(btnDone);
}

-(void)btnDoneClick
{
    if (self.onDoneClick) {
        self.onDoneClick();
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_onDoneClick);
}

@end
