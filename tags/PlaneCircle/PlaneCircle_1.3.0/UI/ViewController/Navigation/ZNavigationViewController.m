//
//  ZNavigationViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZNavigationViewController.h"
#import "Utils.h"
#import "ZPictureViewerViewController.h"
#import "ZPracticeQuestionViewController.h"

@interface ZNavigationViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation ZNavigationViewController

#pragma mark - SuperMethod

-(void)loadView
{
    [super loadView];
    
    [self innerInit];
    
    self.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.interactivePopGestureRecognizer.delegate = self;
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

#pragma mark - UINavigationControllerDelegate

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.viewControllers.count>0){
        viewController.hidesBottomBarWhenPushed = YES;
    }
    ZNavigationBarView *barView = [viewController.view viewWithTag:10001000];
    if (!viewController.navigationBarHidden&&!barView) {
        barView = [[ZNavigationBarView alloc]initWithFrame:VIEW_NAVV_FRAME];
        [barView setBackButtonClick:^(UIButton *button) {
            [self popViewControllerAnimated:YES];
        }];
        barView.title = viewController.title;
        [barView setHiddenBackButton:self.viewControllers.count==0];
        [barView setTag:10001000];
        [viewController.view addSubview:barView];
    }
    barView.hidden = viewController.navigationBarHidden;
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    if ([viewController isKindOfClass:[ZPictureViewerViewController class]]
        || [viewController isKindOfClass:[ZPracticeQuestionViewController class]]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.interactivePopGestureRecognizer.enabled = !isRootVC;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

@end
