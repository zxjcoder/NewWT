//
//  ZSubscribeEachWatchTableView.m
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeEachWatchTableView.h"
#import "ZSubscribeEachWatchTVC.h"

@interface ZSubscribeEachWatchTableView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZSubscribeEachWatchTableView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
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
    
    self.arrMain = [NSMutableArray array];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setRowHeight:[ZSubscribeEachWatchTVC getH]];
}
/// 设置数据源
-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    if (arrResult) {
        if (isHeader) {
            [self.arrMain removeAllObjects];
        }
        [self.arrMain addObjectsFromArray:arrResult];
    }
    CGFloat tvContentH = 0;
    if (self.arrMain.count > 0) {
        tvContentH = self.arrMain.count * self.rowHeight;
    }
    if (self.onTableViewHeightChange) {
        self.onTableViewHeightChange(tvContentH);
    }
    [self reloadData];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZSubscribeEachWatchTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZSubscribeEachWatchTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelCurriculum *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onCurriculumClick) {
        ModelCurriculum *model = [self.arrMain objectAtIndex:indexPath.row];
        self.onCurriculumClick(model);
    }
}


@end
