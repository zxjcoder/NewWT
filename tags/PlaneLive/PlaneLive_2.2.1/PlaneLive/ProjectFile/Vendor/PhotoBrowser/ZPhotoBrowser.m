//
//  ZPhotoBrowser.m
//  PlaneLive
//
//  Created by Daniel on 28/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZPhotoBrowser.h"

@interface ZPhotoBrowser()<MWPhotoBrowserDelegate>

@property (strong, nonatomic) NSMutableArray *arrayPhoto;

@end

@implementation ZPhotoBrowser

#pragma mark - SuperMethod

- (void)viewDidLoad {
    [super viewDidLoad];
    //TODO:ZWW备注设置页面不允许全屏返回
    //[self setFd_interactivePopDisabled:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - PrivateMethod

- (NSMutableArray *)arrayPhoto {
    if (!_arrayPhoto) {
        _arrayPhoto = [NSMutableArray array];
    }
    return _arrayPhoto;
}

#pragma mark - PublicMethod

- (instancetype)initWithPhotos:(NSArray *)arrPhoto index:(NSInteger)index {
    self = [super initWithDelegate:self];
    if (self) {
        for (id obj in arrPhoto) {
            if ([obj isKindOfClass:[NSString class]]) {
                [self.arrayPhoto addObject:[MWPhoto photoWithURL:[NSURL URLWithString:obj]]];
            } else if ([obj isKindOfClass:[NSURL class]]) {
                [self.arrayPhoto addObject:[MWPhoto photoWithURL:obj]];
            }
        }
        [self setDisplayActionButton:NO];
        [self showNextPhotoAnimated:YES];
        [self showPreviousPhotoAnimated:YES];
        [self setCurrentPhotoIndex:index];
        [self reloadData];
    }
    return self;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.arrayPhoto.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.arrayPhoto.count) {
        return [self.arrayPhoto objectAtIndex:index];
    }
    return nil;
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)(index+1), (unsigned long)self.arrayPhoto.count];
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.arrayPhoto.count) {
        return [self.arrayPhoto objectAtIndex:index];
    }
    return nil;
}
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    GBLog(@"MWPhotoBrowserCurrentIndex: %lu", (unsigned long)index);
}
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
