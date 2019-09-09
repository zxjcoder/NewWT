//
//  ZPlayBottomTabView.m
//  PlaneLive
//
//  Created by WT on 14/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZPlayBottomTabView.h"
#import "ZPlayBottomButton.h"

@interface ZPlayBottomTabView()

@property (strong, nonatomic) UIView *viewTop;
@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) ZPlayBottomButton *btnCollection;
@property (strong, nonatomic) ZPlayBottomButton *btnDownload;
@property (strong, nonatomic) ZPlayBottomButton *btnCourseware;
@property (strong, nonatomic) ZPlayBottomButton *btnMessage;
@property (strong, nonatomic) ZPlayBottomButton *btnReward;

@property (assign, nonatomic) ZPlayTabBarViewType tabType;
@property (assign, nonatomic) BOOL isCollection;
@property (strong, nonatomic) NSString *idCollection;

@end

@implementation ZPlayBottomTabView

-(id)initWithFrame:(CGRect)frame type:(ZPlayTabBarViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.viewTop = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, self.width, 16))];
        [self.viewTop setBackgroundColor:[UIColor whiteColor]];
        [self.viewTop setShadowColor];
        [self.viewTop setViewRound:8];
        [self addSubview:self.viewTop];
        
        self.viewContent = [[UIView alloc] initWithFrame:(CGRectMake(0, 8, self.width, self.height-8))];
        [self.viewContent setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.viewContent];
        
        [self sendSubviewToBack:self.viewTop];
        
        [self setTabType:type];
        [self innerInitItem];
        [self setViewFrame];
    }
    return self;
}
-(void)innerInitItem
{
    CGFloat itemH = 42;
    CGFloat itemW = 35;
    CGFloat itemSpace = (self.width-itemW*5)/5;
    CGFloat itemY = 0;
    self.btnCollection = [self createButton:@"favs" title:@"收藏"];
    [self.viewContent addSubview:self.btnCollection];
    
    self.btnDownload = [self createButton:@"download" title:@"下载"];
    [self.viewContent addSubview:self.btnDownload];
    
    self.btnCourseware = [self createButton:@"matter" title:@"课件"];
    [self.viewContent addSubview:self.btnCourseware];
    
    self.btnMessage = [self createButton:@"write" title:@"留言"];
    [self.viewContent addSubview:self.btnMessage];
    
    self.btnReward = [self createButton:@"reward" title:@"打赏"];
    [self.viewContent addSubview:self.btnReward];
    
    [self.btnCollection addTarget:self action:@selector(btnCollectionEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnDownload addTarget:self action:@selector(btnDownloadEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnCourseware addTarget:self action:@selector(btnCoursewareEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnMessage addTarget:self action:@selector(btnMessageEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnReward addTarget:self action:@selector(btnRewardEvent) forControlEvents:(UIControlEventTouchUpInside)];
}
-(void)setViewFrame
{
    CGFloat itemH = 42;
    CGFloat itemW = 35;
    CGFloat itemSpace = (self.width-itemW*4)/4;
    if (self.tabType == ZPlayTabBarViewTypeSubscribe) {
        itemSpace = (self.width-itemW*5)/5;
    }
    CGFloat itemY = 0;
    self.btnCollection.frame = CGRectMake(itemSpace/2, itemY, itemW, itemH);
    
    CGFloat item2X = itemSpace/2+itemW+itemSpace;
    self.btnDownload.frame = CGRectMake(item2X, itemY, itemW, itemH);
    
    CGFloat item3X = itemSpace/2+itemW*2+itemSpace*2;
    self.btnCourseware.frame = CGRectMake(item3X, itemY, itemW, itemH);
    switch (self.tabType) {
        case ZPlayTabBarViewTypeSubscribe:
        {
            [self.btnMessage setHidden:false];
            CGFloat item4X = itemSpace/2+itemW*3+itemSpace*3;
            self.btnMessage.frame = CGRectMake(item4X, itemY, itemW, itemH);
            CGFloat item5X = itemSpace/2+itemW*4+itemSpace*4;
            self.btnReward.frame = CGRectMake(item5X, itemY, itemW, itemH);
            break;
        }
        default:
        {
            [self.btnMessage setHidden:true];
            CGFloat item4X = itemSpace/2+itemW*3+itemSpace*3;
            self.btnReward.frame = CGRectMake(item4X, itemY, itemW, itemH);
            break;
        }
    }
}
/// 设置类型
-(void)setViewTabType:(ZPlayTabBarViewType)type
{
    [self setTabType:type];
    GCDMainBlock(^{
        [self setViewFrame];
    });
}
-(ZPlayBottomButton*)createButton:(NSString *)icon title:(NSString*)title
{
    ZPlayBottomButton *btnItem = [[ZPlayBottomButton alloc] init];
    [btnItem setButtonTitle:title];
    [btnItem setButtonIcon:icon];
    return btnItem;
}
-(void)btnMessageEvent
{
    if (self.onMessageEvent) {
        self.onMessageEvent();
    }
}
-(void)btnCollectionEvent
{
    if (self.onCollectionEvent) {
        self.onCollectionEvent(self.tabType, self.isCollection, self.idCollection);
    }
}
-(void)btnDownloadEvent
{
    if (self.onDownloadEvent) {
        self.onDownloadEvent(self.btnDownload.tag);
    }
}
-(void)btnCoursewareEvent
{
    if (self.onCoursewareEvent) {
        self.onCoursewareEvent();
    }
}
-(void)btnRewardEvent
{
    if (self.onRewardEvent) {
        self.onRewardEvent(self.tabType);
    }
}
/// 设置下载状态
-(void)setDownloadStatus:(ZDownloadStatus)status
{
    [self.btnDownload setTag:status];
    switch (status) {
        case ZDownloadStatusEnd:
        case ZDownloadStatusAudioDowloadEnd:
            [self.btnDownload setButtonIcon:@"download_end"];
            break;
        default:
            [self.btnDownload setButtonIcon:@"download"];
            break;
    }
}
-(void)setCollectionCheck:(BOOL)isCheck
{
    if (isCheck) {
        [self.btnCollection setButtonIcon:@"favs_s"];
    } else {
        [self.btnCollection setButtonIcon:@"favs"];
        [self.btnCollection setButtonTitle:@"收藏"];
    }
}
///设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model
{
    self.idCollection = model.ids;
    self.isCollection = model.isCollection;
    if (model.ccount > kNumberMaxCount) {
        [self.btnCollection setButtonTitle:[NSString stringWithFormat:@"%d", 999]];
    } else {
        [self.btnCollection setButtonTitle:[NSString stringWithFormat:@"%ld", model.ccount]];
    }
    [self setCollectionCheck:model.isCollection];
    
    [self setTabType:(ZPlayTabBarViewTypePractice)];
    GCDMainBlock(^{
        [self setViewFrame];
    });
}
///设置数据源
-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model
{
    self.idCollection = model.ids;
    self.isCollection = model.isCollection;
    if (model.ccount > kNumberMaxCount) {
        [self.btnCollection setButtonTitle:[NSString stringWithFormat:@"%d", 999]];
    } else {
        [self.btnCollection setButtonTitle:[NSString stringWithFormat:@"%ld", model.ccount]];
    }
    [self setCollectionCheck:model.isCollection];
    
    [self setTabType:(ZPlayTabBarViewTypeSubscribe)];
    GCDMainBlock(^{
        [self setViewFrame];
    });
}
/// 设置按钮是否可点
-(void)setOperEnabled:(BOOL)isEnabled
{
    [self.btnCollection setEnabled:isEnabled];
    [self.btnDownload setEnabled:isEnabled];
    [self.btnCourseware setEnabled:isEnabled];
    [self.btnMessage setEnabled:isEnabled];
    [self.btnReward setEnabled:isEnabled];
}
+(CGFloat)getH
{
    if (IsIPhoneX) {
        return 63+kIPhoneXButtonHeight;
    }
    return 63;
}

@end
