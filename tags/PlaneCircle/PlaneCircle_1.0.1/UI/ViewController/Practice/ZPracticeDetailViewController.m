//
//  ZPracticeDetailViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailViewController.h"
#import "ZPracticeDetailTableView.h"
//#import "ZPracticeDetailPlayView.h"
#import "ZPracticeDetailPublishView.h"
#import "ZPracticeDetailNavigationView.h"

#import "ZWebViewController.h"

@interface ZPracticeDetailViewController ()

///导航
@property (strong, nonatomic) ZPracticeDetailNavigationView *viewNavigation;
///主视图
@property (strong, nonatomic) ZPracticeDetailTableView *tvMain;
///发布评论
@property (strong, nonatomic) ZPracticeDetailPublishView *viewPublish;
///数据源
@property (strong, nonatomic) ModelPractice *modelP;

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
///定时器
@property (nonatomic, strong) NSTimer *timer;
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
    
    [self innerInit];
    //TODO:ZWW开启AppConfig配置
    ModelAppConfig *modelAC = [sqlite getLocalAppConfigModelWithId:APP_PROJECT_VERSION];
    if (modelAC && modelAC.appStatus == 1) {
        [self.viewNavigation setHiddenMore:NO];
    } else {
        [self.viewNavigation setHiddenMore:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPreRefreshData:) name:ZPlayPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNextRefreshData:) name:ZPlayNextNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayComment:) name:ZPlayCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayError:) name:ZPlayErrorNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardNotification];
    
    if (self.arrPractice.count > 0) {
        NSDictionary *dicParam = @{@"array":self.arrPractice,@"index":[NSString stringWithFormat:@"%ld",(long)self.arrRow]};
        [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayStartNotification object:dicParam];
    } else {
        if (self.modelP) {
            NSDictionary *dicParam = @{@"array":@[self.modelP],@"index":[NSString stringWithFormat:@"%d",0]};
            [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayStartNotification object:dicParam];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayShowViewNotification object:@"YES"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayShowViewNotification object:@"YES"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPlayEnabledNotification object:@"NO"];
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
    OBJC_RELEASE(_viewPublish);
    OBJC_RELEASE(_viewNavigation);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_timer);
    OBJC_RELEASE(_modelP);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.viewNavigation = [[ZPracticeDetailNavigationView alloc] initWithFrame:VIEW_NAVV_FRAME];
    [self.viewNavigation setViewTitle:self.modelP.title];
    [self.view addSubview:self.viewNavigation];
    
    self.commentFrame = CGRectMake(0, APP_FRAME_HEIGHT-APP_INPUT_HEIGHT, APP_FRAME_WIDTH, APP_INPUT_HEIGHT);
    self.viewPublish = [[ZPracticeDetailPublishView alloc] initWithFrame:self.commentFrame];
    [self.viewPublish setHidden:YES];
    [self.viewPublish setAlpha:0];
    [self.view addSubview:self.viewPublish];
    
    self.mainFrame = CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT-APP_INPUT_HEIGHT);
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
        [ZProgressHUD showError:@"播放文件错误"];
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
    CGFloat alp = y/64;
    alp = alp/2;
    if (alp < 0) {
        alp = 0;
    } else if (alp > 1) {
        alp = 1;
    }
    [self.viewNavigation setViewBGAlpha:alp];
}
///设置背景颜色
-(void)setNavigationBgColorWithAlpha:(CGFloat)a
{
    [self.viewNavigation setViewBGAlpha:a];
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
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)innerEvnet
{
    ZWEAKSELF
    /////////////////导航
    [self.viewNavigation setOnBackClick:^{
        [weakSelf btnBackClick];
    }];
    [self.viewNavigation setOnMoreClick:^{
        [weakSelf btnRightClick];
    }];
    [self.viewNavigation setOnViewClick:^{
        [weakSelf.view endEditing:YES];
    }];
    /////////////////主视图
    [self.tvMain setOnTextClick:^{
        [weakSelf btnTextClick];
    }];
    [self.tvMain setOnPraiseClick:^{
        [weakSelf btnPraiseClick];
    }];
    [self.tvMain setOnCollectionClick:^{
        [weakSelf btnCollectionClick];
    }];
    [self.tvMain setOnOffsetChange:^(CGFloat y) {
        [weakSelf.view endEditing:YES];
        [weakSelf setLastOffsetY:y];
        [weakSelf setNavigationBgColorWithOffsetY:y];
    }];
    ///评论头像点击
    [self.tvMain setOnCommentPhotoClick:^(ModelComment *model) {
        if (![model.userId isEqualToString:[AppSetting getUserId]]) {
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:model.userId];
            [modelUB setNickname:model.nickname];
            [weakSelf showUserProfileVC:modelUB];
        }
    }];
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
        [weakSelf.view endEditing:YES];
        
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            CGRect commentFrame = weakSelf.commentFrame;
            commentFrame.size.height = weakSelf.viewPublish.height;
            commentFrame.origin.y = APP_FRAME_HEIGHT- weakSelf.viewPublish.height;
            [weakSelf.viewPublish setViewFrame:commentFrame];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kANIMATION_TIME animations:^{
                [weakSelf.viewPublish setAlpha:0];
            } completion:^(BOOL finished) {
                CGRect mainFrame = weakSelf.mainFrame;
                mainFrame.size.height = APP_FRAME_HEIGHT-APP_PLAY_HEIGHT;
                [weakSelf.tvMain setFrame:mainFrame];
                [weakSelf.viewPublish setHidden:YES];
            }];
        }];
    }];
    ///评论内容高度改变
    [self.viewPublish setOnViewHeightChange:^(CGFloat viewH) {
        CGRect commentFrame = weakSelf.viewPublish.frame;
        CGRect mainFrame = weakSelf.mainFrame;
        commentFrame.origin.y = APP_FRAME_HEIGHT-weakSelf.keyboardH-viewH;
        commentFrame.size.height = viewH;
        
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
            
            [weakSelf setViewDataWithDictionary:result];
            
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
        [self.view endEditing:YES];
        if (self.isPublishing) { return; }
        self.isPublishing = YES;
        if (content.length == 0 || content.length > kNumberAnswerCommentMaxLength) {
            [ZProgressHUD showError:@"评论内容限制[1-1000]字符" toView:self.view];
            return;
        }
        [self.viewPublish setButtonState:YES];
        [sns postSaveCommentWithUserId:[AppSetting getUserDetauleId] content:content objId:self.modelP.ids type:@"1" resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setRefreshData];
                [weakSelf setIsPublishing:NO];
                [weakSelf.viewPublish setPublishSuccess];
                [ZProgressHUD showSuccess:@"评论成功" toView:weakSelf.view];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [weakSelf setIsPublishing:NO];
                [weakSelf.viewPublish setButtonState:NO];
                [ZProgressHUD showError:msg toView:weakSelf.view];
            });
        }];
    } else {
        [self showLoginVC];
    }
}
///文本点击事件
-(void)btnTextClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Practice_Detail_Text];
    
    ZWebViewController *itemVC = [[ZWebViewController alloc] init];
    [itemVC setWebUrl:kApp_PracticeContentUrl(self.modelP.ids)];
    [itemVC setBottomHeight:APP_PLAY_HEIGHT];
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
                        
                        [ZProgressHUD showError:msg toView:weakSelf.view];
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
                        
                        [ZProgressHUD showError:msg toView:weakSelf.view];
                    }
                });
            }];
        }
    } else {
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
                    [ZProgressHUD showSuccess:@"收藏成功" toView:weakSelf.view];
                    [weakSelf setIsCollectioning:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:@"收藏失败" toView:weakSelf.view];
                    [weakSelf setIsCollectioning:NO];
                    if ([ids isEqualToString:weakSelf.modelP.ids]) {
                        [weakSelf.modelP setIsCollection:NO];
                        [weakSelf.modelP setCcount:weakSelf.modelP.ccount-1];
                        [weakSelf.tvMain setViewDataWithModel:weakSelf.modelP];
                        
                        [weakSelf sendPracticeModelChange];
                        
                        [ZProgressHUD showError:msg toView:weakSelf.view];
                    }
                });
            }];
        } else {
            //取消赞
            [self.modelP setIsCollection:NO];
            [self.modelP setCcount:self.modelP.ccount-1];
            [self.tvMain setViewDataWithModel:self.modelP];
            
            [self sendPracticeModelChange];
            
            NSString *ids = self.modelP.ids;
            
            [sns getDelCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelP.ids type:@"3" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:@"取消收藏成功" toView:weakSelf.view];
                    [weakSelf setIsCollectioning:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:@"取消收藏失败" toView:weakSelf.view];
                    [weakSelf setIsCollectioning:NO];
                    if ([ids isEqualToString:weakSelf.modelP.ids]) {
                        [weakSelf.modelP setIsCollection:YES];
                        [weakSelf.modelP setCcount:weakSelf.modelP.ccount+1];
                        [weakSelf.tvMain setViewDataWithModel:weakSelf.modelP];
                        
                        [weakSelf sendPracticeModelChange];
                        
                        [ZProgressHUD showError:msg toView:weakSelf.view];
                    }
                });
            }];
        }
    } else {
        [self showLoginVC];
    }
    
}
///键盘高度
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    
    [self setKeyboardH:height];
    
    CGRect commentFrame = self.viewPublish.frame;
    
    commentFrame.origin.y = (APP_FRAME_HEIGHT-commentFrame.size.height-height);
    
    CGRect mainFrame = self.mainFrame;
    mainFrame.size.height = APP_FRAME_HEIGHT-commentFrame.size.height-height;
    
    if (height == 0) { [self.tvMain setFrame:mainFrame]; }
    
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.viewPublish setViewFrame:commentFrame];
    } completion:^(BOOL finished) {
        [self.tvMain setFrame:mainFrame];
    }];
}
///更多分享
-(void)btnRightClick
{
    //TODO:ZWW备注-分享-实务详情
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Practice_Detail_Share];
    ZWEAKSELF
    // TODO:ZWW备注-1.0版本 无 有道云笔记和印象笔记, 1.1版本 有 有道云笔记和印象笔记
    ZShareView *shareView = nil;
    if ([Utils isVersion100]) {
        shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
    } else {
        shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypePractice)];
    }
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
            case ZShareTypeYingXiang:
                [MobClick event:kEvent_Practice_Detail_Share_YouDao];
                [weakSelf btnYingXiangClick];
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
    NSString *imageUrl = self.modelP.speech_img;
    NSString *webUrl = kShare_VoiceUrl(self.modelP.ids);
    [ShareManager shareWithTitle:title content:content imageUrl:imageUrl webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) { }];
}
///有道云笔记
-(void)btnYouDaoClick
{
    [self shareNotePlatform:SSDKPlatformTypeYouDaoNote];
}
///印象笔记
-(void)btnYingXiangClick
{
    [self shareNotePlatform:SSDKPlatformTypeYinXiang];
}
///分享笔记平台
-(void)shareNotePlatform:(SSDKPlatformType)type
{
    SSDKImage *image = [[SSDKImage alloc] initWithURL:[NSURL URLWithString:self.modelP.speech_img]];
    NSString *content = kApp_PracticeContentUrl(self.modelP.ids);
    SSUIShareContentEditorViewController *shareVC = [ShareSDKUI contentEditorViewWithContent:content image:image platformTypes:@[@(type)]];
    [shareVC onSubmit:^(NSArray *platforms, NSString *content, SSDKImage *image) {
        
    }];
    [shareVC show];
}
-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self setModelP:model];
}

-(void)setViewDataWithArray:(NSArray *)arr arrDefaultRow:(NSInteger)row
{
    [self setArrRow:row];
    [self setArrPractice:arr];
}

@end
