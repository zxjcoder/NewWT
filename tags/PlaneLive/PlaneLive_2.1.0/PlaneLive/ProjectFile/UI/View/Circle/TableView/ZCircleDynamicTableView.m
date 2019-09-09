//
//  ZCircleDynamicTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleDynamicTableView.h"
#import "ZCircleDynamicItemTVC.h"

@interface ZCircleDynamicTableView()<UITableViewDelegate,UITableViewDataSource>

///用于计算高度
@property (strong, nonatomic) ZCircleDynamicItemTVC *tvcDynamicItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZCircleDynamicTableView

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
    
    self.tvcDynamicItem = [[ZCircleDynamicItemTVC alloc] initWithReuseIdentifier:@"tvcDynamicItem"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    __weak typeof(self) weakSelf = self;
    [self addRefreshHeaderWithEndBlock:^{
        if ([AppSetting getAutoLogin]) {
            if (weakSelf.onRefreshHeader) {
                weakSelf.onRefreshHeader();
            }
        } else {
            [weakSelf endRefreshHeader];
        }
    }];
}

-(void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    OBJC_RELEASE(_onRowSelected);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvcDynamicItem);
    OBJC_RELEASE(_onAnswerClick);
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [super setViewDataWithDictionary:dicResult];
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *arrR = [NSMutableArray array];
        
        NSArray *arrList = [dicResult objectForKey:@"trends"];
        if (arrList && [arrList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrList) {
                ModelCircleDynamic *model = [[ModelCircleDynamic alloc] initWithCustom:dic];
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
    } else {
        [self removeRefreshFooter];
        [self.arrMain removeAllObjects];
        [self setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
    }
    [self reloadData];
}

-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (arrResult) {
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrResult.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStateNull)];
            } else {
                [self setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
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
    } else {
        if (self.arrMain.count == 0) {
            [self setBackgroundViewWithState:(ZBackgroundStateFail)];
        }
    }
    [self reloadData];
}

-(void)setFontSizeChange
{
    [self reloadData];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCircleDynamic *model = [self.arrMain objectAtIndex:indexPath.row];
    CGFloat rowH = [self.tvcDynamicItem getHWithModel:model];
    return rowH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZCircleDynamicItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZCircleDynamicItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelCircleDynamic *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    ZWEAKSELF
    [cell setOnImagePhotoClick:^(ModelUserBase *model) {
        if (weakSelf.onImagePhotoClick) {
            weakSelf.onImagePhotoClick(model);
        }
    }];
    [cell setOnAnswerClick:^(ModelAnswerBase *model) {
        if (weakSelf.onAnswerClick) {
            weakSelf.onAnswerClick(model);
        }
    }];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCircleDynamic *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model);
    }
}

@end