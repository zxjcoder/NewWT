//
//  ZAnswerDetailViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/12/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAnswerDetailViewController.h"
#import "ZAnswerDetailTableView.h"
#import "ZCommentView.h"
#import "ZPictureViewerView.h"

#import "ZUserProfileViewController.h"
#import "ZPublishAnswerViewController.h"

@interface ZAnswerDetailViewController ()

@property (strong, nonatomic) ZAnswerDetailTableView *tvMain;

@property (strong, nonatomic) ZCommentView *viewComment;

@property (strong, nonatomic) ModelAnswerBase *modelAB;

@property (assign, nonatomic) CGRect tvFrame;
@property (assign, nonatomic) CGRect commentFrame;
///键盘高度
@property (assign, nonatomic) CGFloat keyboardH;
@property (assign, nonatomic) int pageNum;
///删除中
@property (assign, nonatomic) BOOL isDeleteing;
///发布评论中
@property (assign, nonatomic) BOOL isPublishing;
///同意中
@property (assign, nonatomic) BOOL isAgreeing;

@end

@implementation ZAnswerDetailViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"答案详情"];
    
    [self innerInit];
    
    [self registerPublishQuestionNotification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRightButtonWithShare];
    
    [self registerKeyboardNotification];
}

-(void)viewWillDisappear:(BOOL)animated
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
    [self removePublishQuestionNotification];
    
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_modelAB);
    
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.tvMain = [[ZAnswerDetailTableView alloc] init];
    ZWEAKSELF
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    [self.tvMain setOnAgreeClick:^(ModelAnswerBase *mdoel) {
        [weakSelf btnAgreeClick];
    }];
    [self.tvMain setOnImagePhotoClick:^(ModelAnswerBase *model) {
        if (![model.userId isEqualToString:[AppSetting getUserId]]) {
            //还在加载数据
            if (!weakSelf.isLoaded) {
                ModelUserBase *modelUB = [[ModelUserBase alloc] init];
                [modelUB setUserId:model.userId];
                [modelUB setNickname:model.nickname];
                [modelUB setHead_img:modelUB.head_img];
                [modelUB setSign:model.sign];
                [weakSelf showUserProfileVC:modelUB];
            }
        }
    }];
    [self.tvMain setOnCommentPhotoClick:^(ModelComment *model) {
        if (![model.userId isEqualToString:[AppSetting getUserId]]) {
            ModelUserBase *modelUB = [[ModelUserBase alloc] init];
            [modelUB setUserId:model.userId];
            [modelUB setNickname:model.nickname];
            [modelUB setHead_img:modelUB.head_img];
            [weakSelf showUserProfileVC:modelUB];
        }
    }];
    ///点击图片查看
    [self.tvMain setOnImageClick:^(UIImage *image, NSURL *imgUrl, CGSize size) {
        ZPictureViewerView *pvView = [[ZPictureViewerView alloc] init];
        [pvView setViewPictureUrlWithImageUrl:imgUrl defaultImage:image defaultSize:size];
        [pvView show];
    }];
    ///开始移动的时候
    [self.tvMain setOnOffsetChange:^(CGFloat y) {
        [weakSelf.view endEditing:YES];
    }];
    [self.view addSubview:self.tvMain];
    
    self.commentFrame = CGRectMake(0, APP_FRAME_HEIGHT-APP_INPUT_HEIGHT, APP_FRAME_WIDTH, APP_INPUT_HEIGHT);
    self.viewComment = [[ZCommentView alloc] initWithFrame:self.commentFrame];
    [self.viewComment setOnPublishClick:^(NSString *content) {
        [weakSelf btnPublishClick:content];
    }];
    [self.viewComment setOnViewHeightChange:^(CGFloat viewH) {
        CGRect commentFrame = weakSelf.viewComment.frame;
        CGRect mainFrame = weakSelf.tvFrame;
        commentFrame.origin.y = APP_FRAME_HEIGHT-weakSelf.keyboardH-viewH;
        commentFrame.size.height = viewH;
        
        mainFrame.size.height = mainFrame.size.height-weakSelf.keyboardH-commentFrame.size.height;;
        if (mainFrame.size.height < 0) {
            mainFrame.size.height = 0;
        }
        [weakSelf.tvMain setFrame:mainFrame];
        
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [weakSelf.viewComment setViewFrame:commentFrame];
        }];
    }];
    [self.view addSubview:self.viewComment];
    
    self.tvFrame = VIEW_ITEM_FRAME;
    CGRect mainFrame = self.tvFrame;
    mainFrame.size.height -= APP_INPUT_HEIGHT;
    [self.tvMain setFrame:mainFrame];
    
    [self innerData];
}

