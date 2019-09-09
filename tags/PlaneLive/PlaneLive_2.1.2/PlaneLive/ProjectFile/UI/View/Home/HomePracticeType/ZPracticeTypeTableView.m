//
//  ZPracticeTypeTableView.m
//  PlaneLive
//
//  Created by Daniel on 02/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeTypeTableView.h"
#import "ZPracticeItemTVC.h"
#import "ZPracticeTypeHeaderView.h"
#import "ZPracticeTypeItemTVC.h"

@interface ZPracticeTypeTableView()<UITableViewDelegate,UITableViewDataSource>

///顶部数据
@property (strong, nonatomic) ZPracticeTypeHeaderView *viewHeader;
///分类数据
@property (strong, nonatomic) ZPracticeTypeItemTVC *tvcItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZPracticeTypeTableView

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
    
    self.viewHeader = [[ZPracticeTypeHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, [ZPracticeTypeHeaderView getViewH])];
    self.tvcItem = [[ZPracticeTypeItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    ZWEAKSELF
    /*[self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];*/
    [self.viewHeader setOnCancelClick:^{
        if (weakSelf.onCancelClick) {
            weakSelf.onCancelClick();
        }
    }];
    [self.viewHeader setOnSearchClick:^{
        if (weakSelf.onSearchClick) {
            weakSelf.onSearchClick();
        }
    }];
    
    [self.tvcItem setOnSortClick:^(BOOL isAscending) {
        if (weakSelf.onSortClick) {
            weakSelf.onSortClick(isAscending);
        }
    }];
    [self.tvcItem setOnTypeClick:^(ModelPracticeType *model) {
        if (weakSelf.onPracticeAllClick) {
            weakSelf.onPracticeAllClick(model);
        }
    }];
}
-(void)setViewTypeDataWithArray:(NSArray *)arrResult
{
    [self.tvcItem setViewDataWithArray:arrResult];
    [self reloadData];
}
-(void)setViewPracticeDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (isHeader) {
        [self.arrMain removeAllObjects];
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
    
    [self reloadData];
}
-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_onPracticeAllClick);
    OBJC_RELEASE(_onPracticeClick);
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.viewHeader.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [ZPracticeTypeItemTVC getH];
    }
    return [ZPracticeItemTVC getH];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.viewHeader;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.tvcItem;
    }
    static NSString *cellid = @"tvcellid";
    ZPracticeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZPracticeItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelPracticeType *model = [self.arrMain objectAtIndex:indexPath.row-1];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    if (self.onPracticeClick) {
        self.onPracticeClick(self.arrMain, indexPath.row-1);
    }
}

@end
