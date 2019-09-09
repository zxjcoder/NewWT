//
//  ZQuestionDetailViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionDetailViewController.h"
#import "ZQuestionDetailTableView.h"
#import "ZTopicListViewController.h"
#import "ZUserProfileViewController.h"
#import "ZInvitationUserViewController.h"
#import "ZCircleQuestionViewController.h"
#import "ZQuestionEditViewController.h"
#import "ZPublishAnswerViewController.h"

@interface ZQuestionDetailViewController ()

@property (strong, nonatomic) ZQuestionDetailTableView *tvMain;

@property (strong, nonatomic) ModelQuestionBase *modelB;

@property (strong, nonatomic) ModelQuestionDetail *modelD;

@property (assign, nonatomic) int pageNum;
@property (assign, nonatomic) BOOL isAtting;
@property (assign, nonatomic) BOOL isDeleteing;
///最后一次选择的问题
@property (assign, nonatomic) NSInteger lastAnswer;
///最后一次问题选择对象
@property (strong, nonatomic) ModelAnswerBase *modelABLast;

@end

@implementation ZQuestionDetailViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:[NSString stringWithFormat:kAnswerToNumber, 0]];
    
    [self innerInit];
    
    [self registerPublishQuestionNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRefreshQuestionData];
    
    [self setRightShareButton];
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
    [self removePublishQuestionNotification];
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_modelB);
    OBJC_RELEASE(_modelD);
    OBJC_RELEASE(_modelABLast);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.tvMain = [[ZQuestionDetailTableView alloc] init];
    [self.tvMain setFrame:VIEW_ITEM_FRAME];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf refreshHeader];
    }];
    //刷新
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf refreshFooter];
    }];
    //回答选择
    [self.tvMain setOnRowSelected:^(ModelAnswerBase *model, NSInteger row) {
        [weakSelf setLastAnswer:row];
        [weakSelf setModelABLast:model];
        [weakSelf showAnswerDetailVC:model];
    }];
    //话题点击
    [self.tvMain setOnTopicSelected:^(ModelTag *model) {
        ZTopicListViewController *itemVC = [[ZTopicListViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    //添加回答
    [self.tvMain setOnAddAnswerClick:^(ModelQuestionDetail *model) {
        [weakSelf btnAddAnswerClick:model];
    }];
    //关注问题
    [self.tvMain setOnAttentionClick:^(ModelQuestionDetail *model) {
        [weakSelf btnAttentionClick:model];
    }];
    //用户头像
    [self.tvMain setOnImagePhotoClick:^(ModelUserBase *model) {
        if (![Utils isMyUserId:model.userId]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
    //邀请回答
    [self.tvMain setOnInvitationClick:^(ModelQuestionDetail *model) {
        [weakSelf btnInvitationClick:model];
    }];
    [self.view addSubview:self.tvMain];
    
    [self innerData];
    
    [super innerInit];
}
///加载数据
-(void)innerData
{
    NSString *strLocalKey = [NSString stringWithFormat:@"QuestionDetailKey%@",self.modelB.ids];
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:strLocalKey];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:dicLocal];
        [self setQuestionModelWithDictionary:dicLocal];
        [dicResult setObject:@"YES" forKey:kIsHeaderKey];
        [self.tvMain setViewDataWithDictionary:dicResult];
    }
}
///刷新问题数据对象
-(void)setRefreshQuestionData
{
    ZWEAKSELF
    self.pageNum = 1;
    NSString *strLocalKey = [NSString stringWithFormat:@"QuestionDetailKey%@",self.modelB.ids];
    [snsV1 getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [sqlite setLocalCacheDataWithDictionary:result pathKay:strLocalKey];
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [weakSelf setQuestionModelWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvMain setViewDataWithDictionary:dicResult];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZAlertView showWithMessage:msg completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        });
    }];
}
///问题信息改变
-(void)setPublishQuestion
{
    ZWEAKSELF
    NSString *strLocalKey = [NSString stringWithFormat:@"QuestionDetailKey%@",self.modelB.ids];
    [snsV1 getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [weakSelf setQuestionModelWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvMain setViewDataWithDictionary:dicResult];
            [weakSelf setPageNum:1];
            
            [sqlite setLocalCacheDataWithDictionary:result pathKay:strLocalKey];
            
        });
    } errorBlock:nil];
}
///设置问题数据源
-(void)setQuestionModelWithDictionary:(NSDictionary *)dicResult
{
    NSDictionary *dicQ = [dicResult objectForKey:@"resultQuestion"];
    if (dicQ) {
        NSMutableDictionary *dicQD = [NSMutableDictionary dictionaryWithDictionary:dicQ];
        NSString *resultAtten = [dicResult objectForKey:@"resultAtten"];
        if (resultAtten) {
            [dicQD setObject:resultAtten forKey:@"resultAtten"];
        }
        NSString *answerQuestion = [dicResult objectForKey:@"answer"];
        if (answerQuestion) {
            [dicQD setObject:answerQuestion forKey:@"answer"];
        }
        NSString *resultAttention = [dicResult objectForKey:@"resultAttention"];
        if (resultAttention) {
            [dicQD setObject:resultAttention forKey:@"resultAttention"];
        }
        NSString *reusltAncount = [dicResult objectForKey:@"reusltAncount"];
        if (reusltAncount) {
            [dicQD setObject:reusltAncount forKey:@"reusltAncount"];
        }
        NSString *reusltInvite = [dicResult objectForKey:@"reusltInvite"];
        if (reusltInvite) {
            [dicQD setObject:reusltInvite forKey:@"reusltInvite"];
        }
        NSArray *arrTopic = [dicResult objectForKey:@"resultArt"];
        if ([arrTopic isKindOfClass:[NSArray class]]) {
            [dicQD setObject:arrTopic forKey:@"resultArt"];
        }
        ModelQuestionDetail *modelD = [[ModelQuestionDetail alloc] initWithCustom:dicQD];
        [self setModelD:modelD];

        if (self.modelD.answerCount > kNumberMaxCount) {
            [self setTitle:[NSString stringWithFormat:kAnswerToNumber, kNumberMaxCount]];
        } else {
            [self setTitle:[NSString stringWithFormat:kAnswerToNumber, (long)self.modelD.answerCount]];
        }
        
        [self.tvMain setViewDataWithModel:modelD];
    }
}
///刷新顶部数据
-(void)refreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV1 getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [weakSelf setQuestionModelWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvMain setViewDataWithDictionary:dicResult];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
        });
    }];
}
///刷新底部数据
-(void)refreshFooter
{
    ZWEAKSELF
    [snsV1 getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum+1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            [weakSelf.tvMain endRefreshFooter];
            [weakSelf setQuestionModelWithDictionary:result];
            [weakSelf.tvMain setViewDataWithDictionary:result];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}
///关注问题
-(void)btnAttentionClick:(ModelQuestionDetail *)model
{
    [StatisticsManager event:kQuestion_Attention];
    if ([AppSetting getAutoLogin]) {
        if (self.isAtting) {return;}
        [self setIsAtting:YES];
        
        ZWEAKSELF
        if (model.isAtt) {
            [snsV1 postDeleteAttentionWithAId:self.modelD.ids userId:[AppSetting getUserDetauleId] type:@"0" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf.modelD setIsAtt:NO];
                    weakSelf.modelD.attCount -= 1;
                    if (weakSelf.modelD.attCount <= 0) {
                        weakSelf.modelD.attCount = 0;
                    }
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelD];
                    
                    [weakSelf setIsAtting:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAtting:NO];
                });
            }];
        } else {
            [snsV1 postAddAttentionWithuserId:[AppSetting getUserDetauleId] hisId:self.modelD.ids type:@"0" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf.modelD setIsAtt:YES];
                    [weakSelf postPublishQuestionNotification];
                    weakSelf.modelD.attCount += 1;
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelD];
                    [weakSelf setIsAtting:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAtting:NO];
                });
            }];
        }
    } else {
        [self showLoginVC];
    }
}
///邀请回答问题
-(void)btnInvitationClick:(ModelQuestionDetail *)model
{
    [StatisticsManager event:kQuestion_InvitationAnswer];
    if ([AppSetting getAutoLogin]) {
        if (self.modelD.ids && [self.modelD.ids integerValue] > 0) {
            ZInvitationUserViewController *itemVC = [[ZInvitationUserViewController alloc] init];
            [itemVC setViewDataWithModel:model];
            [self.navigationController pushViewController:itemVC animated:YES];
        }
    } else {
        [self showLoginVC];
    }
}
///添加问题回答
-(void)btnAddAnswerClick:(ModelQuestionDetail *)model
{
    [StatisticsManager event:kQuestion_AddAnswer];
    if ([AppSetting getAutoLogin]) {
        ///已经获取到问题了
        if (self.modelD.ids && [self.modelD.ids integerValue] > 0) {
            ///已经回答过了
            if (model.answerQuestion && [model.answerQuestion integerValue] > 0) {
                ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
                [modelAB setQuestion_id:model.ids];
                [modelAB setIds:model.answerQuestion];
                [self showAnswerDetailVC:modelAB];
            } else {
                ZPublishAnswerViewController *itemVC = [[ZPublishAnswerViewController alloc] init];
                ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
                [modelAB setQuestion_id:model.ids];
                [modelAB setUserIdQ:model.userId];
                [itemVC setPreVC:self];
                [itemVC setViewDataWithModel:modelAB];
                [self.navigationController pushViewController:itemVC animated:YES];
            }
        }
    } else {
        [self showLoginVC];
    }
}
///查看问题回答
-(void)btnSeeAnswerClick:(ModelQuestionDetail *)model
{
    if ([AppSetting getAutoLogin]) {
        ModelAnswerBase *modelAB = [[ModelAnswerBase alloc] init];
        [modelAB setIds:model.answerQuestion];
        [modelAB setQuestion_id:model.ids];
        [self showAnswerDetailVC:modelAB];
    } else {
        [self showLoginVC];
    }
}
///分享
-(void)btnShareClick
{
    NSString *userIDQ = self.modelD.userId;
    NSString *userId = [AppSetting getUserDetauleId];
    ZShareView *shareView = nil;
    if ([userId isEqualToString:userIDQ]) {
        shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeEditQ)];
    } else {
        shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeReport)];
    }
    ZWEAKSELF
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat:
                [StatisticsManager event:kQuestion_Share_Wechat];
                [weakSelf btnWeChatClick];
                break;
            case ZShareTypeWeChatCircle:
                [StatisticsManager event:kQuestion_Share_WechatCircle];
                [weakSelf btnWeChatCircleClick];
                break;
            case ZShareTypeQQ:
                [StatisticsManager event:kQuestion_Share_QQ];
                [weakSelf btnQQClick];
                break;
            case ZShareTypeQZone:
                [StatisticsManager event:kQuestion_Share_QZone];
                [weakSelf btnQZoneClick];
                break;
            case ZShareTypeEditQuestion:
                [weakSelf btnEditClick];
                break;
            case ZShareTypeDeleteQuestion:
                [StatisticsManager event:kQuestion_Delete];
                [weakSelf btnDeleteClick];
                break;
            case ZShareTypeReport:
                [weakSelf btnReportClick];
                break;
            default: break;
        }
    }];
    [shareView show];
}
///举报
-(void)btnReportClick
{
    [self btnReportClickWithId:self.modelB.ids type:ZReportTypeQuestion];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.modelD.title;
    if (title.length > kShareTitleLength) { title = [title substringToIndex:kShareTitleLength]; }
    NSString *content = self.modelD.qContent;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    UIImage *image = [UIImage imageNamed:@"Icon"];
    NSString *webUrl = kShare_QuestionInfoUrl(self.modelD.ids);
    [ShareManager shareWithTitle:title content:content imgObj:image webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        }
    }];
}
///设置新回答数据
-(void)setNewAnswerWithAnswerId:(NSString *)answerId
{
    ZWEAKSELF
    NSString *strLocalKey = [NSString stringWithFormat:@"QuestionDetailKey%@",self.modelB.ids];
    if (self.pageNum == 1) {
        [snsV1 getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [sqlite setLocalCacheDataWithDictionary:result pathKay:strLocalKey];
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [weakSelf setQuestionModelWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                [weakSelf.tvMain setViewDataWithDictionary:dicResult];
            });
        } errorBlock:nil];
    }
    [self.modelD setAnswerQuestion:answerId];
    [self.tvMain addViewDataWithAnswerId:answerId];
}
///编辑问题
-(void)btnEditClick
{
    if (self.modelD.ids && [self.modelD.ids integerValue] > 0) {
        ZQuestionEditViewController *itemVC = [[ZQuestionEditViewController alloc] init];
        [itemVC setViewDataWithModel:self.modelD];
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}
-(void)setDeleteQuestion:(ModelQuestionBase *)model
{
    
}
///删除问题
-(void)btnDeleteClick
{
    if(self.isDeleteing) {return;}
    ZWEAKSELF
    [ZAlertView showWithMessage:kCMsgDoneDeleteQuestion doneCompletion:^{
        [weakSelf setIsDeleteing:YES];
        [ZProgressHUD showMessage:kCMsgDeleting];
        [snsV1 postDeleteQuestionWithUserId:[AppSetting getUserDetauleId] questionId:weakSelf.modelD.ids resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setIsDeleteing:NO];
                [ZProgressHUD dismiss];
                [ZProgressHUD showSuccess:kCMsgQuestionDeleteSuccess];
                [weakSelf postPublishQuestionNotification];
                if (weakSelf.preVC != nil) {
                    [weakSelf.preVC performSelector:@selector(setDeleteQuestion:) withObject:weakSelf.modelB afterDelay:NO];
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [weakSelf setIsDeleteing:NO];
                [ZProgressHUD dismiss];
                [ZProgressHUD showSuccess:msg];
            });
        }];
    }];
}
-(void)setViewDataWithModel:(ModelQuestionBase *)model
{
    [self setModelB:model];
}

@end