-(void)innerData
{
    self.isLoaded = YES;
    NSString *strLocalKey = [NSString stringWithFormat:@"AnswerDetailKey%@",self.modelAB.ids];
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:strLocalKey];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        
        self.isLoaded = NO;
        
        NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:dicLocal];
        [dicResult setObject:@"YES" forKey:kIsHeaderKey];
        [self setViewDataWithDictionary:dicResult];
        
    }
    ZWEAKSELF
    self.pageNum = 1;
    [sns getAnswerDetailWithAnswerId:self.modelAB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            
            weakSelf.isLoaded = NO;
            
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf setViewDataWithDictionary:dicResult];
            
            [sqlite setLocalCacheDataWithDictionary:result pathKay:strLocalKey];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.isLoaded = NO;
            [ZProgressHUD showError:msg];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
}

-(void)setRefreshData
{
    if (self.pageNum == 1) {
        ZWEAKSELF
        NSString *localKey = [NSString stringWithFormat:@"AnswerDetailKey%@",self.modelAB.ids];
        [sns getAnswerDetailWithAnswerId:self.modelAB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                [weakSelf setViewDataWithDictionary:dicResult];
                
                [sqlite setLocalCacheDataWithDictionary:result pathKay:localKey];
            });
        } errorBlock:nil];
    }
}

-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    NSString *localKey = [NSString stringWithFormat:@"AnswerDetailKey%@",self.modelAB.ids];
    [sns getAnswerDetailWithAnswerId:self.modelAB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
           
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf setViewDataWithDictionary:dicResult];
            
            [sqlite setLocalCacheDataWithDictionary:result pathKay:localKey];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
        });
    }];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    NSDictionary *dicAnswer = [dicResult objectForKey:@"resultAnswer"];
    if (dicAnswer && [dicAnswer isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dicA = [NSMutableDictionary dictionaryWithDictionary:dicAnswer];
        NSString *resultComCount = [dicResult objectForKey:@"resultComCount"];
        if (resultComCount && ![resultComCount isKindOfClass:[NSNull class]]) {
            [dicA setObject:resultComCount forKey:@"resultComCount"];
        }
        NSString *resultRpt = [dicResult objectForKey:@"resultRpt"];
        if (resultRpt && ![resultRpt isKindOfClass:[NSNull class]]) {
            [dicA setObject:resultRpt forKey:@"resultRpt"];
        }
        NSString *resultAld = [dicResult objectForKey:@"resultAld"];
        if (resultAld && ![resultAld isKindOfClass:[NSNull class]]) {
            [dicA setObject:resultAld forKey:@"resultAld"];
        }
        ModelAnswerBase *modelABase = [[ModelAnswerBase alloc] initWithCustom:dicA];
        [self setModelAB:modelABase];
        [self.tvMain setViewDataWithModel:modelABase];
    }
    
    [self.tvMain setViewDataWithDictionary:dicResult];
}

///问题信息变更
-(void)setPublishQuestion
{
    ZWEAKSELF
    NSString *localKey = [NSString stringWithFormat:@"AnswerDetailKey%@",self.modelAB.ids];
    [sns getAnswerDetailWithAnswerId:self.modelAB.ids userId:[AppSetting getUserDetauleId] pageNum:1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setPageNum:1];
            
            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
            [dicResult setObject:@"YES" forKey:kIsHeaderKey];
            [weakSelf setViewDataWithDictionary:dicResult];
            
            [sqlite setLocalCacheDataWithDictionary:result pathKay:localKey];
        });
    } errorBlock:nil];
}

