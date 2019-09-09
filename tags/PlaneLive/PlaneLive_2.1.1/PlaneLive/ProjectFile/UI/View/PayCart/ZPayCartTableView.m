//
//  ZPayCartTableView.m
//  PlaneLive
//
//  Created by Daniel on 12/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPayCartTableView.h"
#import "ZPayCartItemTVC.h"

@interface ZPayCartTableView()<UITableViewDelegate,UITableViewDataSource>

///选中集合
@property (strong, nonatomic) NSMutableArray *arrSelect;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;
///是否选中全部
@property (assign, nonatomic) BOOL checkAll;

@end

@implementation ZPayCartTableView

-(instancetype)init
{
    self = [super init];
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

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
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
    
    self.arrSelect = [NSMutableArray array];
    self.arrMain = [NSMutableArray array];
    self.checkAll = YES;
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setRowHeight:[ZPayCartItemTVC getH]];
    
    ZWEAKSELF
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

///设置是否全选
-(void)setCheckedAll:(BOOL)checkAll
{
    [self setCheckAll:checkAll];
    
    NSArray *arrPath = [self indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in arrPath) {
        ZPayCartItemTVC *cell = (ZPayCartItemTVC*)[self cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setCheckedStatus:checkAll];
        }
    }
    [self.arrSelect removeAllObjects];
    if (checkAll) {
        [self.arrSelect addObjectsFromArray:self.arrMain];
    }
    [self setNeedsDisplay];
}

-(void)setViewDataWithArray:(NSArray *)arrResult
{
    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    if (arrResult) {
        [self setCheckAll:YES];
        [self.arrSelect removeAllObjects];
        [self.arrMain removeAllObjects];
        if (arrResult.count > 0) {
            [self.arrMain addObjectsFromArray:arrResult];
            [self.arrSelect addObjectsFromArray:arrResult];
        } else {
            [self setBackgroundViewWithState:(ZBackgroundStateNullNoButton)];
        }
    } else {
        [self setCheckAll:NO];
        [self.arrSelect removeAllObjects];
        [self.arrMain removeAllObjects];
        [self setBackgroundViewWithState:(ZBackgroundStateFail)];
    }
    [self reloadData];
}
///获取勾选实务
-(NSArray *)getCheckArray
{
    return self.arrSelect;
}
///获取实务
-(NSArray *)getMainArray
{
    return self.arrMain;
}
///移除数据集合
-(void)removeDataWithArray:(NSArray *)array
{
    NSMutableArray *newArray = [NSMutableArray array];
    for (ModelPractice *modelP in self.arrMain) {
        BOOL isAdd = YES;
        for (ModelPractice *model in array) {
            if ([modelP.ids isEqualToString:model.ids]) {
                isAdd = NO;
                break;
            }
        }
        if (isAdd) {
            [newArray addObject:modelP];
        }
    }
    [self.arrMain removeAllObjects];
    [self.arrMain addObjectsFromArray:newArray];
    if (self.arrMain.count == 0) {
        [self setBackgroundViewWithState:(ZBackgroundStateNullNoButton)];
    } else {
        [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    }
    [self reloadData];
}
-(void)dealloc
{
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_arrSelect);
    self.delegate = nil;
    self.dataSource = nil;
}
#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWEAKSELF
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                             title:kDelete
                                                                           handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                           {
                                               ModelPayCart *model = [weakSelf.arrMain objectAtIndex:indexPath.row];
                                               [weakSelf.arrMain removeObjectAtIndex:indexPath.row];
                                               [weakSelf.arrSelect removeObject:model];
                                               [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                               
                                               if (weakSelf.arrMain.count == 0) {
                                                   [weakSelf setBackgroundViewWithState:(ZBackgroundStateNull)];
                                               }
                                               if (weakSelf.onDeleteClick) {
                                                   weakSelf.onDeleteClick(model);
                                               }
                                           }];
    [editRowAction setBackgroundColor:MAINCOLOR];
    return @[editRowAction];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZPayCartItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZPayCartItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    ModelPayCart *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    [cell setCheckedStatus:self.checkAll];
    
    ZWEAKSELF
    [cell setOnCheckedClick:^(BOOL check, NSInteger row) {
        ModelPayCart *modelP = [weakSelf.arrMain objectAtIndex:row];
        if (check) {
            [weakSelf.arrSelect addObject:modelP];
        } else {
            [weakSelf.arrSelect removeObject:modelP];
        }
        if (weakSelf.onCheckedClick) {
            CGFloat maxPrice = 0;
            for (ModelPayCart *model in weakSelf.arrSelect) {
                maxPrice += [model.price floatValue];
            }
            weakSelf.onCheckedClick(check, row, weakSelf.arrSelect.count, weakSelf.arrSelect.count==weakSelf.arrMain.count, maxPrice);
        }
    }];
    return cell;
}

@end
