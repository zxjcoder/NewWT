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
#import "ZPracticeTypeSortView.h"

@interface ZPracticeTypeTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///顶部数据
@property (strong, nonatomic) ZPracticeTypeHeaderView *viewHeader;
///分类数据
@property (strong, nonatomic) ZPracticeTypeItemTVC *tvcItem;
///排序
@property (weak, nonatomic) ZPracticeTypeSortView *viewSort;
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
    [self.viewHeader setOnCancelClick:^{
        if (weakSelf.onCancelClick) {
            weakSelf.onCancelClick();
        }
    }];
    [self.viewHeader setOnSearchClick:^(NSString *content){
        if (weakSelf.onSearchClick) {
            weakSelf.onSearchClick(content);
        }
    }];
    [self.tvcItem setOnSortClick:^(int sort) {
        [weakSelf setShowSortView:sort];
    }];
    [self.tvcItem setOnTypeClick:^(ModelPracticeType *model) {
        if (weakSelf.onPracticeAllClick) {
            weakSelf.onPracticeAllClick(model);
        }
    }];
}
-(void)setShowSortView:(int)sort
{
    if (self.viewSort) {
        [self.viewSort setHiddenSortViewWithAnimate];
        self.viewSort = nil;
    } else {
        CGRect sortFrame = [self rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        ZPracticeTypeSortView *viewSort = [[ZPracticeTypeSortView alloc] initWithFrame:CGRectMake(sortFrame.size.width-105, sortFrame.origin.y+sortFrame.size.height, 100, 80)];
        [self addSubview:viewSort];
        [self bringSubviewToFront:viewSort];
        [viewSort setShowSortViewWithAnimate];
        ZWEAKSELF
        [viewSort setOnSortClick:^(int sort) {
            switch (sort) {
                case 1:
                {
                    [weakSelf.tvcItem setSortButtonTag:1];
                    [weakSelf.tvcItem setSortButtonText:kListenToTheReverse];
                    break;
                }
                default:
                {
                    [weakSelf.tvcItem setSortButtonTag:0];
                    [weakSelf.tvcItem setSortButtonText:kReverseChronologicalOrder];
                    break;
                }
            }
            if (weakSelf.onSortClick) {
                weakSelf.onSortClick(sort);
            }
            weakSelf.viewSort = nil;
        }];
        self.viewSort = viewSort;
    }
}
-(void)setSortButtonText:(NSString *)text
{
    [self.tvcItem setSortButtonText:text];
}
-(void)setTextFieldText:(NSString *)text
{
    [self.viewHeader setTextFieldText:text];
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
-(void)setPayPracticeSuccess:(ModelPractice *)model
{
    [self.arrMain enumerateObjectsUsingBlock:^(ModelPractice *modelP, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([modelP.ids isEqualToString:model.ids]) {
            [modelP setBuyStatus:1];
            *stop = YES;
        }
    }];
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.viewHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [ZPracticeTypeItemTVC getH];
    }
    return [ZPracticeItemTVC getH];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.viewSort) {
        [self.viewSort setHiddenSortView];
        self.viewSort = nil;
    }
}

@end
