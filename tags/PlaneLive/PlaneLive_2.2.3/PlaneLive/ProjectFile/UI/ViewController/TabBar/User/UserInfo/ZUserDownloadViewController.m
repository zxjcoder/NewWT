//
//  ZUserDownloadViewController.m
//  PlaneLive
//
//  Created by Daniel on 05/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserDownloadViewController.h"
#import "DownloadManager.h"
#import "ZSwitchToolView.h"
#import "ZDownloadEndTableView.h"
#import "ZDownloadingTableView.h"
#import "ZPlayerViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"

@interface ZUserDownloadViewController ()<DownloadManagerDelegate>

@property (strong, nonatomic) UISegmentedControl *scView;
///已下载
@property (strong, nonatomic) UIView *viewDownloadEnd;
///工具栏
@property (strong, nonatomic) ZSwitchToolView *viewTool;
///实务
@property (strong, nonatomic) ZDownloadEndTableView *tvPractice;
///订阅
@property (strong, nonatomic) ZDownloadEndTableView *tvSubscribe;
///系列课
@property (strong, nonatomic) ZDownloadEndTableView *tvSeriesCourse;
///下载中
@property (strong, nonatomic) ZDownloadingTableView *tvDownloading;
///已下载索引
@property (assign, nonatomic) NSInteger offsetIndex;

@property (strong, nonatomic) NSArray *arrayPractice;
@property (strong, nonatomic) NSArray *arraySubscribe;
@property (strong, nonatomic) NSArray *arraySeriesCourse;

@property (strong, nonatomic) XMCacheTrack *modeTDowning;
@property (assign, nonatomic) BOOL isDownloading;

@end

@implementation ZUserDownloadViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[DownloadManager sharedManager] setDownloadDelegate:self];
    [self innerData];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[DownloadManager sharedManager] setDownloadDelegate:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}
-(void)setViewNil
{
    OBJC_RELEASE(_scView);
    OBJC_RELEASE(_viewDownloadEnd);
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_tvPractice);
    OBJC_RELEASE(_tvSubscribe);
    OBJC_RELEASE(_tvSeriesCourse);
    OBJC_RELEASE(_tvDownloading);
    OBJC_RELEASE(_arrayPractice);
    OBJC_RELEASE(_arraySubscribe);
    OBJC_RELEASE(_arraySeriesCourse);
    OBJC_RELEASE(_modeTDowning);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.scView = [[UISegmentedControl alloc] initWithItems:@[kDownloadEnd,kDownloadCourse]];
    [self.scView setTintColor:RGBCOLOR(250, 107, 33)];
    [self.scView setSelectedSegmentIndex:0];
    [self.scView setFrame:CGRectMake(0, 8, 150, 28)];
    [self.scView addTarget:self action:@selector(setSegmentedControlValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [[self navigationItem] setTitleView:self.scView];
    
    ZWEAKSELF
    self.viewDownloadEnd = [[UIView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.viewDownloadEnd setBackgroundColor:VIEW_BACKCOLOR2];
    [self.view addSubview:self.viewDownloadEnd];
    
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemDownloadManager)];
    [self.viewTool setFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, [ZSwitchToolView getViewH])];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        [weakSelf setToolItemClick:index];
    }];
    [self.viewDownloadEnd addSubview:self.viewTool];
    
    CGFloat tvY = self.viewTool.height;
    CGFloat tvHeight = self.viewDownloadEnd.height-tvY;
    CGRect tvFrame = CGRectMake(0, tvY, self.viewDownloadEnd.width, tvHeight);
    self.tvPractice = [[ZDownloadEndTableView alloc] initWithFrame:tvFrame];
    [self.tvPractice setScrollsToTop:YES];
//    [self.tvPractice addRefreshHeaderWithEndBlock:^{
//        [weakSelf innerPractice];
//    }];
    [self.tvPractice setOnDeleteClick:^(XMCacheTrack *model) {
        [weakSelf setDeletePracticeWithModel:model];
    }];
    [self.tvPractice setOnRowSelected:^(NSArray *array, NSInteger row) {
        [weakSelf setShowPlayPracticeWithArray:array row:row];
    }];
    [self.tvPractice setOnDeleteMultipleClick:^(NSArray *array) {
        [weakSelf setDeleteMultipeWithArray:array];
    }];
    [self.viewDownloadEnd addSubview:self.tvPractice];
    
    self.tvSubscribe = [[ZDownloadEndTableView alloc] initWithFrame:tvFrame];
    [self.tvSubscribe setHidden:YES];
    [self.tvSubscribe setAlpha:0];
    [self.tvSubscribe setScrollsToTop:NO];
