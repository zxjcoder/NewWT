//
//  ZMyAttentionTopicTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/17/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyAttentionTopicTableView.h"
#import "ZMyTopicTVC.h"

@interface ZMyAttentionTopicTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyAttentionTopicTableView

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
    [self setBackgroundColor:VIEW_BACKCOLOR2];
    [self setTableHeaderView:nil];
    [self setRowHeight:[ZMyTopicTVC getH]];
    
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
        NSArray *arrList = [dicResult objectForKey:@"myAttentArticles"];
        NSMutableArray *arrR = [NSMutableArray array];
        if (arrList && [arrList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrList) {
                ModelTag *model = [[ModelTag alloc] initWithCustom:dic];
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
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:( NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            ModelTag *model = [self.arrMain objectAtIndex:indexPath.row];
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
        default: break;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCancelAttention;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZMyTopicTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyTopicTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelTag *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelTag *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model);
    }
}

@end
