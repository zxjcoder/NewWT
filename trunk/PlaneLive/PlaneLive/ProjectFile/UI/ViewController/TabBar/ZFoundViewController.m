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
@property (strong, nonatomic) ZLabel *lbContent;
@property (strong, nonatomic) ZLabel *lbDesc;
@property (strong, nonatomic) ZFoundCardFlowView *viewCoverFlow;
@property (strong, nonatomic) ZLabel *lbPageSlash;

@property (strong, nonatomic) NSArray *arrayMain;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) ZButton *btnSearch;

@end

@implementation ZFoundViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self setTitle:kFound];
    
    [self innerInit];
    [self registerLoginChangeNotification];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self setRightButtonWithSearch];
    if (self.titleText && self.titleText.length > 0) {
        NSString *timeSlot = [[NSDate date] toTimeSlot];
        [self.lbContent setText:[NSString stringWithFormat:@"%@! %@", timeSlot, self.titleText]];
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
    
    CGFloat space = 20;
    CGFloat titleY = space;
    CGFloat titleH = 25;
    CGFloat labelWidth = APP_FRAME_WIDTH-space*2;
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(space, 50, labelWidth, 37)];
    [self.lbTitle setFont:[ZFont boldSystemFontOfSize:24]];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setText:kFound];
    [self.lbTitle setUserInteractionEnabled:false];
    [self.view addSubview:self.lbTitle];
    if (IsIPhone4 || IsIPhone5) {
        self.lbTitle.frame = CGRectMake(space, 25, labelWidth, 37);
        
        [self setRightButtonWithSearch];
    } else {
        CGFloat btnSize = 45;
        self.btnSearch = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnSearch setImageEdgeInsets:(UIEdgeInsetsMake(4, 4, 4, 4))];
        [self.btnSearch setFrame:(CGRectMake(APP_FRAME_WIDTH-10-btnSize, 50, btnSize, btnSize))];
        [self.btnSearch setImage:[SkinManager getImageWithName:@"search"] forState:(UIControlStateNormal)];
        [self.btnSearch setImage:[SkinManager getImageWithName:@"search"] forState:(UIControlStateHighlighted)];
        [self.btnSearch addTarget:self action:@selector(btnSearchClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:self.btnSearch];
    }
    CGFloat lbContentY = self.lbTitle.y+self.lbTitle.height+12;
    self.lbContent = [[ZLabel alloc] initWithFrame:CGRectMake(space, lbContentY, labelWidth, 26)];
    [self.lbContent setFont:[ZFont systemFontOfSize:20]];
    [self.lbContent setTextColor:COLORTEXT1];
    [self.lbContent setNumberOfLines:1];
    [self.view addSubview:self.lbContent];
    
    CGFloat descY = self.lbContent.y+self.lbContent.height+4;
    self.lbDesc = [[ZLabel alloc] initWithFrame:CGRectMake(space, descY, labelWidth, 20)];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setTextColor:COLORTEXT3];
    [self.lbDesc setNumberOfLines:1];
    [self.view addSubview:self.lbDesc];
    
    CGFloat lbPageSlashHeight = 25;
    CGFloat contentH = [ZFoundCardItemView getH];
    CGFloat contentW = APP_FRAME_WIDTH-space*2;
    CGFloat contentY = self.lbDesc.y+self.lbDesc.height;
    if ([[UIScreen mainScreen] bounds].size.height > 568) {
        CGFloat yspace = APP_FRAME_HEIGHT-contentY-contentH-APP_TABBAR_HEIGHT-[ZGlobalPlayView getMinH]-lbPageSlashHeight;
        contentY = contentY+yspace/2;
    } else {
        contentY = contentY+24;
    }
    self.viewCoverFlow = [[ZFoundCardFlowView alloc] initWithFrame:(CGRectMake(space, contentY, contentW, contentH))];
    ZWEAKSELF
    [self.viewCoverFlow setOnStartPlayEvent:^(ModelPracticeType *model) {
        [weakSelf setStartPlayer:model];
    }];
    [self.viewCoverFlow setOnIndexChange:^(int maxCount, int index) {
        [weakSelf setLabelMaxCount:maxCount index:index];
    }];
    [self.viewCoverFlow setBackgroundColor:self.view.backgroundColor];
    [self.view addSubview:self.viewCoverFlow];
    
    CGFloat lbPageW = 120;
    CGFloat lbPageX = self.view.width/2-lbPageW/2;
    CGFloat lbPageY = self.viewCoverFlow.y+self.viewCoverFlow.height+15*kViewSace;
    self.lbPageSlash = [[ZLabel alloc] initWithFrame:(CGRectMake(lbPageX, lbPageY, lbPageW, lbPageSlashHeight))];
    [self.lbPageSlash setTextAlignment:(NSTextAlignmentCenter)];
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
            [self.lbContent setText:[NSString stringWithFormat:@"%@! %@", timeSlot, title]];
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
            [weakSelf.lbContent setText:[NSString stringWithFormat:@"%@! %@", timeSlot, title]];
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
        [self.lbPageSlash setText:@"1/1"];
        [self.lbPageSlash setTextColor:COLORTEXT3];
        [self.lbPageSlash setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbPageSlash setLabelFontWithRange:(NSMakeRange(0, 1)) font:[ZFont boldSystemFontOfSize:kFont_Huge_Size] color:COLORTEXT2];
    } else {
        NSString *strMax = [NSString stringWithFormat:@"/%d", maxCount];
        [self.lbPageSlash setText:[NSString stringWithFormat:@"%d%@", index, strMax]];
        [self.lbPageSlash setTextColor:COLORTEXT2];
        [self.lbPageSlash setFont:[ZFont boldSystemFontOfSize:kFont_Huge_Size]];
        [self.lbPageSlash setLabelFontWithRange:(NSMakeRange(self.lbPageSlash.text.length-strMax.length, strMax.length)) font:[ZFont systemFontOfSize:kFont_Min_Size] color:COLORTEXT3];
    }
}
/// 开始播放按钮点击事件
-(void)setStartPlayer:(ModelPracticeType *)model
{
    BOOL isShowView = false;
    NSString *localKey = [NSString stringWithFormat:@"kZFoundPracticeArray%@", model.ids];
    NSDictionary *dicResultData = [sqlite getLocalCacheDataWithPathKay:localKey];
    if (dicResultData && [dicResultData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicResult = [dicResultData objectForKey:kResultKey];
        if (dicResult && [dicResult isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *arrResult = [NSMutableArray array];
            NSArray *array = [dicResult objectForKey:@"speechs"];
            NSString *total = [dicResult objectForKey:@"totalRow"];
            if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
                for (NSDictionary *dic in array) {
                    [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
                }
                isShowView = true;
                 [self showPlayVCWithPracticeArray:arrResult index:0];
            }
        }
    }
    if (!isShowView) {
        [ZProgressHUD showMessage:@"正在获取,请稍等..."];
    }
    ZWEAKSELF
    [snsV2 getFoundPracticeArrayWithTypeId:model.ids resultBlock:^(NSArray *arrResult, NSInteger totalCount, NSDictionary *result) {
        if (!isShowView) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                [weakSelf showPlayVCWithPracticeArray:arrResult index:0];
            });
        }
        [sqlite setLocalCacheDataWithDictionary:result pathKay:localKey];
    } errorBlock:^(NSString *msg) {
        if (!isShowView) {
            GCDMainBlock(^{
                [ZProgressHUD dismiss];
                [ZProgressHUD showError:msg];
            });
        }
    }];
}
-(void)btnSearchClick
{
    [super btnSearchClick];
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
