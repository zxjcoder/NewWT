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
#import "ZDownloadCourseTableView.h"
#import "ZDownloadingTableView.h"
#import "ZPlayerViewController.h"
#import "ZDownloadFooterView.h"
#import "ZSubscribeAlreadyHasViewController.h"
#import "ZTrafficDownloadView.h"

@interface ZUserDownloadViewController ()<DownloadManagerDelegate>

///工具栏
@property (strong, nonatomic) ZSwitchToolView *viewTool;
///实务
@property (strong, nonatomic) ZDownloadCourseTableView *tvPractice;
///系列课
@property (strong, nonatomic) ZDownloadCourseTableView *tvSeriesCourse;
///订阅
@property (strong, nonatomic) ZDownloadCourseTableView *tvSubscribe;
///下载中
@property (strong, nonatomic) ZDownloadingTableView *tvDownloading;
///删除
@property (strong, nonatomic) ZDownloadFooterView *viewFooter;
///已下载索引
@property (assign, nonatomic) NSInteger offsetIndex;

///微课下载完成的集合
//@property (strong, nonatomic) NSArray *arrayPractice;
///培训课下载完成的集合
//@property (strong, nonatomic) NSArray *arraySubscribe;
///系列课下载完成的集合
//@property (strong, nonatomic) NSArray *arraySeriesCourse;
///下载中
@property (strong, nonatomic) NSMutableArray *arrayDownloading;
///下载全部
@property (strong, nonatomic) NSMutableArray *arrayDownloadAll;
///当前下载的row
@property (assign, nonatomic) NSInteger downloadRow;
///批量管理按钮
@property (strong, nonatomic) UIButton *btnManager;
///是否在批量管理中
@property (assign, nonatomic) BOOL isChecking;
///视图初始化坐标
@property (assign, nonatomic) CGRect tvFrame;
///底部控件初始化坐标
@property (assign, nonatomic) CGRect footerFrame;

@end

