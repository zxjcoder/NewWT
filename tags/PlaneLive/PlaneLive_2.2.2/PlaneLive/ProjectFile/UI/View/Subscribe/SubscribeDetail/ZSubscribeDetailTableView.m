//
//  ZSubscribeDetailTableView.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZSubscribeDetailTableView.h"
#import "ZSubscribeDetailTextTVC.h"
#import "ZSubscribeDetailImageTVC.h"
#import "ZSpaceTVC.h"

@interface ZSubscribeDetailTableView()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

/// 标题描述
@property (strong, nonatomic) ZSubscribeDetailImageTVC *tvcImage;
/// 课程介绍
@property (strong, nonatomic) ZSubscribeDetailTextTVC *tvcSubscribeInfo;
/// 团队介绍
@property (strong, nonatomic) ZSubscribeDetailTextTVC *tvcTeamInfo;
/// 适合人群
@property (strong, nonatomic) ZSubscribeDetailTextTVC *tvcFitPeople;
/// 订阅须知
@property (strong, nonatomic) ZSubscribeDetailTextTVC *tvcMustKnow;
/// 需要帮助
@property (strong, nonatomic) ZSubscribeDetailTextTVC *tvcNeedHelp;
/// 近期推送
@property (strong, nonatomic) ZSubscribeDetailTextTVC *tvcLatestPush;
/// 空白
@property (strong, nonatomic) ZSpaceTVC *tvcSpace;

@property (strong, nonatomic) NSArray *arrayMain;

@end

@implementation ZSubscribeDetailTableView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.tvcImage = [[ZSubscribeDetailImageTVC alloc] initWithReuseIdentifier:@"tvcImage"];
    self.tvcSubscribeInfo = [[ZSubscribeDetailTextTVC alloc] initWithReuseIdentifier:@"tvcSubscribeInfo" type:(ZSubscribeDetailTextTVCTypeInfo)];
    self.tvcTeamInfo = [[ZSubscribeDetailTextTVC alloc] initWithReuseIdentifier:@"tvcTeamInfo" type:(ZSubscribeDetailTextTVCTypeTeamInfo)];
    self.tvcFitPeople = [[ZSubscribeDetailTextTVC alloc] initWithReuseIdentifier:@"tvcFitPeople" type:(ZSubscribeDetailTextTVCTypeFitPeople)];
    self.tvcMustKnow = [[ZSubscribeDetailTextTVC alloc] initWithReuseIdentifier:@"tvcMustKnow" type:(ZSubscribeDetailTextTVCTypeMustKnow)];
    self.tvcNeedHelp = [[ZSubscribeDetailTextTVC alloc] initWithReuseIdentifier:@"tvcNeedHelp" type:(ZSubscribeDetailTextTVCTypeNeedHelp)];
    self.tvcLatestPush = [[ZSubscribeDetailTextTVC alloc] initWithReuseIdentifier:@"tvcLatestPush" type:(ZSubscribeDetailTextTVCTypeLatestPush)];
    self.tvcSpace = [[ZSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace"];
    
    self.arrayMain = @[self.tvcImage,
                       self.tvcSubscribeInfo,
                       self.tvcTeamInfo,
                       self.tvcFitPeople,
                       self.tvcMustKnow,
                       self.tvcNeedHelp,
                       self.tvcLatestPush,
                       self.tvcSpace];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    [self.tvcSpace setViewBackgroundColor:self.backgroundColor];
    
    [self setViewDataWithModel:nil];
}
-(void)setViewDataWithModel:(ModelSubscribeDetail *)model
{
    [self.tvcImage setCellDataWithModel:model];
    [self.tvcSubscribeInfo setCellDataWithModel:model];
    [self.tvcTeamInfo setCellDataWithModel:model];
    [self.tvcFitPeople setCellDataWithModel:model];
    [self.tvcMustKnow setCellDataWithModel:model];
    [self.tvcNeedHelp setCellDataWithModel:model];
    [self.tvcLatestPush setCellDataWithModel:model];
    
    [self reloadData];
}

-(void)dealloc
{
    OBJC_RELEASE(_tvcImage);
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat imageH = self.tvcImage.getH;
    CGFloat imageW = self.tvcImage.getW;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.onContentOffsetY) {
        CGFloat alpha = offsetY / (imageH-APP_TOP_HEIGHT);
        if (alpha > 1) { alpha = 1; }
        else if (alpha < 0) { alpha = 0; }
        self.onContentOffsetY(alpha);
    }
    if (offsetY < 0) {
        CGRect imageFrame = self.tvcImage.getViewImageFrame;
        imageFrame.origin.y = offsetY;
        imageFrame.origin.x = offsetY;
        imageFrame.size.width = imageW - (offsetY*2);
        imageFrame.size.height = imageH - offsetY;
        [self.tvcImage setViewImageFrame:imageFrame];
    } else {
        CGRect imageFrame = self.tvcImage.getViewImageFrame;
        imageFrame.origin.y = 0;
        imageFrame.origin.x = 0;
        imageFrame.size.width = imageW;
        imageFrame.size.height = imageH;
        if (imageFrame.origin.y > 0 || imageFrame.origin.y < 0) {
            [self.tvcImage setViewImageFrame:imageFrame];
        }
    }
}

@end
