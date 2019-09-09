//
//  ZDownloadCourseTableView.m
//  PlaneLive
//
//  Created by Daniel on 19/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZDownloadCourseTableView.h"
#import "ZDownloadItemTVC.h"

@interface ZDownloadCourseTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrMain;
@property (strong, nonatomic) NSMutableDictionary *dicSelect;
@property (assign, nonatomic) BOOL isChecking;

@end

@implementation ZDownloadCourseTableView

-(id)initWithFrame:(CGRect)frame
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
    self.dicSelect = [NSMutableDictionary dictionary];
   
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setRowHeight:[ZDownloadItemTVC getH]];
    [self setDelegate:self];
    [self setDataSource:self];
}
-(void)setViewDataWithArray:(NSArray *)arrResult
{
    [self.arrMain removeAllObjects];
    [self.dicSelect removeAllObjects];
    if (arrResult && arrResult.count > 0) {
        [self.arrMain addObjectsFromArray:arrResult];
        [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    } else {
        [self setBackgroundViewWithState:(ZBackgroundStateNull)];
    }
    [self reloadData];
}
///添加一个已经完成的对象
-(void)addViewData:(XMCacheTrack*)model
{
    [self.arrMain addObject:model];
    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    [self reloadData];
}
///删除一个已经完成的对象
-(void)removeViewData:(XMCacheTrack*)model
{
    [self.arrMain removeObject:model];
    if (self.arrMain.count > 0) {
        [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    } else {
        [self setBackgroundViewWithState:(ZBackgroundStateNull)];
    }
    [self reloadData];
}
/// 获取选中对象集合
-(NSArray *)getCheckArray
{
    NSMutableArray *checkArray = [NSMutableArray array];
    for (int i = 0; i < self.arrMain.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", i];
        NSString *value = [self.dicSelect objectForKey:key];
        if (value && [value boolValue]) {
            [checkArray addObject:[self.arrMain objectAtIndex:i]];
        }
    }
    return checkArray;
}
-(NSArray *)getAllArray
{
    return self.arrMain;
}
-(NSInteger)getAllArrayCount
{
    return self.arrMain.count;
}
/// 批量设置选中状态
-(void)setStartCheckAll:(BOOL)checkAll
{
    [self.dicSelect removeAllObjects];
    if (checkAll) {
        for (NSInteger i=0; i<self.arrMain.count; i++) {
            NSString *key = [NSString stringWithFormat:@"%d", i];
            NSString *value = [NSString stringWithFormat:@"%d", checkAll];
            [self.dicSelect setObject:value forKey:key];
        }
    }
    [self reloadData];
}
///设置是否开始勾选
-(void)setStartChecking:(BOOL)check
{
    [self setIsChecking:check];
    
    [self reloadData];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.isChecking;
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
            XMCacheTrack *model = [self.arrMain objectAtIndex:indexPath.row];
            if (self.onDeleteClick) {
                self.onDeleteClick(model);
            }
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
//                                                                             title:kDelete
//                                                                           handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                           {
//                                               XMCacheTrack *model = [weakSelf.arrMain objectAtIndex:indexPath.row];
//                                               if (weakSelf.onDeleteClick) {
//                                                   weakSelf.onDeleteClick(model);
//                                               }
//                                           }];
//    [editRowAction setBackgroundColor:COLORDELETE];
//    return @[editRowAction];
//}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZDownloadItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZDownloadItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    
    XMCacheTrack *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    [cell setIsCheckingStatus:self.isChecking];
    if (self.dicSelect.count > 0) {
        NSString *index = [NSString stringWithFormat:@"%d", indexPath.row];
        BOOL isCheck = [[self.dicSelect valueForKey:index] boolValue];
        [cell setCheckedStatus:isCheck];
    } else if (self.dicSelect.count == self.arrMain.count) {
        [cell setCheckedStatus:true];
    } else {
        [cell setCheckedStatus:false];
    }
    ZWEAKSELF
    [cell setOnCheckedClick:^(BOOL check, NSInteger row) {
        NSString *key = [NSString stringWithFormat:@"%d", row];
        if (check) {
            NSString *value = [NSString stringWithFormat:@"%d", check];
            [weakSelf.dicSelect setObject:value forKey:key];
        } else {
            [weakSelf.dicSelect removeObjectForKey:key];
        }
        if (weakSelf.onCheckChange) {
            weakSelf.onCheckChange(weakSelf.dicSelect.count == weakSelf.arrMain.count, weakSelf.dicSelect.count);
        }
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isChecking) {
        if (self.onRowSelected) {
            self.onRowSelected(self.arrMain, indexPath.row);
        }
    }
}

@end
