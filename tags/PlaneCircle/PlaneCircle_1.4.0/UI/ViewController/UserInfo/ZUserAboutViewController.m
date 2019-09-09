//
//  ZUserAboutViewController.m
//  PlaneCircle
//
//  Created by Daniel on 7/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserAboutViewController.h"
#import "ZSettingAboutTVC.h"
#import "ZSettingItemTVC.h"
#import "ZWebViewController.h"

@interface ZUserAboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) ZSettingAboutTVC *tvcAbout;
//@property (strong, nonatomic) ZSettingItemTVC *tvcScore;
@property (strong, nonatomic) ZSettingItemTVC *tvcAgreement;

@end

@implementation ZUserAboutViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kAbout];
    
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
    OBJC_RELEASE(_tvcAbout);
//    OBJC_RELEASE(_tvcScore);
    OBJC_RELEASE(_tvcAgreement);
    [_tvMain setDelegate:nil];
    [_tvMain setDataSource:nil];
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
//    self.tvcScore = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcScore" cellType:(ZSettingItemTVCTypeScore)];
    self.tvcAgreement = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcAgreement" cellType:(ZSettingItemTVCTypeAgreement)];
    self.tvcAbout = [[ZSettingAboutTVC alloc] initWithReuseIdentifier:@"tvcAbout"];
    
    self.arrMain = @[self.tvcAbout,self.tvcAgreement];
    
    self.tvMain = [[ZTableView alloc] init];
    [self.tvMain innerInit];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
}

- (void)setViewFrame
{
    [self.tvMain setFrame:VIEW_ITEM_FRAME];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBaseTVC *cell = [self.arrMain objectAtIndex:indexPath.row];
    return [cell getH];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrMain objectAtIndex:indexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBaseTVC *cell = [self.arrMain objectAtIndex:indexPath.row];
    if ([cell isKindOfClass:[ZSettingItemTVC class]]) {
        ZSettingItemTVCType type = [(ZSettingItemTVC*)cell type];
        switch (type) {
            case ZSettingItemTVCTypeScore:
            {
                //添加统计事件
                [StatisticsManager event:kEvent_User_Setting_Score category:kCategory_User];
                
                [[AppDelegate app] gotoAppStoreScore];
                break;
            }
            case ZSettingItemTVCTypeAgreement:
            {
                //添加统计事件
                [StatisticsManager event:kEvent_User_Setting_Agreement category:kCategory_User];
                
                ZWebViewController *itemVC = [[ZWebViewController alloc] init];
                [itemVC setTitle:kMyAgreement];
                [itemVC setWebUrl:kApp_ProtocolUrl];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            default: break;
        }
    }
}

@end
