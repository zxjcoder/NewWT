//
//  ZMyQuestionAllTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyQuestionAllTableView.h"
#import "ZMyQuestionTVC.h"

@interface ZMyQuestionAllTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyQuestionAllTableView

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
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    [self setTableHeaderView:nil];
    [self setRowHeight:[ZMyQuestionTVC getH]];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    
    NSArray *arrList = [dicResult objectForKey:kResultKey];
    NSMutableArray *arrHot = [NSMutableArray array];
    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in arrList) {
            ModelQuestionDetail *model = [[ModelQuestionDetail alloc] initWithCustom:dic];
            [arrHot addObject:model];
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
        if (arrList.count == 0 || isRefresh) {
            [self setBackgroundViewWithState:(ZBackgroundStateNull)];
        }
    }
    if (arrHot.count >= kPAGE_MAXCOUNT) {
        [self addRefreshFooterWithEndBlock:^{
            if (weakSelf.onRefreshFooter) {
                weakSelf.onRefreshFooter();
            }
        }];
    } else {
        [self removeRefreshFooter];
    }
    [self.arrMain addObjectsFromArray:arrHot];
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
    ZMyQuestionTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyQuestionTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    [cell setViewIsDelete:self.isDelete];
    
    [cell setTag:indexPath.row];
    
    ModelQuestionDetail *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    [cell setOnDeleteClick:^(ModelQuestionDetail *model, ZMyQuestionTVC *tvc) {
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
    ModelQuestionDetail *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
