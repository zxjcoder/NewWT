//
//  ZNewSubscribeAlreadyHasMainView.m
//  PlaneLive
//
//  Created by WT on 30/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewSubscribeAlreadyHasMainView.h"
#import "ZNewSubscribeAlreadyHasDetailTableView.h"
#import "ZNewSubscribeAlreadyHasCourseTableView.h"
#import "ZNewSubscribeAlreadyHasToolView.h"
#import "ZNewSubscribeAlreadyHasInfoTVC.h"
#import "ZNewSubscribeAlreadyHasCourseTVC.h"
#import "ZScrollView.h"

@interface ZNewSubscribeAlreadyHasMainView()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

/// 主面板
@property (strong, nonatomic) ZBaseTableView *tvMain;
/// 信息顶部
@property (strong, nonatomic) ZView *viewHeader1;
/// 系列课,培训课基本信息
@property (strong, nonatomic) ZNewSubscribeAlreadyHasInfoTVC *tvcInfo;
/// 内容顶部
@property (strong, nonatomic) ZNewSubscribeAlreadyHasToolView *viewHeader2;
/// 系列课,培训课详情
@property (strong, nonatomic) ZNewSubscribeAlreadyHasCourseTVC *tvcCourse;

@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) BOOL isAddFooter;
@property (strong, nonatomic) NSMutableArray *arrayCourse;

@end

