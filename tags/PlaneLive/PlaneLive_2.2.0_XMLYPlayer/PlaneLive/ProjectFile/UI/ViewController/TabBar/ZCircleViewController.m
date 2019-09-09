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
#import "ZCircleTopicTableView.h"
#import "ZCircleSearchTableView.h"
#import "ZSwitchToolView.h"
#import "ZCircleQuestionViewController.h"
#import "ZLoginViewController.h"
#import "ZUserProfileViewController.h"
#import "ZTopicListViewController.h"
#import "ZTopicTypeViewController.h"
#import "ZWebViewController.h"
#import "ZCircleSearchViewController.h"

#define kCircleHotLocalCacheKey @"kCircleHotLocalCacheKey"
#define kCircleDynamicLocalCacheKey @"kCircleDynamicLocalCacheKey"
#define kCircleNewLocalCacheKey @"kCircleNewLocalCacheKey"
#define kCircleTopicLocalCacheKey @"kCircleTopicLocalCacheKey"

@interface ZCircleViewController ()<UIScrollViewDelegate>
{
    NSInteger _offsetIndex;
}
///切换栏
@property (strong, nonatomic) ZSwitchToolView *viewTool;
///滚动模块
@property (strong, nonatomic) ZScrollView *scrollView;

///推荐
@property (strong, nonatomic) ZCircleHotTableView *tvHot;
///动态
@property (strong, nonatomic) ZCircleDynamicTableView *tvDynamic;
///最新
@property (strong, nonatomic) ZCircleNewTableView *tvNew;
///话题
@property (strong, nonatomic) ZCircleTopicTableView *tvTopic;

///推荐
@property (strong, nonatomic) NSMutableArray *arrHot;
///动态
@property (strong, nonatomic) NSMutableArray *arrDynamic;
///最新
@property (strong, nonatomic) NSMutableArray *arrNew;
///话题
@property (strong, nonatomic) NSMutableArray *arrTopic;

///推荐
@property (assign, nonatomic) int pageNumHot;
///动态
@property (assign, nonatomic) int pageNumDynamic;
///最新
@property (assign, nonatomic) int pageNumNew;
///话题
@property (assign, nonatomic) int pageNumTopic;

///是否获取语音
@property (assign, nonatomic) BOOL isGetPracticeing;

@property (assign, nonatomic) BOOL isLoadHot;
@property (assign, nonatomic) BOOL isLoadNew;
@property (assign, nonatomic) BOOL isLoadTopic;
@property (assign, nonatomic) BOOL isLoadDynamic;

///提问
@property (strong, nonatomic) UIButton *btnIcon;

@end