-(void)setRefreshFooter
{
    ZWEAKSELF
    self.pageNum += 1;
    [sns getAnswerDetailWithAnswerId:self.modelAB.ids userId:[AppSetting getUserDetauleId] pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshFooter];
            NSArray *resultComment = [result objectForKey:kResultKey];
            if (resultComment && [resultComment isKindOfClass:[NSArray class]]) {
                [weakSelf.tvMain setViewDataWithDictionary:result];
            } else {
                weakSelf.pageNum -= 1;
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            weakSelf.pageNum -= 1;
            [weakSelf.tvMain endRefreshFooter];
        });
    }];
}
///发布评论
-(void)btnPublishClick:(NSString *)content
{
    if ([AppSetting getAutoLogin]) {
        //还在加载数据
        if (self.isLoaded) {
            return;
        }
        //TODO:ZWW备注-添加友盟统计事件
        [MobClick event:kEvent_Answer_Comment];
        ZWEAKSELF
        [self.view endEditing:YES];
        if (self.isPublishing) { return; }
        self.isPublishing = YES;
        if (content.length == 0 || content.length > kNumberAnswerCommentMaxLength) {
            [ZProgressHUD showError:@"评论内容限制[1-1000]字符" toView:self.view];
            return;
        }
        [self.viewComment setButtonState:YES];
        [sns postSaveCommentWithUserId:[AppSetting getUserDetauleId] content:content objId:self.modelAB.ids type:@"0" resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setRefreshData];
                [weakSelf setIsPublishing:NO];
                [ZProgressHUD showSuccess:@"评论成功" toView:weakSelf.view];
                [weakSelf.viewComment setPublishSuccess];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [weakSelf setIsPublishing:NO];
                [weakSelf.viewComment setButtonState:NO];
                [ZProgressHUD showError:msg toView:weakSelf.view];
            });
        }];
    } else {
        [self showLoginVC];
    }
}

-(void)setViewDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
}

