//
//  ZFoundViewController.m
//  PlaneLive
//
//  Created by Daniel on 9/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZFoundViewController.h"
#import "ZPlayerViewController.h"
#import "ZFoundCardFlowView.h"
#import "ZLabelLine.h"

@interface ZFoundViewController ()

@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbDesc;
@property (strong, nonatomic) ZFoundCardFlowView *viewCoverFlow;
@property (strong, nonatomic) ZLabel *lbPageSlash;

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
    
    [self setRightButtonWithSearch];
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
    OBJC_RELEASE(_viewCoverFlow);
    OBJC_RELEASE(_arrayMain);
    OBJC_RELEASE(_lbPageSlash);
    OBJC_RELEASE(_titleText);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    [self.view setBackgroundColor:COLORVIEWBACKCOLOR3];
    
    CGFloat space = 20*kViewSace;
    CGFloat titleY = space;
    CGFloat titleH = 25;
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT+titleY, APP_FRAME_WIDTH, titleH)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:24]];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setBackgroundColor:self.view.backgroundColor];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setNumberOfLines:1];
    [self.view addSubview:self.lbTitle];
    CGFloat descY = self.lbTitle.y+self.lbTitle.height+space;
    self.lbDesc = [[ZLabel alloc] initWithFrame:CGRectMake(0, descY, APP_FRAME_WIDTH, 20)];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setTextColor:COLORTEXT3];
    [self.lbDesc setBackgroundColor:self.view.backgroundColor];
    [self.lbDesc setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbDesc setNumberOfLines:1];
    [self.view addSubview:self.lbDesc];
    
    CGFloat contentY = self.lbDesc.y+self.lbDesc.height+space;
    CGFloat contentH = [ZFoundCardItemView getH];
    CGFloat contentW = APP_FRAME_WIDTH-space*2;
    self.viewCoverFlow = [[ZFoundCardFlowView alloc] initWithFrame:(CGRectMake(space, contentY, contentW, contentH))];
    ZWEAKSELF
    [self.viewCoverFlow setOnStartPlayEvent:^(ModelPracticeType *model) {
        if (model.arrPractice && model.arrPractice.count > 0) {
            [StatisticsManager event:kDiscovery_Classification_List_Item];
            [weakSelf showPlayVCWithPracticeArray:model.arrPractice index:0];
        }
    }];
    [self.viewCoverFlow setOnIndexChange:^(int maxCount, int index) {
        [weakSelf setLabelMaxCount:maxCount index:index];
    }];
    [self.viewCoverFlow setBackgroundColor:self.view.backgroundColor];
    [self.view addSubview:self.viewCoverFlow];
    
    CGFloat lbPageW = 120;
    CGFloat lbPageX = self.view.width/2-lbPageW/2;
    CGFloat lbPageY = self.viewCoverFlow.y+self.viewCoverFlow.height+15*kViewSace;
    self.lbPageSlash = [[ZLabel alloc] initWithFrame:(CGRectMake(lbPageX, lbPageY, lbPageW, 22))];
    [self.lbPageSlash setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbPageSlash setBackgroundColor:self.view.backgroundColor];
    [self.view addSubview:self.lbPageSlash];
    
    [self innerLocalData];
    [super innerInit];
}
-(void)innerLocalData
{
    [self setLabelMaxCount:0 index:1];
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
    [self innerData];
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
    if (maxCount <= 0) {
        [self.lbPageSlash setText:@"1 /1"];
        [self.lbPageSlash setTextColor:COLORTEXT3];
        [self.lbPageSlash setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbPageSlash setLabelFontWithRange:(NSMakeRange(0, 1)) font:[ZFont boldSystemFontOfSize:kFont_Default_Size] color:COLORTEXT2];
    } else {
        NSString *strMax = [NSString stringWithFormat:@"/%d", maxCount];
        [self.lbPageSlash setText:[NSString stringWithFormat:@"%d %@", index, strMax]];
        [self.lbPageSlash setTextColor:COLORTEXT2];
        [self.lbPageSlash setFont:[ZFont boldSystemFontOfSize:kFont_Default_Size]];
        [self.lbPageSlash setLabelFontWithRange:(NSMakeRange(self.lbPageSlash.text.length-strMax.length, strMax.length)) font:[ZFont systemFontOfSize:kFont_Min_Size] color:COLORTEXT3];
    }
}
-(void)setLoginChange
{
    [self innerData];
}
-(void)setViewDataWithArray:(NSArray *)arrResult
{
    [self setLabelMaxCount:arrResult.count index:1];
    [self.viewCoverFlow setViewData:arrResult];
}

@end
