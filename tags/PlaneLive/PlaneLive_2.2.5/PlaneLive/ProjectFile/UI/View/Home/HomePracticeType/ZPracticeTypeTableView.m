//
//  ZPracticeTypeTableView.m
//  PlaneLive
//
//  Created by Daniel on 02/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeTypeTableView.h"
#import "ZNewPracticeItemTVC.h"
#import "ZPracticeTypeHeaderView.h"
#import "ZPracticeTypeHeaderView.h"
#import "ZPracticeTypeSortView.h"

@interface ZPracticeTypeTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///分类数据
@property (strong, nonatomic) ZPracticeTypeHeaderView *viewHeader;
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
    self.viewHeader = [[ZPracticeTypeHeaderView alloc] initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, 0))];
    ZWEAKSELF
    [self.viewHeader setOnSortClick:^(ZPracticeTypeSort sort) {
        if (weakSelf.onSortClick) {
            weakSelf.onSortClick();
        }
    }];
    [self.viewHeader setOnTypeClick:^(ModelPracticeType *model) {
        if (weakSelf.onPracticeAllClick) {
            weakSelf.onPracticeAllClick(model);
        }
    }];
    
    [self setTableHeaderView:self.viewHeader];
    [self setSectionFooterHeight:self.viewHeader.height];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
}
-(ZPracticeTypeSort)getSortValue
{
    return self.viewHeader.getSortValue;
}
-(void)setSortButton:(ZPracticeTypeSort)type;
{
    [self.viewHeader setSortButtonTag:type];
}
-(void)setViewTypeDataWithArray:(NSArray *)arrResult
{
    CGFloat headerHeight = [self.viewHeader setViewDataWithArray:arrResult];
    CGRect headerFrame = self.viewHeader.frame;
    headerFrame.size.height = headerHeight;
    self.viewHeader.frame = headerFrame;
    [self setSectionFooterHeight:self.viewHeader.height];
    [self reloadData];
}
-(void)setViewPracticeDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (isHeader) {
        [self.arrMain removeAllObjects];
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
    OBJC_RELEASE(_onPracticeAllClick);
    OBJC_RELEASE(_onPracticeClick);
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZNewPracticeItemTVC getH];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZNewPracticeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZNewPracticeItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelPracticeType *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onPracticeClick) {
        self.onPracticeClick(self.arrMain, indexPath.row);
    }
}

@end
