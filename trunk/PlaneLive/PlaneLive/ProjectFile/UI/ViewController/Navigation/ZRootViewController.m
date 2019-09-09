//
//  ZRootViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/28/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRootViewController.h"
#import "Utils.h"
#import "ZPlayerViewController.h"
#import "ZPhotoBrowser.h"
#import "ZTransitionAnimation.h"
#import "ZBaseTransitionAnimation.h"

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
    [self.navigationBar setShadowImage:[[UIImage createImageWithColor:[UIColor whiteColor]] setImageAlpha:0]];
}

#pragma mark - UINavigationControllerDelegate

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    [super pushViewController:viewController animated:animated];
//    if (IsIPhoneX) {
//        // 修改tabBra的frame
//        CGRect frame = self.tabBarController.tabBar.frame;
//        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
//        self.tabBarController.tabBar.frame = frame;
//    }
//}
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        if ([toVC isMemberOfClass:[ZPlayerViewController class]]) {
            return [[ZTransitionAnimation alloc] initWithStytle:(ZTransitionAnimationTypePush)];
        }
        return [[ZBaseTransitionAnimation alloc] initWithStytle:(ZTransitionAnimationTypePush)];
    }
    if ([fromVC isMemberOfClass:[ZPlayerViewController class]]) {
        return [[ZTransitionAnimation alloc] initWithStytle:(ZTransitionAnimationTypePop)];
    }
    return [[ZBaseTransitionAnimation alloc] initWithStytle:(ZTransitionAnimationTypePop)];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    GBLog(@"gestureRecognizer: %@, visibleViewController: %@", [gestureRecognizer class], [self.visibleViewController class]);
    if ([self.visibleViewController isMemberOfClass:[ZPlayerViewController class]]) {
        return false;
    }
    return [gestureRecognizer isMemberOfClass:[UIScreenEdgePanGestureRecognizer class]];
}

@end