//    [self.tvSubscribe addRefreshHeaderWithEndBlock:^{
//        [weakSelf innerSubscribe];
//    }];
    [self.tvSubscribe setOnRowSelected:^(NSArray *array, NSInteger row) {
        [weakSelf setShowPlaySubscribeWithArray:array row:row];
    }];
    [self.tvSubscribe setOnDeleteMultipleClick:^(NSArray *array) {
        [weakSelf setDeleteMultipeWithArray:array];
    }];
    [self.tvSubscribe setOnDeleteClick:^(XMCacheTrack *model) {
        [weakSelf setDeleteSubscribeWithModel:model];
    }];
    [self.viewDownloadEnd addSubview:self.tvSubscribe];
    
    self.tvSeriesCourse = [[ZDownloadEndTableView alloc] initWithFrame:tvFrame];
    [self.tvSeriesCourse setHidden:YES];
    [self.tvSeriesCourse setAlpha:0];
    [self.tvSeriesCourse setScrollsToTop:NO];
//    [self.tvSeriesCourse addRefreshHeaderWithEndBlock:^{
//        [weakSelf innerSeriesCourse];
//    }];
    [self.tvSeriesCourse setOnRowSelected:^(NSArray *array, NSInteger row) {
        [weakSelf setShowPlaySubscribeWithArray:array row:row];
    }];
    [self.tvSeriesCourse setOnDeleteMultipleClick:^(NSArray *array) {
        [weakSelf setDeleteMultipeWithArray:array];
    }];
    [self.tvSeriesCourse setOnDeleteClick:^(XMCacheTrack *model) {
        [weakSelf setDeleteSeriesCourseWithModel:model];
    }];
    [self.viewDownloadEnd addSubview:self.tvSeriesCourse];
    
    self.tvDownloading = [[ZDownloadingTableView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.tvDownloading setHidden:YES];
    [self.tvDownloading setAlpha:0];
    [self.tvDownloading setScrollsToTop:NO];
    [self.tvDownloading addRefreshHeaderWithEndBlock:^{
        [weakSelf innerData];
    }];
    [self.tvDownloading setOnDeleteClick:^(XMCacheTrack *model) {
        [weakSelf setDeleteDownloadingWithModel:model];
    }];
    [self.tvDownloading setOnDownloadClick:^(XMCacheTrack *model) {
        [weakSelf setDownloadWithModel:model];
    }];
    [self.view addSubview:self.tvDownloading];
    
    [super innerInit];
}
-(void)innerData
{
    [self innerPractice];
    [self innerSubscribe];
    [self innerSeriesCourse];
    [self innerDownloading];
}
///实务数据集合
-(void)innerPractice
{
    NSInteger userId = [kLoginUserId integerValue];
    NSArray *arrPractice = [[DownloadManager sharedManager] getDownloadedTrackInAlbum:ZDownloadTypePractice];
    NSArray *arrayLocalDownload = [sqlite getLocalDownloadListWithUserId:kLoginUserId];
    NSMutableArray *arrayPractice = [NSMutableArray array];
    for (ModelTrack *modelT in arrPractice) {
        for (XMCacheTrack *modelCT in arrayLocalDownload) {
            if (modelCT.announcer.id == userId && modelT.trackId == modelCT.trackId) {
                [arrayPractice addObject:modelT];
                break;
            }
        }
    }
    self.arrayPractice = [NSArray arrayWithArray:arrayPractice];
    [self.tvPractice setViewDataWithArray:self.arrayPractice];
    [self.tvPractice endRefreshHeader];
}
///订阅数据集合
-(void)innerSubscribe
{
    NSInteger userId = [kLoginUserId integerValue];
    NSArray *arrSubscribe = [[DownloadManager sharedManager] getDownloadedTrackInAlbum:ZDownloadTypeSubscribe];
    NSArray *arrayLocalDownload = [sqlite getLocalDownloadListWithUserId:kLoginUserId];
    NSMutableArray *arraySubscribe = [NSMutableArray array];
    for (ModelTrack *modelT in arrSubscribe) {
        for (XMCacheTrack *modelCT in arrayLocalDownload) {
            if (modelCT.announcer.id == userId && modelT.trackId == modelCT.trackId) {
                [arraySubscribe addObject:modelT];
                break;
            }
        }
    }
    self.arraySubscribe = [NSArray arrayWithArray:arraySubscribe];
    [self.tvSubscribe setViewDataWithArray:self.arraySubscribe];
    [self.tvSubscribe endRefreshHeader];
}
///系列课数据集合
-(void)innerSeriesCourse
{
    NSInteger userId = [kLoginUserId integerValue];
    NSArray *arrSeriesCourse = [[DownloadManager sharedManager] getDownloadedTrackInAlbum:ZDownloadTypeSeriesCourse];
    NSArray *arrayLocalDownload = [sqlite getLocalDownloadListWithUserId:kLoginUserId];
    NSMutableArray *arraySeriesCourse = [NSMutableArray array];
    for (ModelTrack *modelT in arrSeriesCourse) {
        for (XMCacheTrack *modelCT in arrayLocalDownload) {
            if (modelCT.announcer.id == userId && modelT.trackId == modelCT.trackId) {
                [arraySeriesCourse addObject:modelT];
                break;
            }
        }
    }
    self.arraySeriesCourse = [NSArray arrayWithArray:arraySeriesCourse];
    [self.tvSeriesCourse setViewDataWithArray:self.arraySeriesCourse];
    [self.tvSeriesCourse endRefreshHeader];
}
///下载中数据集合
-(void)innerDownloading
{
    NSMutableArray *arrayLocalDownload = [sqlite getLocalDownloadListWithUserId:kLoginUserId];
    if (arrayLocalDownload) {
        NSMutableArray *arrayRemove = [NSMutableArray array];
        for (XMCacheTrack *modelCT in arrayLocalDownload) {
            for (ModelTrack *modelT in self.arrayPractice) {
                if (modelT.trackId == modelCT.trackId) {
                    [arrayRemove addObject:modelCT];
                    break;
                }
            }
        }
        [arrayLocalDownload removeObjectsInArray:arrayRemove];
        [arrayRemove removeAllObjects];
        for (XMCacheTrack *modelCT in arrayLocalDownload) {
            for (ModelTrack *modelT in self.arraySubscribe) {
                if (modelT.trackId == modelCT.trackId) {
                    [arrayRemove addObject:modelCT];
                    break;
                }
            }
        }
        [arrayLocalDownload removeObjectsInArray:arrayRemove];
        [arrayRemove removeAllObjects];
        for (XMCacheTrack *modelCT in arrayLocalDownload) {
            for (ModelTrack *modelT in self.arraySeriesCourse) {
                if (modelT.trackId == modelCT.trackId) {
                    [arrayRemove addObject:modelCT];
                    break;
                }
            }
        }
        [arrayLocalDownload removeObjectsInArray:arrayRemove];
        [arrayRemove removeAllObjects];
    }
    [self.tvDownloading setViewDataWithArray:arrayLocalDownload];
    [self.tvDownloading endRefreshHeader];
}
///播放实务
-(void)setShowPlayPracticeWithArray:(NSArray *)array row:(NSInteger)row
{
    if (array && array.count > 0) {
        NSArray *arrayLocalPractice = [sqlite getLocalPlayPracticeDetailArrayWithUserId:kLoginUserId];
        NSMutableArray *arrayPractice = [NSMutableArray array];
        for (XMCacheTrack *modelCT in array) {
            for (ModelPractice *modelP in arrayLocalPractice) {
                if ([[modelP.ids stringByAppendingString:kMultipleZeros] integerValue] == modelCT.trackId) {
                    [arrayPractice addObject:modelP];
                    break;
                }
            }
        }
        if (row < arrayPractice.count) {
            [self showPlayVCWithPracticeArray:arrayPractice index:row];
        } else {
            [ZProgressHUD showError:kNotFoundPlayRecord];
        }
    }
}
///播放订阅||系列课
-(void)setShowPlaySubscribeWithArray:(NSArray *)array row:(NSInteger)row
{
    if (array && array.count > 0) {
        NSArray *arrayLocalSubscribe = [sqlite getLocalPlayCurriculumDetailArrayWithUserId:kLoginUserId];
        NSMutableArray *arraySubscribe = [NSMutableArray array];
        for (XMCacheTrack *modelCT in array) {
            for (ModelCurriculum *modelC in arrayLocalSubscribe) {
                if ([modelC.ids integerValue] == modelCT.trackId) {
                    [arraySubscribe addObject:modelC];
                    break;
                }
            }
        }
        if (row < arraySubscribe.count) {
            [self showPlayVCWithCurriculumArray:arraySubscribe index:row];
        } else {
            [ZProgressHUD showError:kNotFoundPlayRecord];
        }
    }
}
///删除多个数据对象
-(void)setDeleteMultipeWithArray:(NSArray *)array
{
    if (array && array.count > 0) {
        [[DownloadManager sharedManager] clearDownloadTracks:[NSMutableArray arrayWithArray:array]];
        [sqlite delLocalDownloadListWithArray:array];
        [self innerData];
    }
}
///删除一个实务下载完成的数据对象
-(void)setDeletePracticeWithModel:(XMCacheTrack *)model
{
    [[ZPlayerViewController sharedSingleton] setDeleteDownloadWithModel:model];
    [sqlite delLocalDownloadListWithTrackId:model.trackId dataType:model.source];
    [[DownloadManager sharedManager] clearDownloadAudio:model];
    [self innerPractice];
}
///删除一个订阅下载完成的数据对象
-(void)setDeleteSubscribeWithModel:(XMCacheTrack *)model
{
    [[ZPlayerViewController sharedSingleton] setDeleteDownloadWithModel:model];
    [sqlite delLocalDownloadListWithTrackId:model.trackId dataType:model.source];
    [[DownloadManager sharedManager] clearDownloadAudio:model];
    [self innerSubscribe];
}
///删除一个系列课下载完成的数据对象
-(void)setDeleteSeriesCourseWithModel:(XMCacheTrack *)model
{
    [[ZPlayerViewController sharedSingleton] setDeleteDownloadWithModel:model];
    [sqlite delLocalDownloadListWithTrackId:model.trackId dataType:model.source];
    [[DownloadManager sharedManager] clearDownloadAudio:model];
    [self innerSeriesCourse];
}
///删除一个下载中的数据对象
-(void)setDeleteDownloadingWithModel:(XMCacheTrack *)model
{
    [sqlite delLocalDownloadListWithTrackId:model.trackId dataType:model.source];
    [[DownloadManager sharedManager] clearDownloadAudio:model];
    [self innerDownloading];
}
///开始下载对象
-(void)setDownloadWithModel:(XMCacheTrack *)model
{
    if (self.modeTDowning && self.modeTDowning.trackId == model.trackId && self.modeTDowning.source == model.source) {
        self.modeTDowning = nil;
        [[DownloadManager sharedManager] pauseDownloadSingleTrack:model];
    } else {
        self.modeTDowning = model;
        [[DownloadManager sharedManager] resumeDownloadSingleTrack:model];
    }
}
///工具栏索引改变
-(void)setToolItemClick:(NSInteger)index
{
    switch (index) {
        case 2:
            [self.tvPractice setScrollsToTop:NO];
            [self.tvSeriesCourse setScrollsToTop:NO];
            [self.tvSubscribe setScrollsToTop:YES];
            break;
        case 3:
            [self.tvPractice setScrollsToTop:NO];
            [self.tvSeriesCourse setScrollsToTop:NO];
            [self.tvSubscribe setScrollsToTop:YES];
        default:
            [self.tvPractice setScrollsToTop:YES];
            [self.tvSeriesCourse setScrollsToTop:NO];
            [self.tvSubscribe setScrollsToTop:NO];
            break;
    }
    if (self.offsetIndex == index) {
        return;
    }
    [self setOffsetIndex:index];
    switch (index) {
        case 2:
        {
            [self.viewTool setOffsetChange:self.viewTool.width];
            [self.tvSeriesCourse setHidden:NO];
            [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                [self.tvPractice setAlpha:0];
                [self.tvSubscribe setAlpha:0];
                [self.tvSeriesCourse setAlpha:1];
            } completion:^(BOOL finished) {
                [self.tvPractice setHidden:YES];
                [self.tvSubscribe setHidden:YES];
            }];
            break;
        }
        case 3:
        {
            [self.viewTool setOffsetChange:self.viewTool.width*2];
            [self.tvSubscribe setHidden:NO];
            [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                [self.tvPractice setAlpha:0];
                [self.tvSubscribe setAlpha:1];
                [self.tvSeriesCourse setAlpha:0];
            } completion:^(BOOL finished) {
                [self.tvPractice setHidden:YES];
                [self.tvSeriesCourse setHidden:YES];
            }];
            break;
        }
        default:
        {
            [self.viewTool setOffsetChange:0];
            [self.tvPractice setHidden:NO];
            [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
                [self.tvPractice setAlpha:1];
                [self.tvSubscribe setAlpha:0];
                [self.tvSeriesCourse setAlpha:0];
            } completion:^(BOOL finished) {
                [self.tvSubscribe setHidden:YES];
                [self.tvSeriesCourse setHidden:YES];
            }];
            break;
        }
    }
}
///切换已下载和下载中
-(void)setSegmentedControlValueChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [self.viewDownloadEnd setHidden:NO];
        [self.tvDownloading setScrollsToTop:NO];
        [self setToolItemClick:self.offsetIndex];
        [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            [self.viewDownloadEnd setAlpha:1];
            [self.tvDownloading setAlpha:0];
        } completion:^(BOOL finished) {
            [self.tvDownloading setHidden:YES];
        }];
    } else {
        [self.tvDownloading setHidden:NO];
        [self.tvDownloading setScrollsToTop:YES];
        [self.tvPractice setScrollsToTop:NO];
        [self.tvSubscribe setScrollsToTop:NO];
        [self.tvSeriesCourse setScrollsToTop:NO];
        [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            [self.viewDownloadEnd setAlpha:0];
            [self.tvDownloading setAlpha:1];
        } completion:^(BOOL finished) {
            [self.viewDownloadEnd setHidden:YES];
        }];
    }
}

