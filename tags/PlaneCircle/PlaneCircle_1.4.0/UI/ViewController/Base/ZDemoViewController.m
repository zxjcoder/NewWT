//
//  ZDemoViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/3/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZDemoViewController.h"

@interface ZDemoViewController ()

@end

@implementation ZDemoViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kEmpty];
    
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
