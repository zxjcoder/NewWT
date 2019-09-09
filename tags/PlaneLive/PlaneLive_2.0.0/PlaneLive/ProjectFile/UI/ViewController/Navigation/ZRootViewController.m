//
//  ZRootViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/28/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRootViewController.h"
#import "Utils.h"
#import "ZPlayViewController.h"
#import "ZPictureViewerViewController.h"

@interface ZRootViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
    
    [self setDelegate:self];
    
    [[self interactivePopGestureRecognizer] setDelegate:self];
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

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setBarStyle:(UIBarStyleDefault)];
    [self.navigationBar setTintColor:NAVIGATIONTINTCOLOR];
    [self.navigationBar setBarTintColor:NAVIGATIONCOLOR];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVIGATIONTITLECOLOR}];
}

#pragma mark - UINavigationControllerDelegate

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
        if ([viewController isKindOfClass:[ZPictureViewerViewController class]] ||
            [viewController isKindOfClass:[ZPlayViewController class]]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.interactivePopGestureRecognizer.enabled = !isRootVC;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

@end
