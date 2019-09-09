//
//  ZRankDownloadViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankDownloadViewController.h"

@interface ZRankDownloadViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>


@end

@implementation ZRankDownloadViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    OBJC_RELEASE(_xlsUrl);
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
    [self setDelegate:self];
    [self setDataSource:self];
}

#pragma mark - QLPreviewControllerDataSource

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}
- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:self.xlsUrl];
}

#pragma mark - QLPreviewControllerDelegate

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    [self setViewNil];
}

@end

