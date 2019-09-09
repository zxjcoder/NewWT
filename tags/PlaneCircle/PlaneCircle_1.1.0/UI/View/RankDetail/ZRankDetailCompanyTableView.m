//
//  ZRankDetailCompanyTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/20/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZRankDetailCompanyTableView.h"
#import "ZRankDetailItemTVC.h"

@interface ZRankDetailCompanyTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZRankDetailItemTVC *tvcItem;

@property (strong, nonatomic) NSMutableArray *arrMain;

@end

@implementation ZRankDetailCompanyTableView

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
    
    self.tvcItem = [[ZRankDetailItemTVC alloc] initWithReuseIdentifier:@"tvcItem"];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    @synchronized (self) {
        BOOL isUser = [[dicResult objectForKey:@"isUserObj"] boolValue];
        NSMutableArray *arrR = [NSMutableArray array];
        if (isUser) {
            NSArray *arrList = [dicResult objectForKey:kResultKey];
            if (arrList && [arrList isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in arrList) {
                    ModelRankUser *model = [[ModelRankUser alloc] initWithCustom:dic];
                    [arrR addObject:model];
                }
            }
        } else {
            NSArray *arrList = [dicResult objectForKey:@"resultAvm"];
            if (arrList && [arrList isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in arrList) {
                    ModelRankCompany *model = [[ModelRankCompany alloc] initWithCustom:dic];
                    [arrR addObject:model];
                }
            }
        }
        BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
        if (isHeader) { [self.arrMain removeAllObjects]; }
        __weak typeof(self) weakSelf = self;
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

-(void)dealloc
{
    [self setDelegate:nil];
    [self setDataSource:nil];
    OBJC_RELEASE(_tvcItem);
    OBJC_RELEASE(_arrMain);
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelEntity *model = [self.arrMain objectAtIndex:indexPath.row];
    return [self.tvcItem getHWithModel:model];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZRankDetailItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZRankDetailItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row+1];
    ModelEntity *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

@end
