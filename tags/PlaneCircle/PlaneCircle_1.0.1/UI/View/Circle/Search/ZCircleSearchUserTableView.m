//
//  ZCircleSearchUserTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleSearchUserTableView.h"
#import "ZCircleSearchUserTVC.h"

@interface ZCircleSearchUserTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) NSString *keyword;

@end

@implementation ZCircleSearchUserTableView

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
    [self setRowHeight:[ZCircleSearchUserTVC getH]];
}

-(void)setSearchKey:(NSString *)key
{
    [self setKeyword:key];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    NSArray *arrList = [dicResult objectForKey:kUserKey];
    NSMutableArray *arrHot = [NSMutableArray array];
    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in arrList) {
            ModelUserBase *model = [[ModelUserBase alloc] initWithCustom:dic];
            [arrHot addObject:model];
        }
    }
    BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
    if (isHeader) { [self.arrMain removeAllObjects]; }
    __weak typeof(self) weakSelf = self;
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

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_onOffsetChange);
    OBJC_RELEASE(_keyword);
    OBJC_RELEASE(_onRowSelected);
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
    ZCircleSearchUserTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZCircleSearchUserTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setCellKeyword:self.keyword];
    ModelUserBase *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelUserBase *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model);
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.onOffsetChange) {
        self.onOffsetChange(scrollView.contentOffset.y);
    }
}

@end
