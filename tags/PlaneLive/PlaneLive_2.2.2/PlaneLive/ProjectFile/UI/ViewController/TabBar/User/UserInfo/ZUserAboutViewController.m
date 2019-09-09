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
#import "ZBootViewController.h"

@interface ZUserAboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZBaseTableView *tvMain;

@property (strong, nonatomic) NSArray *arrMain;

@property (strong, nonatomic) ZSettingAboutTVC *tvcAbout;

@property (strong, nonatomic) ZSettingItemTVC *tvcAgreement;

@property (strong, nonatomic) ZSettingItemTVC *tvcWelcomePage;

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
    OBJC_RELEASE(_tvcAgreement);
    [_tvMain setDelegate:nil];
    [_tvMain setDataSource:nil];
    OBJC_RELEASE(_tvMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvcAbout = [[ZSettingAboutTVC alloc] initWithReuseIdentifier:@"tvcAbout"];
    self.tvcAgreement = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcAgreement" cellType:(ZSettingItemTVCTypeAgreement)];
    self.tvcWelcomePage = [[ZSettingItemTVC alloc] initWithReuseIdentifier:@"tvcWelcomePage" cellType:(ZSettingItemTVCTypeWelcomePage)];
    
    self.arrMain = @[self.tvcAbout,self.tvcWelcomePage,self.tvcAgreement];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR2];
    [self.tvMain setDataSource:self];
    [self.tvMain setDelegate:self];
    [self.view addSubview:self.tvMain];
    
    [super innerInit];
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
                [[AppDelegate app] gotoAppStoreScore];
                break;
            }
            case ZSettingItemTVCTypeAgreement:
            {
                ZWebViewController *itemVC = [[ZWebViewController alloc] init];
                [itemVC setTitle:kMyAgreement];
                NSString *weburl = [NSString stringWithFormat:@"%@%@", kWebServerUrl, kApp_ProtocolUrl];
                [itemVC setWebUrl:weburl];
                [self.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case ZSettingItemTVCTypeWelcomePage:
            {
                ZBootViewController *itemVC = [[ZBootViewController alloc] init];
                [self presentViewController:itemVC animated:NO completion:nil];
                break;
            }
            default: break;
        }
    }
}

@end
