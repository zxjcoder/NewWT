//
//  ZFoundViewController.m
//  PlaneLive
//
//  Created by Daniel on 9/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZFoundViewController.h"
#import "ZFoundTableView.h"
#import "ZFoundLastPlayView.h"
#import "ZPlayerViewController.h"
#import "CFCoverFlowView.h"
#import "ZBackgroundView.h"
#import "ZLabelLine.h"

@interface ZFoundViewController () <CFCoverFlowViewDelegate>

@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbDesc;
@property (strong, nonatomic) CFCoverFlowView *viewCoverFlow;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) ZLabelLine *lbPageLeft;
@property (strong, nonatomic) ZLabelLine *lbPageRight;
//@property (strong, nonatomic) ZLabelLine *lbPageSlash;
@property (strong, nonatomic) ZBackgroundView *viewBackground;
@property (strong, nonatomic) NSArray *arrayMain;
@property (strong, nonatomic) NSString *titleText;

@end

@implementation ZFoundViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kFound];
    
    [self innerInit];
    [self registerLoginChangeNotification];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.titleText && self.titleText.length > 0) {
        NSString *timeSlot = [[NSDate date] toTimeSlot];
        [self.lbTitle setText:[NSString stringWithFormat:@"%@，%@", timeSlot, self.titleText]];
    }
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
    [self removeLoginChangeNotification];
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbPageLeft);
    OBJC_RELEASE(_lbPageRight);
    _viewCoverFlow.delegate = nil;
    OBJC_RELEASE(_viewCoverFlow);
    OBJC_RELEASE(_arrayMain);
    OBJC_RELEASE(_pageControl);
    OBJC_RELEASE(_viewBackground);
    OBJC_RELEASE(_titleText);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    CGFloat space = ( APP_FRAME_HEIGHT-300-50-APP_TOP_HEIGHT-APP_TABBAR_HEIGHT)/3;
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT+space, APP_FRAME_WIDTH, 20)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:21]];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setNumberOfLines:1];
    
    [self.view addSubview:self.lbTitle];
    
    self.lbDesc = [[ZLabel alloc] initWithFrame:CGRectMake(0, self.lbTitle.y+self.lbTitle.height+10, APP_FRAME_WIDTH, 20)];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Max_Size]];
    [self.lbDesc setTextColor:DESCCOLOR];
    [self.lbDesc setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbDesc setNumberOfLines:1];
    [self.view addSubview:self.lbDesc];
    
    CGFloat contentY = self.lbDesc.y+self.lbDesc.height+space;
    CGFloat contentH = 260;
    self.viewCoverFlow = [[CFCoverFlowView alloc] initWithFrame:CGRectMake(APP_FRAME_WIDTH/2-150, contentY, 300, contentH)];
    [self.viewCoverFlow setDelegate:self];
    self.viewCoverFlow.backgroundColor = WHITECOLOR;
    self.viewCoverFlow.pageItemWidth = kZFoundCardViewDefaultWidth;
    self.viewCoverFlow.pageItemCoverWidth = 130.0;
    self.viewCoverFlow.pageItemHeight = kZFoundCardViewDefaultHeight;
    self.viewCoverFlow.pageItemCornerRadius = 8.0;
    self.viewCoverFlow.autoAnimation = NO;
    self.viewCoverFlow.animationDuration = 6.0;
    ZWEAKSELF
    [self.viewCoverFlow setOnPracticeTypeClick:^(ModelPracticeType *model) {
        if (model.arrPractice && model.arrPractice.count > 0) {
            [StatisticsManager event:kDiscovery_Classification_List_Item];
            [weakSelf showPlayVCWithPracticeArray:model.arrPractice index:0];
        }
    }];
    [self.view addSubview:self.viewCoverFlow];
    
    //CGRect pageFrame = CGRectMake(APP_FRAME_WIDTH/2-150, self.viewCoverFlow.y+self.viewCoverFlow.height+20, 300, 20);
    //self.pageControl = [[UIPageControl alloc] initWithFrame:pageFrame];
    //[self.pageControl setCurrentPageIndicatorTintColor:MAINCOLOR];
    //[self.pageControl setPageIndicatorTintColor:RGBCOLOR(241, 241, 241)];
    //[self.view addSubview:self.pageControl];
    
    CGFloat lbW = 120;
    CGFloat slashW = 0;
    CGRect pageLeftFrame = CGRectMake(APP_FRAME_WIDTH/2-lbW-slashW/2, self.viewCoverFlow.y+self.viewCoverFlow.height+20, lbW, 22);
    self.lbPageLeft = [[ZLabelLine alloc] initWithFrame:pageLeftFrame];
    [self.lbPageLeft setNumberOfLines:1];
    [self.lbPageLeft setTextColor:MAINCOLOR];
    [self.lbPageLeft setLineAlignment:(ZLineAlignmentLeft)];
    [self.lbPageLeft setFont:[ZFont systemFontOfSize:kFont_Huge_Size]];
    [self.lbPageLeft setTextAlignment:(NSTextAlignmentRight)];
    [self.view addSubview:self.lbPageLeft];
    
    CGRect pageRightFrame = CGRectMake(APP_FRAME_WIDTH/2+slashW/2, self.viewCoverFlow.y+self.viewCoverFlow.height+20, lbW, 22);
    self.lbPageRight = [[ZLabelLine alloc] initWithFrame:pageRightFrame];
    [self.lbPageRight setNumberOfLines:1];
    [self.lbPageRight setTextColor:DESCCOLOR];
    [self.lbPageRight setLineAlignment:(ZLineAlignmentRight)];
    [self.lbPageRight setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbPageRight setTextAlignment:(NSTextAlignmentLeft)];
    [self.view addSubview:self.lbPageRight];
    
    [self setLabelMaxCount:1 index:1];
    [self.lbPageLeft setHidden:YES];
    [self.lbPageRight setHidden:YES];
    
    [self innerLocalData];
    [self innerData];
    [super innerInit];
}
-(void)innerLocalData
{
    NSDictionary *dicResult = [sqlite getLocalCacheDataWithPathKay:@"kZFoundPracticeType"];
    if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
        NSArray *arrR = [dicResult objectForKey:kResultKey];
        NSMutableArray *arrResult = [NSMutableArray array];
        if (arrR && [arrR isKindOfClass:[NSArray class]] && arrR.count > 0) {
            for (NSDictionary *dic in arrR) {
                [arrResult addObject:[[ModelPracticeType alloc] initWithCustom:dic]];
            }
        }
        [self setViewDataWithArray:arrResult];
    }
    NSDictionary *dicConfigureContentResult = [sqlite getLocalCacheDataWithPathKay:@"kZFoundConfigureContent"];
    if (dicConfigureContentResult && [dicConfigureContentResult isKindOfClass:[NSDictionary class]]) {
        NSString *title = [dicConfigureContentResult objectForKey:@"title"];
        NSString *desc = [dicConfigureContentResult objectForKey:@"desc"];
        [self setTitleText:title];
        if (title) {
            NSString *timeSlot = [[NSDate date] toTimeSlot];
            [self.lbTitle setText:[NSString stringWithFormat:@"%@，%@", timeSlot, title]];
        }
        [self.lbDesc setText:desc];
    }
}
-(void)innerData
{
    ZWEAKSELF
    [snsV2 getFoundConfigureContentWithResultBlock:^(NSString *title, NSString *desc) {
        
        [weakSelf setTitleText:title];
        if (title) {
            NSString *timeSlot = [[NSDate date] toTimeSlot];
            [weakSelf.lbTitle setText:[NSString stringWithFormat:@"%@，%@", timeSlot, title]];
        }
        [weakSelf.lbDesc setText:desc];
        if (title && desc) {
            [sqlite setLocalCacheDataWithDictionary:@{@"title":title, @"desc": desc} pathKay:@"kZFoundConfigureContent"];
        }
    } errorBlock:^(NSString *msg) {
        
    }];
    [snsV2 getFoundPracticeTypeWithResultBlock:^(NSArray *arrResult, NSDictionary *result) {
        
        [weakSelf setViewDataWithArray:arrResult];
        [sqlite setLocalCacheDataWithDictionary:result pathKay:@"kZFoundPracticeType"];
    } errorBlock:^(NSString *msg) {
        
    }];
}
-(void)setLabelMaxCount:(int)maxCount index:(int)index
{
    if (self.lbPageLeft && self.lbPageRight) {
        [self.lbPageLeft setHidden:maxCount == 0];
        [self.lbPageRight setHidden:maxCount == 0];
        if (maxCount > 0) {
            NSString *strIndex = [NSString stringWithFormat:@"%d", index];
            [self.lbPageLeft setText:strIndex];
            NSString *strMax = [NSString stringWithFormat:@"／%d", maxCount];
            [self.lbPageRight setText:strMax];
        } else {
            [self.lbPageLeft setText:kEmpty];
            [self.lbPageRight setText:kEmpty];
        }
    }
}
-(void)setLoginChange
{
    [self innerData];
}
-(void)setShowBackgroundView
{
    if (!self.viewBackground) {
        [self.viewBackground removeFromSuperview];
    }
    self.viewBackground = [[ZBackgroundView alloc] initWithFrame:CGRectMake(APP_FRAME_WIDTH/2-150, self.viewCoverFlow.y, 320, 300)];
    [self.viewBackground setViewStateWithState:(ZBackgroundStateNull)];
    ZWEAKSELF
    [self.viewBackground setOnButtonClick:^{
        [weakSelf.viewBackground setViewStateWithState:(ZBackgroundStateLoading)];
        [weakSelf innerData];
    }];
    [self.view addSubview:self.viewBackground];
}
-(void)setViewDataWithArray:(NSArray *)arrResult
{
    NSMutableArray *arrR = [NSMutableArray array];
    switch (arrResult.count) {
        case 1:
        {
            [arrR addObjectsFromArray:arrResult];
            [arrR addObjectsFromArray:arrResult];
            [arrR addObjectsFromArray:arrResult];
            [arrR addObjectsFromArray:arrResult];
            break;
        }
        case 2:
        {
            [arrR addObjectsFromArray:arrResult];
            [arrR addObjectsFromArray:arrResult];
        }
        case 3:
        {
            [arrR addObjectsFromArray:arrResult];
            [arrR addObject:[arrResult firstObject]];
            break;
        }
        default:
            [arrR addObjectsFromArray:arrResult];
            break;
    }
    [self setArrayMain:arrR];
    [self setLabelMaxCount:arrR.count index:1];
    if (arrR.count > 0) {
        if (!self.viewBackground) {
            [self.viewBackground removeFromSuperview];
        }
        [self.viewCoverFlow setHidden:NO];
        [self.viewCoverFlow setCoverFlowViewDataWithArray:arrR];
    } else {
        [self.viewCoverFlow setHidden:YES];
        [self setShowBackgroundView];
    }
    [self.pageControl setHidden:arrResult.count==0];
    //[self.pageControl setHidden:arrResult.count<4];
    [self.pageControl setNumberOfPages:arrResult.count];
}

#pragma mark - CFCoverFlowViewDelegate

- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didScrollPageItemToIndex:(NSInteger)index
{
    [self setLabelMaxCount:self.arrayMain.count index:index+1];
    //self.pageControl.currentPage = index;
}
- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didSelectPageItemAtIndex:(NSInteger)index
{
    
}

@end