@implementation ZUserDownloadViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kDownloadManager];
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setIsShowManagerButton:self.offsetIndex];
    [[DownloadManager sharedManager] setDownloadDelegate:self];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self innerData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_tvPractice);
    OBJC_RELEASE(_tvSubscribe);
    OBJC_RELEASE(_tvSeriesCourse);
    OBJC_RELEASE(_tvDownloading);
    
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.downloadRow = -1;
    self.arrayDownloading = [NSMutableArray array];
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemDownloadManager)];
    [self.viewTool setFrame:CGRectMake(0, APP_TOP_HEIGHT+10, APP_FRAME_WIDTH, [ZSwitchToolView getViewH])];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        [weakSelf setIsShowManagerButton:index];
        [weakSelf setToolItemClick:index];
    }];
    [self.view addSubview:self.viewTool];
    // 微课
    CGFloat tvY = self.viewTool.height + self.viewTool.y;
    CGFloat tvHeight = APP_FRAME_HEIGHT-tvY;
    CGRect tvFrame = CGRectMake(0, tvY, APP_FRAME_WIDTH, tvHeight);
    self.tvFrame = tvFrame;
    self.tvPractice = [[ZDownloadCourseTableView alloc] initWithFrame:tvFrame];
    [self.tvPractice setScrollsToTop:YES];
    [self.tvPractice setOnDeleteClick:^(XMCacheTrack *model) {
        [weakSelf setDeletePracticeWithModel:model];
    }];
    [self.tvPractice setOnCheckChange:^(BOOL isAll, NSInteger count) {
        [weakSelf.viewFooter setViewCheckStatus:isAll];
        [weakSelf.viewFooter setSelectCount:count];
    }];
    [self.tvPractice setOnRowSelected:^(NSArray *array, NSInteger row) {
        [weakSelf setShowPlayPracticeWithArray:array row:row];
    }];
    [self.view addSubview:self.tvPractice];
    // 系列课
    self.tvSeriesCourse = [[ZDownloadCourseTableView alloc] initWithFrame:tvFrame];
    [self.tvSeriesCourse setHidden:YES];
    [self.tvSeriesCourse setAlpha:0];
    [self.tvSeriesCourse setScrollsToTop:NO];
    [self.tvSeriesCourse setOnRowSelected:^(NSArray *array, NSInteger row) {
        [weakSelf setShowPlaySubscribeWithArray:array row:row];
    }];
    [self.tvSeriesCourse setOnDeleteClick:^(XMCacheTrack *model) {
        [weakSelf setDeleteSeriesCourseWithModel:model];
    }];
    [self.tvSeriesCourse setOnCheckChange:^(BOOL isAll, NSInteger count) {
        [weakSelf.viewFooter setViewCheckStatus:isAll];
        [weakSelf.viewFooter setSelectCount:count];
    }];
    [self.view addSubview:self.tvSeriesCourse];
    // 培训课
    self.tvSubscribe = [[ZDownloadCourseTableView alloc] initWithFrame:tvFrame];
    [self.tvSubscribe setHidden:YES];
    [self.tvSubscribe setAlpha:0];
    [self.tvSubscribe setScrollsToTop:NO];
    [self.tvSubscribe setOnRowSelected:^(NSArray *array, NSInteger row) {
        [weakSelf setShowPlaySubscribeWithArray:array row:row];
    }];
    [self.tvSubscribe setOnDeleteClick:^(XMCacheTrack *model) {
        [weakSelf setDeleteSubscribeWithModel:model];
    }];
    [self.tvSubscribe setOnCheckChange:^(BOOL isAll, NSInteger count) {
        [weakSelf.viewFooter setViewCheckStatus:isAll];
        [weakSelf.viewFooter setSelectCount:count];
    }];
    [self.view addSubview:self.tvSubscribe];
    // 下载中
    self.tvDownloading = [[ZDownloadingTableView alloc] initWithFrame:tvFrame];
    [self.tvDownloading setHidden:YES];
    [self.tvDownloading setAlpha:0];
    [self.tvDownloading setScrollsToTop:NO];
    [self.tvDownloading setOnDeleteClick:^(XMCacheTrack *model) {
        [weakSelf setDeleteDownloadingWithModel:model];
    }];
    [self.tvDownloading setOnDownloadClick:^(NSInteger row, XMCacheTrack *model) {
        [weakSelf setDownloadSingle:row model:model];
    }];
    [self.view addSubview:self.tvDownloading];
    // 底部工具栏
    self.footerFrame = CGRectMake(0, APP_FRAME_HEIGHT, APP_FRAME_WIDTH, [ZDownloadFooterView getH]);
    self.viewFooter = [[ZDownloadFooterView alloc] initWithFrame:self.footerFrame];
    [self.view addSubview:self.viewFooter];
    [self.viewFooter setOnDeleteClick:^{
        switch (weakSelf.offsetIndex) {
            case 1:
                [weakSelf setDeleteMultipeWithArray:[weakSelf.tvPractice getCheckArray]];
                break;
            case 2:
                [weakSelf setDeleteMultipeWithArray:[weakSelf.tvSeriesCourse getCheckArray]];
                break;
            case 3:
                [weakSelf setDeleteMultipeWithArray:[weakSelf.tvSubscribe getCheckArray]];
                break;
            default:
                break;
        }
    }];
    [self.viewFooter setOnCheckAllClick:^(BOOL isCheckAll) {
        switch (weakSelf.offsetIndex) {
            case 1:
                [weakSelf.tvPractice setStartCheckAll:isCheckAll];
                if (isCheckAll) {
                    [weakSelf.viewFooter setSelectCount:[weakSelf.tvPractice getAllArrayCount]];
                } else {
                    [weakSelf.viewFooter setSelectCount:0];
                }
                break;
            case 2:
                [weakSelf.tvSeriesCourse setStartCheckAll:isCheckAll];
                if (isCheckAll) {
                    [weakSelf.viewFooter setSelectCount:[weakSelf.tvSeriesCourse getAllArrayCount]];
                } else {
                    [weakSelf.viewFooter setSelectCount:0];
                }
                break;
            case 3:
                [weakSelf.tvSubscribe setStartCheckAll:isCheckAll];
                if (isCheckAll) {
                    [weakSelf.viewFooter setSelectCount:[weakSelf.tvSubscribe getAllArrayCount]];
                } else {
                    [weakSelf.viewFooter setSelectCount:0];
                }
                break;
            default:
                break;
        }
    }];
    self.arrayDownloadAll = [sqlite getLocalDownloadListWithUserId:kLoginUserId];
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
    [self setReloadData:(ZDownloadTypePractice)];
}
///订阅数据集合
-(void)innerSubscribe
{
    [self setReloadData:(ZDownloadTypeSubscribe)];
}
///系列课数据集合
-(void)innerSeriesCourse
{
    [self setReloadData:(ZDownloadTypeSeriesCourse)];
}
///加载数据
-(void)setReloadData:(ZDownloadType)type
{
    NSArray *arrayDownloadEnd = [sqlite getLocalDownloadStatusEndDownload:type];
    GCDGlobalBlock(^{
        NSMutableArray *arrayData = [NSMutableArray array];
        if (arrayDownloadEnd.count > 0) {
            for (XMCacheTrack *modelCT in self.arrayDownloadAll) {
                for (NSDictionary *dic in arrayDownloadEnd) {
                    NSString *ids = [dic objectForKey:@"id"];
                    if ([ids isKindOfClass:[NSString class]] && [ids longLongValue] == modelCT.trackId) {
                        [arrayData addObject:modelCT];
                        break;
                    }
                }
            }
        }
        GCDMainBlock(^{
            switch (type) {
                case ZDownloadTypePractice:
                    [self.tvPractice setViewDataWithArray:arrayData];
                    break;
                case ZDownloadTypeSubscribe:
                    [self.tvSubscribe setViewDataWithArray:arrayData];
                    break;
                case ZDownloadTypeSeriesCourse:
                    [self.tvSeriesCourse setViewDataWithArray:arrayData];
                    break;
                default:
                    [self.tvPractice setViewDataWithArray:arrayData];
                    break;
            }
        });
    });
}
///下载中数据集合
-(void)innerDownloading
{
    NSArray *arrayDownloadNoEnd = [sqlite getLocalDownloadStatusNotEndDownload];
    [self.arrayDownloading removeAllObjects];
    GCDGlobalBlock(^{
        if (arrayDownloadNoEnd.count > 0) {
            if (arrayDownloadNoEnd.count > 0) {
                for (XMCacheTrack *modelCT in self.arrayDownloadAll) {
                    for (NSDictionary *dic in arrayDownloadNoEnd) {
                        NSString *ids = [dic objectForKey:@"id"];
                        if ([ids isKindOfClass:[NSString class]] && [ids longLongValue] == modelCT.trackId) {
                            
                            modelCT.updatedAt = 0;
                            XMTrackDownloadStatus *status = [[DownloadManager sharedManager] getSingleTrackDownloadStatus:modelCT.trackId];
                            if (status) {
                                modelCT.totalBytes = status.totalBytes;
                                modelCT.downloadedBytes =  status.downloadedBytes;
                                modelCT.status =  status.state;
                            } else {
                                NSString *strstatus = [dic objectForKey:@"status"];
                                if (strstatus) {
                                    modelCT.status = [strstatus integerValue];
                                }
                            }
                            [self.arrayDownloading addObject:modelCT];
                            break;
                        }
                    }
                }
            }
        }
        GCDMainBlock(^{
            [self.tvDownloading setViewDataWithArray:self.arrayDownloading];
        });
    });
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
    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
        [[DownloadManager sharedManager] clearDownloadTracks:[NSMutableArray arrayWithArray:array]];
        for (XMCacheTrack *model in array) {
            if (model.playUrl32) {
                [Utils deleteDirectory:[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[model.playUrl32 toMD5]]];
            }
        }
        [sqlite delLocalDownloadListWithArray:array];
        [sqlite delLocalDownloadStatusWithArray:array];
        switch (self.offsetIndex) {
            case 1:
                [self innerPractice];
                break;
            case 2:
                [self innerSeriesCourse];
                break;
            case 3:
                [self innerSubscribe];
                break;
            default:
                break;
        }
    }
    [self btnBatchManagerClick];
}
///删除一个实务下载完成的数据对象
-(void)setDeletePracticeWithModel:(XMCacheTrack *)model
{
    [[ZPlayerViewController sharedSingleton] setDeleteDownloadWithModel:model];
    [sqlite delLocalDownloadListWithTrackId:model.trackId dataType:model.source];
    [sqlite delLocalDownloadStatusWithModel:model];
    [[DownloadManager sharedManager] clearDownloadAudio:model];
    if (model.playUrl32) {
        [Utils deleteDirectory:[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[model.playUrl32 toMD5]]];
    }
    [self.tvPractice removeViewData:model];
}
///删除一个订阅下载完成的数据对象
-(void)setDeleteSubscribeWithModel:(XMCacheTrack *)model
{
    [[ZPlayerViewController sharedSingleton] setDeleteDownloadWithModel:model];
    [sqlite delLocalDownloadListWithTrackId:model.trackId dataType:model.source];
    [sqlite delLocalDownloadStatusWithModel:model];
    [[DownloadManager sharedManager] clearDownloadAudio:model];
    if (model.playUrl32) {
        [Utils deleteDirectory:[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[model.playUrl32 toMD5]]];
    }
    [self.tvSubscribe removeViewData:model];
}
///删除一个系列课下载完成的数据对象
-(void)setDeleteSeriesCourseWithModel:(XMCacheTrack *)model
{
    [[ZPlayerViewController sharedSingleton] setDeleteDownloadWithModel:model];
    [sqlite delLocalDownloadListWithTrackId:model.trackId dataType:model.source];
    [sqlite delLocalDownloadStatusWithModel:model];
    [[DownloadManager sharedManager] clearDownloadAudio:model];
    if (model.playUrl32) {
        [Utils deleteDirectory:[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[model.playUrl32 toMD5]]];
    }
    [self.tvSeriesCourse removeViewData:model];
}
///删除一个下载中的数据对象
-(void)setDeleteDownloadingWithModel:(XMCacheTrack *)model
{
    [sqlite delLocalDownloadListWithTrackId:model.trackId dataType:model.source];
    [sqlite delLocalDownloadStatusWithModel:model];
    [[DownloadManager sharedManager] clearDownloadAudio:model];
    if (model.playUrl32) {
        [Utils deleteDirectory:[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[model.playUrl32 toMD5]]];
    }
    [self.arrayDownloading removeObject:model];
    [self.tvDownloading setViewDataWithArray:self.arrayDownloading];
}

