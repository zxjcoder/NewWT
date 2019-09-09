//
//  ZMyAttentionUserTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAttentionUserTableView.h"
#import "ZMyUserInfoTVC.h"

@interface ZMyAttentionUserTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyAttentionUserTableView

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
    [self setRowHeight:[ZMyUserInfoTVC getH]];
    
    __weak typeof(self) weakSelf = self;
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    @synchronized (self) {
        NSArray *arrList = [dicResult objectForKey:@"myAttentUsers"];
        NSMutableArray *arrR = [NSMutableArray array];
        if (arrList && [arrList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrList) {
                ModelUserBase *model = [[ModelUserBase alloc] initWithCustom:dic];
                [arrR addObject:model];
            }
        }
        __weak typeof(self) weakSelf = self;
        BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrR.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStateNull)];
            } else {
                [self setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
        }
        if (arrR.count >= kPAGE_MAXCOUNT) {
            [self addRefreshFooterWithEndBlock:^{
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
}
-(void)setViewIsDelete:(BOOL)isDel
{
    [self setIsDelete:isDel];
}
///删除用户的行
-(void)setDeleteUserWithRow:(NSInteger)row
{
    [self.arrMain removeObjectAtIndex:row];
    [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    
    if (self.arrMain.count == 0) {
        if (self.onPageNumChange) {
            self.onPageNumChange(1);
        }
        [self setBackgroundViewWithState:(ZBackgroundStateNull)];
    }
    [self removeRefreshFooter];
}
-(void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
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
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWEAKSELF
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                             title:kCancelAttention
                                                                           handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                           {
                                               ModelUserBase *model = [weakSelf.arrMain objectAtIndex:indexPath.row];
                                               if (weakSelf.onDeleteClick) {
                                                   weakSelf.onDeleteClick(model);
                                               }
                                               [weakSelf.arrMain removeObjectAtIndex:indexPath.row];
                                               [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                                               
                                               if (weakSelf.arrMain.count == 0) {
                                                   if (weakSelf.onPageNumChange) {
                                                       weakSelf.onPageNumChange(1);
                                                   }
                                                   [weakSelf setBackgroundViewWithState:(ZBackgroundStateNull)];
                                               }
                                               [weakSelf removeRefreshFooter];
                                           }];
    [editRowAction setBackgroundColor:MAINCOLOR];
    return @[editRowAction];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZMyUserInfoTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyUserInfoTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelUserBase *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelUserBase *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model, indexPath.row);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
