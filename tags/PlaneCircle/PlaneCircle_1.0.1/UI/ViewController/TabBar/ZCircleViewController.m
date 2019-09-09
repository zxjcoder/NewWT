//
//  ZCircleViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleViewController.h"
#import "ZCircleSearchView.h"
#import "ZCircleDynamicTableView.h"
#import "ZCircleHotTableView.h"
#import "ZCircleNewTableView.h"
#import "ZCircleAttTableView.h"
#import "ZCircleToolView.h"
#import "ZCircleSearchTableView.h"

#import "ZCircleQuestionViewController.h"
#import "ZLoginViewController.h"
#import "ZUserProfileViewController.h"
#import "ZTopicListViewController.h"

#import "ZWebViewController.h"

#import "ZPracticeDetailViewController.h"

#define kCircleHotLocalCacheKey @"kCircleHotLocalCacheKey"
#define kCircleDynamicLocalCacheKey @"kCircleDynamicLocalCacheKey"
#define kCircleNewLocalCacheKey @"kCircleNewLocalCacheKey"
#define kCircleAttLocalCacheKey @"kCircleAttLocalCacheKey"

@interface ZCircleViewController ()<UIScrollViewDelegate>
{
    NSInteger _offsetIndex;
    CGRect _tvSearchFrame;
}
///搜索顶部区域
@property (strong, nonatomic) ZCircleSearchView *viewSearch;
//搜索内容区域
@property (strong, nonatomic) ZCircleSearchTableView *tvSearch;
///切换栏
@property (strong, nonatomic) ZCircleToolView *viewTool;
///滚动模块
@property (strong, nonatomic) UIScrollView *scrollView;

///推荐
@property (strong, nonatomic) ZCircleHotTableView *tvHot;
///动态
@property (strong, nonatomic) ZCircleDynamicTableView *tvDynamic;
///最新
@property (strong, nonatomic) ZCircleNewTableView *tvNew;
///关注
@property (strong, nonatomic) ZCircleAttTableView *tvAtt;

///推荐
@property (strong, nonatomic) NSMutableArray *arrHot;
///动态
@property (strong, nonatomic) NSMutableArray *arrDynamic;
///最新
@property (strong, nonatomic) NSMutableArray *arrNew;
///关注
@property (strong, nonatomic) NSMutableArray *arrAtt;

///推荐
@property (assign, nonatomic) int pageNumHot;
///动态
@property (assign, nonatomic) int pageNumDynamic;
///最新
@property (assign, nonatomic) int pageNumNew;
///关注
@property (assign, nonatomic) int pageNumAtt;

///搜索内容
@property (assign, nonatomic) int pageSearchContnet;
///搜索用户
@property (assign, nonatomic) int pageSearchUser;
///搜索内容
@property (strong, nonatomic) NSString *lastSearchContent;

///是否获取语音
@property (assign, nonatomic) BOOL isGetPracticeing;

@end

@implementation ZCircleViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerLoginChangeNotification];
    
    [self registerPublishQuestionNotification];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
}