@implementation ZNewSubscribeAlreadyHasMainView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    self.pageIndex = 0;
    self.isAddFooter = false;
    self.tvcInfo = [[ZNewSubscribeAlreadyHasInfoTVC alloc] initWithReuseIdentifier:@"tvcInfo"];
    self.tvcCourse = [[ZNewSubscribeAlreadyHasCourseTVC alloc] initWithReuseIdentifier:@"tvcCourse"];
    
    self.viewHeader1 = [[ZView alloc] initWithFrame:(CGRectMake(0, 0, self.width, 0.01))];
    self.viewHeader2 = [[ZNewSubscribeAlreadyHasToolView alloc] initWithFrame:(CGRectMake(0, 0, self.width, [ZNewSubscribeAlreadyHasToolView getH]))];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:self.bounds];
    [self.tvMain innerInit];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setBackgroundColor:WHITECOLOR];
    [self addSubview:self.tvMain];
    
    [self innerInitEvent];
}
-(void)innerInitEvent
{
    ZWEAKSELF
    [self.tvMain setRefreshHeaderWithRefreshBlock:^{
        if (weakSelf.onRefreshCourseHeader) {
            weakSelf.onRefreshCourseHeader();
        }
    }];
    [self.tvcInfo setOnDownloadEvent:^(ModelSubscribe *model) {
        if (weakSelf.onDownloadAllClick) {
            weakSelf.onDownloadAllClick([weakSelf arrayCourse]);
        }
    }];
    [self.viewHeader2 setOnListEvent:^{
        [weakSelf.tvcCourse setPageIndex:0];
    }];
    [self.viewHeader2 setOnInfoEvent:^{
        [weakSelf.tvcCourse setPageIndex:1];
    }];
    [self.tvcCourse setOnStopPlayClick:^(ModelCurriculum *model) {
        if (weakSelf.onStopPlayClick) {
            weakSelf.onStopPlayClick(model);
        }
    }];
    [self.tvcCourse setOnPageChange:^(CGFloat index) {
        [weakSelf setPageIndex:index];
        [weakSelf.viewHeader2 setSelectIndex:index];
        [weakSelf setPageChange];
        [weakSelf.tvcInfo setHiddenDownloadButton:index==1];
    }];
    [self.tvcCourse setOnOffsetChange:^(CGFloat offsetX) {
        [weakSelf.viewHeader2 setLineOffset:offsetX];
        [weakSelf.tvcInfo setHiddenDownloadButton:false];
        [weakSelf.tvcInfo setDownloadButtonAlpha:(1-offsetX/APP_FRAME_WIDTH)];
    }];
    [self.tvcCourse setOnCourseClick:^(ModelCurriculum *model) {
        if (weakSelf.onCourseClick) {
            weakSelf.onCourseClick(model);
        }
    }];
    [self.tvcCourse setOnDownloadClick:^(NSInteger row, ModelCurriculum *model) {
        if (weakSelf.onDownloadClick) {
            weakSelf.onDownloadClick(row, model);
        }
    }];
    [self.tvcCourse setOnCourseItemClick:^(NSArray *array, NSInteger index) {
        if (weakSelf.onCourseItemClick) {
            weakSelf.onCourseItemClick(array, index);
        }
    }];
    [self.tvcCourse setOnCellHeightChange:^(CGFloat cellHeight) {
        [weakSelf.tvMain reloadData];
    }];
}
///设置下载进度
-(void)setDownloadProgress:(double)progress row:(NSInteger)row
{
    [self.tvcCourse setDownloadProgress:progress row:row];
}
///设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status row:(NSInteger)row
{
    [self.tvcCourse setDownloadStatus:status row:row];
}
/// 设置是否播放中
-(void)setIsPlayStatus:(BOOL)status rowModel:(ModelCurriculum *)rowModel
{
    [self.tvcCourse setIsPlayStatus:status rowModel:rowModel];
}
/// 设置数据源
-(void)setViewDataWithModel:(ModelSubscribeDetail *)model
{
    [self.tvcInfo setCellDataWithModel:model];
    if ([model isKindOfClass:[ModelSubscribeDetail class]]) {
        [self.tvcCourse setViewDataWithModel:model];
    }
    [self.tvMain reloadData];
}
-(NSMutableArray *)arrayCourse
{
    if (!_arrayCourse) {
        _arrayCourse = [NSMutableArray array];
    }
    return _arrayCourse;
}
-(int)getDownloadToalSize
{
    CGFloat totalSize = 0;
    for (ModelCurriculum *modelC in self.arrayCourse) {
        totalSize += modelC.audio_sizeMB;
    }
    return (int)totalSize;
}
///设置课程列表数据源
-(void)setViewDataWithCourseArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    if (isHeader) {
        [self.tvMain endRefreshHeader];
    } else {
        [self.tvMain endRefreshFooter];
    }
    if (arrResult && [arrResult isKindOfClass:[NSArray class]] && arrResult.count > 0) {
        if (isHeader) {
            [self.arrayCourse removeAllObjects];
        }
        [self.arrayCourse addObjectsFromArray:arrResult];
        [self.tvcCourse setViewDataWithArray:arrResult isHeader:isHeader];
        switch (self.pageIndex) {
            case 1:
                self.isAddFooter = arrResult.count>=kPAGE_MAXCOUNT;
                break;
            default:
                self.isAddFooter = arrResult.count>=kPAGE_MAXCOUNT;
                if (arrResult.count >= kPAGE_MAXCOUNT) {
                    ZWEAKSELF
                    [self.tvMain setRefreshFooterWithEndBlock:^{
                        if (weakSelf.onRefreshCourseFooter) {
                            weakSelf.onRefreshCourseFooter();
                        }
                    }];
                } else {
                    [self.tvMain removeRefreshFooter];
                }
                break;
        }
    }
}
-(void)setViewBackgroundState:(ZBackgroundState)state
{
    [self.tvMain setBackgroundViewWithState:state];
}
-(void)setPageChange
{
    switch (self.pageIndex) {
        case 1:
            [self.tvMain removeRefreshFooter];
            break;
        default:
            if (self.isAddFooter) {
                ZWEAKSELF
                [self.tvMain setRefreshFooterWithEndBlock:^{
                    if (weakSelf.onRefreshCourseFooter) {
                        weakSelf.onRefreshCourseFooter();
                    }
                }];
            }
            break;
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1: return [self.tvcCourse cellH];
        default: break;
    }
    return [self.tvcInfo cellH];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.viewHeader2.height;
        default: break;
    }
    return self.viewHeader1.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1: return self.viewHeader2;
        default: break;
    }
    return self.viewHeader1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1: return self.tvcCourse;
        default: break;
    }
    return self.tvcInfo;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tvMain scrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.tvMain scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tvMain scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.tvMain scrollViewDidEndScrollingAnimation:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tvMain scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
