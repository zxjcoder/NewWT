//
//  ZSubscribeContinuousSowingTableView.m
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeContinuousSowingTableView.h"

#import "ZSubscribeContinuousSowingTVC.h"

@interface ZSubscribeContinuousSowingTableView()<UITableViewDelegate, UITableViewDataSource>

///计算高度
@property (strong, nonatomic) ZSubscribeContinuousSowingTVC *tvcItem;

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZSubscribeContinuousSowingTableView

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
    
    self.tvcItem = [[ZSubscribeContinuousSowingTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
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
    for (ModelCurriculum *model in self.arrMain) {
        tvContentH = tvContentH + [self.tvcItem setCellDataWithModel:model];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCurriculum *modelC = [self.arrMain objectAtIndex:indexPath.row];
    return [self.tvcItem setCellDataWithModel:modelC];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZSubscribeContinuousSowingTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZSubscribeContinuousSowingTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelCurriculum *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onCurriculumClick) {
        self.onCurriculumClick(self.arrMain, indexPath.row);
    }
}

@end
