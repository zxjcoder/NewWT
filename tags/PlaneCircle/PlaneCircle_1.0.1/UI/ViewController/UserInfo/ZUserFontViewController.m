//
//  ZUserFontViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserFontViewController.h"

@interface ZUserFontViewController ()

@end

@implementation ZUserFontViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"字体大小"];
    
    [self innerInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithText:@"完成"];
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

-(void)btnRightClick
{
    
}

@end