- (void)setViewFrame
{
    CGFloat contentW = APP_FRAME_WIDTH;
    [self.viewSearch setFrame:CGRectMake(0, 0, contentW, APP_TOP_HEIGHT)];
    [self.viewTool setFrame:CGRectMake(0, self.viewSearch.height, contentW, 40)];
    
    CGFloat contentY = self.viewTool.y+self.viewTool.height;
    CGFloat contentH = APP_FRAME_HEIGHT-contentY-APP_TABBAR_HEIGHT;
    [self.scrollView setFrame:CGRectMake(0, contentY, contentW, contentH)];
    [self.scrollView setContentSize:CGSizeMake(contentW*4, self.scrollView.height)];
    
    [self.tvHot setFrame:CGRectMake(0, 0, contentW, contentH)];
    [self.tvDynamic setFrame:CGRectMake(contentW, 0, contentW, contentH)];
    [self.tvNew setFrame:CGRectMake(contentW*2, 0, contentW, contentH)];
    [self.tvAtt setFrame:CGRectMake(contentW*3, 0, contentW, contentH)];
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
    [self removePublishQuestionNotification];
    [self removeLoginChangeNotification];
    OBJC_RELEASE(_viewSearch);
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_tvHot);
    OBJC_RELEASE(_tvDynamic);
    OBJC_RELEASE(_tvNew);
    OBJC_RELEASE(_tvAtt);
    OBJC_RELEASE(_scrollView);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrHot = [NSMutableArray array];
    self.arrDynamic = [NSMutableArray array];
    self.arrNew = [NSMutableArray array];
    self.arrAtt = [NSMutableArray array];
    
    self.viewSearch = [[ZCircleSearchView alloc] init];
    [self.view addSubview:self.viewSearch];
    
    self.viewTool = [[ZCircleToolView alloc] init];
    [self.view addSubview:self.viewTool];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.view addSubview:self.scrollView];
    
    self.tvHot = [[ZCircleHotTableView alloc] init];
    [self.scrollView addSubview:self.tvHot];
    
    self.tvDynamic = [[ZCircleDynamicTableView alloc] init];
    [self.scrollView addSubview:self.tvDynamic];
    
    self.tvNew = [[ZCircleNewTableView alloc] init];
    [self.scrollView addSubview:self.tvNew];
    
    self.tvAtt = [[ZCircleAttTableView alloc] init];
    [self.scrollView addSubview:self.tvAtt];
    
    self.tvSearch = [[ZCircleSearchTableView alloc] init];
    [self.tvSearch setHidden:YES];
    [self.tvSearch setAlpha:0];
    [self.view addSubview:self.tvSearch];
    
    _tvSearchFrame = CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-APP_TABBAR_HEIGHT);
    [self.tvSearch setFrame:_tvSearchFrame];
    
    [self setScrollsToTop:ZCircleToolViewItemHot];
    
    [self.view bringSubviewToFront:self.tvSearch];
    [self.view sendSubviewToBack:self.scrollView];
    [self.view sendSubviewToBack:self.viewTool];
    
    [self setViewFrame];
    
    [self innerData];
    
    [self innerEvent];
}

