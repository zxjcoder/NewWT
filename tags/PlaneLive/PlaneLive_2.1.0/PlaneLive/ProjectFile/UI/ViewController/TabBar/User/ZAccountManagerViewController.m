//
//  ZAccountManagerViewController.m
//  PlaneLive
//
//  Created by Daniel on 07/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountManagerViewController.h"

@interface ZAccountManagerViewController ()

@end

@implementation ZAccountManagerViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kAccountManager];
    
    [self innerInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)setViewNil
{
    
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    
    [super innerInit];
}

@end
