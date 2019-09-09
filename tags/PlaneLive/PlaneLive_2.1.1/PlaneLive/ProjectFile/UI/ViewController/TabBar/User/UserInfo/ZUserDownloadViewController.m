//
//  ZUserDownloadViewController.m
//  PlaneLive
//
//  Created by Daniel on 05/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserDownloadViewController.h"
#import "ZSwitchToolView.h"
#import "ZDownloadEndTableView.h"
#import "ZDownloadingTableView.h"
#import "ZDownloadHeaderView.h"
#import "ZDownloadFooterView.h"
#import "DownLoadManager.h"
#import "ZPlayerViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"

@interface ZUserDownloadViewController ()<UIScrollViewDelegate, DownloadManagerDelegate>

@property (assign, nonatomic) NSInteger offsetIndex;

@property (strong, nonatomic) ZSwitchToolView *viewTool;

@property (strong, nonatomic) UIScrollView *scrollViewAll;

@property (strong, nonatomic) UIScrollView *scrollViewEnd;

@property (strong, nonatomic) ZDownloadEndTableView *tvPractice;
@property (strong, nonatomic) ZDownloadEndTableView *tvSubscribe;
@property (strong, nonatomic) ZDownloadingTableView *tvDownload;

@property (strong, nonatomic) ZDownloadHeaderView *viewHeader;
@property (strong, nonatomic) ZDownloadFooterView *viewFooter;

@property (strong, nonatomic) UISegmentedControl *scView;

@property (assign, nonatomic) CGRect footerFrame;