-(void)innerData
{
    BOOL _isHotLoading = YES;
    NSDictionary *dicHotLocalCache = [sqlite getLocalCacheDataWithPathKay:kCircleHotLocalCacheKey];
    if ([dicHotLocalCache objectForKey:kResultKey]) {
        _isHotLoading = NO;
        NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:dicHotLocalCache];
        [dicResult setObject:@"YES" forKey:kIsHeaderKey];
        [self.tvHot setViewDataWithDictionary:dicResult];
    }
    [self loadHotData:_isHotLoading];
    
    if (![AppSetting getAutoLogin]) {
        [self.tvDynamic setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
        [self.tvDynamic setViewDataWithDictionary:nil];
        
    } else {
        BOOL _isDynamicLoading = YES;
        NSDictionary *dicDynamicLocalCache = [sqlite getLocalCacheDataWithPathKay:kCircleDynamicLocalCacheKey];
        if ([dicDynamicLocalCache objectForKey:kResultKey]) {
            _isDynamicLoading = NO;
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:dicDynamicLocalCache];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [self.tvDynamic setViewDataWithDictionary:dicResult];
        }
        [self loadDynamicData:_isDynamicLoading];
    }
    
    BOOL _isNewLoading = YES;
    NSDictionary *dicNewLocalCache = [sqlite getLocalCacheDataWithPathKay:kCircleNewLocalCacheKey];
    if ([dicNewLocalCache objectForKey:kResultKey]) {
        _isNewLoading = NO;
        NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:dicNewLocalCache];
        [dicResult setObject:@"YES" forKey:kIsHeaderKey];
        [self.tvNew setViewDataWithDictionary:dicResult];
    }
    [self loadNewData:_isNewLoading];
    
    if (![AppSetting getAutoLogin]) {
        [self.tvAtt setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
        [self.tvAtt setViewDataWithDictionary:nil];
    } else {
        BOOL _isAttLoading = YES;
        NSDictionary *dicAttLocalCache = [sqlite getLocalCacheDataWithPathKay:kCircleAttLocalCacheKey];
        if ([dicAttLocalCache objectForKey:kResultKey]) {
            _isAttLoading = NO;
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:dicAttLocalCache];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [self.tvAtt setViewDataWithDictionary:dicResult];
        }
        [self loadAttData:_isAttLoading];
    }
}
///推荐
-(void)loadHotData:(BOOL)isLoading
{
    ZWEAKSELF
    self.pageNumHot = 1;
    if (isLoading) {[self.tvHot setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns getCircleRemdListWithPageNum:self.pageNumHot resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            if ([result objectForKey:kResultKey]) {
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                [weakSelf.tvHot setViewDataWithDictionary:dicResult];
                
                [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleHotLocalCacheKey];
            } else {
                if (isLoading) {
                    [weakSelf.tvHot setBackgroundViewWithState:(ZBackgroundStateNull)];
                }
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isLoading) {
                [weakSelf.tvHot setBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}
///动态
-(void)loadDynamicData:(BOOL)isLoading
{
    if (![AppSetting getAutoLogin]) {
        [self.tvDynamic setViewDataWithDictionary:nil];
        return;
    }
    ZWEAKSELF
    self.pageNumDynamic = 1;
    if (isLoading) {[self.tvDynamic setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns getCircleTrendListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumDynamic resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            if ([result objectForKey:@"trends"]) {
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                [weakSelf.tvDynamic setBackgroundViewWithState:(ZBackgroundStateNone)];
                [weakSelf.tvDynamic setViewDataWithDictionary:dicResult];
                [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleDynamicLocalCacheKey];
            } else {
                if (isLoading) {
                    [weakSelf.tvDynamic setBackgroundViewWithState:(ZBackgroundStateNull)];
                }
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isLoading) {
                [weakSelf.tvDynamic setBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}
///最新
-(void)loadNewData:(BOOL)isLoading
{
    ZWEAKSELF
    self.pageNumNew = 1;
    if (isLoading) {[self.tvNew setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns getCircleLatestListWithPageNum:self.pageNumNew resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            if ([result objectForKey:kResultKey]) {
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                [weakSelf.tvNew setBackgroundViewWithState:(ZBackgroundStateNone)];
                [weakSelf.tvNew setViewDataWithDictionary:dicResult];
                [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleNewLocalCacheKey];
            } else {
                if (isLoading) {
                    [weakSelf.tvNew setBackgroundViewWithState:(ZBackgroundStateNull)];
                }
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isLoading) {
                [weakSelf.tvNew setBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}
///关注
-(void)loadAttData:(BOOL)isLoading
{
    if (![AppSetting getAutoLogin]) {
        [self.tvAtt setViewDataWithDictionary:nil];
        return;
    }
    ZWEAKSELF
    self.pageNumAtt = 1;
    if (isLoading) {[self.tvAtt setBackgroundViewWithState:(ZBackgroundStateLoading)];}
    [sns getCircleAttentionListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumAtt resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            if ([result objectForKey:kResultKey]) {
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                [weakSelf.tvAtt setBackgroundViewWithState:(ZBackgroundStateNone)];
                [weakSelf.tvAtt setViewDataWithDictionary:dicResult];
                [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleAttLocalCacheKey];
            } else {
                if (isLoading) {
                    [weakSelf.tvAtt setBackgroundViewWithState:(ZBackgroundStateNull)];
                }
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            if (isLoading) {
                [weakSelf.tvAtt setBackgroundViewWithState:(ZBackgroundStateFail)];
            }
        });
    }];
}

-(void)innerEvent
{
    ZWEAKSELF
    //新闻
    [self.tvHot setOnHotArticleViewClick:^(ModelHotArticle *model) {
        //TODO:ZWW备注-添加友盟统计事件
        [MobClick event:kEvent_Circle_News];
        
        ZWebViewController *webVC =[[ZWebViewController alloc] init];
        [webVC setTitle:@"新闻详情"];
        [webVC setWebUrl:model.source];
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }];
    //广告(目前只有实务)
    [self.tvHot setOnBannerClick:^(ModelBanner *model) {
        ModelPractice *modelP = [sqlite getLocalPracticeModelWithId:model.code];
        if (modelP) {
            ZPracticeDetailViewController *itemVC = [[ZPracticeDetailViewController alloc] init];
            [itemVC setNavigationBarHidden:YES];
            [itemVC setViewDataWithModel:modelP];
            [itemVC setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:itemVC animated:YES];
        } else {
            if (weakSelf.isGetPracticeing) {
                return ;
            }
            weakSelf.isGetPracticeing = YES;
            [ZProgressHUD showMessage:@"正在获取语音,请稍等..." toView:weakSelf.view];
            [sns getQuerySpeechDetailWithSpeechId:model.code userId:[AppSetting getUserDetauleId] resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    weakSelf.isGetPracticeing = NO;
                    [ZProgressHUD dismissForView:weakSelf.view];
                    
                    NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                    if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                        ModelPractice *modelP = [[ModelPractice alloc] initWithCustom:dicReuslt];
                        
                        [sqlite setLocalPracticeWithModel:modelP];
                        
                        ZPracticeDetailViewController *itemVC = [[ZPracticeDetailViewController alloc] init];
                        [itemVC setNavigationBarHidden:YES];
                        [itemVC setViewDataWithModel:modelP];
                        [itemVC setHidesBottomBarWhenPushed:YES];
                        [weakSelf.navigationController pushViewController:itemVC animated:YES];
                    } else {
                        [ZProgressHUD showError:@"获取语音信息失败" toView:weakSelf.view];
                    }
                    
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    weakSelf.isGetPracticeing = NO;
                    [ZProgressHUD showError:msg toView:weakSelf.view];
                });
            }];
        }
    }];
    //工具栏切换
    [self.viewTool setOnItemClick:^(ZCircleToolViewItem item) {
        [weakSelf setScrollsToTop:item];
        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.width*(item-1), 0) animated:YES];
    }];
    //取消搜索事件
    [self.viewSearch setOnClearClick:^{
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [weakSelf.tvSearch setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [weakSelf.tvSearch setHidden:YES];
        }];
    }];
    //开始搜索事件
    [self.viewSearch setOnBeginClick:^{
        //TODO:ZWW备注-添加友盟统计事件
        [MobClick event:kEvent_Circle_Search];
        
        [weakSelf.tvSearch setHidden:NO];
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [weakSelf.tvSearch setAlpha:1.0f];
        } completion:^(BOOL finished) {
            if (weakSelf.lastSearchContent.length == 0) {
                [weakSelf.tvSearch setViewKeyword:kEmpty];
                [weakSelf setLastSearchContent:kEmpty];
                [weakSelf setSearchWithContent:kEmpty];
            }
        }];
    }];
    //提问事件
    [self.viewSearch setOnQuestionClick:^{
        [weakSelf showCircleQuestionVC];
    }];
    //搜索内容事件
    [self.viewSearch setOnSearchClick:^(NSString *content) {
        [weakSelf.tvSearch setViewKeyword:content];
        [weakSelf setLastSearchContent:content];
        [weakSelf setSearchWithContent:content];
    }];
    //搜索话题点击事件
    [self.tvSearch setOnTagClick:^(ModelTag *model) {
        [weakSelf showTagDetailVC:model];
    }];
    //搜索内容底部刷新
    [self.tvSearch setOnRefreshContentFooter:^{
        [weakSelf setSearchContentRefreshFooter];
    }];
    //搜索用户底部刷新
    [self.tvSearch setOnRefreshUserFooter:^{
        [weakSelf setSearchUserRefreshFooter];
    }];
    ///选中搜索用户
    [self.tvSearch setOnUserItemClick:^(ModelUserBase *model) {
        [weakSelf showUserProfileVCWithModel:model];
    }];
    ///选中搜索内容
    [self.tvSearch setOnContentItemClick:^(ModelCircleSearchContent *model) {
        if (model.type == 0) {
            [weakSelf showCircleQuestionDetailVC:model];
        } else {
            [weakSelf showCircleAnswerDetailVC:model];
        }
    }];
    ///开始滑动
    [self.tvSearch setOnOffsetChange:^(CGFloat y) {
        [weakSelf.view endEditing:YES];
    }];
    //关注头像点击
    [self.tvAtt setOnImagePhotoClick:^(ModelCircleAtt *model) {
        if ([model.userIdQ intValue] > 0) {
            ModelUserBase *modelUser = [[ModelUserBase alloc] init];
            [modelUser setUserId:model.userIdQ];
            [modelUser setNickname:model.nicknameQ];
            [weakSelf showUserProfileVCWithModel:modelUser];
        }
    }];
    //最新头像点击
    [self.tvNew setOnImagePhotoClick:^(ModelCircleNew *model) {
        if ([model.userIdQ intValue] > 0) {
            ModelUserBase *modelUser = [[ModelUserBase alloc] init];
            [modelUser setUserId:model.userIdQ];
            [modelUser setNickname:model.nicknameQ];
            [weakSelf showUserProfileVCWithModel:modelUser];
        }
    }];
    //关注问题选中
    [self.tvAtt setOnRowSelected:^(ModelCircleAtt *model) {
        ModelCircleSearchContent *modelContent = [[ModelCircleSearchContent alloc] init];
        [modelContent setIds:model.ids];
        [modelContent setTitle:model.title];
        [weakSelf showCircleQuestionDetailVC:modelContent];
    }];
    //推荐问题选中
    [self.tvHot setOnRowSelected:^(ModelCircleHot *model) {
        ModelCircleSearchContent *modelContent = [[ModelCircleSearchContent alloc] init];
        [modelContent setIds:model.ids];
        [modelContent setTitle:model.title];
        [weakSelf showCircleQuestionDetailVC:modelContent];
    }];
    //动态问题选中
    [self.tvDynamic setOnRowSelected:^(ModelCircleDynamic *model) {
        ModelCircleSearchContent *modelContent = [[ModelCircleSearchContent alloc] init];
        [modelContent setIds:model.ids];
        [modelContent setTitle:model.title];
        if (model.type == 0) {
            [weakSelf showCircleQuestionDetailVC:modelContent];
        } else {
            [weakSelf showCircleAnswerDetailVC:modelContent];
        }
    }];
    //最新问题选中
    [self.tvNew setOnRowSelected:^(ModelCircleNew *model) {
        ModelCircleSearchContent *modelContent = [[ModelCircleSearchContent alloc] init];
        [modelContent setIds:model.ids];
        [modelContent setTitle:model.title];
        [weakSelf showCircleQuestionDetailVC:modelContent];
    }];
    //刷新推荐顶部
    [self.tvHot setOnRefreshHeader:^{
        [weakSelf setRefreshHotHeader];
    }];
    //刷新推荐底部
    [self.tvHot setOnRefreshFooter:^{
        [weakSelf setRefreshHotFooter];
    }];
    //推荐回答区域点击事件
    [self.tvHot setOnAnswerClick:^(ModelCircleHot *model) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setQuestion_id:model.ids];
        [modelAB setTitle:model.answerContent];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
    //最新回答区域点击事件
    [self.tvNew setOnAnswerClick:^(ModelCircleNew *model) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setQuestion_id:model.ids];
        [modelAB setTitle:model.answerContent];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
    //关注回答区域点击事件
    [self.tvAtt setOnAnswerClick:^(ModelCircleAtt *model) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setQuestion_id:model.ids];
        [modelAB setTitle:model.answerContent];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
    //动态回答区域点击事件
    [self.tvDynamic setOnAnswerClick:^(ModelCircleDynamic *model) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.wid];
        [modelAB setQuestion_id:model.ids];
        [modelAB setTitle:model.content];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
    //刷新最新顶部
    [self.tvNew setOnRefreshHeader:^{
        [weakSelf setRefreshNewHeader];
    }];
    //刷子最新底部
    [self.tvNew setOnRefreshFooter:^{
        [weakSelf setRefreshNewFooter];
    }];
    //刷新关注顶部
    [self.tvAtt setOnRefreshHeader:^{
        [weakSelf setRefreshAttHeader];
    }];
    //刷新关注底部
    [self.tvAtt setOnRefreshFooter:^{
        [weakSelf setRefreshAttFooter];
    }];
    //刷新动态顶部
    [self.tvDynamic setOnRefreshHeader:^{
        [weakSelf setRefreshDynamicHeader];
    }];
    //刷新动态底部
    [self.tvDynamic setOnRefreshFooter:^{
        [weakSelf setRefreshDynamicFooter];
    }];
    //动态背景点击事件
    [self.tvDynamic setOnBackgroundClick:^(ZBackgroundState viewBGState) {
        switch (viewBGState) {
            case ZBackgroundStateFail:
            {
                [weakSelf loadDynamicData:YES];
                break;
            }
            case ZBackgroundStateNull:
            {
                [weakSelf loadDynamicData:YES];
                break;
            }
            case ZBackgroundStateLoginNull:
            {
                [weakSelf showLoginVC];
                break;
            }
            default: break;
        }
    }];
    //关注背景点击事件
    [self.tvAtt setOnBackgroundClick:^(ZBackgroundState viewBGState) {
        switch (viewBGState) {
            case ZBackgroundStateFail:
            {
                [weakSelf loadAttData:YES];
                break;
            }
            case ZBackgroundStateNull:
            {
                [weakSelf loadAttData:YES];
                break;
            }
            case ZBackgroundStateLoginNull:
            {
                [weakSelf showLoginVC];
                break;
            }
            default: break;
        }
    }];
    //推荐背景点击事件
    [self.tvHot setOnBackgroundClick:^(ZBackgroundState viewBGState) {
        switch (viewBGState) {
            case ZBackgroundStateFail:
            {
                [weakSelf loadHotData:YES];
                break;
            }
            case ZBackgroundStateNull:
            {
                [weakSelf loadHotData:YES];
                break;
            }
            default: break;
        }
    }];
    //最新背景点击事件
    [self.tvNew setOnBackgroundClick:^(ZBackgroundState viewBGState) {
        switch (viewBGState) {
            case ZBackgroundStateFail:
            {
                [weakSelf loadNewData:YES];
                break;
            }
            case ZBackgroundStateNull:
            {
                [weakSelf loadNewData:YES];
                break;
            }
            default: break;
        }
    }];
}
///显示他人用户界面
-(void)showUserProfileVCWithModel:(ModelUserBase *)model
{
    if (![model.userId isEqualToString:[AppSetting getUserDetauleId]]) {
        [self showUserProfileVC:model];
    }
}
///显示话题界面
-(void)showTagDetailVC:(ModelTag *)model
{
    [self.view endEditing:YES];
    ZTopicListViewController *tdVC = [[ZTopicListViewController alloc] init];
    [tdVC setViewDataWithModel:model];
    [tdVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:tdVC animated:YES];
}
///显示提问界面
-(void)showCircleQuestionVC
{
    if ([AppSetting getAutoLogin]) {
        //TODO:ZWW备注-添加友盟统计事件
        [MobClick event:kEvent_Circle_Question];
        
        [self.view endEditing:YES];
        ZCircleQuestionViewController *itemVC = [[ZCircleQuestionViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        [self showLoginVC];
    }
}
///显示问题详情界面
-(void)showCircleQuestionDetailVC:(ModelCircleSearchContent *)model
{
    [self.view endEditing:YES];
    ModelQuestionBase *modelB = [[ModelQuestionBase alloc] init];
    [modelB setIds:model.ids];
    [modelB setTitle:model.title];
    [self showQuestionDetailVC:modelB];
}
///显示答案详情界面
-(void)showCircleAnswerDetailVC:(ModelCircleSearchContent *)model
{
    [self.view endEditing:YES];
    ModelAnswerBase *modelB = [[ModelAnswerBase alloc] init];
    [modelB setIds:model.ids];
    [modelB setTitle:model.title];
    [self showAnswerDetailVC:modelB];
}
///搜索内容
-(void)setSearchWithContent:(NSString *)content
{
    ZWEAKSELF
    weakSelf.pageSearchContnet = 1;
    [sns getCircleQueryQuestionAnswerWithUserId:[AppSetting getUserDetauleId] content:content pageNum:weakSelf.pageSearchContnet resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvSearch setViewContentWithDictionary:dicResult];
        });
    } errorBlock:nil];
    weakSelf.pageSearchUser = 1;
    [sns getCircleSearchUserWithUserId:[AppSetting getUserDetauleId] content:content pageNum:weakSelf.pageSearchUser resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvSearch setViewUserWithDictionary:dicResult];
        });
    } errorBlock:nil];
}
///搜索内容底部刷新
-(void)setSearchContentRefreshFooter
{
    ZWEAKSELF
    weakSelf.pageSearchContnet += 1;
    [sns getCircleQueryQuestionAnswerWithUserId:[AppSetting getUserDetauleId] content:self.lastSearchContent pageNum:weakSelf.pageSearchContnet resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvSearch setViewContentWithDictionary:result];
        });
    } errorBlock:nil];
}
///搜索用户底部刷新
-(void)setSearchUserRefreshFooter
{
    ZWEAKSELF
    weakSelf.pageSearchUser += 1;
    [sns getCircleSearchUserWithUserId:[AppSetting getUserDetauleId] content:self.lastSearchContent pageNum:weakSelf.pageSearchUser resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvSearch setViewUserWithDictionary:result];
        });
    } errorBlock:nil];
}
///登录改变
-(void)setLoginChange
{
    GCDMainBlock(^{
        [self loadAttData:YES];
        
        [self loadDynamicData:YES];
    });
}
///问题变化
-(void)setPublishQuestion:(NSNotification *)sender
{
    ZWEAKSELF
    NSString *index = sender.object;
    switch ([index intValue]) {
        case 3:
            [self setScrollsToTop:ZCircleToolViewItemNew];
            [self.viewTool setViewSelectItemWithType:ZCircleToolViewItemNew];
            break;
        case 4:
            [self setScrollsToTop:ZCircleToolViewItemAtt];
            [self.viewTool setViewSelectItemWithType:ZCircleToolViewItemAtt];
            break;
        default: break;
    }
    //最新
    [sns getCircleLatestListWithPageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            if (result && [result isKindOfClass:[NSDictionary class]] && [result objectForKey:kResultKey]) {
                weakSelf.pageNumNew = 1;
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                [weakSelf.tvNew setBackgroundViewWithState:(ZBackgroundStateNone)];
                [weakSelf.tvNew setViewDataWithDictionary:dicResult];
                [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleNewLocalCacheKey];
            }
        });
    } errorBlock:nil];
    //推荐
    [sns getCircleRemdListWithPageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            if (result && [result isKindOfClass:[NSDictionary class]] && [result objectForKey:kResultKey]) {
                weakSelf.pageNumHot = 1;
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                [weakSelf.tvHot setViewDataWithDictionary:dicResult];
                [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleHotLocalCacheKey];
            }
        });
    } errorBlock:nil];
    //动态
    if ([AppSetting getAutoLogin]) {
        [sns getCircleTrendListWithUserId:[AppSetting getUserDetauleId] pageNum:1 resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                if (result && [result isKindOfClass:[NSDictionary class]] && [result objectForKey:kResultKey]) {
                    weakSelf.pageNumDynamic = 1;
                    NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                    [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                    [weakSelf.tvDynamic setViewDataWithDictionary:dicResult];
                    [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleDynamicLocalCacheKey];
                }
            });
        } errorBlock:nil];
    }
    //关注
    if ([AppSetting getAutoLogin]) {
        [sns getCircleAttentionListWithUserId:[AppSetting getUserDetauleId] pageNum:1 resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                if (result && [result isKindOfClass:[NSDictionary class]] && [result objectForKey:kResultKey]) {
                    weakSelf.pageNumAtt = 1;
                    NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                    [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                    [weakSelf.tvAtt setViewDataWithDictionary:dicResult];
                    [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleAttLocalCacheKey];
                }
            });
        } errorBlock:nil];
    }
}
///设置置顶对象
-(void)setScrollsToTop:(NSInteger)index
{
    switch (index) {
        case ZCircleToolViewItemHot:
        {
            [self.tvHot setScrollsToTop:YES];
            [self.tvDynamic setScrollsToTop:NO];
            [self.tvAtt setScrollsToTop:NO];
            [self.tvNew setScrollsToTop:NO];
            break;
        }
        case ZCircleToolViewItemDynamic:
        {
            [self.tvHot setScrollsToTop:NO];
            [self.tvDynamic setScrollsToTop:YES];
            [self.tvAtt setScrollsToTop:NO];
            [self.tvNew setScrollsToTop:NO];
            break;
        }
        case ZCircleToolViewItemNew:
        {
            [self.tvHot setScrollsToTop:NO];
            [self.tvDynamic setScrollsToTop:NO];
            [self.tvAtt setScrollsToTop:YES];
            [self.tvNew setScrollsToTop:NO];
            break;
        }
        case ZCircleToolViewItemAtt:
        {
            [self.tvHot setScrollsToTop:NO];
            [self.tvDynamic setScrollsToTop:NO];
            [self.tvAtt setScrollsToTop:NO];
            [self.tvNew setScrollsToTop:YES];
            break;
        }
    }
}
///刷新推荐顶部数据
-(void)setRefreshHotHeader
{
    ZWEAKSELF
    self.pageNumHot = 1;
    [sns getCircleRemdListWithPageNum:self.pageNumHot resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvHot setViewDataWithDictionary:dicResult];
            [weakSelf.tvHot endRefreshHeader];
            [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleHotLocalCacheKey];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvHot endRefreshHeader];
        });
    }];
}
///刷新推荐底部数据
-(void)setRefreshHotFooter
{
    ZWEAKSELF
    self.pageNumHot += 1;
    [sns getCircleRemdListWithPageNum:self.pageNumHot resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvHot setViewDataWithDictionary:result];
            [weakSelf.tvHot endRefreshFooter];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNumHot -= 1;
            [weakSelf.tvHot endRefreshFooter];
        });
    }];
}
///刷新最新顶部数据
-(void)setRefreshNewHeader
{
    ZWEAKSELF
    self.pageNumNew = 1;
    [sns getCircleLatestListWithPageNum:self.pageNumNew resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvNew setViewDataWithDictionary:dicResult];
            [weakSelf.tvNew endRefreshHeader];
            [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleNewLocalCacheKey];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvNew endRefreshHeader];
        });
    }];
}
///刷新最新底部数据
-(void)setRefreshNewFooter
{
    ZWEAKSELF
    self.pageNumNew += 1;
    [sns getCircleLatestListWithPageNum:self.pageNumNew resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvNew setViewDataWithDictionary:result];
            [weakSelf.tvNew endRefreshFooter];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNumNew -= 1;
            [weakSelf.tvNew endRefreshFooter];
        });
    }];
}
///刷新动态顶部数据
-(void)setRefreshDynamicHeader
{
    ZWEAKSELF
    self.pageNumDynamic = 1;
    [sns getCircleTrendListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumDynamic resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvDynamic setViewDataWithDictionary:dicResult];
            [weakSelf.tvDynamic endRefreshHeader];
            [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleDynamicLocalCacheKey];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvDynamic endRefreshHeader];
        });
    }];
}
///刷新动态底部数据
-(void)setRefreshDynamicFooter
{
    ZWEAKSELF
    self.pageNumDynamic += 1;
    [sns getCircleTrendListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumDynamic resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvDynamic setViewDataWithDictionary:result];
            [weakSelf.tvDynamic endRefreshFooter];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNumDynamic -= 1;
            [weakSelf.tvDynamic endRefreshFooter];
        });
    }];
}
///刷新关注顶部数据
-(void)setRefreshAttHeader
{
    ZWEAKSELF
    self.pageNumAtt = 1;
    [sns getCircleAttentionListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumAtt resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvAtt setViewDataWithDictionary:dicResult];
            [weakSelf.tvAtt endRefreshHeader];
            [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleAttLocalCacheKey];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvAtt endRefreshHeader];
        });
    }];
}
///刷新关注底部数据
-(void)setRefreshAttFooter
{
    ZWEAKSELF
    self.pageNumAtt += 1;
    [sns getCircleAttentionListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumAtt resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvAtt setViewDataWithDictionary:result];
            [weakSelf.tvAtt endRefreshFooter];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNumAtt -= 1;
            [weakSelf.tvAtt endRefreshFooter];
        });
    }];
}
///键盘改变事件
-(void)keyboardFrameChange:(CGFloat)height
{
    CGRect tvSearchFrame = _tvSearchFrame;
    tvSearchFrame.size.height -= height;
    if (height > kKeyboard_Min_Height) {
        tvSearchFrame.size.height += APP_TABBAR_HEIGHT;
    }
    [self.tvSearch setFrame:tvSearchFrame];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self setScrollsToTop:(_offsetIndex+1)];
    [self.viewTool setViewSelectItemWithType:(_offsetIndex+1)];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewTool setOffsetChange:scrollView.contentOffset.x];
}

@end
