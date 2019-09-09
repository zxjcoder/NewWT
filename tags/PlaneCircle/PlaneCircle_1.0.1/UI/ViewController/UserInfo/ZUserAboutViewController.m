//
//  ZUserAboutViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserAboutViewController.h"
#import "ZAboutView.h"

@interface ZUserAboutViewController ()

@property (strong, nonatomic) ZAboutView *viewMain;

@end

@implementation ZUserAboutViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"关于"];
    
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
    OBJC_RELEASE(_viewMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.viewMain = [[ZAboutView alloc] init];
    [self.view addSubview:self.viewMain];
    
    [self setViewFrame];
}

- (void)setViewFrame
{
    [self.viewMain setFrame:VIEW_MAIN_FRAME];
}

@end
