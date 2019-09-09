//
//  ZSearchViewController.m
//  PlaneLive
//
//  Created by Daniel on 21/09/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZSearchViewController.h"
#import "ZHomeSearchView.h"
#import "ZNewSearchHistoryView.h"
#import "ZSubscribeDetailViewController.h"
#import "ZSubscribeAlreadyHasViewController.h"
#import "ZNavigationTitleView.h"
#import "ZSearchBar.h"

@interface ZSearchViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) ZHomeSearchView *viewSearch;
@property (strong, nonatomic) ZNewSearchHistoryView *viewSearchHistory;
@property (assign, nonatomic) CGRect viewFrame;

@property (strong, nonatomic) ZSearchBar *searchBar;
@property (weak, nonatomic) UITextField *textField;
@property (strong, nonatomic) ZButton *btnCancel;
@property (strong, nonatomic) NSString *searchText;

@property (assign, nonatomic) int pageNumPractice;
@property (assign, nonatomic) int pageNumSubscribe;
@property (assign, nonatomic) int pageNumSeriesCourse;

@property (strong, nonatomic) NSMutableArray *arrayHistory;

@end

@implementation ZSearchViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self innerInit];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.searchText.length == 0) {
        [self.searchBar becomeFirstResponder];
    }
    [StatisticsManager eventIOBeginPageWithName:kZhugeIOPageHomeKey];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.searchText.length == 0) {
        [self.searchBar resignFirstResponder];
    }
    [StatisticsManager eventIOEndPageWithName:kZhugeIOPageHomeKey dictionary:nil];
}
#pragma mark - PrivateMethod
#define kSearchHotKeywordKey @"SearchHotKeywordKey"
#define kSearchHistoryKeywordKey @"SearchHistoryKeywordKey"
-(void)innerInit
{
    self.arrayHistory = [NSMutableArray array];
    
    ZNavigationTitleView *viewTitle = [[ZNavigationTitleView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH-20, APP_NAVIGATION_HEIGHT)];
    [viewTitle setBackgroundColor:CLEARCOLOR];
    
    self.searchBar = [[ZSearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = kSearchPracticeSubscribe;
    self.searchBar.showsCancelButton = false;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    [self.searchBar setImage:[SkinManager getImageWithName:@"clear"] forSearchBarIcon:(UISearchBarIconClear) state:(UIControlStateNormal)];
    [self.searchBar setImage:[SkinManager getImageWithName:@"clear"] forSearchBarIcon:(UISearchBarIconClear) state:(UIControlStateHighlighted)];
    [self.searchBar sizeToFit];
    [self setSearchTextFiled];
    [viewTitle addSubview:self.searchBar];
    
    self.btnCancel = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel setTitle:kCancel forState:(UIControlStateNormal)];
    [self.btnCancel setTitle:kCancel forState:(UIControlStateHighlighted)];
    [self.btnCancel setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [self.btnCancel setTitleColor:COLORTEXT3 forState:(UIControlStateHighlighted)];
    [[self.btnCancel titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnCancel setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
    [self.btnCancel setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [viewTitle  addSubview:self.btnCancel];
    
    self.navigationItem.titleView = viewTitle;
    CGFloat btnW = 45;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.hidesSearchBarWhenScrolling = false;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        [self.searchBar setFrame:CGRectMake(0, 0, viewTitle.width-btnW+5, viewTitle.height)];
        [self.btnCancel setFrame:(CGRectMake(self.searchBar.x+self.searchBar.width-5, 0, btnW, 44))];
        
        self.searchBar.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.searchBar safeAreaInsetsDidChange];
        [viewTitle safeAreaInsetsDidChange];
    } else {
        [self.searchBar setFrame:CGRectMake(10, 0, viewTitle.width-btnW-20, viewTitle.height)];
        [self.btnCancel setFrame:(CGRectMake(self.searchBar.x+self.searchBar.width+10, 0, btnW, 44))];
    }
    //[viewTitle setBackgroundColor:COLORCONTENT4];
    //[self.btnCancel setBackgroundColor:COLORCONTENT3];
    ZWEAKSELF
    self.viewSearchHistory = [[ZNewSearchHistoryView alloc] initWithFrame:VIEW_ITEM_FRAME];
    [self.viewSearchHistory setOnContentOffsetChange:^(CGFloat contentOffsetY) {
        [weakSelf.view endEditing:true];
    }];
    [self.viewSearchHistory setOnKeywordClick:^(NSString *keyword) {
        
        [weakSelf.searchBar setText:keyword];
        [weakSelf setStartSearch:keyword];
        
        [weakSelf.viewSearchHistory setViewHistoryData:weakSelf.arrayHistory];
    }];
    [self.viewSearchHistory setOnDelegateClick:^{
        [weakSelf.arrayHistory removeAllObjects];
        [sqlite setLocalCacheDataWithDictionary:[NSDictionary dictionaryWithObject:weakSelf.arrayHistory forKey:kSearchHistoryKeywordKey] pathKay:kSearchHistoryKeywordKey];
        [weakSelf.viewSearchHistory setViewHistoryData:weakSelf.arrayHistory];
    }];
    [self.view addSubview:self.viewSearchHistory];
    
    self.viewFrame = VIEW_ITEM_FRAME;
    self.viewSearch = [[ZHomeSearchView alloc] initWithFrame:(self.viewFrame)];
    [self.viewSearch setHidden:true];
    [self.viewSearch setOnContentOffsetChange:^(CGFloat contentOffsetY) {
        [weakSelf.view endEditing:true];
    }];
    [self.viewSearch setOnPracticeBackgroundClick:^{
        [weakSelf setReloadPracticeHeader];
    }];
    [self.viewSearch setOnPracticeClick:^(NSArray *array, NSInteger row) {
       
        [weakSelf.searchBar resignFirstResponder];
        [weakSelf showPlayVCWithPracticeArray:array index:row];
    }];
    [self.viewSearch setOnPracticeRefreshFooter:^{
        [weakSelf setReloadPracticeFooter];
    }];
    
    [self.viewSearch setOnSubscribeBackgroundClick:^{
        [weakSelf setReloadSubscribeHeader];
    }];
    [self.viewSearch setOnSubscribeClick:^(ModelSubscribe *model) {
        [weakSelf showSubscribeDetailVCWithModel:model];
    }];
    [self.viewSearch setOnSubscribeRefreshFooter:^{
        [weakSelf setReloadSubscribeFooter];
    }];
    
    [self.viewSearch setOnSeriesCourseBackgroundClick:^{
        [weakSelf setReloadSeriesCourseHeader];
    }];
    [self.viewSearch setOnSeriesCourseClick:^(ModelSubscribe *model) {
       [weakSelf showSubscribeDetailVCWithModel:model];
    }];
    [self.viewSearch setOnSeriesCourseRefreshFooter:^{
        [weakSelf setReloadSeriesCourseFooter];
    }];
    [self.view addSubview:self.viewSearch];
    [self.view sendSubviewToBack:self.viewSearchHistory];
    [super innerInit];
    
    [self setReloadHistoryKeyword];
    [self setLocalReloadHotKeyword];
}
///设置搜索区域
-(void)setSearchTextFiled
{
    for (UIView *view in self.searchBar.subviews) {
        if (view.subviews.count > 0) {
            for (UIView *item in view.subviews) {
                GBLog(@"SearchSubviews: %@", item);
                if ([item isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                    self.textField = (UITextField *)item;
                }
                if ([item isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    [item removeFromSuperview];
                }
                if ([item isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                    [item removeFromSuperview];
                    //[[(UIButton *)item titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
                    //[(UIButton *)item setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
                    //[(UIButton *)item setTitleColor:COLORTEXT3 forState:(UIControlStateHighlighted)];
                    //[(UIButton *)item setTitleColor:COLORTEXT3 forState:(UIControlStateSelected)];
                }
            }
        }
    }
    if (self.textField) {
        [self.textField setBackgroundColor:COLORVIEWBACKCOLOR2];
        [self.textField setTextColor:COLORTEXT2];
        [self.textField setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [[self.textField layer] setMasksToBounds:YES];
        
        UIImageView *imageSearch = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 24, 24)];
        [imageSearch setImage:[SkinManager getImageWithName:@"search"]];
        [self.textField setLeftView:imageSearch];

        if (@available(iOS 11.0, *)) {
            [self.textField setViewRound:20 borderWidth:0 borderColor:CLEARCOLOR];
        } else {
            [self.textField setViewRound:14 borderWidth:0 borderColor:CLEARCOLOR];
        }
    }
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
/// 加载本地热门数据
-(void)setLocalReloadHotKeyword
{
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:kSearchHotKeywordKey];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSArray *arrR = [dicLocal objectForKey:kResultKey];
        NSMutableArray *arrResult = [NSMutableArray array];
        if (arrR && [arrR isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in arrR) {
                NSString *title = [dic objectForKey:@"title"];
                if (title && [title isKindOfClass:[NSString class]]) {
                    [arrResult addObject:title];
                }
            }
        }
        [self.viewSearchHistory setViewHotData:arrResult];
    }
    [self setReloadHotKeyword];
}
/// 获取热门记录
-(void)setReloadHotKeyword
{
    ZWEAKSELF
    [snsV2 getV6HotSearchWithResultBlock:^(NSArray *array, NSDictionary *result) {
        [weakSelf.viewSearchHistory setViewHotData:array];
        [sqlite setLocalCacheDataWithDictionary:result pathKay:kSearchHotKeywordKey];
    } errorBlock:^(NSString *msg) {
        [ZProgressHUD showError:msg];
    }];
}
/// 加载历史数据
-(void)setReloadHistoryKeyword
{
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:kSearchHistoryKeywordKey];
    [self.arrayHistory removeAllObjects];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        [self.arrayHistory addObjectsFromArray:[dicLocal objectForKey:kSearchHistoryKeywordKey]];
    }
    [self.viewSearchHistory setViewHistoryData:self.arrayHistory];
}
/// 搜索微课顶部
-(void)setReloadPracticeHeader
{
    [self.viewSearch setPracticeBackgroundLoading];
    ZWEAKSELF
    [snsV2 getHomeSearchPracticeWithParam:self.searchText.toTrim pageNum:1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumPractice = 1;
        [weakSelf.viewSearch setViewDataPracticeWithArray:arrResult isHeader:YES];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewSearch setPracticeBackgroundFail];
    }];
}
/// 搜索微课底部
-(void)setReloadPracticeFooter
{
    ZWEAKSELF
    [snsV2 getHomeSearchPracticeWithParam:self.searchText.toTrim pageNum:self.pageNumPractice+1 resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumPractice += 1;
        [weakSelf.viewSearch endRefreshPracticeFooter];
        [weakSelf.viewSearch setViewDataPracticeWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewSearch endRefreshPracticeFooter];
    }];
}
/// 搜索订阅顶部
-(void)setReloadSubscribeHeader
{
    [self.viewSearch setSubscribeBackgroundLoading];
    ZWEAKSELF
    [snsV2 getHomeSearchSubscribeWithParam:self.searchText.toTrim pageNum:1 isSeries:NO resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumSubscribe = 1;
        [weakSelf.viewSearch setViewDataSubscribeWithArray:arrResult isHeader:YES];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewSearch setSubscribeBackgroundFail];
    }];
}
/// 搜索订阅底部
-(void)setReloadSubscribeFooter
{
    ZWEAKSELF
    [snsV2 getHomeSearchSubscribeWithParam:self.searchText.toTrim pageNum:self.pageNumPractice+1 isSeries:NO resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumSubscribe += 1;
        [weakSelf.viewSearch endRefreshSubscribeFooter];
        [weakSelf.viewSearch setViewDataSubscribeWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewSearch endRefreshSubscribeFooter];
    }];
}
/// 搜索系列课顶部
-(void)setReloadSeriesCourseHeader
{
    [self.viewSearch setSeriesCourseBackgroundLoading];
    ZWEAKSELF
    [snsV2 getHomeSearchSubscribeWithParam:self.searchText.toTrim pageNum:1 isSeries:YES resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumSeriesCourse = 1;
        [weakSelf.viewSearch setViewDataSeriesCourseWithArray:arrResult isHeader:YES];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewSearch setSeriesCourseBackgroundFail];
    }];
}
/// 搜索系列课底部
-(void)setReloadSeriesCourseFooter
{
    ZWEAKSELF
    [snsV2 getHomeSearchSubscribeWithParam:self.searchText.toTrim pageNum:self.pageNumSeriesCourse+1 isSeries:YES resultBlock:^(NSArray *arrResult, NSDictionary *result) {
        weakSelf.pageNumSeriesCourse += 1;
        [weakSelf.viewSearch endRefreshSeriesCourseFooter];
        [weakSelf.viewSearch setViewDataSeriesCourseWithArray:arrResult isHeader:NO];
    } errorBlock:^(NSString *msg) {
        [weakSelf.viewSearch endRefreshSeriesCourseFooter];
    }];
}
/// 搜索内容改变
-(void)setSearchContent:(NSString *)text
{
    [self.view endEditing:true];
    [self.viewSearch setHidden:text.length==0];
    [self setSearchText: text];
    if (self.searchText.length > 0) {
        [self setReloadPracticeHeader];
        [self setReloadSubscribeHeader];
        [self setReloadSeriesCourseHeader];
    }
}
-(void)setStartSearch:(NSString *)text
{
    NSString *content = text.toTrim;
    if (content.length > 0) {
        [self.arrayHistory removeObject:content];
        [self.arrayHistory insertObject:content atIndex:0];
        [self.viewSearchHistory setViewHistoryData:self.arrayHistory];
        [sqlite setLocalCacheDataWithDictionary:[NSDictionary dictionaryWithObject:self.arrayHistory forKey:kSearchHistoryKeywordKey] pathKay:kSearchHistoryKeywordKey];
    } else {
        self.searchBar.text = kEmpty;
    }
    [self setSearchContent:content];
}
-(void)btnCancelClick
{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self setStartSearch:searchBar.text];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:true];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    GBLog(@"文本输入框 text: %@,  rangelength: %d, rangelocation: %d, string: %@", searchBar.text, range.length, range.location, text);
    if (text.length == 0) {
        NSString *comcatstr = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
        if (comcatstr.length > kSearchContentMaxLength) {
            return false;
        }
    } else {
        if ([[searchBar.textInputMode primaryLanguage] isEqualToString:@"emoji"]) {
            return false;
        }
        NSString *content = [searchBar.text stringByAppendingString:text];
        if (content.length > kSearchContentMaxLength) {
            return false;
        }
    }
    return true;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [self setStartSearch:searchText];
    }
}

@end
