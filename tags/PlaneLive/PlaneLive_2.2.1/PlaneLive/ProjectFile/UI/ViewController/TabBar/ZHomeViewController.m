//
//  ZHomeViewController.m
//  PlaneLive
//
//  Created by Daniel on 9/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeViewController.h"

#import "ZHomeTableView.h"
#import "ZHomeSearchView.h"
#import "ZHomeSubscribeTrailerView.h"
#import "ZPracticeTypeViewController.h"
#import "ZQuestionBoutiqueViewController.h"
#import "ZSubscribeListViewController.h"
#import "ZSubscribeDetailViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"
#import "ZSubscribeDetailViewController.h"
#import "ZCurriculumListViewController.h"
#import "ZSubscribeTypeViewController.h"
#import "ZQuestionDetailViewController.h"
#import "ZLawFirmListViewController.h"
#import "ZLawFirmDetailViewController.h"

#define kSearchDefaultWidth 65
#define kSearchSpaceWidth 10

@interface ZHomeViewController ()<UISearchBarDelegate>

///上次导航栏透明度
@property (assign, nonatomic) CGFloat navLastAlpha;
///主视图
@property (strong, nonatomic) ZHomeTableView *tvMain;
///左边展示搜索框
@property (strong, nonatomic) UISearchBar *searchBar;
///输入框
@property (weak, nonatomic) UITextField *textField;
///搜索内容
@property (strong, nonatomic) ZHomeSearchView *viewSearch;
///搜索内容初始化坐标
@property (assign, nonatomic) CGRect searchFrame;
///搜索内容
@property (strong, nonatomic) NSString *lastSearchText;
///是否显示搜索内容
@property (assign, nonatomic) BOOL isShowSearchView;
///实务第几页
@property (assign, nonatomic) int pageNumPractice;
///订阅第几页
@property (assign, nonatomic) int pageNumSubscribe;
///系列课第几页
@property (assign, nonatomic) int pageNumSeriesCourse;
///返回数据对象
@property (strong, nonatomic) NSDictionary *dicResult;
///是否显示查询过数据库
@property (assign, nonatomic) BOOL isSelectData;

@end

