//
//  ZRankTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankTableView.h"
#import "ZRankAchievementView.h"
#import "ZRankHotTVC.h"

@interface ZRankTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZRankAchievementView *viewAchievement;

@property (strong, nonatomic) ZRankHotTVC *tvcHot;

@end

@implementation ZRankTableView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    __weak typeof(self) weakSelf = self;
    self.tvcHot = [[ZRankHotTVC alloc] initWithReuseIdentifier:@"tvcHot"];
    [self.tvcHot setOnRankUserClick:^(ModelRankUser *model) {
        if (weakSelf.onRankUserClick) {
            weakSelf.onRankUserClick(model);
        }
    }];
    [self.tvcHot setOnRankCompanyClick:^(ModelRankCompany *model) {
        if (weakSelf.onRankCompanyClick) {
            weakSelf.onRankCompanyClick(model);
        }
    }];
    
    self.viewAchievement = [[ZRankAchievementView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_HEIGHT, [ZRankAchievementView getViewH])];
    [self.viewAchievement setOnLawyerClick:^{
        if (weakSelf.onLawyerClick) {
            weakSelf.onLawyerClick();
        }
    }];
    [self.viewAchievement setOnAccountingClick:^{
        if (weakSelf.onAccountingClick) {
            weakSelf.onAccountingClick();
        }
    }];
    [self.viewAchievement setOnSecuritiesClick:^{
        if (weakSelf.onSecuritiesClick) {
            weakSelf.onSecuritiesClick();
        }
    }];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR2];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [self.tvcHot setCellDataWithDictionary:dicResult];
    
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        __weak typeof(self) weakSelf = self;
        [self addRefreshHeaderWithEndBlock:^{
            if (weakSelf.onRefreshHeader) {
                weakSelf.onRefreshHeader();
            }
        }];
    }
    
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_tvcHot);
    OBJC_RELEASE(_onLawyerClick);
    OBJC_RELEASE(_onRankUserClick);
    OBJC_RELEASE(_onRefreshHeader);
    OBJC_RELEASE(_viewAchievement);
    OBJC_RELEASE(_onAccountingClick);
    OBJC_RELEASE(_onSecuritiesClick);
    OBJC_RELEASE(_onRankCompanyClick);
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.tvcHot.getH;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return [ZRankAchievementView getViewH];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    return self.viewAchievement;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.tvcHot;
    }
    static NSString *cellid = @"tvcellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellid];
    }
    return cell;
}

@end
