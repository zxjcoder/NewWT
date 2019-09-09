//
//  ZCircleAttTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleAttTableView.h"
#import "ZCircleAttItemTVC.h"

@interface ZCircleAttTableView()<UITableViewDelegate,UITableViewDataSource>

///用于计算高度
@property (strong, nonatomic) ZCircleAttItemTVC *tvcItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZCircleAttTableView

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
    
    self.tvcItem = [[ZCircleAttItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    __weak typeof(self) weakSelf = self;
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    OBJC_RELEASE(_onRowSelected);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_onAnswerClick);
    OBJC_RELEASE(_onImagePhotoClick);
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    [super setViewDataWithDictionary:dicResult];
    
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
        NSArray *arrList = [dicResult objectForKey:kResultKey];
        NSMutableArray *arrResult = [NSMutableArray array];
        if (arrList && [arrList isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrList) {
                ModelCircleAtt *model = [[ModelCircleAtt alloc] initWithCustom:dic];
                [arrResult addObject:model];
            }
        }
        __weak typeof(self) weakSelf = self;
        if (isHeader) {
            [self.arrMain removeAllObjects];
            if (arrResult.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStateNull)];
            } else {
                [self setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
        }
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
        [self.arrMain removeAllObjects];
        [self setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
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
    ModelCircleAtt *model = [self.arrMain objectAtIndex:indexPath.row];
    CGFloat rowH = [self.tvcItem getHWithModel:model];
    return rowH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZCircleAttItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZCircleAttItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    __weak typeof(self) weakSelf = self;
    ModelCircleAtt *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    [cell setOnImagePhotoClick:^(ModelCircleAtt *model) {
        if (weakSelf.onImagePhotoClick) {
            weakSelf.onImagePhotoClick(model);
        }
    }];
    [cell setOnAnswerClick:^(ModelCircleAtt *model) {
        if (weakSelf.onAnswerClick) {
            weakSelf.onAnswerClick(model);
        }
    }];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelCircleAtt *model = [self.arrMain objectAtIndex:indexPath.row];
    if (self.onRowSelected) {
        self.onRowSelected(model);
    }
}

@end