///工具栏索引改变
-(void)setToolItemClick:(NSInteger)index
{
    switch (index) {
        case 2:
            [self.tvPractice setScrollsToTop:NO];
            [self.tvSeriesCourse setScrollsToTop:NO];
            [self.tvSubscribe setScrollsToTop:YES];
            [self.tvDownloading setScrollsToTop:NO];
            break;
        case 3:
            [self.tvPractice setScrollsToTop:NO];
            [self.tvSeriesCourse setScrollsToTop:NO];
            [self.tvSubscribe setScrollsToTop:YES];
            [self.tvDownloading setScrollsToTop:NO];
        case 4:
            [self.tvPractice setScrollsToTop:NO];
            [self.tvSeriesCourse setScrollsToTop:NO];
            [self.tvSubscribe setScrollsToTop:NO];
            [self.tvDownloading setScrollsToTop:YES];
        default:
            [self.tvPractice setScrollsToTop:YES];
            [self.tvSeriesCourse setScrollsToTop:NO];
            [self.tvSubscribe setScrollsToTop:NO];
            [self.tvDownloading setScrollsToTop:NO];
            break;
    }
    if (self.offsetIndex == index) {
        return;
    }
    [self setOffsetIndex:index];
    [self setIsChecking:false];
    
    self.tvPractice.frame = self.tvFrame;
    self.tvSeriesCourse.frame = self.tvFrame;
    self.tvSubscribe.frame = self.tvFrame;
    self.tvDownloading.frame = self.tvFrame;
    
    [self.tvPractice setStartChecking:false];
    [self.tvSeriesCourse setStartChecking:false];
    [self.tvSubscribe setStartChecking:false];
    
    switch (index) {
        case 2:
        {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [self.viewTool setOffsetChange:self.viewTool.width];
                self.viewFooter.frame = self.footerFrame;
            }];
            [self.tvSeriesCourse setHidden:NO];
            
            self.tvSeriesCourse.frame = self.tvFrame;
            self.viewFooter.frame = self.footerFrame;
            [self.tvSeriesCourse setStartChecking:false];
            
            [self.tvPractice setAlpha:0];
            [self.tvSubscribe setAlpha:0];
            [self.tvSeriesCourse setAlpha:1];
            [self.tvDownloading setAlpha:0];

            [self.tvPractice setHidden:YES];
            [self.tvSubscribe setHidden:YES];
            [self.tvDownloading setHidden:YES];
            break;
        }
        case 3:
        {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [self.viewTool setOffsetChange:self.viewTool.width*2];
                self.viewFooter.frame = self.footerFrame;
            }];
            [self.tvSubscribe setHidden:NO];
            
            [self.tvPractice setAlpha:0];
            [self.tvSubscribe setAlpha:1];
            [self.tvSeriesCourse setAlpha:0];
            [self.tvDownloading setAlpha:0];
            
            [self.tvPractice setHidden:YES];
            [self.tvSeriesCourse setHidden:YES];
            [self.tvDownloading setHidden:YES];
            break;
        }
        case 4: {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [self.viewTool setOffsetChange:self.viewTool.width*3];
                self.viewFooter.frame = self.footerFrame;
            }];
            [self.tvDownloading setHidden:NO];
            
            [self.tvPractice setAlpha:0];
            [self.tvSubscribe setAlpha:0];
            [self.tvSeriesCourse setAlpha:0];
            [self.tvDownloading setAlpha:1];
            
            [self.tvPractice setHidden:YES];
            [self.tvSeriesCourse setHidden:YES];
            [self.tvSubscribe setHidden:YES];
            break;
        }
        default:
        {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [self.viewTool setOffsetChange:0];
                self.viewFooter.frame = self.footerFrame;
            }];
            [self.tvPractice setHidden:NO];
            
            [self.tvPractice setAlpha:1];
            [self.tvSubscribe setAlpha:0];
            [self.tvSeriesCourse setAlpha:0];
            [self.tvDownloading setAlpha:0];
            
            [self.tvSubscribe setHidden:YES];
            [self.tvSeriesCourse setHidden:YES];
            [self.tvDownloading setHidden:YES];
            break;
        }
    }
}
/// 批量管理下载按钮
-(void)btnBatchManagerClick
{
    if (self.offsetIndex == 0) {
        self.offsetIndex = 1;
    }
    if (self.offsetIndex == 4) {
        self.isChecking = false;
    } else {
        self.isChecking = !self.isChecking;
    }
    [self setShowFooterView];
    
    if (self.isChecking) {
        [self setManagerRightButton: kCancel];
    } else {
        [self setManagerRightButton: kBatchManagement];
    }
}
/// 显示底部删除数据
-(void)setShowFooterView
{
    if (self.isChecking) {
        switch (self.offsetIndex) {
            case 2:
            {
                CGRect tvFrame = self.tvFrame;
                tvFrame.size.height -= self.viewFooter.height;
                self.tvSeriesCourse.frame = tvFrame;
                [UIView animateWithDuration:kANIMATION_TIME animations:^{
                    CGRect footerFrame = self.footerFrame;
                    footerFrame.origin.y -= footerFrame.size.height;
                    self.viewFooter.frame = footerFrame;
                }];
                [self.tvSeriesCourse setStartChecking:self.isChecking];
                break;
            }
            case 3: {
                CGRect tvFrame = self.tvFrame;
                tvFrame.size.height -= self.viewFooter.height;
                self.tvSubscribe.frame = tvFrame;
                [UIView animateWithDuration:kANIMATION_TIME animations:^{
                    CGRect footerFrame = self.footerFrame;
                    footerFrame.origin.y -= footerFrame.size.height;
                    self.viewFooter.frame = footerFrame;
                }];
                [self.tvSubscribe setStartChecking:self.isChecking];
                break;
            }
            case 4: {
                self.tvPractice.frame = self.tvFrame;
                self.tvSeriesCourse.frame = self.tvFrame;
                self.tvSubscribe.frame = self.tvFrame;
                [self.tvPractice setStartChecking:false];
                [self.tvSeriesCourse setStartChecking:false];
                [self.tvSubscribe setStartChecking:false];
                [UIView animateWithDuration:kANIMATION_TIME animations:^{
                    self.viewFooter.frame = self.footerFrame;
                }];
                break;
            }
            default:
            {
                CGRect tvFrame = self.tvFrame;
                tvFrame.size.height -= self.viewFooter.height;
                self.tvPractice.frame = tvFrame;
                [UIView animateWithDuration:kANIMATION_TIME animations:^{
                    CGRect footerFrame = self.footerFrame;
                    footerFrame.origin.y -= footerFrame.size.height;
                    self.viewFooter.frame = footerFrame;
                }];
                [self.tvPractice setStartChecking:self.isChecking];
                break;
            }
        }
    } else {
        switch (self.offsetIndex) {
            case 2:
            {
                self.tvSeriesCourse.frame = self.tvFrame;
                [UIView animateWithDuration:kANIMATION_TIME animations:^{
                    self.viewFooter.frame = self.footerFrame;
                }];
                [self.tvSeriesCourse setStartChecking:self.isChecking];
                break;
            }
            case 3: {
                self.tvSubscribe.frame = self.tvFrame;
                [UIView animateWithDuration:kANIMATION_TIME animations:^{
                    self.viewFooter.frame = self.footerFrame;
                }];
                [self.tvSubscribe setStartChecking:self.isChecking];
                break;
            }
            case 4: {
                self.tvPractice.frame = self.tvFrame;
                self.tvSeriesCourse.frame = self.tvFrame;
                self.tvSubscribe.frame = self.tvFrame;
                [self.tvPractice setStartChecking:false];
                [self.tvSeriesCourse setStartChecking:false];
                [self.tvSubscribe setStartChecking:false];
                [UIView animateWithDuration:kANIMATION_TIME animations:^{
                    self.viewFooter.frame = self.footerFrame;
                }];
                break;
            }
            default:
            {
                self.tvPractice.frame = self.tvFrame;
                [UIView animateWithDuration:kANIMATION_TIME animations:^{
                    self.viewFooter.frame = self.footerFrame;
                }];
                [self.tvPractice setStartChecking:self.isChecking];
                break;
            }
        }
    }
}
/// 是否显示批量管理按钮
-(void)setIsShowManagerButton:(NSInteger)index
{
    if (self.offsetIndex > 0 && self.offsetIndex == index) {
        return;
    }
    if (self.offsetIndex > 0 && self.offsetIndex != 4 && index != 4 && !self.isChecking) {
        return;
    }
    if (index == 4) {
        [self.navigationItem setRightBarButtonItem:nil];
    } else {
        self.isChecking = false;
        [self setManagerRightButton: kBatchManagement];
    }
}
-(void)setManagerRightButton:(NSString *)text
{
    UIButton *btnRight = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnRight setFrame:(CGRectMake(0, 0, 64, 45))];
    [btnRight setTitle:text forState:(UIControlStateNormal)];
    [btnRight setTitleColor:COLORCONTENT1 forState:(UIControlStateNormal)];
    [btnRight setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
    [btnRight setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
    [[btnRight titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [btnRight addTarget:self action:@selector(btnBatchManagerClick) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *btnBarRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    [self.navigationItem setRightBarButtonItem:btnBarRight];
}

#pragma mark - 下载管理

/// 下载单个按钮
-(void)setDownloadSingle:(NSInteger)row model:(XMCacheTrack *)model
{
    GBLog(@"setDownloadSingle: %@, row: %ld", model.trackTitle, row);
    if (self.arrayDownloading.count > row) {
        XMTrackDownloadStatus *status = [[DownloadManager sharedManager] getSingleTrackDownloadStatus:model.trackId];
        switch (status.state) {
            case XMCacheTrackStatusDownloading:
                [[DownloadManager sharedManager] pauseDownloadSingleTrack:model];
                break;
            case XMCacheTrackStatusDownloaded:
                break;
            default:
                switch ([[AppDelegate app] statusNetwork]) {
                    case 1: {
                        self.downloadRow = row;
                        [[DownloadManager sharedManager] downloadSingleTrack:model immediately:true];
                        break;
                    }
                    case 2: {
                        ZWEAKSELF
                        ZTrafficDownloadView *downloadView = [[ZTrafficDownloadView alloc] initWithSize:0];
                        [downloadView setOnConfirmationClick:^{
                            weakSelf.downloadRow = row;
                            [[DownloadManager sharedManager] downloadSingleTrack:model immediately:true];
                        }];
                        [downloadView show];
                        break;
                    }
                    default:
                        [ZProgressHUD showError:@"无网络,请检查网络设置"];
                        break;
                }
                break;
        }
    }
}
/// 下载完成
-(void)setDownloadEndChange
{
    GBLog(@"setDownloadEndChange-downloadRow: %ld, arrayDownloading: %ld", self.downloadRow, self.arrayDownloading.count);
    if (self.downloadRow >= 0 && self.arrayDownloading.count > self.downloadRow) {
        XMCacheTrack *modelT = [self.arrayDownloading objectAtIndex:self.downloadRow];
        switch (modelT.source) {
            case ZDownloadTypePractice:
                [self.tvPractice addViewData:modelT];
                break;
            case ZDownloadTypeSubscribe:
                [self.tvSubscribe addViewData:modelT];
                break;
            case ZDownloadTypeSeriesCourse:
                [self.tvSeriesCourse addViewData:modelT];
                break;
            default:
                break;
        }
        [self.arrayDownloading removeObjectAtIndex:self.downloadRow];
        [self.tvDownloading setDownloadRemoveWithIndex:self.downloadRow];
    }
    self.downloadRow = -1;
    if (self.arrayDownloading.count > 0) {
        XMCacheTrack *modelT = self.arrayDownloading.firstObject;
        [[DownloadManager sharedManager] downloadSingleTrack:modelT immediately:true];
    }
}
/// 处理当前下载对象索引
-(void)setDownloadChangeRow:(NSUInteger)trackId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trackId == %ld", trackId];
    NSArray *filteredArray = [self.arrayDownloading filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        XMCacheTrack *modelT = filteredArray.firstObject;
        self.downloadRow = [self.arrayDownloading indexOfObject:modelT];
    } else {
        self.downloadRow = -1;
    }
    GBLog(@"setDownloadChangeRow-downloadRow: %ld", self.downloadRow);
}
/// 改变下载状态图标
-(void)setDownloadChangeStatus:(XMCacheTrackStatus)status
{
    if (self.downloadRow >= 0 && self.downloadRow < self.arrayDownloading.count) {
        [self.tvDownloading setDownloadStatus:status row:self.downloadRow];
        XMCacheTrack *modelT = [self.arrayDownloading objectAtIndex:self.downloadRow];
        modelT.status = status;
    }
}
/// 更新下载进度
-(void)setDownloadProgress:(double)progress
{
    if (self.downloadRow >= 0 && self.downloadRow < self.arrayDownloading.count) {
        [self.tvDownloading setDownloadProgress:progress row:self.downloadRow];
    }
}

#pragma mark - DownloadManagerDelegate

///下载失败时被调用
- (void)trackDownloadDidFailed:(XMTrack *)track
{
    [self setDownloadChangeStatus:(XMCacheTrackStatusFailed)];
}
////下载完成时被调用
- (void)trackDownloadDidFinished:(XMTrack *)track
{
    [self setDownloadChangeStatus:(XMCacheTrackStatusDownloaded)];
    [self setDownloadEndChange];
}
///下载开始时被调用
- (void)trackDownloadDidBegan:(XMTrack *)track
{
    [self setDownloadChangeStatus:(XMCacheTrackStatusDownloading)];
}
///下载取消时被调用
- (void)trackDownloadDidCanceled:(XMTrack *)track
{
    [self setDownloadChangeStatus:(XMCacheTrackStatusCancelled)];
}
///下载暂停时被调用
- (void)trackDownloadDidPaused:(XMTrack *)track
{
    [self setDownloadChangeStatus:(XMCacheTrackStatusPausedByUser)];
}
///下载进度更新时被调用
- (void)track:(XMTrack *)track updateDownloadedPercent:(double)downloadedPercent
{
    [self setDownloadProgress:downloadedPercent];
}
///下载状态更新为ready时被调用
- (void)trackDownloadStatusUpdated:(XMTrack *)track
{
    [self setDownloadChangeRow:(track.trackId)];
}
///从数据库载入数据时被调用
- (void)trackDownloadDidLoadFromDB
{
    [self innerData];
}

@end