-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    [self setKeyboardH:height];
    
    CGRect commentFrame = self.viewComment.frame;
    CGRect mainFrame = self.tvFrame;
    mainFrame.size.height = mainFrame.size.height-height-commentFrame.size.height;;
    commentFrame.origin.y = (APP_FRAME_HEIGHT-commentFrame.size.height-height);
    
    [self.tvMain setFrame:mainFrame];
    
    NSLogFrame(commentFrame);
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [ws.viewComment setViewFrame:commentFrame];
    }];
}
///同意
-(void)btnAgreeClick
{
    if ([AppSetting getAutoLogin]) {
        //还在加载数据
        if (self.isLoaded) {
            return;
        }
        //TODO:ZWW备注-添加友盟统计事件
        [MobClick event:kEvent_Answer_Agree];
        ZWEAKSELF
        if (self.isAgreeing) {return;}
        self.isAgreeing = YES;
        if (self.modelAB.isAgree == 0) {
            [sns postClickLikeWithAId:self.modelAB.ids userId:[AppSetting getUserDetauleId] type:@"2" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsAgreeing:NO];
                    [weakSelf.modelAB setIsAgree:1];
                    weakSelf.modelAB.agree += 1;
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelAB];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAgreeing:NO];
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelAB];
                });
            }];
        } else {
            [sns postClickUnLikeWithAId:self.modelAB.ids userId:[AppSetting getUserDetauleId] type:@"2" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsAgreeing:NO];
                    [weakSelf.modelAB setIsAgree:0];
                    weakSelf.modelAB.agree -= 1;
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelAB];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAgreeing:NO];
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelAB];
                });
            }];
        }
    } else {
        [self showLoginVC];
    }
}
///分享
-(void)btnRightClick
{
    //TODO:ZWW备注-添加友盟统计事件
    [MobClick event:kEvent_Answer_Share];
    //还在加载数据
    if (self.isLoaded) {
        return;
    }
    //TODO:ZWW备注-分享-答案详情
    NSString *userIDA = self.modelAB.userId;
    NSString *userId = [AppSetting getUserId];
    if ([userId isEqualToString:userIDA]) {
        ZWEAKSELF
        ZShareView *shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeEditA)];
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat:
                    [MobClick event:kEvent_Answer_Share_WeChat];
                    [weakSelf btnWeChatClick];
                    break;
                case ZShareTypeWeChatCircle:
                    [MobClick event:kEvent_Answer_Share_WeChatCircle];
                    [weakSelf btnWeChatCircleClick];
                    break;
                case ZShareTypeQQ:
                    [MobClick event:kEvent_Answer_Share_QQ];
                    [weakSelf btnQQClick];
                    break;
                case ZShareTypeQZone:
                    [MobClick event:kEvent_Answer_Share_QZone];
                    [weakSelf btnQZoneClick];
                    break;
                case ZShareTypeEditAnswer:
                    [MobClick event:kEvent_Answer_Edit];
                    [weakSelf btnEditClick];
                    break;
                case ZShareTypeDeleteAnswer:
                    [MobClick event:kEvent_Answer_Delete];
                    [weakSelf btnDeleteClick];
                    break;
                default: break;
            }
        }];
        [shareView show];
    } else {
        ZWEAKSELF
        // TODO:ZWW备注-1.0版本 无 举报, 1.1版本 有 举报
        ZShareView *shareView = nil;
        if ([Utils isVersion100]) {
            shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeNone)];
        } else {
            shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeReport)];
        }
        [shareView setOnItemClick:^(ZShareType shareType) {
            switch (shareType) {
                case ZShareTypeWeChat:
                    [MobClick event:kEvent_Answer_Share_WeChat];
                    [weakSelf btnWeChatClick];
                    break;
                case ZShareTypeWeChatCircle:
                    [MobClick event:kEvent_Answer_Share_WeChatCircle];
                    [weakSelf btnWeChatCircleClick];
                    break;
                case ZShareTypeQQ:
                    [MobClick event:kEvent_Answer_Share_QQ];
                    [weakSelf btnQQClick];
                    break;
                case ZShareTypeQZone:
                    [MobClick event:kEvent_Answer_Share_QZone];
                    [weakSelf btnQZoneClick];
                    break;
                case ZShareTypeReport:
                    [MobClick event:kEvent_Answer_Report];
                    [weakSelf btnReportClick];
                    break;
                default: break;
            }
        }];
        [shareView show];
    }
}
///举报
-(void)btnReportClick
{
    ZWEAKSELF
    [sns postAddReportWithUserId:[AppSetting getUserDetauleId] objId:self.modelAB.ids type:ZReportTypeAnswer content:nil resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [ZProgressHUD showSuccess:@"举报成功" toView:weakSelf.view];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZProgressHUD showError:msg toView:weakSelf.view];
        });
    }];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.title;
    NSString *content = self.modelAB.title.imgReplacing;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    UIImage *image = [UIImage imageNamed:@"Icon"];
    NSString *webUrl = kShare_AnswerInfoUrl(self.modelAB.question_id, self.modelAB.ids);
    [ShareManager shareWithTitle:title content:content imgObj:image webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) { }];
}
///编辑问题
-(void)btnEditClick
{
    if (self.modelAB.ids && [self.modelAB.ids integerValue] > 0) {
        ZPublishAnswerViewController *itemVC = [[ZPublishAnswerViewController alloc] init];
        [itemVC setPreVC:self];
        [itemVC setViewDataWithModel:self.modelAB];
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}
///删除问题
-(void)btnDeleteClick
{
    ZWEAKSELF
    if(self.isDeleteing) {return;}
    [ZAlertView showWithMessage:@"确定删除当前的答案吗?" doneCompletion:^{
        [weakSelf setIsDeleteing:YES];
        [ZProgressHUD showMessage:@"正在删除,请稍等..." toView:weakSelf.view];
        [sns postDeleteAnswerWithAnswerId:weakSelf.modelAB.ids userId:[AppSetting getUserDetauleId] resultBlock:^(NSDictionary *result) {
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


@end
