//
//  ZRootViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/28/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRootViewController.h"
#import "Utils.h"

@interface ZRootViewController ()

@end

@implementation ZRootViewController

#pragma mark - SuperMethod

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    [self innerInit];
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

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationBar setTintColor:NAVIGATION_BACKCOLOR2];
    [self.navigationBar setBarTintColor:NAVIGATION_BACKCOLOR1];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVIGATION_BACKCOLOR2}];
}

@end