@property (assign, nonatomic) CGRect scrollViewEndFrame;
///最后一次点击暂停或开始的数据对象
@property (strong, nonatomic) ModelAudio *lastModel;

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
    
    [[DownLoadManager sharedHelper] setDelegate:self];
    
    [self innerPractice];
    
    [self innerSubscribe];
    
    [self.tvPractice setStartChecked:NO];
    
    [self.tvSubscribe setStartChecked:NO];
    
    [self innerDownload];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    GCDAfterBlock(0.25, ^{
        [self setDefaultDownload];
    });
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[DownLoadManager sharedHelper] setDelegate:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.viewHeader setCancelCheckAll];
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
    OBJC_RELEASE(_viewFooter);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_scView);
    OBJC_RELEASE(_tvDownload);
    OBJC_RELEASE(_tvPractice);
    OBJC_RELEASE(_tvSubscribe);
    OBJC_RELEASE(_scrollViewAll);
    OBJC_RELEASE(_scrollViewEnd);
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
    
    self.scrollViewAll = [[UIScrollView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.scrollViewAll setOpaque:NO];
    [self.scrollViewAll setPagingEnabled:YES];
    [self.scrollViewAll setBounces:NO];
    [self.scrollViewAll setScrollEnabled:NO];
    [self.scrollViewAll setShowsHorizontalScrollIndicator:NO];
    [self.scrollViewAll setShowsVerticalScrollIndicator:NO];
    [self.scrollViewAll setScrollsToTop:NO];
    [self.scrollViewAll setBackgroundColor:VIEW_BACKCOLOR2];
    [self.scrollViewAll setContentSize:CGSizeMake(self.scrollViewAll.width*2, self.scrollViewAll.height)];
    [self.view addSubview:self.scrollViewAll];
    
    ZWEAKSELF
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemDownloadManager)];
    [self.viewTool setFrame:CGRectMake(0, 0, self.scrollViewAll.width, [ZSwitchToolView getViewH])];
    [self.viewTool setOnItemClick:^(NSInteger index) {
        switch (index) {
            case 2:
                [weakSelf.tvPractice setScrollsToTop:NO];
                [weakSelf.tvSubscribe setScrollsToTop:YES];
                break;
            default:
                [weakSelf.tvPractice setScrollsToTop:YES];
                [weakSelf.tvSubscribe setScrollsToTop:NO];
                break;
        }
        [weakSelf.tvDownload setScrollsToTop:NO];
        _offsetIndex = index - 1;
        if (_offsetIndex == 0) {
            [weakSelf.viewHeader setDownloadMaxCount:(int)weakSelf.tvPractice.getDataCount];
        } else {
            [weakSelf.viewHeader setDownloadMaxCount:(int)weakSelf.tvSubscribe.getDataCount];
        }
        if (!weakSelf.viewFooter.hidden) {
            [weakSelf.viewHeader setCancelCheckAll];
        }
        [weakSelf.scrollViewEnd setContentOffset:CGPointMake(_offsetIndex*self.scrollViewEnd.width, 0) animated:NO];
        [weakSelf.tvPractice setFrame:CGRectMake(0, 0, weakSelf.tvPractice.width, weakSelf.tvPractice.height)];
        [weakSelf.tvSubscribe setFrame:CGRectMake(weakSelf.scrollViewEnd.width, 0, weakSelf.tvPractice.width, weakSelf.tvPractice.height)];
    }];
    [self.scrollViewAll addSubview:self.viewTool];
    
    self.viewHeader = [[ZDownloadHeaderView alloc] initWithFrame:CGRectMake(0, self.viewTool.height, self.scrollViewAll.width, [ZDownloadHeaderView getH])];
    [self.viewHeader setOnCheckClick:^(BOOL isCheck) {
        if (isCheck) {
            [weakSelf.viewFooter setDownloadSelCount:weakSelf.viewHeader.getDownloadMaxCount];
        } else {
            [weakSelf.viewFooter setDownloadSelCount:0];
        }
        if (_offsetIndex == 0) {
            [weakSelf.tvPractice setCheckedAll:isCheck];
        } else {
            [weakSelf.tvSubscribe setCheckedAll:isCheck];
        }
    }];
    [self.viewHeader setOnCancelClick:^{
        [weakSelf setHiddenFooter];
    }];
    [self.viewHeader setOnDeleteClick:^{
        [weakSelf setShowFooter];
    }];
    [self.scrollViewAll addSubview:self.viewHeader];
    
    self.footerFrame = CGRectMake(0, self.scrollViewAll.height, self.scrollViewAll.width, [ZDownloadFooterView getH]);
    self.viewFooter = [[ZDownloadFooterView alloc] initWithFrame:self.footerFrame];
    [self.viewFooter setOnDeleteClick:^{
        switch (weakSelf.offsetIndex) {
            case 0:
            {
                NSArray *array = [weakSelf.tvPractice getCheckArray];
                [weakSelf setDeleteWithArray:array];
                break;
            }
            case 1:
            {
                NSArray *array = [weakSelf.tvSubscribe getCheckArray];
                [weakSelf setDeleteWithArray:array];
                break;
            }
            default: break;
        }
    }];
    [self.viewFooter setHidden:YES];
    [self.scrollViewAll addSubview:self.viewFooter];
    
    CGFloat endY = self.viewHeader.y+self.viewHeader.height;
    self.scrollViewEndFrame = CGRectMake(0, endY, self.scrollViewAll.width, self.scrollViewAll.height-endY);
    self.scrollViewEnd = [[UIScrollView alloc] initWithFrame:self.scrollViewEndFrame];
    [self.scrollViewEnd setOpaque:NO];
    [self.scrollViewEnd setDelegate:self];
    [self.scrollViewEnd setPagingEnabled:YES];
    [self.scrollViewEnd setBounces:NO];
    [self.scrollViewEnd setScrollEnabled:NO];
    [self.scrollViewEnd setShowsHorizontalScrollIndicator:NO];
    [self.scrollViewEnd setShowsVerticalScrollIndicator:NO];
    [self.scrollViewEnd setScrollsToTop:NO];
    [self.scrollViewEnd setBackgroundColor:VIEW_BACKCOLOR2];
    [self.scrollViewEnd setContentSize:CGSizeMake(self.scrollViewEnd.width*2, self.scrollViewEnd.height)];
    [self.scrollViewAll addSubview:self.scrollViewEnd];
    
    [self.scrollViewAll bringSubviewToFront:self.viewFooter];
    
    self.tvPractice = [[ZDownloadEndTableView alloc] initWithFrame:self.scrollViewEnd.bounds];
    [self.tvPractice setScrollsToTop:YES];
    [self.tvPractice setScrollEnabled:YES];
    [self.tvPractice addRefreshHeaderWithEndBlock:^{
        [weakSelf innerPractice];
    }];
    [self.tvPractice setOnDeleteClick:^(ModelAudio *model, int maxCount) {
        [weakSelf.viewHeader setDownloadMaxCount:maxCount];
        [weakSelf setDeleteWithModel:model];
    }];
    [self.tvPractice setOnCheckedClick:^(BOOL check, NSInteger row, NSInteger selCount, BOOL isMaxCount) {
        [weakSelf.viewHeader setCheckAllStatus:isMaxCount];
        [weakSelf.viewFooter setDownloadSelCount:(int)selCount];
    }];
    [self.tvPractice setOnRowSelected:^(NSArray *array, NSInteger row) {
        [weakSelf setShowPracticeDetailVC:array row:row];
    }];
    [self.scrollViewEnd addSubview:self.tvPractice];
    
    self.tvSubscribe = [[ZDownloadEndTableView alloc] initWithFrame:CGRectMake(self.scrollViewEnd.width, 0, self.scrollViewEnd.width, self.scrollViewEnd.height)];
    [self.tvSubscribe setScrollsToTop:NO];
    [self.tvSubscribe setScrollEnabled:YES];
    [self.tvSubscribe addRefreshHeaderWithEndBlock:^{
        [weakSelf innerSubscribe];
    }];
    [self.tvSubscribe setOnCheckedClick:^(BOOL check, NSInteger row, NSInteger selCount, BOOL isMaxCount) {
        [weakSelf.viewHeader setCheckAllStatus:isMaxCount];
        [weakSelf.viewFooter setDownloadSelCount:(int)selCount];
    }];
    [self.tvSubscribe setOnRowSelected:^(NSArray *array, NSInteger row) {
        [weakSelf setShowSubscribeDetailVC:array row:row];
    }];
    [self.tvSubscribe setOnDeleteClick:^(ModelAudio *model, int maxCount) {
        [weakSelf.viewHeader setDownloadMaxCount:maxCount];
        [weakSelf setDeleteWithModel:model];
    }];
    [self.scrollViewEnd addSubview:self.tvSubscribe];
    
    self.tvDownload = [[ZDownloadingTableView alloc] initWithFrame:CGRectMake(self.scrollViewAll.width, 0, self.scrollViewAll.width, self.scrollViewAll.height)];
    [self.tvDownload setScrollsToTop:NO];
    [self.tvDownload setScrollEnabled:YES];
    [self.tvDownload addRefreshHeaderWithEndBlock:^{
        [weakSelf innerDownload];
    }];
    [self.tvDownload setOnDeleteClick:^(ModelAudio *model) {
        [weakSelf setDeleteDownloadingWithModel:model];
    }];
    [self.tvDownload setOnDownloadClick:^(NSArray *array, NSInteger row) {
        [weakSelf setDownloadClickWithArray:array row:row];
    }];
    [self.scrollViewAll addSubview:self.tvDownload];
    
    [super innerInit];
}
-(void)innerPractice
{
    NSString *userId = [AppSetting getUserDetauleId];
    NSArray *array = [sqlite getLocalDownloadAudioEndWithUserId:userId type:1 pageNum:0];
    
    [self.tvPractice setViewDataWithArray:array];
    
    if (_offsetIndex == 0) {
        [self.viewHeader setDownloadMaxCount:(int)self.tvPractice.getDataCount];
    }
    [self.tvPractice endRefreshHeader];
}
-(void)innerSubscribe
{
    NSString *userId = [AppSetting getUserDetauleId];
    NSArray *array = [sqlite getLocalDownloadAudioEndWithUserId:userId type:2 pageNum:0];
    
    [self.tvSubscribe setViewDataWithArray:array];
    
    if (_offsetIndex != 0) {
        [self.viewHeader setDownloadMaxCount:(int)self.tvSubscribe.getDataCount];
    }
    [self.tvSubscribe endRefreshHeader];
}
-(void)innerDownload
{
    NSString *userId = [AppSetting getUserDetauleId];
    NSArray *array = [sqlite getLocalDownloadAudioWaitWithUserId:userId pageNum:0];
    
    [self.tvDownload setViewDataWithArray:array];
    
    [self.tvDownload endRefreshHeader];
}
-(void)setDefaultDownload
{
    ModelAudio *modelA = [[DownLoadManager sharedHelper] downloadModel];
    if (modelA && [DownLoadManager sharedHelper].state == DownLoadManagerStateStart) {
        GCDMainBlock(^{
            [modelA setAddress:ZDownloadStatusStart];
            [self setLastModel:modelA];
            [self.tvDownload setStartDownloadWithModel:modelA];
        });
    }
}
///显示订阅详情
-(void)setShowSubscribeDetailVC:(NSArray *)array row:(NSInteger)row
{
    NSString *ids = kEmpty;
    for (ModelAudio *modelA in array) {
        if (modelA.ids) {
            ids = [ids stringByAppendingString:modelA.ids];
            ids = [ids stringByAppendingString:@","];
        }
    }
    if (ids.length > 0) {
        ids = [ids substringToIndex:ids.length-1];
    }
    NSArray *arrayCurriculum = [sqlite getLocalPlayrecordSubscribeCurriculumArrayWithIds:ids];
    if (arrayCurriculum && arrayCurriculum.count > 0) {
        int newRow = 0;
        ModelAudio *modelA = [array objectAtIndex:row];
        for (ModelCurriculum *modelC in arrayCurriculum) {
            if ([modelC.ids isEqualToString:modelA.ids]) {
                break;
            }
            newRow++;
        }
        [self showPlayVCWithCurriculumArray:arrayCurriculum index:newRow];
    }
}
///显示实务详情
-(void)setShowPracticeDetailVC:(NSArray *)array row:(NSInteger)row
{
    NSString *ids = kEmpty;
    for (ModelAudio *modelA in array) {
        if (modelA.ids) {
            ids = [ids stringByAppendingString:modelA.ids];
            ids = [ids stringByAppendingString:@","];
        }
    }
    if (ids.length > 0) {
        ids = [ids substringToIndex:ids.length-1];
    }
    NSArray *arrayPractice = [sqlite getLocalPlayrecordPracticeArrayWithIds:ids];
    if (arrayPractice && arrayPractice.count > 0) {
        int newRow = 0;
        ModelAudio *modelA = [array objectAtIndex:row];
        for (ModelPractice *modelP in arrayPractice) {
            if ([modelP.ids isEqualToString:modelA.ids]) {
                break;
            }
            newRow++;
        }
        [self showPlayVCWithPracticeArray:arrayPractice index:newRow];
    }
}
///开始下载或停止下载
-(void)setDownloadClickWithArray:(NSArray *)array row:(NSInteger)row
{
    if (row < array.count) {
        switch ([ZPlayerViewController sharedSingleton].getNetworkReachabilityStatus) {
            case ZNetworkReachabilityStatusUnknown:
                [ZProgressHUD showError:kCMsgContentUnusual];
                break;
            case ZNetworkReachabilityStatusNotReachable:
                [ZProgressHUD showError:kCMsgContentError];
                break;
            case ZNetworkReachabilityStatusReachableViaWWAN:
            case ZNetworkReachabilityStatusReachableViaWiFi:
            {
                ModelAudio *modelA = [array objectAtIndex:row];
                [self setLastModel:modelA];
                switch (modelA.address) {
                    case ZDownloadStatusNomral:
                        [self setStartDownloadWithModel:modelA];
                        break;
                    case ZDownloadStatusStart:
                        [self setSuspendDownloadWithModel:modelA];
                        break;
                    default: break;
                }
                break;
            }
            default: break;
        }
    }
}
///开始下载
-(void)setStartDownloadWithModel:(ModelAudio *)model
{
    GCDMainBlock(^{
        [[DownLoadManager sharedHelper] setDownloadWithModel:model];
        
        [self.tvDownload setStartDownloadWithModel:model];
    });
}
///暂停下载
-(void)setSuspendDownloadWithModel:(ModelAudio *)model
{
    GCDMainBlock(^{
        [[DownLoadManager sharedHelper] dismiss];
        
        [self.tvDownload setSuspendDownloadWithModel:model];
    });
}
///删除下载记录
-(void)setDeleteWithModel:(ModelAudio *)model
{
    GCDMainBlock(^{
        BOOL delSuccess = [sqlite delLocalDownloadAudioWithModel:model userId:[AppSetting getUserId]];
        if (delSuccess) {
            NSString *filePath = [[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[Utils stringMD5:model.audioPath]] stringByAppendingPathExtension:kPathExtension];
            [Utils deleteDirectory:filePath];
        }
    });
}
///下载中对象下载
-(void)setDeleteDownloadingWithModel:(ModelAudio *)model
{
    ModelAudio *modelA = [[DownLoadManager sharedHelper] downloadModel];
    if (modelA && [modelA.ids isEqualToString:model.ids]) {
        GCDMainBlock(^{
            [[DownLoadManager sharedHelper] remove];
        });
    }
    [self setDeleteWithModel:model];
}
///删除下载记录
-(void)setDeleteWithArray:(NSArray *)array
{
    if (array == nil || array.count == 0) {
        return;
    }
    GCDMainBlock(^{
        BOOL delSuccess = [sqlite delLocalDownloadAudioWithArray:array userId:[AppSetting getUserDetauleId]];
        if (delSuccess) {
            for (ModelAudio *model in array) {
                NSString *filePath = [[[AppSetting getAudioFilePath] stringByAppendingPathComponent:[Utils stringMD5:model.audioPath]] stringByAppendingPathExtension:kPathExtension];
                [Utils deleteDirectory:filePath];
            }
        }
        switch (self.offsetIndex) {
            case 0:
            {
                [self innerPractice];
                
                [self.viewHeader setCancelCheckAll];
                
                [self.viewHeader setDownloadMaxCount:(int)self.tvPractice.getDataCount];
                [self.viewFooter setDownloadSelCount:0];
                break;
            }
            case 1:
            {
                [self innerSubscribe];
                
                [self.viewHeader setCancelCheckAll];
                
                [self.viewHeader setDownloadMaxCount:(int)self.tvSubscribe.getDataCount];
                [self.viewFooter setDownloadSelCount:0];
                break;
            }
            default: break;
        }
        [ZProgressHUD showSuccess:kCMsgFileDeleteSuccess];
    });
}
///切换已下载和下载中
-(void)setSegmentedControlValueChanged:(UISegmentedControl *)sender
{
    if (!self.viewFooter.hidden) {
        [self.viewHeader setCancelCheckAll];
    }
    if (sender.selectedSegmentIndex == 0) {
        if (_offsetIndex == 0) {
            [self.tvPractice setScrollsToTop:YES];
            [self.tvSubscribe setScrollsToTop:NO];
        } else {
            [self.tvPractice setScrollsToTop:YES];
            [self.tvSubscribe setScrollsToTop:NO];
        }
        [self.tvDownload setScrollsToTop:NO];
    } else {
        [self.tvPractice setScrollsToTop:NO];
        [self.tvSubscribe setScrollsToTop:NO];
        [self.tvDownload setScrollsToTop:YES];
    }
    [self.scrollViewAll setContentOffset:CGPointMake(sender.selectedSegmentIndex*self.scrollViewAll.width, 0) animated:NO];
}
///隐藏底部功能按钮
-(void)setHiddenFooter
{
    [self.tvPractice setStartChecked:NO];
    [self.tvSubscribe setStartChecked:NO];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.viewFooter setFrame:self.footerFrame];
        [self.scrollViewEnd setFrame:self.scrollViewEndFrame];
        
        [self.tvPractice setFrame:self.scrollViewEnd.bounds];
        [self.tvSubscribe setFrame:CGRectMake(self.scrollViewEnd.width, 0, self.scrollViewEnd.width, self.scrollViewEnd.height)];
    } completion:^(BOOL finished) {
        [self.viewFooter setHidden:YES];
    }];
}
///显示底部功能按钮
-(void)setShowFooter
{
    [self.viewFooter setHidden:NO];
    [self.tvPractice setStartChecked:YES];
    [self.tvSubscribe setStartChecked:YES];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        CGRect footerFrame = self.footerFrame;
        footerFrame.origin.y -= footerFrame.size.height;
        [self.viewFooter setFrame:footerFrame];
        CGRect scrollViewEndFrame = self.scrollViewEndFrame;
        scrollViewEndFrame.size.height -= footerFrame.size.height;
        [self.scrollViewEnd setFrame:scrollViewEndFrame];
        [self.tvPractice setFrame:self.scrollViewEnd.bounds];
        [self.tvSubscribe setFrame:CGRectMake(self.scrollViewEnd.width, 0, self.scrollViewEnd.width, self.scrollViewEnd.height)];
    }];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self.viewTool setViewSelectItemWithType:(_offsetIndex+1)];
    GBLog(@"scrollViewDidEndDecelerating: %ld", _offsetIndex);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewTool setOffsetChange:scrollView.contentOffset.x];
}

#pragma mark - DownloadManagerDelegate

-(void)ZDownloadManagerDidFinishDownLoad:(ModelAudio *)model
{
    GCDMainBlock(^{
        [self innerDownload];
        
        if (model.audioPlayType == 1) {
            [self innerPractice];
        } else {
            [self innerSubscribe];
        }
    });
}
-(void)ZDownloadManager:(ModelAudio *)model didReceiveProgress:(float)progress
{
    if (self.lastModel && [self.lastModel.ids isEqualToString:model.ids]) {
        GCDMainBlock(^{
            [self.tvDownload setDownloadProgress:progress model:model];
        });
    }
}

@end
