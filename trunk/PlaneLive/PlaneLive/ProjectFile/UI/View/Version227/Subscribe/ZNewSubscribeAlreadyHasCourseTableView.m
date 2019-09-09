//
//  ZNewSubscribeAlreadyHasCourseTableView.m
//  PlaneLive
//
//  Created by WT on 30/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewSubscribeAlreadyHasCourseTableView.h"
#import "ZNewSubscribeAlreadyHasItemTVC.h"
#import "ZGlobalPlayView.h"

@interface ZNewSubscribeAlreadyHasCourseTableView()<UITableViewDelegate, UITableViewDataSource>

/// 课程列表数组
@property (strong, nonatomic) NSMutableArray *arrayCourse;
@property (strong, nonatomic) ModelCurriculum *modelCP;
@property (assign, nonatomic) BOOL isPlayStatus;

@end

@implementation ZNewSubscribeAlreadyHasCourseTableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    [super innerInit];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setScrollsToTop:false];
    [self setScrollEnabled:false];
    [self setShowsVerticalScrollIndicator:false];
    [self setShowsHorizontalScrollIndicator:false];
    [self setRowHeight:[ZNewSubscribeAlreadyHasItemTVC getH]];
    [self setBackgroundColor:WHITECOLOR];
}
-(NSMutableArray *)arrayCourse
{
    if (!_arrayCourse) {
        _arrayCourse = [NSMutableArray array];
    }
    return _arrayCourse;
}
-(CGFloat)setViewDataWithArray:(NSArray *)array isHeader:(BOOL)isHeader
{
    if (isHeader) {
        [self.arrayCourse removeAllObjects];
    }
    [self.arrayCourse addObjectsFromArray:array];
    [self reloadData];
    
    CGFloat viewHeight = self.arrayCourse.count*[ZNewSubscribeAlreadyHasItemTVC getH]+[ZGlobalPlayView getH];
    if (self.onViewHeightChange) {
        self.onViewHeightChange(viewHeight);
    }
    return viewHeight;
}
///设置下载进度
-(void)setDownloadProgress:(double)progress row:(NSInteger)row
{
    if (self.arrayCourse.count > row) {
        ModelCurriculum *rowModel = [self.arrayCourse objectAtIndex:row];
        rowModel.downloadStatus = XMCacheTrackStatusDownloading;
        rowModel.downloadProgress = progress;
        [self reloadData];
    }
}
///设置是否播放中
-(void)setIsPlayStatus:(BOOL)status rowModel:(ModelCurriculum *)rowModel
{
    [self setModelCP:rowModel];
    [self setIsPlayStatus:status];
    [self reloadData];
}
///设置下载状态
-(void)setDownloadStatus:(XMCacheTrackStatus)status row:(NSInteger)row
{
    if (self.arrayCourse.count > row) {
        ModelCurriculum *rowModel = [self.arrayCourse objectAtIndex:row];
        rowModel.downloadStatus = status;
        [self reloadData];
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCourse.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZNewSubscribeAlreadyHasItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[ZNewSubscribeAlreadyHasItemTVC alloc] initWithReuseIdentifier:@"cellId"];
    }
    [cell setTag:indexPath.row];
    ModelCurriculum *modelC = [self.arrayCourse objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:modelC];
    //设置下载状态和进度
    [cell setDownloadStatus:(modelC.downloadStatus)];
    [cell setDownloadProgress:modelC.downloadProgress];
    //设置播放状态
    if ([modelC.ids isEqualToString:self.modelCP.ids]) {
        [cell setIsPlayStatus:self.isPlayStatus];
    } else {
        [cell setIsPlayStatus:false];
    }
    ZWEAKSELF
    [cell setOnStopPlayClick:^(ModelCurriculum *model) {
        if (weakSelf.onStopPlayClick) {
            weakSelf.onStopPlayClick(model);
        }
    }];
    [cell setOnStartPlayClick:^(NSInteger row) {
        if (weakSelf.onItemClick) {
            weakSelf.onItemClick(weakSelf.arrayCourse, row);
        }
    }];
    [cell setOnCourseClick:^(ModelCurriculum *model) {
        if (weakSelf.onCourseClick) {
            weakSelf.onCourseClick(model);
        }
    }];
    [cell setOnDownloadClick:^(NSInteger row, ModelCurriculum *model) {
        if (weakSelf.onDownloadClick) {
            weakSelf.onDownloadClick(row, model);
        }
    }];
    return cell;
}

@end
