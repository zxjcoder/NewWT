//
//  ZCircleTopicTableView.m
//  PlaneCircle
//
//  Created by Daniel on 7/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleTopicTableView.h"
#import "ZCircleTopicTVC.h"

@interface ZCircleTopicTableView()<UITableViewDelegate,UITableViewDataSource>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZCircleTopicTableView

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
    [self setRowHeight:[ZCircleTopicTVC getH]];
    
    __weak typeof(self) weakSelf = self;
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [super setViewDataWithDictionary:dicResult];
    //TODO:ZWW备注-处理新版圈子话题
//    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
//        BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
//        NSArray *arrList = [dicResult objectForKey:kResultKey];
//        NSMutableArray *arrHot = [NSMutableArray array];
//        if (arrList && [arrList isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *dic in arrList) {
//                ModelCircleNew *model = [[ModelCircleNew alloc] initWithCustom:dic];
//                [arrHot addObject:model];
//            }
//        }
//        __weak typeof(self) weakSelf = self;
//        if (isHeader) {
//            [self.arrMain removeAllObjects];
//            if (arrHot.count == 0) {
//                [self removeRefreshHeader];
//                [self setBackgroundViewWithState:(ZBackgroundStateNull)];
//            } else {
//                [self setBackgroundViewWithState:(ZBackgroundStateNone)];
//            }
//        }
//        if (arrHot.count >= kPAGE_MAXCOUNT) {
//            [self addRefreshFooterWithEndBlock:^{
//                if (weakSelf.onRefreshFooter) {
//                    weakSelf.onRefreshFooter();
//                }
//            }];
//        } else {
//            [self removeRefreshFooter];
//        }
//        [self.arrMain addObjectsFromArray:arrHot];
//    }
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_onAllClick);
    OBJC_RELEASE(_onItemClick);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZCircleTopicTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZCircleTopicTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelTagType *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    [cell setOnAllClick:^(ModelTagType *model) {
        if (weakSelf.onAllClick) {
            weakSelf.onAllClick(model);
        }
    }];
    [cell setOnItemClick:^(ModelTag *model) {
        if (weakSelf.onItemClick) {
            weakSelf.onItemClick(model);
        }
    }];
    
    return cell;
}

@end
