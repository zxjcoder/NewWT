//
//  ZNewSubscribeAlreadyHasDetailTableView.m
//  PlaneLive
//
//  Created by WT on 30/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZNewSubscribeAlreadyHasDetailTableView.h"
#import "ZNewSubscribeAlreadyHasDescTVC.h"
#import "ZGlobalPlayView.h"

@interface ZNewSubscribeAlreadyHasDetailTableView()

/// 课程介绍
@property (strong, nonatomic) ZNewSubscribeAlreadyHasDescTVC *tvcSubscribeInfo;
/// 团队介绍
@property (strong, nonatomic) ZNewSubscribeAlreadyHasDescTVC *tvcTeamInfo;
/// 适合人群
@property (strong, nonatomic) ZNewSubscribeAlreadyHasDescTVC *tvcFitPeople;
/// 订阅须知
@property (strong, nonatomic) ZNewSubscribeAlreadyHasDescTVC *tvcMustKnow;
/// 需要帮助
@property (strong, nonatomic) ZNewSubscribeAlreadyHasDescTVC *tvcNeedHelp;
/// 近期推送
@property (strong, nonatomic) ZNewSubscribeAlreadyHasDescTVC *tvcLatestPush;

@property (strong, nonatomic) NSArray *arrayMain;

@property (assign, nonatomic) CGFloat tvHeight;

@end

@implementation ZNewSubscribeAlreadyHasDetailTableView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.tvcSubscribeInfo = [[ZNewSubscribeAlreadyHasDescTVC alloc] initWithReuseIdentifier:@"tvcSubscribeInfo" type:(ZSubscribeDetailTextTVCTypeInfo)];
    self.tvcTeamInfo = [[ZNewSubscribeAlreadyHasDescTVC alloc] initWithReuseIdentifier:@"tvcTeamInfo" type:(ZSubscribeDetailTextTVCTypeTeamInfo)];
    self.tvcFitPeople = [[ZNewSubscribeAlreadyHasDescTVC alloc] initWithReuseIdentifier:@"tvcFitPeople" type:(ZSubscribeDetailTextTVCTypeFitPeople)];
    self.tvcMustKnow = [[ZNewSubscribeAlreadyHasDescTVC alloc] initWithReuseIdentifier:@"tvcMustKnow" type:(ZSubscribeDetailTextTVCTypeMustKnow)];
    self.tvcNeedHelp = [[ZNewSubscribeAlreadyHasDescTVC alloc] initWithReuseIdentifier:@"tvcNeedHelp" type:(ZSubscribeDetailTextTVCTypeNeedHelp)];
    self.tvcLatestPush = [[ZNewSubscribeAlreadyHasDescTVC alloc] initWithReuseIdentifier:@"tvcLatestPush" type:(ZSubscribeDetailTextTVCTypeLatestPush)];
    
    self.arrayMain = @[self.tvcSubscribeInfo,
                       self.tvcTeamInfo,
                       self.tvcFitPeople,
                       self.tvcMustKnow,
                       self.tvcNeedHelp,
                       self.tvcLatestPush];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setScrollsToTop:false];
    [self setScrollEnabled:false];
    [self setShowsVerticalScrollIndicator:false];
    [self setShowsHorizontalScrollIndicator:false];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    [self setViewDataWithModel:nil];
}
-(void)setViewDataWithModel:(ModelSubscribeDetail *)model
{
    CGFloat rowHeight = 0;
    rowHeight += [self.tvcSubscribeInfo setCellDataWithModel:model];
    rowHeight += [self.tvcTeamInfo setCellDataWithModel:model];
    rowHeight += [self.tvcFitPeople setCellDataWithModel:model];
    rowHeight += [self.tvcMustKnow setCellDataWithModel:model];
    rowHeight += [self.tvcNeedHelp setCellDataWithModel:model];
    rowHeight += [self.tvcLatestPush setCellDataWithModel:model];
    
    self.tvHeight = rowHeight + [ZGlobalPlayView getH];
    if (self.onTableViewHeightChange) {
        self.onTableViewHeightChange(self.tvHeight);
    }
    [self reloadData];
}
-(void)dealloc
{
    OBJC_RELEASE(_tvcTeamInfo);
    OBJC_RELEASE(_tvcSubscribeInfo);
    OBJC_RELEASE(_tvcMustKnow);
    OBJC_RELEASE(_tvcNeedHelp);
    OBJC_RELEASE(_tvcFitPeople);
    OBJC_RELEASE(_tvcLatestPush);
    OBJC_RELEASE(_arrayMain);
    self.dataSource = nil;
    self.delegate = nil;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.arrayMain objectAtIndex:indexPath.row] getH];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrayMain objectAtIndex:indexPath.row];
}

@end
