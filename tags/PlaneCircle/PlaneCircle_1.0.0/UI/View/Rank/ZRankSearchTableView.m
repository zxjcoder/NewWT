//
//  ZRankSearchTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankSearchTableView.h"
#import "ZRankSearchTVC.h"

@interface ZRankSearchTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZRankSearchTableView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.arrMain = [NSMutableArray array];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setTableHeaderView:nil];
    [self setRowHeight:[ZRankSearchTVC getH]];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [self.arrMain removeAllObjects];
    NSDictionary *dicData = [dicResult objectForKey:kResultKey];
    if (dicData && [dicData isKindOfClass:[NSDictionary class]]) {
        NSArray *arrCommpany = [dicData objectForKey:@"company"];
        if (arrCommpany && [arrCommpany isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrCommpany) {
                ModelRankCompany *model = [[ModelRankCompany alloc] initWithCustom:dic];
                [self.arrMain addObject:model];
            }
        }
        
        NSArray *arrUser = [dicData objectForKey:@"companyStaff"];
        if (arrUser && [arrUser isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrUser) {
                ModelRankUser *model = [[ModelRankUser alloc] initWithCustom:dic];
                [self.arrMain addObject:model];
            }
        }
    }
    [self reloadData];
}

-(void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZRankSearchTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZRankSearchTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelEntity *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelEntity *model = [self.arrMain objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[ModelRankUser class]]) {
        if (self.onRankUserClick) {
            ModelRankUser *modelRU = (ModelRankUser*)model;
            self.onRankUserClick(modelRU);
        }
    } else if ([model isKindOfClass:[ModelRankCompany class]]) {
        if (self.onRankCompanyClick) {
            ModelRankCompany *modelRC = (ModelRankCompany*)model;
            self.onRankCompanyClick(modelRC);
        }
    }
}

@end
