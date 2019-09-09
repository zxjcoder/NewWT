//
//  ZPracticeDetailTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailTableView.h"
#import "ZPracticeDetailHeaderTVC.h"
#import "ZPrecticeDetailCommentView.h"
#import "ZCommentTVC.h"

@interface ZPracticeDetailTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) ZPracticeDetailHeaderTVC *tvcHeader;

@property (strong, nonatomic) ZCommentTVC *tvcItem;

@property (strong, nonatomic) ZPrecticeDetailCommentView *viewHeader;

@property (strong, nonatomic) NSMutableArray *arrMain;

@property (strong, nonatomic) NSMutableDictionary *dicDefaultH;

@end

@implementation ZPracticeDetailTableView

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

-(void)innerInit
{
    [super innerInit];
    
    self.arrMain = [NSMutableArray array];
    self.dicDefaultH = [NSMutableDictionary dictionary];
    
    self.tvcItem = [[ZCommentTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    __weak typeof(self) weakSelf = self;
    self.tvcHeader = [[ZPracticeDetailHeaderTVC alloc] initWithReuseIdentifier:@"tvcHeader"];
    [self.tvcHeader setOnTextClick:^{
        if (weakSelf.onTextClick) {
            weakSelf.onTextClick();
        }
    }];
    [self.tvcHeader setOnPraiseClick:^{
        if (weakSelf.onPraiseClick) {
            weakSelf.onPraiseClick();
        }
    }];
    [self.tvcHeader setOnCollectionClick:^{
        if (weakSelf.onCollectionClick) {
            weakSelf.onCollectionClick();
        }
    }];
    self.viewHeader = [[ZPrecticeDetailCommentView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 45)];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
}

-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self.tvcHeader setCellDataWithModel:model];
    [self.viewHeader setViewDataWithModel:model];
    
    [self reloadData];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        NSArray *arrList = [dicResult objectForKey:@"resultComments"];
        NSMutableArray *arrHot = [NSMutableArray array];
        if (arrList && [arrList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrList) {
                ModelComment *model = [[ModelComment alloc] initWithCustom:dic];
                [arrHot addObject:model];
            }
        }
        __weak typeof(self) weakSelf = self;
        BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
        if (isHeader) {
            [self.dicDefaultH removeAllObjects];
            [self.arrMain removeAllObjects];
        }
        if (arrHot.count >= kPAGE_MAXCOUNT) {
            [self addRefreshFooterWithEndBlock:^{
                if (weakSelf.onRefreshFooter) {
                    weakSelf.onRefreshFooter();
                }
            }];
        } else {
            [self removeRefreshFooter];
        }
        [self.arrMain addObjectsFromArray:arrHot];
    } else {
        [self removeRefreshFooter];
        [self.dicDefaultH removeAllObjects];
        [self.arrMain removeAllObjects];
    }
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_tvcHeader);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_dicDefaultH);
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return self.viewHeader.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    return self.viewHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.tvcHeader.getH;
    }
    ModelComment *model = [self.arrMain objectAtIndex:indexPath.row];
    BOOL isMaxH = [[self.dicDefaultH objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]] boolValue];
    [self.tvcItem setCellIsDefaultH:!isMaxH];
    CGFloat rowH = [self.tvcItem getHWithModel:model];
    return rowH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.tvcHeader;
    }
    static NSString *cellid = @"tvcellid";
    ZCommentTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZCommentTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    ModelComment *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    __weak typeof(self) weakSelf = self;
    [cell setOnImagePhotoClick:^(ModelComment *model) {
        if (weakSelf.onCommentPhotoClick) {
            weakSelf.onCommentPhotoClick(model);
        }
    }];
    [cell setOnRowHeightChange:^(NSInteger tag, BOOL isDefaultH) {
        [weakSelf.dicDefaultH setObject:[NSString stringWithFormat:@"%d",!isDefaultH] forKey:[NSString stringWithFormat:@"%d",(int)tag]];
        GCDMainBlock(^{
            [weakSelf reloadData];
        })
    }];
    return cell;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.onOffsetChange) {
        self.onOffsetChange(scrollView.contentOffset.y);
    }
}

@end
