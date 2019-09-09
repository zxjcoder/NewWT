//
//  ZFeekBackSuccessViewController.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFeekBackSuccessViewController.h"
#import "ZFeekBackSuccessView.h"
#import "ZFeekBackRecordViewController.h"

@interface ZFeekBackSuccessViewController ()

@property (strong, nonatomic) NSString *prompt;

@end

@implementation ZFeekBackSuccessViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kFeedback];
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
    ZFeekBackSuccessView *viewMain = [[ZFeekBackSuccessView alloc] initWithFrame:VIEW_ITEM_FRAME title:self.prompt];
    ZWEAKSELF
    [viewMain setOnSayRecordClick:^{
        ZFeekBackRecordViewController *itemVC = [[ZFeekBackRecordViewController alloc] init];
        [weakSelf.navigationController pushViewController:itemVC animated:true];
    }];
    [self.view addSubview:viewMain];
    
    [super innerInit];
}
/// 设置提示语
-(void)setPromptText:(NSString *)prompt
{
    [self setPrompt:prompt];
}
-(void)btnBackClick
{
    [self.navigationController popToRootViewControllerAnimated:true];
}
-(void)btnLeftClick
{
    [self.navigationController popToRootViewControllerAnimated:true];
}

@end
