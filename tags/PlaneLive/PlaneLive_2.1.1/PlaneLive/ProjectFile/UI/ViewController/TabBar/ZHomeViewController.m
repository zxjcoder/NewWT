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

@end

@implementation ZHomeViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self innerInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppDidBecomeActive:) name:ZApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCartPaySuccess) name:ZCartPaySuccessNotification object:nil];
    
    [self registerLoginChangeNotification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isShowSearchView) {
        [self setNavBarBackgroundWithAlpha:self.navLastAlpha];
    } else {
        [self.searchBar becomeFirstResponder];
    }
    
    [self setNavigationTintColor];
    
    [self registerKeyboardNotification];
    
    [self registerTextFieldTextDidChangeNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
    
    [self removeTextFieldTextDidChangeNotification];
    
    [self.searchBar resignFirstResponder];
}
-(void)dealloc
{
    [self setViewNil];
}
-(void)setViewNil
{
    [self removeLoginChangeNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZApplicationDidBecomeActiveNotification object:nil];
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
        [StatisticsManager event:kHomepage_Banner];
        switch (model.type) {
            case ZBannerTypePractice://实务
            {
                ModelPractice *modelP = [sqlite getLocalPracticeModelWithId:model.code];
                if (modelP) {
                    [weakSelf showPlayVCWithPracticeArray:@[modelP] index:0];
                } else {
                    [ZProgressHUD showMessage:kGetPracticeing];
                    [snsV1 getQuerySpeechDetailWithSpeechId:model.code userId:[AppSetting getUserDetauleId] resultBlock:^(NSDictionary *result) {
                        GCDMainBlock(^{
                            [ZProgressHUD dismiss];
                            
                            NSDictionary *dicReuslt = [result objectForKey:kResultKey];
                            if (dicReuslt && [dicReuslt isKindOfClass:[NSDictionary class]]) {
                                ModelPractice *modelPractice = [[ModelPractice alloc] initWithCustom:dicReuslt];
                                
                                [sqlite setLocalPracticeWithModel:modelPractice];
                                
                                [weakSelf showPlayVCWithPracticeArray:@[modelPractice] index:0];
                            } else {
                                [ZProgressHUD showError:kGetPracticeInfoFail];
                            }
                        });
                    } errorBlock:^(NSString *msg) {
                        GCDMainBlock(^{
                            [ZProgressHUD dismiss];
                            [ZProgressHUD showError:msg];
                        });
                    }];
                }
                break;
            }
            case ZBannerTypeNews://新闻
            {
                [weakSelf showWebVCWithUrl:model.url title:model.title];
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
                ModelSubscribeDetail *modelSD = [sqlite getLocalSubscribeDetailWithUserId:[AppSetting getUserDetauleId] subscribeId:model.code];
                if (modelSD && modelSD.ids) {
                    [weakSelf showSubscribeDetailVCWithModel:modelSD];
                } else {
                    [ZProgressHUD showMessage:kGetSubscriptioning];
                    [snsV2 getSubscribeRecommendArrayWithSubscribeId:model.code resultBlock:^(ModelSubscribeDetail *model, NSDictionary *result) {
                        [ZProgressHUD dismiss];
                        if (model) {
                            [weakSelf showSubscribeDetailVCWithModel:model];
                            
                            [sqlite setLocalSubscribeDetailWithModel:model userId:[AppSetting getUserDetauleId]];
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
        
        [weakSelf setNavigationTintColor];
    }];
    ///实务全部按钮
    [self.tvMain setOnAllPracticeClick:^{
        [StatisticsManager event:kHomepage_Practice_All];
        ZPracticeTypeViewController *itemVC = [[ZPracticeTypeViewController alloc] init];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///实务单个点击事件
    [self.tvMain setOnPracticeClick:^(NSArray *array, NSInteger row) {
        if (array.count > 0 && row < array.count) {
            ModelPractice *modelP = [array objectAtIndex:row];
            if (modelP) {
                [StatisticsManager event:kHomepage_Practice_List_Item dictionary:@{kObjectId:modelP.ids==nil?kEmpty:modelP.ids,kObjectTitle:modelP.title==nil?kEmpty:modelP.title}];
            }
        }
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    ///精品问答点击事件
    [self.tvMain setOnQuestionClick:^(ModelQuestionBoutique *model) {
        [StatisticsManager event:kHomepage_BoutiqueQusetion];
        ZQuestionBoutiqueViewController *itemVC = [[ZQuestionBoutiqueViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///订阅单个点击事件
    [self.tvMain setOnSubscribeClick:^(ModelSubscribe *model) {
        [StatisticsManager event:kHomepage_Subscription_List_Item dictionary:@{kObjectId:model.ids==nil?kEmpty:model.ids,kObjectTitle:model.title==nil?kEmpty:model.title}];
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
    ///刷新顶部按钮
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.view addSubview:self.tvMain];
    
    [self setSearchView];
    
    [super innerInit];
    
    [self setNavBarAlpha:0];
    
    [self innerData];
}
///设置导航栏颜色
-(void)setNavigationTintColor
{
    
}
///设置搜索内容区域
-(void)setSearchView
{
    ZWEAKSELF
    ///搜索内容视图
    self.searchFrame = CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-APP_TABBAR_HEIGHT);
    self.viewSearch = [[ZHomeSearchView alloc] initWithFrame:self.searchFrame];
    [self.viewSearch setOnContentOffsetChange:^(CGFloat contentOffsetY) {
        [weakSelf.searchBar resignFirstResponder];
    }];
    [self.viewSearch setOnPracticeClick:^(NSArray *array, NSInteger row) {
        if (array.count > 0 && row < array.count) {
            ModelPractice *modelP = [array objectAtIndex:row];
            if (modelP) {
                [StatisticsManager event:kHomepage_Search_Practice_List_Item dictionary:@{kObjectId:modelP.ids==nil?kEmpty:modelP.ids,kObjectTitle:modelP.title==nil?kEmpty:modelP.title}];
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
        [StatisticsManager event:kHomepage_Search_Subscription_List_Item dictionary:@{kObjectId:model.ids==nil?kEmpty:model.ids,kObjectTitle:model.title==nil?kEmpty:model.title}];
        [weakSelf showSubscribeDetailVCWithModel:model];
    }];
    [self.viewSearch setOnSubscribeRefreshFooter:^{
        [snsV2 getHomeSearchSubscribeWithParam:weakSelf.lastSearchText pageNum:weakSelf.pageNumSubscribe+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
            
            weakSelf.pageNumSubscribe += 1;
            [weakSelf.viewSearch endRefreshSubscribeFooter];
            [weakSelf.viewSearch setViewDataSubscribeWithArray:arrResult isHeader:NO];
        } errorBlock:^(NSString *msg) {
            [weakSelf.viewSearch endRefreshSubscribeFooter];
        }];
    }];
    [self.viewSearch setHidden:YES];
    [self.view addSubview:self.viewSearch];
}
-(void)setAppDidBecomeActive:(NSNotification *)sender
{
    [self.tvMain setAnimateQuestion];
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
            [self setSearchPlaceholder:kSearchPracticeSubscribe];
        } else {
            [self setSearchPlaceholder:kSearch];
        }
    }
    if (self.navigationItem.rightBarButtonItem.customView) {
        ///设置播放按钮状态
        [self.navigationItem.rightBarButtonItem.customView viewWithTag:1000100010].hidden = alpha==1;
        if (alpha <= 0) {
            [self.navigationItem.rightBarButtonItem.customView viewWithTag:1000100010].alpha = 1;
        } else {
            [self.navigationItem.rightBarButtonItem.customView viewWithTag:1000100010].alpha = 1-alpha;
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
        NSArray *arrPractice = [sqlite getLocalHomePracticeArrayWithUserId:[AppSetting getUserDetauleId]];
        NSArray *arrQuestion = [sqlite getLocalHomeQuestionArrayWithAll];
        NSArray *arrSubscribe = [sqlite getLocalHomeSubscribeArrayWithUserId:[AppSetting getUserDetauleId]];
        
        [self.tvMain setViewDataWithBannerArray:arrLocalBanner arrayPractice:arrPractice arrQuestion:arrQuestion arrSubscribe:arrSubscribe];
    } else {
        [self.tvMain setViewLoading];
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
    [snsV2 getHomeDataWithResultBlock:^(NSArray *arrBanner, NSArray *arrPractice, NSArray *arrQuestion, NSArray *arrSubscribe, NSDictionary *result) {
        
        [weakSelf.tvMain endRefreshHeader];
        
        [weakSelf.tvMain setViewDataWithBannerArray:arrBanner arrayPractice:arrPractice arrQuestion:arrQuestion arrSubscribe:arrSubscribe];
        
        [sqlite setLocalHomeQuestionWithArray:arrQuestion];
        [sqlite setLocalHomeBannerWithArray:arrBanner];
        [sqlite setLocalHomePracticeWithArray:arrPractice userId:[AppSetting getUserDetauleId]];
        [sqlite setLocalHomeSubscribeWithArray:arrSubscribe userId:[AppSetting getUserDetauleId]];
    } errorBlock:^(NSString *msg) {
        
        [weakSelf.tvMain endRefreshHeader];
        
        [weakSelf.tvMain setViewLoadFail];
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
    NSString *content = textField.text.toTrim;
    if (![content isIncludingEmoji]) {
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
        [snsV2 getHomeSearchSubscribeWithParam:text pageNum:self.pageNumSubscribe resultBlock:^(NSArray *arrResult, NSDictionary *result) {
            
            [weakSelf.viewSearch setViewDataSubscribeWithArray:arrResult isHeader:YES];
        } errorBlock:^(NSString *msg) {
            
            [weakSelf.viewSearch setSubscribeBackgroundFail];
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
    [snsV2 getHomeSearchSubscribeWithParam:self.searchBar.text.toTrim pageNum:self.pageNumSubscribe+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        weakSelf.pageNumSubscribe += 1;
        [weakSelf.viewSearch endRefreshSubscribeFooter];
        [weakSelf.viewSearch setViewDataSubscribeWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        
        [weakSelf.viewSearch endRefreshSubscribeFooter];
    }];
}

#pragma mark - UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self setIsShowSearchView:YES];
    
    [self setSearchContentWithText:searchBar.text.toTrim];
    
    if (!self.isDisappear) {
        [searchBar setShowsCancelButton:YES animated:NO];
        
        self.viewSearch.hidden = NO;
        self.viewSearch.alpha = 0;
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            
            self.viewSearch.alpha = 1;
            [self setNavBarBackgroundWithAlpha:1];
        } completion:^(BOOL finished) {
            self.tvMain.hidden = YES;
            self.navigationItem.rightBarButtonItem = nil;
        }];
    }
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