#pragma mark - DownloadManagerDelegate

///下载失败时被调用
- (void)trackDownloadDidFailed:(XMTrack *)track
{
    self.modeTDowning = nil;
    [self setIsDownloading:NO];
}
////下载完成时被调用
- (void)trackDownloadDidFinished:(XMTrack *)track
{
    self.modeTDowning = nil;
    [self setIsDownloading:NO];
    GCDAfterBlock(0.5, ^{ [self innerData]; });
}
///下载开始时被调用
- (void)trackDownloadDidBegan:(XMTrack *)track
{
    [self setIsDownloading:YES];
    [self.tvDownloading setDownloadButtonImage:(XMCacheTrackStatusDownloading) model:track];
}
///下载取消时被调用
- (void)trackDownloadDidCanceled:(XMTrack *)track
{
    self.modeTDowning = nil;
    [self setIsDownloading:NO];
    [self.tvDownloading setDownloadButtonImage:(XMCacheTrackStatusCancelled) model:track];
}
///下载暂停时被调用
- (void)trackDownloadDidPaused:(XMTrack *)track
{
    [self setIsDownloading:NO];
    [self.tvDownloading setDownloadButtonImage:(XMCacheTrackStatusPausedByUser) model:track];
}
///下载进度更新时被调用
- (void)track:(XMTrack *)track updateDownloadedPercent:(double)downloadedPercent
{
    [self setIsDownloading:YES];
    [self.tvDownloading setDownloadProgress:downloadedPercent model:track];
}
///下载状态更新为ready时被调用
- (void)trackDownloadStatusUpdated:(XMTrack *)track
{
    [self.tvDownloading setDownloadButtonImage:(XMCacheTrackStatusDownloading) model:track];
}
///从数据库载入数据时被调用
- (void)trackDownloadDidLoadFromDB
{
    [self innerData];
}

@end
