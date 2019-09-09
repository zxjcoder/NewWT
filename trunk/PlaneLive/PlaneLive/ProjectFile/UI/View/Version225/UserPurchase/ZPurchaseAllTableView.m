//
//  ZPurchaseAllTableView.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZPurchaseAllTableView.h"
#import "ZNewPracticeItemTVC.h"
#import "ZNewCoursesItemTVC.h"
#import "ZPurchaseBindAccountTVC.h"
#import "ZPurchaseAllItemTVC.h"
#import "ZPurchaseAllSpaceTVC.h"
#import "ZGlobalPlayView.h"

@interface ZPurchaseAllTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

/// 数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;
@property (strong, nonatomic) ZPurchaseAllSpaceTVC *tvcSpace;
@property (strong, nonatomic) ZPurchaseBindAccountTVC *tvcBind;
@property (strong, nonatomic) ZBaseTVC *tvcPlayer;
/// 是否需要显示绑定列
@property (assign, nonatomic) BOOL isShowBind;

@end


@implementation ZPurchaseAllTableView

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
    
    self.tvcSpace = [[ZPurchaseAllSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace"];
    self.tvcBind = [[ZPurchaseBindAccountTVC alloc] initWithReuseIdentifier:@"tvcBind"];
    self.tvcPlayer = [[ZBaseTVC alloc] initWithReuseIdentifier:@"tvcPlayer"];
    [self.tvcPlayer innerInit];
    self.tvcPlayer.cellH = [ZGlobalPlayView getMinH];
    
    ZWEAKSELF
    [self.tvcBind setOnBindEvent:^{
        if (weakSelf.onBindEvent) {
            weakSelf.onBindEvent();
        }
    }];
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    [self setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}
-(void)setViewDataWithNoLogin
{
    [self.arrMain removeAllObjects];
    self.isShowBind = false;
    [self setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
    [self removeRefreshFooter];
    [self reloadData];
}
-(void)setViewDataWithNoData
{
    [self.arrMain removeAllObjects];
    [self reloadData];
}
-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (arrResult) {
        if (self.isShowBind) {
            [self setBackgroundViewWithState:(ZBackgroundStateNone)];
        } else {
            if (isHeader && arrResult.count == 0) {
                [self setBackgroundViewWithState:(ZBackgroundStateAllNoData)];
            } else {
                [self setBackgroundViewWithState:(ZBackgroundStateNone)];
            }
        }
        if (isHeader) {
            [self.arrMain removeAllObjects];
        }
        __weak typeof(self) weakSelf = self;
        if (arrResult.count >= kPAGE_MAXCOUNT) {
            [self setRefreshFooterWithEndBlock:^{
                if (weakSelf.onRefreshFooter) {
                    weakSelf.onRefreshFooter();
                }
            }];
        } else {
            [self removeRefreshFooter];
        }
        [self.arrMain addObjectsFromArray:arrResult];
    } else {
        if (isHeader && self.arrMain.count == 0) {
            [self setBackgroundViewWithState:(ZBackgroundStateAllNoData)];
        } else {
            [self setBackgroundViewWithState:(ZBackgroundStateNone)];
        }
    }
    [self reloadData];
}
-(void)setShowBindCell:(BOOL)isShow
{
    self.isShowBind = isShow;
    [self reloadData];
}
-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    
    OBJC_RELEASE(_onPracticeSelected);
    OBJC_RELEASE(_onSubscribeSelected);
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
        if (self.isShowBind) {
            if (self.arrMain.count == 0) {
                return 3;
            } else {
                return 2;
            }
        }
        return 1;
    }
    return self.arrMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.isShowBind) {
            if (self.arrMain.count == 0) {
                switch (indexPath.row) {
                    case 1: return self.tvcBind.cellH;
                    case 2: return self.tvcPlayer.cellH;
                    default: return self.tvcSpace.cellH;
                }
            } else {
                switch (indexPath.row) {
                    case 1: return self.tvcPlayer.cellH;
                    default: return self.tvcBind.cellH;
                }
            }
        }
        return self.tvcPlayer.cellH;
    }
    return [ZPurchaseAllItemTVC getH];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.isShowBind) {
            if (self.arrMain.count == 0) {
                switch (indexPath.row) {
                    case 1: return self.tvcBind;
                    case 2: return self.tvcPlayer;
                    default: return self.tvcSpace;
                }
            } else {
                switch (indexPath.row) {
                    case 1: return self.tvcPlayer;
                    default: return self.tvcBind;
                }
            }
        }
        return self.tvcPlayer;
    }
    static NSString *cellid = @"tvcellid";
    ZPurchaseAllItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZPurchaseAllItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    ModelEntity *model = [self.arrMain objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[ModelPractice class]]) {
        [cell setCellDataWithPracticeModel:model];
    } else {
        [cell setCellDataWithCourseModel:model];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            ModelEntity *model = [self.arrMain objectAtIndex:indexPath.row];
            if ([model isKindOfClass:[ModelPractice class]]) {
                if (self.onPracticeSelected) {
                    NSMutableArray *arrayPractice = [NSMutableArray array];
                    int index = 0;
                    int row = 0;
                    for (ModelEntity *modelItem in self.arrMain) {
                        if ([modelItem isKindOfClass:[ModelPractice class]]) {
                            if ([[(ModelPractice*)modelItem ids] isEqualToString:[(ModelPractice*)model ids]]) {
                                row = index;
                            }
                            [arrayPractice addObject:modelItem];
                            index++;
                        }
                    }
                    [(ModelPractice *)model setIncreasedCourseCount:0];
                    ZPurchaseAllItemTVC *cell = [tableView cellForRowAtIndexPath:indexPath];
                    [cell setCellDataWithPracticeModel:model];
                    self.onPracticeSelected(arrayPractice, row);
                }
            } else {
                if (self.onSubscribeSelected) {
                    [(ModelSubscribe *)model setIncreasedCourseCount:0];
                    ZPurchaseAllItemTVC *cell = [tableView cellForRowAtIndexPath:indexPath];
                    [cell setCellDataWithCourseModel:model];
                    self.onSubscribeSelected(model);
                }
            }
            break;
        }
        default: break;
    }
}

#define mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if (self.onContentOffsetChange) {
        self.onContentOffsetChange(scrollView.contentOffset.y);
    }
}

@end
