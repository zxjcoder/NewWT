//
//  ZPracticeDetailViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailViewController.h"
#import "ZPracticeDetailTableView.h"
#import "ZPracticeDetailPlayView.h"
#import "ZPracticeDetailPublishView.h"
#import "ZPracticeDetailNavigationView.h"

#import "ZPracticeContentViewController.h"
#import "ZPictureViewerViewController.h"

@interface ZPracticeDetailViewController ()<ZActionSheetDelegate>

///导航
@property (strong, nonatomic) ZPracticeDetailNavigationView *viewNavigation;
///主视图
@property (strong, nonatomic) ZPracticeDetailTableView *tvMain;
///发布评论
@property (strong, nonatomic) ZPracticeDetailPublishView *viewPublish;
///数据源
@property (strong, nonatomic) ModelPractice *modelP;
///举报对象
@property (strong, nonatomic) ModelComment *modelC;

///主视图坐标
@property (assign, nonatomic) CGRect mainFrame;
///评论坐标
@property (assign, nonatomic) CGRect commentFrame;
///文本坐标
@property (assign, nonatomic) CGRect textFrame;
///键盘高度
@property (assign, nonatomic) CGFloat keyboardH;
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

@implementation ZPracticeDetailViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"实务详情"];
    
    [self setNavigationBarHidden:YES];
    
    [self innerInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPreRefreshData:) name:ZPlayPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNextRefreshData:) name:ZPlayNextNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayComment:) name:ZPlayCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayError:) name:ZPlayErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppDidBecomeActive:) name:ZApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardNotification];
    
    [self setSefreshPracticeData];
    
    [self.viewNavigation setViewTitle:self.modelP.title];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayShowViewNotification object:@"YES"];
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
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayErrorNotification object:nil];
    OBJC_RELEASE(_viewPublish);
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
    
    self.commentFrame = CGRectMake(0, APP_FRAME_HEIGHT-APP_INPUT_HEIGHT, APP_FRAME_WIDTH, APP_INPUT_HEIGHT);
    self.viewPublish = [[ZPracticeDetailPublishView alloc] initWithFrame:self.commentFrame];
    [self.viewPublish setHidden:YES];
    [self.viewPublish setAlpha:0];
    [self.view addSubview:self.viewPublish];
    
    self.mainFrame = CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_TOP_HEIGHT-APP_PLAY_HEIGHT);
    self.tvMain = [[ZPracticeDetailTableView alloc] init];
    [self.tvMain setFrame:self.mainFrame];
    [self.view addSubview:self.tvMain];
    
    [self.tvMain setViewDataWithModel:self.modelP];
    [self.view bringSubviewToFront:self.viewPublish];
    [self.view sendSubviewToBack:self.tvMain];
    
    ZWEAKSELF
    [self.tvMain addRefreshHeaderWithEndBlock:^{
        [weakSelf setRefreshHeader];
    }];
    
    [self innerData];
    
    [self innerEvnet];
}
///初始化数据
-(void)innerData
{
    [self setLastIds:self.modelP.ids];
    [self.tvMain setViewDataWithModel:self.modelP];
    
    ZWEAKSELF
    self.pageNum = 1;
    [sns getSpeechDetailWithSpeechId:self.modelP.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            
            [weakSelf setViewDataWithDictionary:dicResult];
        });
    } errorBlock:nil];
}
-(void)setSefreshPracticeData
{
    ZWEAKSELF
    NSString *userId = [AppSetting getUserDetauleId];
    [sns getSpeechDetailWithSpeechId:self.modelP.ids userId:userId pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSDictionary *dicP = [result objectForKey:kResultKey];
            if (dicP && [dicP isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicP];
                
                NSString *resultCollect = [result objectForKey:@"resultCollect"];
                if (resultCollect && ![resultCollect isKindOfClass:[NSNull class]]) {
                    [dicR setObject:resultCollect forKey:@"resultCollect"];
                }
                NSString *resultApplaud = [result objectForKey:@"resultApplaud"];
                if (resultApplaud && ![resultApplaud isKindOfClass:[NSNull class]]) {
                    [dicR setObject:resultApplaud forKey:@"resultApplaud"];
                }
                ModelPractice *modelPractice = [[ModelPractice alloc] initWithCustom:dicR];
                
                [sqlite setLocalPracticeDetailWithModel:modelPractice userId:[AppSetting getUserDetauleId]];
                
                [weakSelf setModelP:modelPractice];
                
                [weakSelf.tvMain setViewDataWithModel:modelPractice];
                
                ModelPractice *modelPL = [sqlite getLocalPlayPracticeModelWithId:modelPractice.ids];
                if (modelPL != nil) {
                    [modelPractice setPlay_time:modelPL.play_time];
                }
            }
        });
    } errorBlock:nil];
}
///点击评论
-(void)setPlayComment:(NSNotification *)sender
{
    if (self.isDisappear) {
        [self.viewPublish setHidden:NO];
        [self.viewPublish setAlpha:0];
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self.viewPublish setAlpha:1];
        } completion:^(BOOL finished) {
            [self.viewPublish showKeyboard];
        }];
    }
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
///设置数据源
-(void)setViewDataWithDictionary:(NSDictionary *)result
{
    NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
    
    NSString *resultIds = nil;
    BOOL isHeader = [[result objectForKey:kIsHeaderKey] boolValue];
    if (isHeader) {
        NSString *resultCollect = [result objectForKey:@"resultCollect"];
        if (resultCollect && ![resultCollect isKindOfClass:[NSNull class]]) {
            [dicResult setObject:resultCollect forKey:@"resultCollect"];
        }
        NSString *resultApplaud = [result objectForKey:@"resultApplaud"];
        if (resultApplaud && ![resultApplaud isKindOfClass:[NSNull class]]) {
            [dicResult setObject:resultApplaud forKey:@"resultApplaud"];
        }
        NSDictionary *dicP = [result objectForKey:kResultKey];
        if (dicP && [dicP isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dicR = [NSMutableDictionary dictionaryWithDictionary:dicP];
            if (resultCollect && ![resultCollect isKindOfClass:[NSNull class]]) {
                [dicR setObject:resultCollect forKey:@"resultCollect"];
            }
            if (resultApplaud && ![resultApplaud isKindOfClass:[NSNull class]]) {
                [dicR setObject:resultApplaud forKey:@"resultApplaud"];
            }
            ModelPractice *modelPractice = [[ModelPractice alloc] initWithCustom:dicR];
            
            resultIds = modelPractice.ids;
            
            [sqlite setLocalPracticeDetailWithModel:modelPractice userId:[AppSetting getUserDetauleId]];
            
            //当前返回对象不是当前展示对象
            if ([self.lastIds isEqualToString:resultIds]) {
            
                [self setModelP:modelPractice];
                
                [self.tvMain setViewDataWithModel:modelPractice];
                
                ModelPractice *modelPL = [sqlite getLocalPlayPracticeModelWithId:modelPractice.ids];
                if (modelPL != nil) {
                    [modelPractice setPlay_time:modelPL.play_time];
                }
            }
        }
    }
    if (resultIds) {
        //当前返回对象不是当前展示对象
        if ([self.lastIds isEqualToString:resultIds]) {
            [self.tvMain setViewDataWithDictionary:dicResult];
        }
    } else {
        [self.tvMain setViewDataWithDictionary:dicResult];
    }
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    NSString *userId = [AppSetting getUserDetauleId];
    [sns getSpeechDetailWithSpeechId:self.modelP.ids userId:userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            
            [weakSelf.tvMain endRefreshHeader];
            [weakSelf.tvMain setViewDataWithDictionary:dicResult];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
        });
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    self.pageNum += 1;
    NSString *userId = [AppSetting getUserDetauleId];
    [sns getSpeechDetailWithSpeechId:self.modelP.ids userId:userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
            [weakSelf.tvMain setViewDataWithDictionary:result];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}
///设置背景颜色
-(void)setNavigationBgColorWithOffsetY:(CGFloat)y
{
//    CGFloat alp = y/64;
//    alp = alp/2;
//    if (alp < 0) {
//        alp = 0;
//    } else if (alp > 1) {
//        alp = 1;
//    }
//    [self.viewNavigation setViewBGAlpha:alp];
}
///返回
-(void)btnBackClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayShowViewNotification object:@"NO"];
    
    if (![AppDelegate app].isPaying) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayCancelNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayNextNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZPlayErrorNotification object:nil];
    
    [self.viewNavigation setStopScroll];
    
    [self.navigationController popViewControllerAnimated:YES];
}
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
    ///标题点击事件
    [self.viewNavigation setOnViewClick:^{
        [weakSelf setViewKeyboardHidden];
    }];
    /////////////////主视图
    ///文本内容
    [self.tvMain setOnTextClick:^{
        [weakSelf btnTextClick];
    }];
    ///ppt
    [self.tvMain setOnPPTClick:^{
        NSMutableArray *imageUrls = [NSMutableArray new];
        for (NSDictionary *dicImage in weakSelf.modelP.arrImage) {
            [imageUrls addObject:[NSURL URLWithString:[dicImage objectForKey:@"url"]]];
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
        [weakSelf setViewKeyboardHidden];
        [weakSelf setLastOffsetY:y];
        [weakSelf setNavigationBgColorWithOffsetY:y];
    }];
    ///评论头像点击
    [self.tvMain setOnCommentPhotoClick:^(ModelComment *model) {
        if (![Utils isMyUserId:model.userId]) {
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:model.userId];
            [modelUB setNickname:model.nickname];
            [weakSelf showUserProfileVC:modelUB];
        }
    }];
    ///举报评论
    [self.tvMain setOnCommentRowClick:^(ModelComment *model) {
        if (![Utils isMyUserId:model.userId]) {
            [weakSelf setModelC:model];
            ZActionSheet *actionSheet = [[ZActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:kCancel destructiveButtonTitle:nil otherButtonTitles:@[@"举报评论"]];
            [actionSheet setTag:11];
            [actionSheet show];
        }
    }];
    ///刷新底部数据
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    /////////////////评论
    ///发布按钮
    [self.viewPublish setOnPublishClick:^(NSString *content) {
        [weakSelf btnPublishClick:content];
    }];
    ///评论->点击播放
    [self.viewPublish setOnPlayClick:^{
        [weakSelf setViewKeyboardHidden];
    }];
    ///评论内容高度改变
    [self.viewPublish setOnViewHeightChange:^(CGFloat viewH) {
        CGRect commentFrame = weakSelf.viewPublish.frame;
        commentFrame.origin.y = APP_FRAME_HEIGHT-weakSelf.keyboardH-viewH;
        commentFrame.size.height = viewH;
        
        ///超过导航栏了
        if (commentFrame.origin.y < APP_TOP_HEIGHT) {
            commentFrame.origin.y = APP_TOP_HEIGHT;
            commentFrame.size.height = APP_FRAME_HEIGHT-weakSelf.keyboardH-APP_TOP_HEIGHT;
        }
        
        CGRect mainFrame = weakSelf.mainFrame;
        mainFrame.size.height = APP_FRAME_HEIGHT-weakSelf.keyboardH-commentFrame.size.height;;
        if (mainFrame.size.height < 0) {
            mainFrame.size.height = 0;
        }
        [weakSelf.tvMain setFrame:mainFrame];
        
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [weakSelf.viewPublish setViewFrame:commentFrame];
        }];
    }];
}
-(void)setViewKeyboardHidden
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        CGRect commentFrame = self.commentFrame;
        commentFrame.size.height = self.viewPublish.height;
        commentFrame.origin.y = APP_FRAME_HEIGHT;
        [self.viewPublish setViewFrame:commentFrame];
    } completion:^(BOOL finished) {
        CGRect mainFrame = self.mainFrame;
        mainFrame.size.height = APP_FRAME_HEIGHT-APP_TOP_HEIGHT-APP_PLAY_HEIGHT;
        
        [self.tvMain setFrame:mainFrame];
        
        [self.viewPublish setAlpha:0];
        [self.viewPublish setHidden:YES];
    }];
}
///评论成功刷新数据
-(void)setRefreshData
{
    if (self.pageNum == 1) {
        ZWEAKSELF
        NSString *userId = [AppSetting getUserDetauleId];
        [sns getSpeechDetailWithSpeechId:self.modelP.ids userId:userId pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                
                [weakSelf setViewDataWithDictionary:dicResult];
            });
        } errorBlock:nil];
    }
}
///数据改变
-(void)setDataChangeWithModel:(ModelPractice *)modelPra
{
    ModelPractice *modelPLocal = [sqlite getLocalPracticeDetailModelWithId:modelPra.ids userId:[AppSetting getUserDetauleId]];
    if (modelPLocal) {
        [self setModelP:modelPLocal];
        [self.tvMain setViewDataWithModel:modelPLocal];
    } else {
        [self setModelP:modelPra];
        [self.tvMain setViewDataWithModel:modelPra];
    }
    [self setLastIds:self.modelP.ids];
    [self.tvMain setViewDataWithDictionary:nil];
    ZWEAKSELF
    NSString *userId = [AppSetting getUserDetauleId];
    [sns getSpeechDetailWithSpeechId:modelPra.ids userId:userId pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            
            [weakSelf setViewDataWithDictionary:dicResult];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayEnabledNotification object:@"YES"];
        });
    } errorBlock:nil];
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
///发布
-(void)btnPublishClick:(NSString *)content
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Practice_Detail_Comment];
    
    if ([AppSetting getAutoLogin]) {
        ZWEAKSELF
        [self setViewKeyboardHidden];
        if (self.isPublishing) { return; }
        self.isPublishing = YES;
        if (content.length == 0 || content.length > kNumberAnswerCommentMaxLength) {
            [ZProgressHUD showError:[NSString stringWithFormat:@"评论内容限制[1-%d]字符",kNumberAnswerCommentMaxLength]];
            self.isPublishing = NO;
            return;
        }
        [self.viewPublish setHidden:YES];
        [self.viewPublish setButtonState:YES];
        [sns postSaveCommentWithUserId:[AppSetting getUserDetauleId] content:content objId:self.modelP.ids type:@"1" resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setRefreshData];
                [weakSelf setIsPublishing:NO];
                [weakSelf.tvMain setFrame:weakSelf.mainFrame];
                [weakSelf.viewPublish setPublishSuccess];
                [ZProgressHUD showSuccess:@"评论成功"];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [weakSelf setIsPublishing:NO];
                [weakSelf.viewPublish setButtonState:NO];
                [ZProgressHUD showError:msg];
            });
        }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayShowViewNotification object:@"NO"];
        [self showLoginVC];
    }
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
        if (self.isPraiseing) { return; }
        [self setIsPraiseing:YES];
        ZWEAKSELF
        if (!self.modelP.isPraise) {
            NSString *ids = self.modelP.ids;
            //点赞
            [self.modelP setIsPraise:YES];
            [self.modelP setApplauds:self.modelP.applauds+1];
            [self.tvMain setViewDataWithModel:self.modelP];
            
            [self sendPracticeModelChange];
            
            [sns postClickLikeWithAId:ids userId:[AppSetting getUserDetauleId] type:@"4" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                    if ([ids isEqualToString:weakSelf.modelP.ids]) {
                        [weakSelf.modelP setIsPraise:NO];
                        [weakSelf.modelP setApplauds:weakSelf.modelP.applauds-1];
                        [weakSelf.tvMain setViewDataWithModel:weakSelf.modelP];
                        
                        [weakSelf sendPracticeModelChange];
                        
                        [ZProgressHUD showError:msg];
                    }
                });
            }];
        } else {
            NSString *ids = self.modelP.ids;
            //取消赞
            [self.modelP setIsPraise:NO];
            [self.modelP setApplauds:weakSelf.modelP.applauds-1];
            [self.tvMain setViewDataWithModel:self.modelP];
            
            [self sendPracticeModelChange];
            
            [sns postClickUnLikeWithAId:self.modelP.ids userId:[AppSetting getUserDetauleId] type:@"4" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsPraiseing:NO];
                    if ([ids isEqualToString:weakSelf.modelP.ids]) {
                        [weakSelf.modelP setIsPraise:YES];
                        [weakSelf.modelP setApplauds:weakSelf.modelP.applauds+1];
                        [weakSelf.tvMain setViewDataWithModel:weakSelf.modelP];
                        
                        [weakSelf sendPracticeModelChange];
                        
                        [ZProgressHUD showError:msg];
                    }
                });
            }];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayShowViewNotification object:@"NO"];
        [self showLoginVC];
    }
}
///收藏
-(void)btnCollectionClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Practice_Detail_Collection];
    
    if ([AppSetting getAutoLogin]) {
        if (self.isCollectioning) { return; }
        [self setIsCollectioning:YES];
        ZWEAKSELF
        if (!self.modelP.isCollection) {
            //收藏
            [self.modelP setIsCollection:YES];
            [self.modelP setCcount:self.modelP.ccount+1];
            [self.tvMain setViewDataWithModel:self.modelP];
            
            [self sendPracticeModelChange];
            
            NSString *ids = self.modelP.ids;
            
            [sns getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelP.ids flag:1 type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:@"收藏成功"];
                    [weakSelf setIsCollectioning:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:@"收藏失败"];
                    [weakSelf setIsCollectioning:NO];
                    if ([ids isEqualToString:weakSelf.modelP.ids]) {
                        [weakSelf.modelP setIsCollection:NO];
                        if (weakSelf.modelP.ccount > 0) {
                            [weakSelf.modelP setCcount:weakSelf.modelP.ccount-1];
                        }
                        [weakSelf.tvMain setViewDataWithModel:weakSelf.modelP];
                        
                        [weakSelf sendPracticeModelChange];
                        
                        [ZProgressHUD showError:msg];
                    }
                });
            }];
        } else {
            //取消赞
            [self.modelP setIsCollection:NO];
            if (self.modelP.ccount > 0) {
                [self.modelP setCcount:self.modelP.ccount-1];
            }
            [self.tvMain setViewDataWithModel:self.modelP];
            
            [self sendPracticeModelChange];
            
            NSString *ids = self.modelP.ids;
            
            [sns getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelP.ids type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:@"取消收藏成功"];
                    [weakSelf setIsCollectioning:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:@"取消收藏失败"];
                    [weakSelf setIsCollectioning:NO];
                    if ([ids isEqualToString:weakSelf.modelP.ids]) {
                        [weakSelf.modelP setIsCollection:YES];
                        [weakSelf.modelP setCcount:weakSelf.modelP.ccount+1];
                        [weakSelf.tvMain setViewDataWithModel:weakSelf.modelP];
                        
                        [weakSelf sendPracticeModelChange];
                        
                        [ZProgressHUD showError:msg];
                    }
                });
            }];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayShowViewNotification object:@"NO"];
        [self showLoginVC];
    }
    
}
///键盘高度
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    [self setKeyboardH:height];
    
    if (height >= kKeyboard_Min_Height) {
        [self.viewPublish setAlpha:0];
        [self.viewPublish setHidden:NO];
        CGRect commentFrame = self.commentFrame;
        commentFrame.size.height = self.viewPublish.height;
        commentFrame.origin.y = APP_FRAME_HEIGHT-self.keyboardH-commentFrame.size.height;
        ///超过导航栏了
        if (commentFrame.origin.y < APP_TOP_HEIGHT) {
            commentFrame.origin.y = APP_TOP_HEIGHT;
            commentFrame.size.height = APP_FRAME_HEIGHT-self.keyboardH-APP_TOP_HEIGHT;
        }
        [self.viewPublish setViewFrame:commentFrame];
        
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self.viewPublish setAlpha:1.0f];
        } completion:^(BOOL finished) {
            CGRect mainFrame = self.mainFrame;
            mainFrame.size.height = APP_FRAME_HEIGHT-height-commentFrame.size.height;;
            if (mainFrame.size.height < 0) {
                mainFrame.size.height = 0;
            }
            [self.tvMain setFrame:mainFrame];
        }];
    }
}
///更多分享
-(void)btnRightClick
{
    [self setViewKeyboardHidden];
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