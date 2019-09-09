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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"?个答案"];
    
    [self innerInit];
    
    [self registerPublishQuestionNotification];
    
    [self registerLoginChangeNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithShare];
}

- (void)setViewFrame
{
    [self.tvMain setFrame:VIEW_ITEM_FRAME];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (!self.isViewLoaded && self.view.window) {
        [self setViewNil];
    }
}

-(void)setViewNil
{
    [self removePublishQuestionNotification];
    [self removeLoginChangeNotification];
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_modelB);
    OBJC_RELEASE(_modelD);
    OBJC_RELEASE(_modelABLast);
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    ZWEAKSELF
    self.tvMain = [[ZQuestionDetailTableView alloc] init];
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf refreshHeader];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf refreshFooter];
    }];
    [self.tvMain setOnRowSelected:^(ModelAnswerBase *model, NSInteger row) {
        [weakSelf setLastAnswer:row];
        [weakSelf setModelABLast:model];
        [weakSelf showAnswerDetailVC:model];
    }];
    [self.tvMain setOnTopicSelected:^(ModelTag *model) {
        ZTopicListViewController *itemVC = [[ZTopicListViewController alloc] init];
        [itemVC setViewDataWithModel:model];
        [weakSelf.navigationController pushViewController:itemVC animated:YES];
    }];
    [self.tvMain setOnAddAnswerClick:^(ModelQuestionDetail *model) {
        [weakSelf btnAddAnswerClick:model];
    }];
    [self.tvMain setOnAttentionClick:^(ModelQuestionDetail *model) {
        [weakSelf btnAttentionClick:model];
    }];
    [self.tvMain setOnImagePhotoClick:^(ModelUserBase *model) {
        if (![model.userId isEqualToString:[AppSetting getUserId]]) {
            [weakSelf showUserProfileVC:model];
        }
    }];
    [self.tvMain setOnInvitationClick:^(ModelQuestionDetail *model) {
        [weakSelf btnInvitationClick:model];
    }];
    [self.view addSubview:self.tvMain];
    
    [self setViewFrame];
    
    [self innerData];
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
    ZWEAKSELF
    self.pageNum = 1;
    [sns getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [sqlite setLocalCacheDataWithDictionary:result pathKay:strLocalKey];
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [weakSelf setQuestionModelWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvMain setViewDataWithDictionary:dicResult];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD showError:msg];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
}
-(void)setUserInfoChange
{
    ZWEAKSELF
    NSString *strLocalKey = [NSString stringWithFormat:@"QuestionDetailKey%@",self.modelB.ids];
    [sns getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:1 resultBlock:^(NSDictionary *result) {
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
///问题信息改变
-(void)setPublishQuestion
{
    ZWEAKSELF
    NSString *strLocalKey = [NSString stringWithFormat:@"QuestionDetailKey%@",self.modelB.ids];
    [sns getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [weakSelf setQuestionModelWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf.tvMain setViewDataWithDictionary:dicResult];
            [weakSelf setPageNum:1];
            
            [sqlite setLocalCacheDataWithDictionary:result pathKay:strLocalKey];
            
        });
    } errorBlock:nil];
    /*
    if (self.pageNum == 1) {
        [sns getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:1 resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [weakSelf setQuestionModelWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                [weakSelf.tvMain setViewDataWithDictionary:dicResult];
                [weakSelf setPageNum:1];
                
                [sqlite setLocalCacheDataWithDictionary:result pathKay:strLocalKey];
                
            });
        } errorBlock:nil];
    } else {
        [sns getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:1 resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setQuestionModelWithDictionary:result];
                
                [sqlite setLocalCacheDataWithDictionary:result pathKay:strLocalKey];
            });
        } errorBlock:nil];
    }
     */
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
            [self setViewTitle:[NSString stringWithFormat:@"%d个答案",kNumberMaxCount]];
        } else {
            [self setViewTitle:[NSString stringWithFormat:@"%ld个答案",self.modelD.answerCount]];
        }
        
        [self.tvMain setViewDataWithModel:modelD];
    }
}
///刷新顶部数据
-(void)refreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [sns getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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
    self.pageNum += 1;
    [sns getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
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
    if ([AppSetting getAutoLogin]) {
        if (self.isAtting) {return;}
        [self setIsAtting:YES];
        ZWEAKSELF
        if (model.isAtt) {
            [sns postDeleteAttentionWithAId:self.modelD.ids userId:[AppSetting getUserDetauleId] type:@"0" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf.modelD setIsAtt:NO];
                    [weakSelf postPublishQuestionNotificationWithIndex:ZCircleToolViewItemAtt];
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelD];
                    [weakSelf setIsAtting:NO];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAtting:NO];
                });
            }];
        } else {
            [sns postAddAttentionWithuserId:[AppSetting getUserDetauleId] hisId:self.modelD.ids type:@"0" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf.modelD setIsAtt:YES];
                    [weakSelf postPublishQuestionNotification];
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
-(void)btnRightClick
{
    //TODO:ZWW备注-分享-问题详情
    NSString *userIDQ = self.modelD.userId;
    NSString *userId = [AppSetting getUserId];
    if ([userId isEqualToString:userIDQ]) {
        ZWEAKSELF
        ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeEditQ)];
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat: [weakSelf btnWeChatClick]; break;
                case ZShareTypeWeChatCircle: [weakSelf btnWeChatCircleClick]; break;
                case ZShareTypeQQ: [weakSelf btnQQClick]; break;
                case ZShareTypeQZone: [weakSelf btnQZoneClick]; break;
                case ZShareTypeEditQuestion: [weakSelf btnEditClick]; break;
                case ZShareTypeDeleteQuestion: [weakSelf btnDeleteClick]; break;
                default: break;
            }
        }];
        [shareView show];
    } else {
        ZWEAKSELF
        ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat: [weakSelf btnWeChatClick]; break;
                case ZShareTypeWeChatCircle: [weakSelf btnWeChatCircleClick]; break;
                case ZShareTypeQQ: [weakSelf btnQQClick]; break;
                case ZShareTypeQZone: [weakSelf btnQZoneClick]; break;
                default: break;
            }
        }];
        [shareView show];
    }
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
    [ShareManager shareWithTitle:title content:content imgObj:image webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) { }];
}
///设置新回答数据
-(void)setNewAnswerWithAnswerId:(NSString *)answerId
{
    ZWEAKSELF
    NSString *strLocalKey = [NSString stringWithFormat:@"QuestionDetailKey%@",self.modelB.ids];
    if (self.pageNum == 1) {
        [sns getQuestionDetailWithQuestionId:self.modelB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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
///删除问题
-(void)btnDeleteClick
{
    if(self.isDeleteing) {return;}
    ZWEAKSELF
    [ZAlertView showWithMessage:@"确定删除当前的问题吗?" doneCompletion:^{
        [weakSelf setIsDeleteing:YES];
        [ZProgressHUD showMessage:@"正在删除,请稍等..." toView:weakSelf.view];
        [sns postDeleteQuestionWithUserId:[AppSetting getUserDetauleId] questionId:weakSelf.modelD.ids resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setIsDeleteing:NO];
                [ZProgressHUD dismissForView:weakSelf.view];
                [ZProgressHUD showSuccess:@"问题删除成功" toView:weakSelf.view];
                [weakSelf postPublishQuestionNotification];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [weakSelf setIsDeleteing:NO];
                [ZProgressHUD dismissForView:weakSelf.view];
                [ZProgressHUD showSuccess:msg toView:weakSelf.view];
            });
        }];
    }];
}
-(void)setViewDataWithModel:(ModelQuestionBase *)model
{
    [self setModelB:model];
}

@end
