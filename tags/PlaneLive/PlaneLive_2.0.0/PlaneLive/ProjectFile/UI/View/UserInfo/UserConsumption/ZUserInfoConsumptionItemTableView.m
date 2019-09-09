//
//  ZUserInfoConsumptionItemTableView.m
//  PlaneLive
//
//  Created by Daniel on 13/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoConsumptionItemTableView.h"
#import "ZUserInfoConsumptionItemTVC.h"

@interface ZUserInfoConsumptionItemTableView()<UITableViewDelegate, UITableViewDataSource>

///计算高度
@property (strong, nonatomic) ZUserInfoConsumptionItemTVC *tvcItem;
///数据集合
@property (strong, nonatomic) NSMutableArray *arrayMain;

@end

@implementation ZUserInfoConsumptionItemTableView

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
    
    self.arrayMain = [NSMutableArray array];
    
    self.tvcItem = [[ZUserInfoConsumptionItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    ZWEAKSELF
    [self addRefreshHeaderWithEndBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}

-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    if (arrResult) {
        if (isHeader) {
            [self.arrayMain removeAllObjects];
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
        [self.arrayMain addObjectsFromArray:arrResult];
    } else {
        if (self.arrayMain.count == 0) {
            [self setBackgroundViewWithState:(ZBackgroundStateFail)];
        }
    }
    [self reloadData];
}
-(void)dealloc
{
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_arrayMain);
    self.delegate = nil;
    self.dataSource = nil;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelEntity *model = [self.arrayMain objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[ModelSubscribePlay class]]) {
        [self.tvcItem setCellDataWithSubscribePlay:(ModelSubscribePlay*)model];
    } else if ([model isKindOfClass:[ModelRechargeRecord class]]) {
        [self.tvcItem setCellDataWithRechargeRecord:(ModelRechargeRecord*)model];
    }
    return [self.tvcItem getH];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZUserInfoConsumptionItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZUserInfoConsumptionItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    
    ModelEntity *model = [self.arrayMain objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[ModelSubscribePlay class]]) {
        [cell setCellDataWithSubscribePlay:(ModelSubscribePlay*)model];
    } else if ([model isKindOfClass:[ModelRechargeRecord class]]) {
        [cell setCellDataWithRechargeRecord:(ModelRechargeRecord*)model];
    }
    
    return cell;
}

@end
