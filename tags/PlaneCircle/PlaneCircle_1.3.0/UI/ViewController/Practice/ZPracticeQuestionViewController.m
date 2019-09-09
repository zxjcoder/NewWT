//
//  ZPracticeQuestionViewController.m
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeQuestionViewController.h"
#import "ZPracticeQuestionTableView.h"
#import "ZPracticeDetailNavigationView.h"

#import "ZPracticeContentViewController.h"
#import "ZPictureViewerViewController.h"
#import "ZCircleQuestionViewController.h"

#import "ZPracticeHotQuestionViewController.h"

#import "AudioPlayerView.h"

@interface ZPracticeQuestionViewController ()<ZActionSheetDelegate>

///导航
@property (strong, nonatomic) ZPracticeDetailNavigationView *viewNavigation;
///主视图
@property (strong, nonatomic) ZPracticeQuestionTableView *tvMain;
///数据源
@property (strong, nonatomic) ModelPractice *modelP;
///举报对象
@property (strong, nonatomic) ModelComment *modelC;

///主视图坐标
@property (assign, nonatomic) CGRect mainFrame;
///评论分页数
@property (assign, nonatomic) int pageNum;
///点收藏中
@property (assign, nonatomic) BOOL isCollectioning;
///点赞中
@property (assign, nonatomic) BOOL isPraiseing;
///是否在读文本
@property (assign, nonatomic) BOOL isTexting;
///是否在发布
@property (assign, nonatomic) BOOL isPublishing;
///最后偏移量
@property (assign, nonatomic) CGFloat lastOffsetY;
///当前第几条索引
@property (assign, nonatomic) NSInteger arrRow;
///数据源集合
@property (nonatomic, strong) NSArray *arrPractice;
///是否显示错误提示
@property (assign, nonatomic) BOOL isShowError;
///最后一条ID
@property (strong, nonatomic) NSString *lastIds;

@end

