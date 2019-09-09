//
//  ZSubscribeAlreadyTableView.m
//  PlaneLive
//
//  Created by Daniel on 05/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeAlreadyTableView.h"
#import "ZSubscribeAlreadyTVC.h"

@interface ZSubscribeAlreadyTableView()<UITableViewDelegate,UITableViewDataSource>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZSubscribeAlreadyTableView

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
    
    self.arrMain = [NSMutableArray array];
    
    [self setRowHeight:[ZSubscribeAlreadyTVC getH]];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    ZWEAKSELF
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (arrResult) {
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrResult.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStateSubscribeSetNoData)];
            } else {
                [self setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
        }
        ZWEAKSELF
        if (arrResult.count >= kPAGE_MAXCOUNT) {
            [self addRefreshFooterWithEndBlock:^{
                if (weakSelf.onRefreshFooter) {
                    weakSelf.onRefreshFooter();
                }
            }];
        } else {
            [self removeRefreshFooter];
        }
        [self.arrMain addObjectsFromArray:arrResult];
    } else {
        if (self.arrMain.count == 0) {
            [self setBackgroundViewWithState:(ZBackgroundStateFail)];
        }
    }
    [self reloadData];
}

-(void)setViewNoLoginState
{
    [self removeRefreshFooter];
    [self.arrMain removeAllObjects];
    [self setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    
    OBJC_RELEASE(_onCurriculumClick);
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
    ZSubscribeAlreadyTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZSubscribeAlreadyTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelCurriculum *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    ZWEAKSELF
    [cell setOnSubscribeClick:^(ModelCurriculum *model, int unReadCount) {
        if (weakSelf.onSubscribeClick) {
            weakSelf.onSubscribeClick(model, unReadCount);
        }
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onCurriculumClick) {
        ModelCurriculum *model = [self.arrMain objectAtIndex:indexPath.row];
        self.onCurriculumClick(model, model.unReadCount);
        
        [model setUnReadCount:0];
        ZSubscribeAlreadyTVC *cell = (ZSubscribeAlreadyTVC*)[tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setCellDataWithModel:model];
        }
    }
}

@end
