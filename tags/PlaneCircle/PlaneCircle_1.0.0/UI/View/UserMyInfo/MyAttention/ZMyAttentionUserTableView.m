//
//  ZMyAttentionUserTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAttentionUserTableView.h"
#import "ZMyUserInfoTVC.h"

@interface ZMyAttentionUserTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyAttentionUserTableView

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
    [self setRowHeight:[ZMyUserInfoTVC getH]];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    
    NSArray *arrList = [dicResult objectForKey:@"myAttentUsers"];
    NSMutableArray *arrR = [NSMutableArray array];
    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in arrList) {
            ModelUserBase *model = [[ModelUserBase alloc] initWithCustom:dic];
            [arrR addObject:model];
        }
    }
    __weak typeof(self) weakSelf = self;
    BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
    if (isHeader) {
        [self.arrMain removeAllObjects];
        [self addRefreshHeaderWithEndBlock:^{
            if (weakSelf.onRefreshHeader) {
                weakSelf.onRefreshHeader();
            }
        }];
        BOOL isRefresh = [[dicResult objectForKey:kIsRefreshKey] boolValue];
        if (arrR.count == 0 || isRefresh) {
            [self setBackgroundViewWithState:(ZBackgroundStateNull)];
        }
    }
    if (arrR.count >= kPAGE_MAXCOUNT) {
        [self addRefreshFooterWithEndBlock:^{
            if (weakSelf.onRefreshFooter) {
                weakSelf.onRefreshFooter();
            }
        }];
    } else {
        [self removeRefreshFooter];
    }
    [self.arrMain addObjectsFromArray:arrR];
    [self reloadData];
}
-(void)setViewIsDelete:(BOOL)isDel
{
    [self setIsDelete:isDel];
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
    ZMyUserInfoTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyUserInfoTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    [cell setViewIsDelete:self.isDelete];
    
    ModelUserBase *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    [cell setTag:indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [cell setOnDeleteClick:^(ModelUserBase *model, ZMyUserInfoTVC *tvc) {
        if (weakSelf.onDeleteClick) {
            weakSelf.onDeleteClick(model);
        }
        [weakSelf.arrMain removeObjectAtIndex:tvc.tag];
        [weakSelf deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tvc.tag inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelUserBase *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
