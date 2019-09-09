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

@interface ZPurchaseAllTableView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;
@property (strong, nonatomic) ZPurchaseAllSpaceTVC *tvcSpace;
@property (strong, nonatomic) ZPurchaseBindAccountTVC *tvcBind;
///是否显示绑定CELL
@property (assign, nonatomic) BOOL isShowBind;

@end


@implementation ZPurchaseAllTableView

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
    
    self.tvcSpace = [[ZPurchaseAllSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace"];
    self.tvcBind = [[ZPurchaseBindAccountTVC alloc] initWithReuseIdentifier:@"tvcBind"];
    ZWEAKSELF
    [self.tvcBind setOnBindEvent:^{
        if (weakSelf.onBindEvent) {
            weakSelf.onBindEvent();
        }
    }];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    [self setDelegate:self];
    [self setDataSource:self];
    
    [self setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
}
-(void)setViewDataWithNoLogin
{
    [self.arrMain removeAllObjects];
    [self setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
    self.isShowBind = false;
    [self removeRefreshFooter];
    [self reloadData];
}
-(void)setViewDataWithNoData
{
    [self.arrMain removeAllObjects];
    if (self.isShowBind) {
        [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    } else {
        [self setBackgroundViewWithState:(ZBackgroundStateAllNoData)];
    }
    [self reloadData];
}
-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (self.isShowBind) {
        [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    } else {
        if (arrResult.count == 0 && isHeader) {
            [self setBackgroundViewWithState:(ZBackgroundStateAllNoData)];
        } else {
            [self setBackgroundViewWithState:(ZBackgroundStateNone)];
        }
    }
    if (arrResult) {
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
    if (self.isShowBind) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            if (self.arrMain.count <= 0) {
                return 2;
            } else {
                return 1;
            }
            break;
        default:
            return self.arrMain.count;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
            if (self.arrMain.count <= 0) {
                switch (indexPath.row) {
                    case 1:
                        return self.tvcBind.getH;
                        break;
                    default:
                        return self.tvcSpace.getH;
                        break;
                }
            } else {
                return self.tvcBind.getH;
            }
            break;
        default:
        {
            ModelEntity *model = [self.arrMain objectAtIndex:indexPath.row];
            if ([model isKindOfClass:[ModelPractice class]]) {
                return [ZPurchaseAllItemTVC getPracticeH];
            }
            return [ZPurchaseAllItemTVC getCourseH];
            break;
        }
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
            if (self.arrMain.count <= 0) {
                switch (indexPath.row) {
                    case 1:
                        return self.tvcBind;
                        break;
                    default:
                        return self.tvcSpace;
                        break;
                }
            } else {
                return self.tvcBind;
            }
            break;
        default:
        {
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
            break;
        }
    }
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
                    self.onPracticeSelected(arrayPractice, row);
                }
            } else {
                if (self.onSubscribeSelected) {
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
