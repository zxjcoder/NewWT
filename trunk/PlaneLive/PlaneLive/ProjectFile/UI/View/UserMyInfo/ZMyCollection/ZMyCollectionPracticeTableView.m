//
//  ZMyCollectionPracticeTableView.m
//  PlaneCircle
//
//  Created by Daniel on 7/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZMyCollectionPracticeTableView.h"
#import "ZMyCollectionPracticeTVC.h"
#import "ZGlobalPlayView.h"

@interface ZMyCollectionPracticeTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) ZBaseTVC *tvcSpace;

@property (assign, nonatomic) BOOL isDelete;

@end

@implementation ZMyCollectionPracticeTableView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.arrMain = [NSMutableArray array];
    self.tvcSpace = [[ZBaseTVC alloc] initWithReuseIdentifier:@"tvcSpace"];
    [self.tvcSpace innerInit];
    self.tvcSpace.cellH = [ZGlobalPlayView getH];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setTableHeaderView:nil];
    //[self setRowHeight:[ZMyCollectionPracticeTVC getH]];
    
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
            ModelPractice *model = [[ModelPractice alloc] initWithCustom:dic];
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
    ZWEAKSELF
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return self.arrMain.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return false;
    }
    return self.isDelete;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return kEmpty;
    }
    return kCancelCollection;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.tvcSpace.cellH;
    }
    return [ZMyCollectionPracticeTVC getH];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return;
    }
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
        {
            ModelPractice *model = [self.arrMain objectAtIndex:indexPath.row];
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
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.tvcSpace;
    }
    static NSString *cellid = @"tvcellids";
    ZMyCollectionPracticeTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZMyCollectionPracticeTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelPractice *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    [cell setHiddenLine:(self.arrMain.count-1)==indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.onRowSelected) {
            self.onRowSelected(self.arrMain, indexPath.row);
        }
    }
}


@end
