//
//  ZPicturePreViewController.m
//  PlaneCircle
//
//  Created by Daniel on 8/9/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPicturePreViewController.h"

@interface ZPicturePreViewController ()

@end

@implementation ZPicturePreViewController

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
    
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    
}

- (void)setViewFrame
{
    
}

@end
