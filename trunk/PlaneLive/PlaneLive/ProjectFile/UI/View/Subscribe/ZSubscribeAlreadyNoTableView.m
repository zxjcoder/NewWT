//
//  ZSubscribeAlreadyHasTableView.m
//  PlaneLive
//
//  Created by Daniel on 11/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeAlreadyNoTableView.h"
#import "ZNewCoursesItemTVC.h"
#import "ZGlobalPlayView.h"

@interface ZSubscribeAlreadyNoTableView()<UITableViewDelegate,UITableViewDataSource>

///数据集合
@property (strong, nonatomic) NSMutableArray *arrMain;
@property (strong, nonatomic) ZBaseTVC *tvcSpace;

@end

@implementation ZSubscribeAlreadyNoTableView

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
    //[self setRowHeight:[ZNewCoursesItemTVC getH]];
    
    ZWEAKSELF
    [self setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshHeader) {
            weakSelf.onRefreshHeader();
        }
    }];
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
        [self removeRefreshFooter];
        if (self.arrMain.count == 0) {
            [self setBackgroundViewWithState:(ZBackgroundStateFail)];
        }
    }
    [self reloadData];
}

-(void)dealloc
{
    [self setDataSource:nil];
    [self setDelegate:nil];
    
    OBJC_RELEASE(_onCurriculumClick);
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.tvcSpace.cellH;
    }
    return [ZNewCoursesItemTVC getH];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.tvcSpace;
    }
    static NSString *cellid = @"tvcellid";
    ZNewCoursesItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZNewCoursesItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setHiddenPrice];
    [cell setHiddenListen];
    ModelCurriculum *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithCurriculumModel:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.onCurriculumClick) {
            ModelCurriculum *model = [self.arrMain objectAtIndex:indexPath.row];
            self.onCurriculumClick(model);
        }
    }
}

@end
