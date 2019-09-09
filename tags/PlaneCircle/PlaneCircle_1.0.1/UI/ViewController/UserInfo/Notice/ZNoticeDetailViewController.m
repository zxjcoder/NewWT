//
//  ZNoticeDetailViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZNoticeDetailViewController.h"

@interface ZNoticeDetailViewController ()

@end

@implementation ZNoticeDetailViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"我的消息"];
    
    [self innerInit];
}

- (void)setViewFrame
{
    
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

@end