@implementation ZPracticeQuestionViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"实务详情"];
    
    [self setNavigationBarHidden:YES];
    
    [self innerInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPreRefreshData:) name:ZPlayPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNextRefreshData:) name:ZPlayNextNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayError:) name:ZPlayErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppDidBecomeActive:) name:ZApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRrefreshPracticeDataWithIsNotification:NO];
    
    [self.viewNavigation setViewTitle:self.modelP.title];
    
    [[ZDragButton shareDragButton] setIsCanShow:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayShowViewNotification object:@"YES"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayQuestion:) name:ZPlayQuestionNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.arrPractice.count > 0) {
        NSDictionary *dicParam = @{@"array":self.arrPractice,@"index":[NSString stringWithFormat:@"%ld",(long)self.arrRow]};
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayStartNotification object:dicParam];
    } else {
        if (self.modelP) {
            NSDictionary *dicParam = @{@"array":@[self.modelP],@"index":[NSString stringWithFormat:@"%d",0]};
            [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayStartNotification object:dicParam];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayQuestionNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}

-(void)dealloc
{
    [self setViewNil];
}

-(void)setViewNil
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayNextNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayErrorNotification object:nil];
    
    OBJC_RELEASE(_viewNavigation);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_modelP);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.viewNavigation = [[ZPracticeDetailNavigationView alloc] initWithScrollFrame:VIEW_NAVV_FRAME];
    [self.viewNavigation setViewBGAlpha:1.0f];
    [self.view addSubview:self.viewNavigation];
    //TODO:ZWW开启AppConfig配置
    ModelAppConfig *modelAC = [sqlite getLocalAppConfigModelWithId:APP_PROJECT_VERSION];
    if (modelAC && modelAC.appStatus == 1) {
        [self.viewNavigation setHiddenMore:NO];
    } else {
        [self.viewNavigation setHiddenMore:YES];
    }
    
    self.mainFrame = CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-APP_PLAY_HEIGHT);
    self.tvMain = [[ZPracticeQuestionTableView alloc] initWithFrame:self.mainFrame];
    [self.tvMain setFrame:self.mainFrame];
    [self.view addSubview:self.tvMain];
    
    [self.tvMain setViewDataWithModel:self.modelP];
    [self.view sendSubviewToBack:self.tvMain];
    
    [self innerData];
    
    [self innerEvnet];
}
///初始化数据
-(void)innerData
{
    [self setLastIds:self.modelP.ids];
    ModelPractice *model = [sqlite getLocalPracticeDetailModelWithId:self.modelP.ids userId:[AppSetting getUserDetauleId]];
    if (model) {
        [self setModelP:model];
    }
    [self.tvMain setViewDataWithModel:self.modelP];
    
    NSArray *arrHot = [sqlite getLocalPracticeQuestionWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeHot)];
    if (arrHot && arrHot.count > 0) {
        NSString *pageSizeHot = [sqlite getSysParamWithKey:@"pageSizeHot"];
        NSString *questionCount = [sqlite getSysParamWithKey:[NSString stringWithFormat:@"HotQuestionCount%@",self.modelP.ids]];
        [self.tvMain setViewHotDataWithArray:arrHot isHeader:YES pageSizeHot:[pageSizeHot intValue] questionCount:[questionCount integerValue]];
    }
    NSArray *arrNew = [sqlite getLocalPracticeQuestionWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeNew)];
    if (arrNew && arrNew.count > 0) {
        NSString *questionCount = [sqlite getSysParamWithKey:[NSString stringWithFormat:@"NewQuestionCount%@",self.modelP.ids]];
        [self.tvMain setViewNewDataWithArray:arrNew isHeader:YES questionCount:[questionCount integerValue]];
    }
}
///获取顶部数据
-(void)setRrefreshPracticeDataWithIsNotification:(BOOL)isNotification
{
    self.pageNum = 1;
    ZWEAKSELF
    [DataOper130 getPracticeDetailWithPracticeId:self.modelP.ids userId:[AppSetting getUserDetauleId] resultBlock:^(ModelPractice *resultModel) {
        //数据为最后一条的时候
        if (resultModel && [resultModel.ids isEqualToString:weakSelf.lastIds]) {
            GCDMainBlock(^{
                [weakSelf setModelP:resultModel];
                
                [weakSelf.tvMain setViewDataWithModel:resultModel];
                
                [sqlite setLocalPracticeDetailWithModel:resultModel userId:[AppSetting getUserDetauleId]];
            });
            NSString *hotKey = [NSString stringWithFormat:@"HotQuestionCount%@",weakSelf.modelP.ids];
            NSString *newKey = [NSString stringWithFormat:@"NewQuestionCount%@",weakSelf.modelP.ids];
            ///热门
            [DataOper130 getPracticeQuestionArrayWithPracticeId:weakSelf.modelP.ids type:(ZPracticeQuestionTypeHot) pageNum:1 resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
                
                [sqlite setSysParam:@"pageSizeHot" value:[NSString stringWithFormat:@"%d",pageSizeHot]];
                [sqlite setSysParam:hotKey value:[NSString stringWithFormat:@"%ld", (long)questionCount]];
                
                GCDMainBlock(^{
                    [weakSelf.tvMain setViewHotDataWithArray:arrResult isHeader:YES pageSizeHot:pageSizeHot questionCount:questionCount];
                    
                    [sqlite setLocalPracticeQuestionWithArray:arrResult practiceId:weakSelf.modelP.ids type:ZPracticeQuestionTypeHot];
                });
            } errorBlock:nil];
            ///最新
            [DataOper130 getPracticeQuestionArrayWithPracticeId:weakSelf.modelP.ids type:(ZPracticeQuestionTypeNew) pageNum:weakSelf.pageNum resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
                
                [sqlite setSysParam:newKey value:[NSString stringWithFormat:@"%ld", (long)questionCount]];
                
                GCDMainBlock(^{
                    [weakSelf.tvMain setViewNewDataWithArray:arrResult isHeader:YES questionCount:questionCount];
                    
                    [sqlite setLocalPracticeQuestionWithArray:arrResult practiceId:weakSelf.modelP.ids type:ZPracticeQuestionTypeNew];
                });
            } errorBlock:nil];
        } else {
            [weakSelf.tvMain endRefreshHeader];
        }
        if (isNotification) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayEnabledNotification object:@"YES"];
        }
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
        });
    }];
}
///点击提问
-(void)setPlayQuestion:(NSNotification *)sender
{
    [self.view endEditing:YES];
    
    if ([AppSetting getAutoLogin]) {
        [[AudioPlayerView shareAudioPlayerView] dismissOnly];
        
        ZCircleQuestionViewController *itemVC = [[ZCircleQuestionViewController alloc] init];
        [itemVC setPreVC:self];
        [itemVC setPracticeId:self.modelP.ids];
        [itemVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:itemVC animated:YES];
    } else {
        [[AudioPlayerView shareAudioPlayerView] dismissOnly];
        
        [self showLoginVC];
    }
}
///添加问题成功
-(void)setPublishPracticeQuestion:(ModelQuestion *)model
{
    ModelPracticeQuestion *modelPQ = [[ModelPracticeQuestion alloc] init];
    
    [modelPQ setIds:model.ids];
    [modelPQ setTitle:model.title];
    [modelPQ setPid:model.bePracticeId];
    
    ModelUserBase *modelUB = [AppSetting getUserLogin];
    
    [modelPQ setUserId:modelUB.userId];
    [modelPQ setNickname:modelUB.nickname];
    [modelPQ setSign:modelUB.sign];
    [modelPQ setHead_img:modelUB.head_img];
    
    [self.tvMain setViewNewDataWithModel:modelPQ];
}
///播放错误
-(void)setPlayError:(NSNotification *)sender
{
    GCDMainBlock(^{
        [ZProgressHUD showError:@"语音读取失败"];
    });
}
///App进入前台
-(void)setAppDidBecomeActive:(NSNotification *)sender
{
    GCDMainBlock(^{
        [self.viewNavigation setViewTitle:self.modelP.title];
    });
}
///刷新顶部数据
-(void)setRefreshHeader
{
    [self setRrefreshPracticeDataWithIsNotification:NO];
}
///刷新底部数据
-(void)setRefreshFooter
{
    ZWEAKSELF
    [DataOper130 getPracticeQuestionArrayWithPracticeId:self.modelP.ids type:(ZPracticeQuestionTypeNew) pageNum:self.pageNum+1 resultBlock:^(NSArray *arrResult, int pageSizeHot, NSInteger questionCount) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            [weakSelf.tvMain setViewNewDataWithArray:arrResult isHeader:NO questionCount:questionCount];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}
///返回按钮事件
-(void)btnBackClick
{
    [self.viewNavigation setStopScroll];
    
    [[ZDragButton shareDragButton] setIsCanShow:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayShowViewNotification object:@"NO"];
    
    if (![AppDelegate app].isPaying) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayCancelNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayNextNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayQuestionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayErrorNotification object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
///初始化事件
-(void)innerEvnet
{
    ZWEAKSELF
    /////////////////导航
    ///返回点击事件
    [self.viewNavigation setOnBackClick:^{
        [weakSelf btnBackClick];
    }];
    ///更多点击事件
    [self.viewNavigation setOnMoreClick:^{
        [weakSelf btnRightClick];
    }];
    /////////////////主视图
    ///文本内容
    [self.tvMain setOnTextClick:^{
        [weakSelf btnTextClick];
    }];
    ///PPT点击
    [self.tvMain setOnPPTClick:^{
        NSMutableArray *imageUrls = [NSMutableArray new];
        for (NSDictionary *dicImage in weakSelf.modelP.arrImage) {
            NSURL *url = [NSURL URLWithString:[dicImage objectForKey:@"url"]];
            if (url) {
                [imageUrls addObject:url];
            }
        }
        ZPictureViewerViewController *browser = [[ZPictureViewerViewController alloc] initWithPhotos:[IDMPhoto photosWithURLs:imageUrls]];
        browser.progressTintColor       = MAINCOLOR;
        [weakSelf presentViewController:browser animated:YES completion:nil];
    }];
    ///点赞
    [self.tvMain setOnPraiseClick:^{
        [weakSelf btnPraiseClick];
    }];
    ///收藏
    [self.tvMain setOnCollectionClick:^{
        [weakSelf btnCollectionClick];
    }];
    ///偏移量
    [self.tvMain setOnOffsetChange:^(CGFloat y) {
        [weakSelf setLastOffsetY:y];
    }];
    ///刷新顶部数据
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    ///刷新底部数据
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    ///热门查看全部点击
    [self.tvMain setOnHotAllClick:^{
        [[AudioPlayerView shareAudioPlayerView] dismissOnly];
        
        ZPracticeHotQuestionViewController *itemVC = [[ZPracticeHotQuestionViewController alloc] init];
        [itemVC setViewDataWithModel:weakSelf.modelP];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    ///问题详情
    [self.tvMain setOnQuestionRowClick:^(ModelPracticeQuestion *model) {
        [[AudioPlayerView shareAudioPlayerView] dismissOnly];
        
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:model.ids];
        [modelQB setTitle:model.title];
        [weakSelf showQuestionDetailVC:modelQB];
    }];
    ///回答详情
    [self.tvMain setOnAnswerRowClick:^(ModelPracticeQuestion *model) {
        [[AudioPlayerView shareAudioPlayerView] dismissOnly];
        
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.aid];
        [modelAB setTitle:model.answerContent];
        [modelAB setQuestion_id:model.ids];
        [modelAB setQuestion_title:model.title];
        [modelAB setUserId:model.userId];
        [modelAB setHead_img:model.head_img];
        [modelAB setNickname:model.nickname];
        [weakSelf showAnswerDetailVC:modelAB];
    }];
}
///数据改变
-(void)setDataChangeWithModel:(ModelPractice *)modelPra
{
    [self setModelP:modelPra];
    
    [self innerData];
    
    [self setRrefreshPracticeDataWithIsNotification:YES];
}
///上一页获取数据
-(void)setPreRefreshData:(NSNotification *)sender
{
    NSDictionary *dicParam = sender.object;
    ModelPractice *modelN = [dicParam objectForKey:@"model"];
    self.arrRow = [[dicParam objectForKey:@"row"] integerValue];
    [self setModelP:modelN];
    
    [self.viewNavigation setViewTitle:modelN.title];
    
    [self setDataChangeWithModel:modelN];
}
///下一页获取数据
-(void)setNextRefreshData:(NSNotification *)sender
{
    NSDictionary *dicParam = sender.object;
    ModelPractice *modelN = [dicParam objectForKey:@"model"];
    self.arrRow = [[dicParam objectForKey:@"row"] integerValue];
    [self setModelP:modelN];
    
    [self.viewNavigation setViewTitle:modelN.title];
    
    [self setDataChangeWithModel:modelN];
}
///文本点击事件
-(void)btnTextClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Practice_Detail_Text];
    
    ZPracticeContentViewController *itemVC = [[ZPracticeContentViewController alloc] init];
    [itemVC setNavigationBarHidden:YES];
    [itemVC setViewDataWithModel:self.modelP];
    [itemVC setTitle:self.modelP.title];
    [self.navigationController pushViewController:itemVC animated:YES];
}
///发送实务对象改变
-(void)sendPracticeModelChange
{
    [sqlite setLocalPracticeDetailWithModel:self.modelP userId:[AppSetting getUserDetauleId]];
    
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setValue:self.modelP forKey:@"model"];
    [dicParam setValue:[NSNumber numberWithInteger:self.arrRow] forKey:@"row"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPracticeChangeNotification object:dicParam];
}
///点赞
-(void)btnPraiseClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Practice_Detail_Praise];
    
    if ([AppSetting getAutoLogin]) {
        if (self.isPraiseing) {
            [ZProgressHUD showError:@"正在点赞中..."];
            return;
        }
        [self setIsPraiseing:YES];
        ZWEAKSELF
        if (!self.modelP.isPraise) {
            //点赞
            [self.modelP setIsPraise:YES];
            [sns postClickLikeWithAId:self.modelP.ids userId:[AppSetting getUserDetauleId] type:@"4" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                    
                    [weakSelf.modelP setIsPraise:YES];
                    weakSelf.modelP.applauds += 1;
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelP];
                    
                    [weakSelf sendPracticeModelChange];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                    
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            //取消赞
            [sns postClickUnLikeWithAId:self.modelP.ids userId:[AppSetting getUserDetauleId] type:@"4" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                    
                    [weakSelf.modelP setIsPraise:NO];
                    if (weakSelf.modelP.applauds > 0) {
                        weakSelf.modelP.applauds -= 1;
                    }
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelP];
                    
                    [weakSelf sendPracticeModelChange];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                    
                    [ZProgressHUD showError:msg];
                });
            }];
        }
    } else {
        [[AudioPlayerView shareAudioPlayerView] dismissOnly];
        
        [self showLoginVC];
    }
}
///收藏
-(void)btnCollectionClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Practice_Detail_Collection];
    
    if ([AppSetting getAutoLogin]) {
        if (self.isCollectioning) {
            [ZProgressHUD showError:@"正在收藏中..."];
            return;
        }
        [self setIsCollectioning:YES];
        ZWEAKSELF
        if (!self.modelP.isCollection) {
            //收藏
            [sns getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelP.ids flag:1 type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:@"收藏成功"];
                    
                    [weakSelf setIsCollectioning:NO];
                    
                    [weakSelf.modelP setIsCollection:YES];
                    weakSelf.modelP.ccount += 1;
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelP];
                    
                    [weakSelf sendPracticeModelChange];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsCollectioning:NO];
                    
                    [ZProgressHUD showError:msg];
                });
            }];
        } else {
            //取消赞
            [sns getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelP.ids type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:@"取消收藏成功"];
                    
                    [weakSelf setIsCollectioning:NO];
                    
                    [weakSelf.modelP setIsCollection:NO];
                    if (weakSelf.modelP.ccount > 0) {
                        weakSelf.modelP.ccount -= 1;
                    }
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelP];
                    
                    [weakSelf sendPracticeModelChange];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsCollectioning:NO];
                    
                    [ZProgressHUD showError:msg];
                });
            }];
        }
    } else {
        [[AudioPlayerView shareAudioPlayerView] dismissOnly];
        
        [self showLoginVC];
    }
    
}
///更多分享
-(void)btnRightClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Practice_Detail_Share];
    
    //TODO:ZWW备注-分享-实务详情
    ZWEAKSELF
    ZShareView *shareView = nil;
    shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat:
                [MobClick event:kEvent_Practice_Detail_Share_WeChat];
                [weakSelf btnWeChatClick];
                break;
            case ZShareTypeWeChatCircle:
                [MobClick event:kEvent_Practice_Detail_Share_WeChatCircle];
                [weakSelf btnWeChatCircleClick];
                break;
            case ZShareTypeQQ:
                [MobClick event:kEvent_Practice_Detail_Share_QQ];
                [weakSelf btnQQClick];
                break;
            case ZShareTypeQZone:
                [MobClick event:kEvent_Practice_Detail_Share_QZone];
                [weakSelf btnQZoneClick];
                break;
            case ZShareTypeYouDao:
                [MobClick event:kEvent_Practice_Detail_Share_YingXiang];
                [weakSelf btnYouDaoClick];
                break;
            case ZShareTypeYinXiang:
                [MobClick event:kEvent_Practice_Detail_Share_YouDao];
                [weakSelf btnYinXiangClick];
                break;
            default: break;
        }
    }];
    [shareView show];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.modelP.title;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelP.share_content;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    NSString *imageUrl = [Utils getMinPicture:self.modelP.speech_img];
    NSString *webUrl = kShare_VoiceUrl(self.modelP.ids);
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}
///设置数据模型
-(void)setViewDataWithModel:(ModelPractice *)model
{
    [super setViewDataWithModel:model];
    
    [self setModelP:model];
}
///设置数据源
-(void)setViewDataWithArray:(NSArray *)arr arrDefaultRow:(NSInteger)row
{
    [self setArrRow:row];
    [self setArrPractice:arr];
}

#pragma mark - ZActionSheetDelegate

-(void)actionSheet:(ZActionSheet *)actionSheet didButtonClickWithIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 11:
        {
            switch (buttonIndex) {
                case 0:
                {
                    [self btnReportClickWithId:self.modelC.ids type:ZReportTypeComment];
                    break;
                }
                default: break;
            }
            break;
        }
        default: break;
    }
}


@end
