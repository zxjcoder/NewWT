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
    return UIStatusBarStyleLightContent;
}

-(void)innerInit
{
    [self.navigationBar setTranslucent:NO];
//    [self.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationBar setTintColor:NAVIGATION_BACKCOLOR2];
    [self.navigationBar setBarTintColor:NAVIGATION_BACKCOLOR1];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVIGATION_BACKCOLOR2}];
}

@end
