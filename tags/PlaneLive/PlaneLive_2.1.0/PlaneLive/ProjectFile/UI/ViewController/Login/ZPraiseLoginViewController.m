//
//  ZPraiseLoginViewController.m
//  PlaneLive
//
//  Created by Daniel on 03/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPraiseLoginViewController.h"

@interface ZPraiseLoginViewController ()

@end

@implementation ZPraiseLoginViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kPraiseLogin];
    
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
