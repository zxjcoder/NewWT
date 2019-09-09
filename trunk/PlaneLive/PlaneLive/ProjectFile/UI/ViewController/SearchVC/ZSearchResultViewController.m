//
//  ZSearchResultViewController.m
//  PlaneLive
//
//  Created by Daniel on 21/09/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZSearchResultViewController.h"

@interface ZSearchResultViewController ()<UISearchResultsUpdating>

@end

@implementation ZSearchResultViewController

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
    [self.view setBackgroundColor:REDCOLOR];
    [super innerInit];
}

#pragma mark - PublicMethod

-(void)setSearchText:(NSString *)text
{
    
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

@end
