//
//  ZNewSubscribeAlreadyHasContentTVC.m
//  PlaneLive
//
//  Created by WT on 02/04/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewSubscribeAlreadyHasCourseTVC.h"
#import "ZNewSubscribeAlreadyHasCourseTableView.h"
#import "ZNewSubscribeAlreadyHasDetailTableView.h"
#import "ZNewSubscribeAlreadyHasInfoTVC.h"
#import "ZNewSubscribeAlreadyHasToolView.h"
#import "ZScrollView.h"

@interface ZNewSubscribeAlreadyHasCourseTVC()<UIScrollViewDelegate>

@property (strong, nonatomic) ZScrollView *scMain;
@property (strong, nonatomic) ZNewSubscribeAlreadyHasCourseTableView *tvCourse;
@property (strong, nonatomic) ZNewSubscribeAlreadyHasDetailTableView *tvDetail;
@property (assign, nonatomic) NSInteger itemIndex;
@property (assign, nonatomic) CGFloat contentCourseHeight;
@property (assign, nonatomic) CGFloat contentDetailHeight;

@end

@implementation ZNewSubscribeAlreadyHasCourseTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    [super innerInit];
    self.itemIndex = 0;
    
    self.scMain = [[ZScrollView alloc] initWithFrame:(CGRectMake(0, 0, self.cellW, 0))];
    [self.scMain setDelegate:self];
    [self.scMain setBounces:false];
    [self.scMain setScrollsToTop:false];
    [self.scMain setScrollEnabled:true];
    [self.scMain setPagingEnabled:true];
    [self.scMain setUserInteractionEnabled:true];
    [self.scMain setShowsVerticalScrollIndicator:false];
    [self.scMain setShowsHorizontalScrollIndicator:false];
    [self.viewMain addSubview:self.scMain];
    
    self.tvCourse = [[ZNewSubscribeAlreadyHasCourseTableView alloc] initWithFrame:(CGRectMake(0, 0, self.scMain.width, 0))];
    [self.scMain addSubview:self.tvCourse];
    
    self.tvDetail = [[ZNewSubscribeAlreadyHasDetailTableView alloc] initWithFrame:(CGRectMake(self.scMain.width, 0, self.scMain.width, 0))];
    [self.scMain addSubview:self.tvDetail];
    
    [self.scMain setContentSize:(CGSizeMake(self.scMain.width*2, 0))];
    [self.scMain setContentOffset:(CGPointMake(0, 0))];
    
    [self innerInitEvent];
}
-(void)innerInitEvent
{
    ZWEAKSELF
    [self.tvCourse setOnItemClick:^(NSArray *array, NSInteger index) {
        if (weakSelf.onCourseItemClick) {
            weakSelf.onCourseItemClick(array, index);
        }
    }];
    [self.tvCourse setOnStopPlayClick:^(ModelCurriculum *model) {
        if (weakSelf.onStopPlayClick) {
            weakSelf.onStopPlayClick(model);
        }
    }];
    [self.tvCourse setOnCourseClick:^(ModelCurriculum *model) {
        if (weakSelf.onCourseClick) {
            weakSelf.onCourseClick(model);
        }
    }];
    [self.tvCourse setOnDownloadClick:^(NSInteger row, ModelCurriculum *model) {
        if (weakSelf.onDownloadClick) {
            weakSelf.onDownloadClick(row, model);
        }
    }];
    [self.tvCourse setOnViewHeightChange:^(CGFloat height) {
        [weakSelf setContentCourseHeight:height];
        [weakSelf setViewFrame:0];
    }];
    [self.tvDetail setOnTableViewHeightChange:^(CGFloat height) {
        [weakSelf setContentDetailHeight:height];
        [weakSelf setViewFrame:1];
    }];
}
-(void)setViewFrame:(NSInteger)index
{
    switch (index) {
        case 1:
            [self.tvDetail setFrame:(CGRectMake(self.tvDetail.x, self.tvDetail.y, self.tvDetail.width, self.contentDetailHeight))];
            break;
        default:
            [self.tvCourse setFrame:(CGRectMake(self.tvCourse.x, self.tvCourse.y, self.tvCourse.width, self.contentCourseHeight))];
            break;
    }
    switch (self.itemIndex) {
        case 1:
            self.cellH = self.contentDetailHeight;
            break;
        default:
            self.cellH = self.contentCourseHeight;
            break;
    }
    CGFloat minHeight = APP_FRAME_HEIGHT-APP_TOP_HEIGHT-[ZNewSubscribeAlreadyHasInfoTVC getH]-[ZNewSubscribeAlreadyHasToolView getH];
    if (self.cellH <= minHeight) {
        self.cellH = minHeight;
    }
    [self.scMain setFrame:(CGRectMake(0, 0, self.cellW, self.cellH))];
    [self.scMain setContentSize:(CGSizeMake(self.scMain.width*2, self.cellH))];
    [self.viewMain setFrame:[self getMainFrame]];
    if (self.onCellHeightChange) {
        self.onCellHeightChange(self.cellH);
    }
}
/// 设置默认索引
-(void)setPageIndex:(NSInteger)page
{
    [self setItemIndex:page];
    [self setViewFrame:page];
    switch (page) {
        case 1:
        {
            [self.scMain setContentOffset:(CGPointMake(self.scMain.width, 0)) animated:true];
            break;
        }
        default:
        {
            [self.scMain setContentOffset:(CGPointMake(0, 0)) animated:true];
            break;
        }
    }
}
/// 设置数据源
-(void)setViewDataWithModel:(ModelSubscribeDetail *)model
{
    [self.tvDetail setViewDataWithModel:model];
}
/// 设置数据源
-(void)setViewDataWithArray:(NSArray *)array isHeader:(BOOL)isHeader
{
    [self.tvCourse setViewDataWithArray:array isHeader:isHeader];
}
/// 设置是否播放中
-(void)setIsPlayStatus:(BOOL)status rowModel:(ModelCurriculum *)rowModel
{
    [self.tvCourse setIsPlayStatus:status rowModel:rowModel];
}
///设置下载进度
-(void)setDownloadProgress:(double)progress row:(NSInteger)row
{
    [self.tvCourse setDownloadProgress:progress row:row];
}
///设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status row:(NSInteger)row
{
    [self.tvCourse setDownloadStatus:status row:row];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.onOffsetChange) {
        self.onOffsetChange(scrollView.contentOffset.x);
    }
    [self.scMain scrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.itemIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self setViewFrame:self.itemIndex];
    if (self.onPageChange) {
        self.onPageChange(self.itemIndex);
    }
    [self.scMain scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.scMain scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self.scMain scrollViewDidEndScrollingAnimation:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.scMain scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
