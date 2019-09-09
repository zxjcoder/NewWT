//
//  ZImagePickerController.m
//  PlaneCircle
//
//  Created by Daniel on 8/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZImagePickerController.h"

@interface ZImagePickerController ()

@end

@implementation ZImagePickerController

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //TODO:ZWW备注设置页面不允许全屏返回
    //[self setFd_interactivePopDisabled:YES];
    [self setEdgesForExtendedLayout:(UIRectEdgeNone)];
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
    return UIStatusBarStyleDefault;
}

-(void)innerInit
{
    [self.navigationBar setTintColor:NAVIGATIONTINTCOLOR];
    [self.navigationBar setBarTintColor:NAVIGATIONCOLOR];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVIGATIONTITLECOLOR}];
}

@end