@implementation ZCircleViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kCircle];
    
    [self registerLoginChangeNotification];
    
    [self registerPublishQuestionNotification];
    
    [self registerFontSizeChangeNotification];
    
    [self innerInit];
    
    [self setLeftButtonWithImage:@"cricle_search_btn"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        //[self setViewNil];
    }
}
- (void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [self removePublishQuestionNotification];
    [self removeLoginChangeNotification];
    [self removeFontSizeChangeNotification];
    
    OBJC_RELEASE(_viewTool);
    OBJC_RELEASE(_tvHot);
    OBJC_RELEASE(_tvDynamic);
    OBJC_RELEASE(_tvNew);
    OBJC_RELEASE(_btnIcon);
    OBJC_RELEASE(_tvTopic);
    OBJC_RELEASE(_scrollView);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrHot = [NSMutableArray array];
    self.arrDynamic = [NSMutableArray array];
    self.arrNew = [NSMutableArray array];
    self.arrTopic = [NSMutableArray array];
    
    self.viewTool = [[ZSwitchToolView alloc] initWithType:(ZSwitchToolViewItemCircle)];
    [self.view addSubview:self.viewTool];
    CGFloat contentW = APP_FRAME_WIDTH;
    [self.viewTool setFrame:CGRectMake(0, APP_TOP_HEIGHT, contentW, [ZSwitchToolView getViewH])];
    
    CGFloat contentY = self.viewTool.y+self.viewTool.height;
    CGFloat contentH = APP_FRAME_HEIGHT-contentY-APP_TABBAR_HEIGHT;
    self.scrollView = [[ZScrollView alloc] initWithFrame:CGRectMake(0, contentY, contentW, contentH)];
    [self.scrollView setOpaque:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.scrollView setContentSize:CGSizeMake(contentW*4, self.scrollView.height)];
    [self.view addSubview:self.scrollView];
    
    self.tvHot = [[ZCircleHotTableView alloc] initWithFrame:CGRectMake(0, 0, contentW, contentH)];
    [self.scrollView addSubview:self.tvHot];
    
    self.tvTopic = [[ZCircleTopicTableView alloc] initWithFrame:CGRectMake(contentW, 0, contentW, contentH)];
    [self.scrollView addSubview:self.tvTopic];
    
    self.tvNew = [[ZCircleNewTableView alloc] initWithFrame:CGRectMake(contentW*2, 0, contentW, contentH)];
    [self.scrollView addSubview:self.tvNew];
    
    self.tvDynamic = [[ZCircleDynamicTableView alloc] initWithFrame:CGRectMake(contentW*3, 0, contentW, contentH)];
    [self.scrollView addSubview:self.tvDynamic];
    
    [self setScrollsToTop:ZCircleToolViewItemHot];
    
    [self.view sendSubviewToBack:self.scrollView];
    [self.view sendSubviewToBack:self.viewTool];
    
    CGFloat iconW = 58;
    CGFloat iconH = 61;
    self.btnIcon = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnIcon setImage:[SkinManager getImageWithName:@"btn_cricle_question"] forState:(UIControlStateNormal)];
    [self.btnIcon setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnIcon setFrame:CGRectMake(APP_FRAME_WIDTH-iconW-5, APP_FRAME_HEIGHT-APP_TABBAR_HEIGHT-iconH-3, iconW, iconH)];
    [self.btnIcon addTarget:self action:@selector(btnIconClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.btnIcon];
    
    [self.view bringSubviewToFront:self.btnIcon];
    
    [self setIsLoadHot:YES];
    
    [self innerHot];
    
    [self innerEvent];
    
    [super innerInit];
}
///初始化热门
-(void)innerHot
{
    NSArray *arrHot = [sqlite getLocalCircleHotQuestionArrayWithAll];
    if (arrHot && arrHot.count > 0) {
        [self.tvHot setViewDataWithArray:arrHot isHeader:YES];
    } else {
        [self.tvHot setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshHotHeader];
}
///初始化最新
-(void)innerNew
{
    NSArray *arrNew = [sqlite getLocalCircleNewQuestionArrayWithAll];
    if (arrNew && arrNew.count > 0) {
        [self.tvNew setViewDataWithArray:arrNew isHeader:YES];
    } else {
        [self.tvNew setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshNewHeader];
}
///初始化话题
-(void)innerTopic
{
    NSDictionary *dicTopicLocalCache = [sqlite getLocalCacheDataWithPathKay:kCircleTopicLocalCacheKey];
    if ([dicTopicLocalCache objectForKey:kResultKey]) {
        NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:dicTopicLocalCache];
        [dicResult setObject:@"YES" forKey:kIsHeaderKey];
        
        [self.tvTopic setViewDataWithDictionary:dicResult];
    } else {
        [self.tvTopic setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshTopicHeader];
}
///初始化动态
-(void)innerDynamic
{
    if (![AppSetting getAutoLogin]) {
        [self.tvDynamic setViewDataWithArray:nil isHeader:YES];
        [self.tvDynamic setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
    } else {
        NSArray *arrDynamic = [sqlite getLocalCircleDynamicQuestionArrayWithUserId:[AppSetting getUserDetauleId]];
        if (arrDynamic && arrDynamic.count > 0) {
            [self.tvDynamic setViewDataWithArray:arrDynamic isHeader:YES];
        } else {
            [self.tvDynamic setBackgroundViewWithState:(ZBackgroundStateLoading)];
        }
        [self setRefreshDynamicHeader];
    }
}
///功能按钮
-(void)btnIconClick
{
    [StatisticsManager event:kCircle_Question];
    
    [self showCircleQuestionVC];
}
///左边按钮
-(void)btnLeftClick
{
    [StatisticsManager event:kCircle_Search];
    
    ZCircleSearchViewController *itemVC = [[ZCircleSearchViewController alloc] init];
    [itemVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:itemVC animated:NO];
}

-(void)innerEvent
{
    ZWEAKSELF
    //工具栏切换
    [self.viewTool setOnItemClick:^(NSInteger index) {
        [weakSelf setChangeItem:index];
        [weakSelf setScrollsToTop:index];
        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.width*(index-1), 0) animated:YES];
    }];
    //话题类型点击
    [self.tvTopic setOnAllClick:^(ModelTagType *model) {
        ZTopicTypeViewController *itemVC = [[ZTopicTypeViewController alloc] init];
        [itemVC setTitle:model.typeName];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    //话题点击
    [self.tvTopic setOnItemClick:^(ModelTag *model) {
        ZTopicListViewController *itemVC = [[ZTopicListViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    //最新头像点击
    [self.tvNew setOnImagePhotoClick:^(ModelUserBase *model) {
        if (![model.userId isEqualToString:[AppSetting getUserDetauleId]]) {
            [weakSelf showUserProfileVCWithModel:model];
        }
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
    [self.tvHot setOnAnswerClick:^(ModelAnswerBase *model) {
        [weakSelf showAnswerDetailVC:model];
    }];
    //推荐头像区域点击事件
    [self.tvHot setOnImagePhotoClick:^(ModelUserBase *model) {
        if (![model.userId isEqualToString:[AppSetting getUserDetauleId]]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
    //最新回答区域点击事件
    [self.tvNew setOnAnswerClick:^(ModelAnswerBase *model) {
        [weakSelf showAnswerDetailVC:model];
    }];
    //动态回答区域点击事件
    [self.tvDynamic setOnAnswerClick:^(ModelAnswerBase *model) {
        [weakSelf showAnswerDetailVC:model];
    }];
    //动态回答区域点击事件
    [self.tvDynamic setOnImagePhotoClick:^(ModelUserBase *model) {
        if (![model.userId isEqualToString:[AppSetting getUserDetauleId]]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
    //刷新最新顶部
    [self.tvNew setOnRefreshHeader:^{
        [weakSelf setRefreshNewHeader];
    }];
    //刷子最新底部
    [self.tvNew setOnRefreshFooter:^{
        [weakSelf setRefreshNewFooter];
    }];
    //刷新话题顶部
    [self.tvTopic setOnRefreshHeader:^{
        [weakSelf setRefreshTopicHeader];
    }];
    //刷新话题底部
    [self.tvTopic setOnRefreshFooter:^{
        [weakSelf setRefreshTopicFooter];
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
            case ZBackgroundStateLoginNull:
                [weakSelf showLoginVC];
                break;
            default:
                [weakSelf.tvDynamic setBackgroundViewWithState:(ZBackgroundStateLoading)];
                [weakSelf setRefreshDynamicHeader];
                break;
        }
    }];
    //话题背景点击事件
    [self.tvTopic setOnBackgroundClick:^(ZBackgroundState viewBGState) {
        [weakSelf.tvTopic setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshTopicHeader];
    }];
    //推荐背景点击事件
    [self.tvHot setOnBackgroundClick:^(ZBackgroundState viewBGState) {
        [weakSelf.tvHot setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHotHeader];
    }];
    //最新背景点击事件
    [self.tvNew setOnBackgroundClick:^(ZBackgroundState viewBGState) {
        [weakSelf.tvNew setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshNewHeader];
    }];
}
///显示他人用户界面
-(void)showUserProfileVCWithModel:(ModelUserBase *)model
{
    if (![Utils isMyUserId:model.userId]) {
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
///登录改变
-(void)setLoginChange
{
    if (self) {
        [self setRefreshTopicHeader];
        
        [self setRefreshDynamicHeader];
    }
}
///TODO:ZWW备注-设置字体大小改变
-(void)setFontSizeChange
{
    if (self) {
        GCDMainBlock(^{
            if (self.tvHot) {
                [self.tvHot setFontSizeChange];
            }
            if (self.tvDynamic) {
                [self.tvDynamic setFontSizeChange];
            }
            if (self.tvNew) {
                [self.tvNew setFontSizeChange];
            }
        });
    }
}
///问题变化
-(void)setPublishQuestion:(NSNotification *)sender
{
    if (self && sender) {
        ZWEAKSELF
        ModelQuestion *modelQ = sender.object;
        if (modelQ && [modelQ isKindOfClass:[ModelQuestion class]] && [modelQ.ids integerValue] > 0) {
            [self setScrollsToTop:ZCircleToolViewItemNew];
            [self.viewTool setViewSelectItemWithType:ZCircleToolViewItemNew];
            [self.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.width*(2), 0) animated:YES];
            
            [self.tvNew addViewModelWithNewQuestion:modelQ];
        }
    }
}
///顶部内容区域切换
-(void)setScrollViewContentOffsetWithIndex:(ZCircleToolViewItem)index
{
    [self setScrollsToTop:index];
    [self.viewTool setViewSelectItemWithType:index];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*(index-1), 0) animated:NO];
}
///设置置顶对象
-(void)setScrollsToTop:(NSInteger)index
{
    switch (index) {
        case ZCircleToolViewItemHot:
        {
            [self.tvHot setScrollsToTop:YES];
            [self.tvTopic setScrollsToTop:NO];
            [self.tvNew setScrollsToTop:NO];
            [self.tvDynamic setScrollsToTop:NO];
            break;
        }
        case ZCircleToolViewItemDynamic:
        {
            [self.tvHot setScrollsToTop:NO];
            [self.tvTopic setScrollsToTop:NO];
            [self.tvNew setScrollsToTop:NO];
            [self.tvDynamic setScrollsToTop:YES];
            break;
        }
        case ZCircleToolViewItemNew:
        {
            [self.tvHot setScrollsToTop:NO];
            [self.tvTopic setScrollsToTop:NO];
            [self.tvNew setScrollsToTop:YES];
            [self.tvDynamic setScrollsToTop:NO];
            break;
        }
        case ZCircleToolViewItemTopic:
        {
            [self.tvHot setScrollsToTop:NO];
            [self.tvTopic setScrollsToTop:YES];
            [self.tvNew setScrollsToTop:NO];
            [self.tvDynamic setScrollsToTop:NO];
            break;
        }
    }
}
///刷新推荐顶部数据
-(void)setRefreshHotHeader
{
    ZWEAKSELF
    self.pageNumHot = 1;
    [snsV2 getCircleRemdListWithPageNum:self.pageNumHot resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvHot endRefreshHeader];
        [weakSelf.tvHot setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalCircleHotQuestionWithArray:arrResult];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvHot endRefreshHeader];
        [weakSelf.tvHot setViewDataWithArray:nil isHeader:YES];
    }];
}
///刷新推荐底部数据
-(void)setRefreshHotFooter
{
    ZWEAKSELF
    [snsV2 getCircleRemdListWithPageNum:self.pageNumHot+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNumHot += 1;
        [weakSelf.tvHot endRefreshFooter];
        [weakSelf.tvHot setViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvHot endRefreshFooter];
    }];
}
///刷新最新顶部数据
-(void)setRefreshNewHeader
{
    ZWEAKSELF
    self.pageNumNew = 1;
    [snsV1 getCircleLatestListWithPageNum:self.pageNumNew resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf.tvNew endRefreshHeader];
        [weakSelf.tvNew setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalCircleNewQuestionWithArray:arrResult];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvNew endRefreshHeader];
        [weakSelf.tvNew setViewDataWithArray:nil isHeader:YES];
    }];
}
///刷新最新底部数据
-(void)setRefreshNewFooter
{
    ZWEAKSELF
    [snsV1 getCircleLatestListWithPageNum:self.pageNumNew+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNumNew += 1;
        [weakSelf.tvNew endRefreshFooter];
        [weakSelf.tvNew setViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvNew endRefreshFooter];
    }];
}
///刷新动态顶部数据
-(void)setRefreshDynamicHeader
{
    ZWEAKSELF
    self.pageNumDynamic = 1;
    [snsV1 getCircleTrendListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumDynamic resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        [weakSelf.tvDynamic endRefreshHeader];
        [weakSelf.tvDynamic setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalCircleDynamicQuestionWithArray:arrResult userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvDynamic endRefreshHeader];
    }];
}
///刷新动态底部数据
-(void)setRefreshDynamicFooter
{
    ZWEAKSELF
    [snsV1 getCircleTrendListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumDynamic+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumDynamic += 1;
        [weakSelf.tvDynamic endRefreshFooter];
        [weakSelf.tvDynamic setViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvDynamic endRefreshFooter];
    }];
}
///刷新话题顶部数据
-(void)setRefreshTopicHeader
{
    ZWEAKSELF
    self.pageNumTopic = 1;
    [snsV1 getCircleTopicListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumTopic resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        [weakSelf.tvTopic endRefreshHeader];
        
        [weakSelf.tvTopic setViewDataWithArray:arrResult isHeader:YES];
        
        [sqlite setLocalCacheDataWithDictionary:result pathKay:kCircleTopicLocalCacheKey];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvTopic endRefreshHeader];
    }];
}
///刷新话题底部数据
-(void)setRefreshTopicFooter
{
    ZWEAKSELF
    [snsV1 getCircleTopicListWithUserId:[AppSetting getUserDetauleId] pageNum:self.pageNumTopic+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumTopic += 1;
        [weakSelf.tvTopic endRefreshFooter];
        [weakSelf.tvTopic setViewDataWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvTopic endRefreshFooter];
    }];
}
///读取数据
-(void)setChangeItem:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            [StatisticsManager event:kCircle_Recommend];
            if (!self.isLoadHot) {
                [self setIsLoadHot:YES];
                [self innerHot];
            }
            break;
        }
        case 2:
        {
            [StatisticsManager event:kCircle_Topic];
            if (!self.isLoadTopic) {
                [self setIsLoadTopic:YES];
                [self innerTopic];
            }
            break;
        }
        case 3:
        {
            [StatisticsManager event:kCircle_New];
            if (!self.isLoadNew) {
                [self setIsLoadNew:YES];
                [self innerNew];
            }
            break;
        }
        case 4:
        {
            [StatisticsManager event:kCircle_Dynamic];
            if (!self.isLoadDynamic) {
                [self setIsLoadDynamic:YES];
                [self innerDynamic];
            }
            break;
        }
        default: break;
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    [self setScrollsToTop:(_offsetIndex+1)];
    [self.viewTool setViewSelectItemWithType:(_offsetIndex+1)];
    [self setChangeItem:_offsetIndex+1];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewTool setOffsetChange:scrollView.contentOffset.x];
}

@end
