//
//  ZBootViewController.m
//  PlaneLive
//
//  Created by Daniel on 20/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBootViewController.h"
#import "ZBootView.h"
#import "SQLiteOper.h"

@interface ZBootViewController ()

@end

@implementation ZBootViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ZWEAKSELF
    ZBootView *bootView = [[ZBootView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    [bootView setOnStartClick:^{
        [sqlite setSysParam:kSQLITE_FRIST_START value:@"YES"];
        
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
    [self.view addSubview:bootView];
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
    
}
-(void)dealloc
{
    [self setViewNil];
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

@end