@implementation ZHomeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kHome];
    [self innerInit];
    // TODO:ZWW备注-开关引导页
    //[[AppDelegate app] setShowBootVC];
    [self registerLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCartPaySuccess) name:ZCartPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSubscribePaySuccess) name:ZSubscribeSuccessNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.isShowSearchView) {
        [self setNavBarBackgroundWithAlpha:self.navLastAlpha];
    } else {
        [self.searchBar becomeFirstResponder];
    }
    [self.tvMain adjustWhenControllerViewWillAppera];
    [self registerKeyboardNotification];
    [self registerTextFieldTextDidChangeNotification];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.isSelectData) {
        NSString *strParam = [sqlite getSysParamWithKey:kSQLITE_LAST_PUSHDATA];
        if (strParam && strParam.length > 0) {
            NSDictionary *dicParam = [NSJSONSerialization JSONObjectWithData:[strParam dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if (dicParam && [dicParam isKindOfClass:[NSDictionary class]]) {
                [[AppDelegate getTabBarVC] setShowViewControllerWithParam:dicParam];
            }
        }
        [self setIsSelectData:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
    [self removeTextFieldTextDidChangeNotification];
    [self.searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        //[self setViewNil];
    }
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [self removeLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZSubscribeSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZCartPaySuccessNotification object:nil];
    
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_searchBar);
    OBJC_RELEASE(_viewSearch);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self setNavSearchBar:kSearch];
    
    ZWEAKSELF
    self.tvMain = [[ZHomeTableView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TABBAR_HEIGHT)];
    ///广告区域
    [self.tvMain setOnBannerClick:^(ModelBanner *model) {
        [StatisticsManager event:kHomepage_Banner dictionary:@{@"objectId": model.ids==nil?kEmpty:model.ids,
                                                               @"objectName": model.title==nil?kEmpty:model.title,
                                                               @"userId": [AppSetting getUserId]}];
        switch (model.type) {
            case ZBannerTypePractice://实务
            {
                [ZProgressHUD showMessage:kCMsgGeting];
                [snsV1 getQuerySpeechDetailWithSpeechId:model.code userId:kLoginUserId resultBlock:^(NSDictionary *result) {
                    GCDMainBlock(^{
                        [ZProgressHUD dismiss];
                        NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                        if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                            ModelPractice *modelPractice = [[ModelPractice alloc] initWithCustom:dicReuslt];
                            
                            [sqlite setLocalPlayPracticeDetailWithModel:modelPractice userId:kLoginUserId];
                            
                            [weakSelf showPlayVCWithPracticeArray:@[modelPractice] index:0];
                        } else {
                            [ZProgressHUD showError:kGetInfoFail];
                        }
                    });
                } errorBlock:^(NSString *msg) {
                    GCDMainBlock(^{
                        [ZProgressHUD dismiss];
                        [ZProgressHUD showError:msg];
                    });
                }];
                break;
            }
            case ZBannerTypeNews://新闻
            {
                [weakSelf showWebVCWithModel:model];
                break;
            }
            case ZBannerTypeQuestion://问题
            {
                ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
                [modelQB setIds:model.code];
                [modelQB setTitle:model.title];
                [weakSelf showQuestionDetailVC:modelQB];
                break;
            }
            case ZBannerTypeSubscribe://订阅
            {
                ModelSubscribeDetail *modelSD = [sqlite getLocalSubscribeDetailWithUserId:kLoginUserId subscribeId:model.code];
                if (modelSD && modelSD.ids) {
                    [weakSelf showSubscribeDetailVCWithModel:modelSD];
                } else {
                    [ZProgressHUD showMessage:kGetSubscriptioning];
                    [snsV2 getSubscribeRecommendArrayWithSubscribeId:model.code resultBlock:^(ModelSubscribeDetail *model, NSDictionary *result) {
                        [ZProgressHUD dismiss];
                        if (model) {
                            [weakSelf showSubscribeDetailVCWithModel:model];
                            [sqlite setLocalSubscribeDetailWithModel:model userId:kLoginUserId];
                        } else {
                            [ZProgressHUD showError:kGetSubscriptionInfoFail];
                        }
                    } errorBlock:^(NSString *msg) {
                        [ZProgressHUD dismiss];
                        [ZProgressHUD showError:msg];
                    }];
                }
                break;
            }
            default: break;
        }
    }];
    ///屏幕偏移量
    [self.tvMain setOnContentOffsetClick:^(CGFloat contentOffsetY, CGFloat bannerHeight) {
        [weakSelf.searchBar resignFirstResponder];
        CGFloat alpha = contentOffsetY / (bannerHeight-APP_TOP_HEIGHT);
        if (alpha > 1) { alpha = 1; }
        else if (alpha < 0) { alpha = 0; }
        [weakSelf setNavLastAlpha:alpha];
        [weakSelf setNavBarBackgroundWithAlpha:alpha];
    }];
    ///实务全部按钮
    [self.tvMain setOnAllPracticeClick:^{
        [StatisticsManager event:kHomepage_Practice_All];
        ZPracticeTypeViewController *itemVC = [[ZPracticeTypeViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///工具栏子项点击事件
    [self.tvMain setOnToolItemClick:^(NSInteger index) {
        switch (index) {
            case 1:
            {
                [StatisticsManager event:kHomepage_Practice_All];
                ZPracticeTypeViewController *itemVC = [[ZPracticeTypeViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [weakSelf.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case 2:
            {
                [StatisticsManager event:kHomepage_Subscription_All];
                ZSubscribeTypeViewController *itemVC = [[ZSubscribeTypeViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [weakSelf.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            case 3:
            {
                [StatisticsManager event:kHomepage_SeriesCourse_All];
                ZCurriculumListViewController *itemVC = [[ZCurriculumListViewController alloc] init];
                [itemVC setHidesBottomBarWhenPushed:YES];
                [weakSelf.navigationController pushViewController:itemVC animated:YES];
                break;
            }
            default: break;
        }
    }];
    ///实务单个点击事件
    [self.tvMain setOnPracticeClick:^(NSArray *array, NSInteger row) {
        if (array.count > 0 && row < array.count) {
            ModelPractice *modelP = [array objectAtIndex:row];
            if (modelP && modelP.ids && modelP.title) {
                [StatisticsManager event:kHomepage_Practice_List_Item dictionary:@{kObjectId:modelP.ids,kObjectTitle:modelP.title,kObjectUser:kLoginUserId}];
            }
        }
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    [self.tvMain setOnAllLawFirmClick:^{
        [StatisticsManager event:kHomepage_LawFirm_All];
        ZLawFirmListViewController *itemVC= [[ZLawFirmListViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.tvMain setOnLawFirmClick:^(ModelLawFirm *model) {
        [StatisticsManager event:kHomepage_LawFirm_List_Item dictionary:@{kObjectId:model.ids,kObjectTitle:model.title,kObjectUser:kLoginUserId}];
        ZLawFirmDetailViewController *itemVC= [[ZLawFirmDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///精品问答点击事件
    [self.tvMain setOnQuestionClick:^(ModelQuestionBoutique *model) {
        [StatisticsManager event:kHomepage_BoutiqueQusetion];
        ZQuestionDetailViewController *itemVC = [[ZQuestionDetailViewController alloc] init];
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:model.ids];
        [modelQB setTitle:model.title];
        [itemVC setViewDataWithModel:modelQB];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///订阅全部
    [self.tvMain setOnAllSubscribeClick:^{
        ZSubscribeTypeViewController *itemVC = [[ZSubscribeTypeViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///系列课程全部
    [self.tvMain setOnAllCurriculumClick:^{
        ZCurriculumListViewController *itemVC = [[ZCurriculumListViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///精品问答全部
    [self.tvMain setOnAllQuestionClick:^{
        [StatisticsManager event:kHomepage_BoutiqueQusetion];
        ZQuestionBoutiqueViewController *itemVC = [[ZQuestionBoutiqueViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///订阅单个点击事件
    [self.tvMain setOnSubscribeClick:^(ModelSubscribe *model) {
        if (model && model.ids && model.title) {
            [StatisticsManager event:kHomepage_Subscription_List_Item dictionary:@{kObjectId:model.ids,kObjectTitle:model.title,kObjectUser:kLoginUserId}];
        }
        switch (model.type) {
            case 1:
            {
                ZHomeSubscribeTrailerView *subscribeTrailerView = [[ZHomeSubscribeTrailerView alloc] initWithModel:model];
                [subscribeTrailerView show];
                break;
            }
            default:
                [weakSelf showSubscribeDetailVCWithModel:model];
                break;
        }
    }];
    ///系列课程点击事件
    [self.tvMain setOnCurriculumClick:^(ModelSubscribe *model) {
        if (model && model.ids && model.title) {
            [StatisticsManager event:kHomepage_Subscription_List_Item dictionary:@{kObjectId:model.ids,kObjectTitle:model.title,kObjectUser:kLoginUserId}];
        }
        switch (model.type) {
            case 1:
            {
                ZHomeSubscribeTrailerView *subscribeTrailerView = [[ZHomeSubscribeTrailerView alloc] initWithModel:model];
                [subscribeTrailerView show];
                break;
            }
            default:
                [weakSelf showSubscribeDetailVCWithModel:model];
                break;
        }
    }];
    ///什么是订阅点击事件
    [self.tvMain setOnWhatSubscribeClick:^{
        if (weakSelf.dicResult != nil) {
            NSString *url = [weakSelf.dicResult objectForKey:@"courseNote"];
            if (url != nil) {
                [weakSelf showWebVCWithUrl:url title:kWhatIsASubscription];
            }
        }
    }];
    ///什么是系列课点击事件
    [self.tvMain setOnWhatCurriculumClick:^{
        if (weakSelf.dicResult != nil) {
            NSString *url = [weakSelf.dicResult objectForKey:@"seriesCourseNote"];
            if (url != nil) {
                [weakSelf showWebVCWithUrl:url title:kWhatIsSeriesOfLessons];
            }
        }
    }];
    ///刷新顶部按钮
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.view addSubview:self.tvMain];
    
    [self setSearchView];
    [self innerData];
    [super innerInit];
    [self setNavBarAlpha:0];
}
///设置搜索内容区域
-(void)setSearchView
{
    ZWEAKSELF
    ///搜索内容视图
    self.searchFrame = CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-APP_TABBAR_HEIGHT);
    self.viewSearch = [[ZHomeSearchView alloc] initWithFrame:self.searchFrame];
    [self.viewSearch setOnPracticeClick:^(NSArray *array, NSInteger row) {
        if (array.count > 0 && row < array.count) {
            ModelPractice *modelP = [array objectAtIndex:row];
            if (modelP && modelP.ids && modelP.title) {
                [StatisticsManager event:kHomepage_Search_Practice_List_Item dictionary:@{kObjectId:modelP.ids,kObjectTitle:modelP.title,kObjectUser:kLoginUserId}];
            } else {
                [StatisticsManager event:kHomepage_Search_Practice_List_Item];
            }
        }
        [weakSelf.searchBar resignFirstResponder];
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    [self.viewSearch setOnPracticeRefreshFooter:^{
        [snsV2 getHomeSearchPracticeWithParam:weakSelf.lastSearchText pageNum:weakSelf.pageNumPractice+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
            
            weakSelf.pageNumPractice += 1;
            [weakSelf.viewSearch endRefreshPracticeFooter];
            [weakSelf.viewSearch setViewDataPracticeWithArray:arrResult isHeader:NO];
        } errorBlock:^(NSString *msg) {
            [weakSelf.viewSearch endRefreshPracticeFooter];
        }];
    }];
    [self.viewSearch setOnSubscribeClick:^(ModelSubscribe *model) {
        if (model && model.ids && model.title) {
            [StatisticsManager event:kHomepage_Search_Subscription_List_Item dictionary:@{kObjectId:model.ids,kObjectTitle:model.title,kObjectUser:kLoginUserId}];
        } else {
            [StatisticsManager event:kHomepage_Search_Subscription_List_Item];
        }
        [weakSelf showSubscribeDetailVCWithModel:model];
    }];
    [self.viewSearch setOnSubscribeRefreshFooter:^{
        [weakSelf setRefreshSubscribeFooter];
    }];
    [self.viewSearch setOnSeriesCourseClick:^(ModelSubscribe *model) {
        if (model && model.ids && model.title) {
            [StatisticsManager event:kHomepage_Search_SeriesCourse_List_Item dictionary:@{kObjectId:model.ids,kObjectTitle:model.title,kObjectUser:kLoginUserId}];
        } else {
            [StatisticsManager event:kHomepage_Search_SeriesCourse_List_Item];
        }
        [weakSelf showSubscribeDetailVCWithModel:model];
    }];
    [self.viewSearch setOnSeriesCourseRefreshFooter:^{
        [weakSelf setRefreshSeriesCourseFooter];
    }];
    
    [self.viewSearch setHidden:YES];
    [self.view addSubview:self.viewSearch];
}
///显示订阅详情
-(void)showSubscribeDetailVCWithModel:(ModelSubscribe *)model
{
    if (!model.isSubscribe) {
        ZSubscribeDetailViewController *itemVC = [[ZSubscribeDetailViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        ZSubscribeAlreadyHasViewController *itemVC = [[ZSubscribeAlreadyHasViewController alloc] init];
        [itemVC setViewDataWithSubscribeModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}
///设置搜索按钮
-(void)setNavSearchBar:(NSString *)placeholder
{
    [self.navigationItem setTitleView:nil];
    [self.navigationItem setLeftBarButtonItem:nil];
    
    if (self.searchBar) {
        self.searchBar.delegate = nil;
        [self.searchBar removeFromSuperview];
    }
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kSearchDefaultWidth, 45)];
    [self.searchBar setPlaceholder:placeholder];
    [self.searchBar setBarTintColor:DESCCOLOR];
    [self.searchBar setBackgroundColor:CLEARCOLOR];
    [self.searchBar setDelegate:self];
    [self setSearchTextFiled];
    
    UIView *viewTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
    [viewTitle setBackgroundColor:CLEARCOLOR];
    [viewTitle addSubview:self.searchBar];
    
    [self.navigationItem setTitleView:viewTitle];
}
///设置搜索按钮是否可用
-(void)setSearchTextFiled
{
    UITextField *textField = nil;
    for (UIView *view in self.searchBar.subviews) {
        if (view.subviews.count > 0) {
            for (UIView *item in view.subviews) {
                if ([item isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                    textField = (UITextField *)item;
                }
                if ([item isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    [item removeFromSuperview];
                }
            }
        }
    }
    if (textField) {
        [textField setReturnKeyType:(UIReturnKeyDone)];
        [textField setBackgroundColor:SEARCHBACKCOLOR];
        [[textField layer] setMasksToBounds:YES];
        UIImageView *imageSearch = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 17, 19)];
        [imageSearch setImage:[SkinManager getImageWithName:@"home_search_icon"]];
        [textField setLeftView:imageSearch];
        [textField setViewRound:14 borderWidth:0 borderColor:CLEARCOLOR];
        self.textField = textField;
        [self setSearchPlaceholder:kSearch];
    }
}
-(void)setSearchPlaceholder:(NSString *)placeholder
{
    [self.textField setPlaceholder:placeholder];
    [self.textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.textField.placeholder attributes:@{NSForegroundColorAttributeName:SEARCHTINTCOLOR,NSFontAttributeName:[ZFont systemFontOfSize:kFont_Least_Size]}]];
}
///设置导航栏透明度
-(void)setNavBarBackgroundWithAlpha:(CGFloat)alpha
{
    [self setNavBarAlpha:alpha];
    
    if (alpha <= 0) {
        CGRect searchFrame = self.searchBar.frame;
        searchFrame.size.width = kSearchDefaultWidth;
        [self.searchBar setFrame:searchFrame];
        
        [self setSearchPlaceholder:kSearch];
    } else {
        CGRect searchFrame = self.searchBar.frame;
        searchFrame.size.width = kSearchDefaultWidth+(APP_FRAME_WIDTH-kSearchDefaultWidth-kSearchSpaceWidth*2)*(alpha);
        [self.searchBar setFrame:searchFrame];
        [[self.textField leftView] setFrame:CGRectMake(self.textField.leftView.x, self.textField.leftView.y, 17, 19)];
        
        if (alpha >= 1) {
            if (kIsAppAudit) {
                [self setSearchPlaceholder:kSearchPracticeSpecialColumn];
            } else {
                [self setSearchPlaceholder:kSearchPracticeSubscribe];
            }
        } else {
            [self setSearchPlaceholder:kSearch];
        }
    }
    if (self.navigationItem.rightBarButtonItem.customView) {
        ///设置播放按钮状态
        UIButton *btnPlay = [self.navigationItem.rightBarButtonItem.customView viewWithTag:kNavPlayButtonTag];
        if (btnPlay) {
            btnPlay.hidden = alpha==1;
            if (alpha <= 0) {
                btnPlay.alpha = 1;
            } else {
                btnPlay.alpha = 1-alpha;
            }
        }
    } else {
        if ([[AppDelegate app] isPlay]) {
            [self setRightPlayButtonWithAlpha:1-self.navLastAlpha];
        } else {
            [[self navigationItem] setRightBarButtonItem:nil];
        }
    }
}
-(void)innerData
{
    NSArray *arrLocalBanner = [sqlite getLocalHomeBannerArrayWithAll];
    if (arrLocalBanner && arrLocalBanner.count > 0) {
        NSArray *arrPractice = [sqlite getLocalHomePracticeArrayWithUserId:kLoginUserId];
        NSArray *arrLawFirm = [sqlite getLocalHomeLawFirmWithArrayAll];
        NSArray *arrQuestion = [sqlite getLocalHomeQuestionArrayWithAll];
        NSArray *arrSubscribe = [sqlite getLocalHomeSubscribeArrayWithUserId:kLoginUserId];
        NSArray *arrCurriculum = [sqlite getLocalHomeCurriculumArrayWithUserId:kLoginUserId];
        
        [self.tvMain setViewDataWithBannerArray:arrLocalBanner arrayPractice:arrPractice arrLawFirm:arrLawFirm arrQuestion:arrQuestion arrSubscribe:arrSubscribe arrCurriculum:arrCurriculum];
    }
    [self setRefreshHeader];
}
-(void)setLoginChange
{
    [self setRefreshHeader];
}
-(void)setCartPaySuccess
{
    [self setRefreshHeader];
}
-(void)setSubscribePaySuccess
{
    [self setRefreshHeader];
}
///显示搜索实务界面
-(void)setShowSearchPractice
{
    GCDAfterBlock(1.3, ^{
        [self.searchBar becomeFirstResponder];
        
        [self setNavBarBackgroundWithAlpha:1];
    });
}
///刷新主页面顶部数据
-(void)setRefreshHeader
{
    ZWEAKSELF
    [snsV2 getHomeDataWithResultBlock:^(NSArray *arrBanner, NSArray *arrPractice, NSArray *arrLawFirm, NSArray *arrQuestion, NSArray *arrSubscribe, NSArray *arrCurriculum, NSDictionary *result) {
        [weakSelf setDicResult:result];
        [weakSelf.tvMain endRefreshHeader];
        [weakSelf.tvMain setViewDataWithBannerArray:arrBanner arrayPractice:arrPractice arrLawFirm:arrLawFirm arrQuestion:arrQuestion arrSubscribe:arrSubscribe arrCurriculum:arrCurriculum];
        
        [sqlite setLocalHomeQuestionWithArray:arrQuestion];
        [sqlite setLocalHomeBannerWithArray:arrBanner];
        NSString *userid = kLoginUserId;
        [sqlite setLocalHomeLawFirmWithArray:arrLawFirm];
        [sqlite setLocalHomePracticeWithArray:arrPractice userId:userid];
        [sqlite setLocalHomeSubscribeWithArray:arrSubscribe userId:userid];
        [sqlite setLocalHomeCurriculumWithArray:arrCurriculum userId:userid];
    } errorBlock:^(NSString *msg) {
        [weakSelf.tvMain endRefreshHeader];
    }];
}
///键盘隐藏显示通知事件
-(void)keyboardFrameChange:(CGFloat)height
{
    if (height >= kKeyboard_Min_Height) {
        CGRect searchFrame = self.searchFrame;
        searchFrame.size.height = APP_FRAME_HEIGHT-APP_TOP_HEIGHT-height;
        [self.viewSearch setViewFrame:searchFrame];
    } else {
        [self.viewSearch setViewFrame:self.searchFrame];
    }
}
///文本内容改编事件
-(void)textFieldTextDidChange:(UITextField *)textField
{
    if (textField == nil) {
        return;
    }
    NSString *content = textField.text.toTrim;
    if (content && ![content isIncludingEmoji]) {
        if (content.length > kSearchContentMaxLength) {
            [textField setText:[content substringToIndex:kSearchContentMaxLength]];
        }
        [self setSearchContentWithText:content];
    } else {
        [textField setText:[content removedEmojiString]];
    }
}
///查询关键字搜索
-(void)setSearchContentWithText:(NSString *)text
{
    if (![text isEqualToString:self.lastSearchText]) {
        [self setLastSearchText:text];
        ZWEAKSELF
        self.pageNumPractice = 1;
        [snsV2 getHomeSearchPracticeWithParam:text pageNum:self.pageNumPractice resultBlock:^(NSArray *arrResult, NSDictionary *result) {
            [weakSelf.viewSearch setViewDataPracticeWithArray:arrResult isHeader:YES];
        } errorBlock:^(NSString *msg) {
            [weakSelf.viewSearch setPracticeBackgroundFail];
        }];
        self.pageNumSubscribe = 1;
        [snsV2 getHomeSearchSubscribeWithParam:text pageNum:self.pageNumSubscribe isSeries:NO resultBlock:^(NSArray *arrResult, NSDictionary *result) {
            [weakSelf.viewSearch setViewDataSubscribeWithArray:arrResult isHeader:YES];
        } errorBlock:^(NSString *msg) {
            [weakSelf.viewSearch setSubscribeBackgroundFail];
        }];
        self.pageNumSeriesCourse = 1;
        [snsV2 getHomeSearchSubscribeWithParam:text pageNum:self.pageNumSeriesCourse isSeries:YES resultBlock:^(NSArray *arrResult, NSDictionary *result) {
            [weakSelf.viewSearch setViewDataSeriesCourseWithArray:arrResult isHeader:YES];
        } errorBlock:^(NSString *msg) {
            [weakSelf.viewSearch setSeriesCourseBackgroundFail];
        }];
    }
}
///刷新搜索实务底部数据
-(void)setRefreshPracticeFooter
{
    ZWEAKSELF
    [snsV2 getHomeSearchPracticeWithParam:self.searchBar.text.toTrim pageNum:self.pageNumPractice+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumPractice += 1;
        [weakSelf.viewSearch endRefreshPracticeFooter];
        [weakSelf.viewSearch setViewDataPracticeWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewSearch endRefreshPracticeFooter];
    }];
}
///刷新搜索订阅底部数据
-(void)setRefreshSubscribeFooter
{
    ZWEAKSELF
    [snsV2 getHomeSearchSubscribeWithParam:self.searchBar.text.toTrim pageNum:self.pageNumPractice+1 isSeries:NO resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumSubscribe += 1;
        [weakSelf.viewSearch endRefreshSubscribeFooter];
        [weakSelf.viewSearch setViewDataSubscribeWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewSearch endRefreshSubscribeFooter];
    }];
}
///刷新搜索系列课底部数据
-(void)setRefreshSeriesCourseFooter
{
    ZWEAKSELF
    [snsV2 getHomeSearchSubscribeWithParam:self.searchBar.text.toTrim pageNum:self.pageNumSeriesCourse+1 isSeries:YES resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumSeriesCourse += 1;
        [weakSelf.viewSearch endRefreshSeriesCourseFooter];
        [weakSelf.viewSearch setViewDataSeriesCourseWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewSearch endRefreshSeriesCourseFooter];
    }];
}

#pragma mark - UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self setSearchContentWithText:searchBar.text.toTrim];
    
    if (!self.isDisappear) {
        [searchBar setShowsCancelButton:YES animated:NO];
        
        self.viewSearch.hidden = NO;
        self.viewSearch.alpha = 0;
        if (self.isShowSearchView) {
            self.viewSearch.alpha = 1;
            [self setNavBarBackgroundWithAlpha:1];
            self.tvMain.hidden = YES;
            self.navigationItem.rightBarButtonItem = nil;
            return YES;
        } else {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{ 
                self.viewSearch.alpha = 1;
                [self setNavBarBackgroundWithAlpha:1];
            } completion:^(BOOL finished) {
                self.tvMain.hidden = YES;
                self.navigationItem.rightBarButtonItem = nil;
            }];
        }
    }
    [self setIsShowSearchView:YES];
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:NO];
    return YES;
}
-(void)searchBarShouldEndEditing
{
    if (!self.isDisappear) {
        self.viewSearch.hidden = NO;
        self.tvMain.hidden = NO;
        self.viewSearch.alpha = 1;
        
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            
            self.viewSearch.alpha = 0;
            [self setNavBarBackgroundWithAlpha:self.navLastAlpha];
        } completion:^(BOOL finished) {
            self.viewSearch.hidden = YES;
        }];
    }
    [self.searchBar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self setIsShowSearchView:NO];
    
    [searchBar setText:nil];
    
    [self setRightPlayButtonWithAlpha:0];
    
    [self setSearchContentWithText:kEmpty];
    
    [self setSearchPlaceholder:kSearch];
    
    [self searchBarShouldEndEditing];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

@end
