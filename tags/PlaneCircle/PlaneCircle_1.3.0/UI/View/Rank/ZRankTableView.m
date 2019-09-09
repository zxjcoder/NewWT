//
//  ZRankTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankTableView.h"
#import "ZRankAchievementTVC.h"
#import "ZRankHeaderTVC.h"
#import "ZRankHotTVC.h"

@interface ZRankTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZRankHeaderTVC *tvcHotHeader;
@property (strong, nonatomic) ZRankHotTVC *tvcHot;

@property (strong, nonatomic) ZRankHeaderTVC *tvcAchievementHeader;
@property (strong, nonatomic) ZRankAchievementTVC *tvcAchievement;

@property (strong, nonatomic) NSArray *tvArray;

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

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    __weak typeof(self) weakSelf = self;
    
    self.tvcHotHeader = [[ZRankHeaderTVC alloc] initWithReuseIdentifier:@"tvcHotHeader"];
    [self.tvcHotHeader setCellDataWithString:@"热门搜索"];
    
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
    
    self.tvcAchievementHeader = [[ZRankHeaderTVC alloc] initWithReuseIdentifier:@"tvcAchievementHeader"];
    [self.tvcAchievementHeader setCellDataWithString:@"业绩清单"];
    
    self.tvcAchievement = [[ZRankAchievementTVC alloc] initWithReuseIdentifier:@"tvcAchievement"];
    [self.tvcAchievement setOnLawyerClick:^{
        if (weakSelf.onLawyerClick) {
            weakSelf.onLawyerClick();
        }
    }];
    [self.tvcAchievement setOnAccountingClick:^{
        if (weakSelf.onAccountingClick) {
            weakSelf.onAccountingClick();
        }
    }];
    [self.tvcAchievement setOnSecuritiesClick:^{
        if (weakSelf.onSecuritiesClick) {
            weakSelf.onSecuritiesClick();
        }
    }];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    if (dicResult == nil) {
        self.tvArray = @[self.tvcAchievementHeader,self.tvcAchievement];
    } else {
        self.tvArray = @[self.tvcHotHeader,self.tvcHot,self.tvcAchievementHeader,self.tvcAchievement];
        
        [self.tvcHot setCellDataWithDictionary:dicResult];
    }
    
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_tvcHot);
    OBJC_RELEASE(_tvcHotHeader);
    OBJC_RELEASE(_tvcAchievement);
    OBJC_RELEASE(_tvcAchievementHeader);
    
    OBJC_RELEASE(_onLawyerClick);
    OBJC_RELEASE(_onRankUserClick);
    OBJC_RELEASE(_onAccountingClick);
    OBJC_RELEASE(_onSecuritiesClick);
    OBJC_RELEASE(_onRankCompanyClick);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tvArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBaseTVC *cell = [self.tvArray objectAtIndex:indexPath.row];
    return [cell getH];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBaseTVC *cell = [self.tvArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
