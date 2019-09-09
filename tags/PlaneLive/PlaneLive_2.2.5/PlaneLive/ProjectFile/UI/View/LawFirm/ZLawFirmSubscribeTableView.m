//
//  ZLawFirmSubscribeTableView.m
//  PlaneLive
//
//  Created by Daniel on 13/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmSubscribeTableView.h"
#import "ZNewCoursesItemTVC.h"

@interface ZLawFirmSubscribeTableView()<UITableViewDelegate,UITableViewDataSource>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZLawFirmSubscribeTableView

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
    
    [self setRowHeight:[ZNewCoursesItemTVC getH]];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    ZWEAKSELF
    [self setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    if (arrResult) {
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrResult.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStateNull)];
            }
        }
        ZWEAKSELF
        if (arrResult.count >= kPAGE_MAXCOUNT) {
            [self setRefreshFooterWithEndBlock:^{
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

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    
    OBJC_RELEASE(_onSubscribeClick);
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
    ZNewCoursesItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZNewCoursesItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelSubscribe *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onSubscribeClick) {
        ModelSubscribe *model = [self.arrMain objectAtIndex:indexPath.row];
        self.onSubscribeClick(model);
    }
}


@end
