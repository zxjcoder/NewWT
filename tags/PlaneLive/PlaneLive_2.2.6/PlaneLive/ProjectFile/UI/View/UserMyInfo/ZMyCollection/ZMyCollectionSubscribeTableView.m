//
//  ZMyCollectionSubscribeTableView.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/5.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZMyCollectionSubscribeTableView.h"
#import "ZSubscribeEachWatchTVC.h"

@interface ZMyCollectionSubscribeTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyCollectionSubscribeTableView

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
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setTableHeaderView:nil];
    [self setRowHeight:[ZSubscribeEachWatchTVC getH]];
    
    __weak typeof(self) weakSelf = self;
    [self setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    NSArray *arrList = [dicResult objectForKey:kResultKey];
    NSMutableArray *arrR = [NSMutableArray array];
    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in arrList) {
            ModelCollection *model = [[ModelCollection alloc] initWithCustom:dic];
            [arrR addObject:model];
        }
    }
    BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
    if (isHeader) {
        [self.arrMain removeAllObjects];
        if (arrR.count == 0) {
            [self setBackgroundViewWithState:(ZBackgroundStateNull)];
        } else {
            [self setBackgroundViewWithState:(ZBackgroundStateNone)];
        }
    }
    __weak typeof(self) weakSelf = self;
    if (arrR.count >= kPAGE_MAXCOUNT) {
        [self setRefreshFooterWithEndBlock:^{
            if (weakSelf.onRefreshFooter) {
                weakSelf.onRefreshFooter();
            }
        }];
    } else {
        [self removeRefreshFooter];
    }
    [self.arrMain addObjectsFromArray:arrR];
    [self reloadData];
}
-(void)setViewIsDelete:(BOOL)isDel
{
    [self setIsDelete:isDel];
    [self reloadData];
}
-(void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    OBJC_RELEASE(_onRowSelected);
    OBJC_RELEASE(_onDeleteClick);
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.isDelete;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            ModelCollection *model = [self.arrMain objectAtIndex:indexPath.row];
            if (self.onDeleteClick) {
                self.onDeleteClick(model);
            }
            [self.arrMain removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            
            if (self.arrMain.count == 0) {
                if (self.onPageNumChange) {
                    self.onPageNumChange(1);
                }
                [self setBackgroundViewWithState:(ZBackgroundStateNull)];
            }
            [self removeRefreshFooter];
            break;
        }
        default:
            break;
    }
}
/// TODO: ZWW - 在IOS8.1-iPhone5部分设备下有BUG故此没有使用这个方法
//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ZWEAKSELF
//    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
//                                                                             title:kCancelCollection
//                                                                           handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                           {
//                                               ModelCollection *model = [weakSelf.arrMain objectAtIndex:indexPath.row];
//                                               if (weakSelf.onDeleteClick) {
//                                                   weakSelf.onDeleteClick(model);
//                                               }
//                                               [weakSelf.arrMain removeObjectAtIndex:indexPath.row];
//                                               [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//
//                                               if (weakSelf.arrMain.count == 0) {
//                                                   if (weakSelf.onPageNumChange) {
//                                                       weakSelf.onPageNumChange(1);
//                                                   }
//                                                   [weakSelf setBackgroundViewWithState:(ZBackgroundStateNull)];
//                                               }
//                                               [weakSelf removeRefreshFooter];
//                                           }];
//    [editRowAction setBackgroundColor:COLORDELETE];
//    return @[editRowAction];
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZSubscribeEachWatchTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZSubscribeEachWatchTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelCollection *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModelCollection:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCollection *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model);
    }
}

@end
