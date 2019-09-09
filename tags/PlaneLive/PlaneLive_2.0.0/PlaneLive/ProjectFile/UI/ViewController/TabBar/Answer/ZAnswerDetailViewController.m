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
#import "IDMPhotoBrowser.h"

#import "ZUserProfileViewController.h"
#import "ZPublishAnswerViewController.h"

@interface ZAnswerDetailViewController ()<ZActionSheetDelegate>

@property (strong, nonatomic) ZAnswerDetailTableView *tvMain;

@property (strong, nonatomic) ZCommentView *viewComment;
///回答对象
@property (strong, nonatomic) ModelAnswerBase *modelAB;
///默认选中的评论
@property (strong, nonatomic) ModelAnswerComment *modelAC;
///当前选中的评论
@property (strong, nonatomic) ModelAnswerComment *modelLastAC;
///当前选中的回复
@property (strong, nonatomic) ModelCommentReply *modelLastCR;
///内容坐标
@property (assign, nonatomic) CGRect tvFrame;
///评论坐标
@property (assign, nonatomic) CGRect commentFrame;
///键盘高度
@property (assign, nonatomic) CGFloat keyboardH;
///分页
@property (assign, nonatomic) int pageNum;
///0评论答案,1回复对答案评论的内容,2回复对评论回复的内容
@property (assign, nonatomic) int commentType;
///是否评论答案
@property (assign, nonatomic) BOOL isComment;
///删除中
@property (assign, nonatomic) BOOL isDeleteing;
///发布评论中
@property (assign, nonatomic) BOOL isPublishing;
///收藏中
@property (assign, nonatomic) BOOL isCollectioning;
///同意中
@property (assign, nonatomic) BOOL isAgreeing;

@property (assign, nonatomic) NSInteger lastRow;

@end

@implementation ZAnswerDetailViewController

#pragma mark - SuperMethod

- (void)loadView
{
    [super loadView];
    
    [self setIsDismissPlay:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kAnwerDetail];
    
    [self innerInit];
    
    [self registerPublishQuestionNotification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRefreshAnswerData];
    
    [self registerKeyboardNotification];
    
    [self setRightShareButton];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
    
    [self.viewComment setKeyboardHidden];
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
    self.isComment = YES;
    self.lastRow = -1;
    ZWEAKSELF
    CGRect mainFrame = VIEW_ITEM_FRAME;
    mainFrame.size.height -= APP_INPUT_HEIGHT;
    self.tvFrame = mainFrame;
    self.tvMain = [[ZAnswerDetailTableView alloc] initWithFrame:self.tvFrame];
    ///刷新顶部数据
    [self.tvMain setOnRefreshHeader:^{
        [weakSelf setRefreshHeader];
    }];
    ///刷新底部数据
    [self.tvMain setOnRefreshFooter:^{
        [weakSelf setRefreshFooter];
    }];
    ///同意
    [self.tvMain setOnAgreeClick:^(ModelAnswerBase *mdoel) {
        [weakSelf btnAgreeClick];
    }];
    ///问题标题点击
    [self.tvMain setOnQuestionClick:^(ModelAnswerBase *model) {
        ModelQuestionBase *modelQB = [[ModelQuestionBase alloc] init];
        [modelQB setIds:model.question_id];
        [modelQB setTitle:model.question_title];
        [weakSelf showQuestionDetailVC:modelQB];
    }];
    ///答案详情点击头像
    [self.tvMain setOnImagePhotoClick:^(ModelAnswerBase *model) {
        if (![Utils isMyUserId:model.userId]) {
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
    ///评论区域头像点击
    [self.tvMain setOnCommentPhotoClick:^(ModelUserBase *model) {
        if (![Utils isMyUserId:model.userId]) {
            //还在加载数据
            if (!weakSelf.isLoaded) {
                [weakSelf showUserProfileVC:model];
            }
        }
    }];
    ///对回复内容点击事件
    [self.tvMain setOnReplyClick:^(ModelCommentReply *model, NSInteger row) {
        [weakSelf setModelLastCR:model];
        [weakSelf setLastRow:row];
        if ([Utils isMyUserId:model.user_id]) {
            //删除自己的回复
            [weakSelf.viewComment setKeyboardHidden];
            ZActionSheet *actionSheet = [[ZActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:kCancel destructiveButtonTitle:nil otherButtonTitles:@[kDelete]];
            [actionSheet setTag:12];
            [actionSheet show];
        } else {
            //回复内容
            [weakSelf setCommentType:2];
            [weakSelf setIsComment:NO];
            [weakSelf.viewComment setPlaceholderText:[NSString stringWithFormat:@"%@%@:", kReply, model.hnickname]];
            [weakSelf.viewComment setKeyboardShow];
            [weakSelf.tvMain setViewScrollToRowAtRow:row];
        }
    }];
    ///对评论内容点击事件
    [self.tvMain setOnCommentClick:^(ModelAnswerComment *model, NSInteger row) {
        [weakSelf.viewComment setKeyboardHidden];
        [weakSelf setModelLastAC:model];
        [weakSelf setLastRow:row];
        if ([Utils isMyUserId:model.userId]) {
            ZActionSheet *actionSheet = [[ZActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:kCancel destructiveButtonTitle:nil otherButtonTitles:@[kDelete]];
            [actionSheet setTag:11];
            [actionSheet show];
        } else {
            ZActionSheet *actionSheet = [[ZActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:kCancel destructiveButtonTitle:nil otherButtonTitles:@[kReplyComment, kReportComment]];
            [actionSheet setTag:10];
            [actionSheet show];
        }
    }];
    ///点击图片查看
    [self.tvMain setOnImageClick:^(UIImage *image, NSURL *imageUrl, NSInteger currentIndex, NSArray *arrImageUrl, CGSize size) {
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:[IDMPhoto photosWithURLs:arrImageUrl]];
        if (currentIndex < arrImageUrl.count) {
            [browser setInitialPageIndex:currentIndex];
        }
        browser.progressTintColor       = MAINCOLOR;
        [browser setDoneButtonImage:[UIImage imageNamed:@"btn_back1"]];
        [weakSelf presentViewController:browser animated:YES completion:nil];
    }];
    ///开始移动的时候
    [self.tvMain setOnOffsetChange:^(CGFloat y) {
        //[weakSelf.viewComment setKeyboardHidden];
        
        //[weakSelf setIsComment:YES];
        
        //[weakSelf actionSheetDidClickOnCancelButton];
    }];
    [self.view addSubview:self.tvMain];
    
    self.commentFrame = CGRectMake(0, APP_FRAME_HEIGHT-APP_INPUT_HEIGHT, APP_FRAME_WIDTH, APP_INPUT_HEIGHT);
    self.viewComment = [[ZCommentView alloc] initWithFrame:self.commentFrame];
    ///发布评论或者回复
    [self.viewComment setOnPublishClick:^(NSString *content) {
        [weakSelf btnPublishClick:content];
    }];
    ///结束编辑
    [self.viewComment setOnReturnText:^{
        [weakSelf setIsComment:YES];
        
        [weakSelf actionSheetDidClickOnCancelButton];
    }];
    ///输入框高度改变
    [self.viewComment setOnViewHeightChange:^(CGFloat viewH) {
        CGRect commentFrame = weakSelf.viewComment.frame;
        commentFrame.origin.y = APP_FRAME_HEIGHT-weakSelf.keyboardH-viewH;
        commentFrame.size.height = viewH;
        
        CGRect mainFrame = weakSelf.tvFrame;
        mainFrame.size.height = APP_FRAME_HEIGHT-APP_TOP_HEIGHT-weakSelf.keyboardH-commentFrame.size.height;;
        if (mainFrame.size.height < 0) {
            mainFrame.size.height = 0;
        }
        ///超过导航栏了
        if (commentFrame.origin.y < APP_TOP_HEIGHT) {
            commentFrame.origin.y = APP_TOP_HEIGHT;
            commentFrame.size.height = APP_FRAME_HEIGHT-weakSelf.keyboardH-APP_TOP_HEIGHT;
        }
        [weakSelf.tvMain setFrame:mainFrame];
        
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [weakSelf.viewComment setViewFrame:commentFrame];
        }];
    }];
    [self.view addSubview:self.viewComment];
    
    [self innerData];
    
    [super innerInit];
}
///初始化数据
-(void)innerData
{
    self.isLoaded = YES;
    ModelAnswerBase *modelAnswer = [sqlite getLocalAnswerDetailWithAnswerId:self.modelAB.ids userId:[AppSetting getUserDetauleId]];
    if (modelAnswer && [modelAnswer.ids integerValue] > 0) {
        self.isLoaded = NO;
        [self.tvMain setViewDataWithCommentArray:modelAnswer.commentArray modelAnswer:modelAnswer modelDefaultComment:nil isHeader:YES];
    }
}
///获取答案数据
-(void)setRefreshAnswerData
{
    ZWEAKSELF
    self.pageNum = 1;
    [DataOper130 getAnswerDetailWithAnswerId:self.modelAB.ids userId:[AppSetting getUserDetauleId] commentId:self.modelAC.ids pageNum:self.pageNum resultBlock:^(NSArray *arrComment, ModelAnswerBase *modelAnswer, ModelAnswerComment *modelDefaultComment, NSDictionary *dicResult) {
        GCDMainBlock(^{
            weakSelf.isLoaded = NO;
            if (modelAnswer) {
                [weakSelf setModelAB:modelAnswer];
                
                [weakSelf.tvMain setViewDataWithCommentArray:arrComment modelAnswer:modelAnswer modelDefaultComment:modelDefaultComment isHeader:YES];
                
                [sqlite setLocalAnswerDetailWithModel:modelAnswer commentArray:arrComment userId:[AppSetting getUserDetauleId]];
            } else {
                [ZProgressHUD showError:kCMsgGetAnswerDetailFail];
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [ZAlertView showWithMessage:msg completion:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        });
    }];
}
///刷新顶部数据
-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [DataOper130 getAnswerDetailWithAnswerId:self.modelAB.ids userId:[AppSetting getUserDetauleId] commentId:self.modelAC.ids pageNum:self.pageNum resultBlock:^(NSArray *arrComment, ModelAnswerBase *modelAnswer, ModelAnswerComment *modelDefaultComment, NSDictionary *dicResult) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
            
            weakSelf.isLoaded = NO;
            if (modelAnswer) {
                [weakSelf setModelAB:modelAnswer];
                
                [weakSelf.tvMain setViewDataWithCommentArray:arrComment modelAnswer:modelAnswer modelDefaultComment:modelDefaultComment isHeader:YES isScrollToRow:NO];
                
                [sqlite setLocalAnswerDetailWithModel:modelAnswer commentArray:arrComment userId:[AppSetting getUserDetauleId]];
            }
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf.tvMain endRefreshHeader];
        });
    }];
}
///刷新底部数据
-(void)setRefreshFooter
{
    ZWEAKSELF
    [DataOper130 getAnswerDetailWithAnswerId:self.modelAB.ids userId:[AppSetting getUserDetauleId] commentId:self.modelAC.ids pageNum:self.pageNum+1 resultBlock:^(NSArray *arrComment, ModelAnswerBase *modelAnswer, ModelAnswerComment *modelDefaultComment, NSDictionary *dicResult) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            
            [weakSelf.tvMain endRefreshFooter];
            
            [weakSelf.tvMain setViewDataWithCommentArray:arrComment modelAnswer:modelAnswer modelDefaultComment:modelDefaultComment isHeader:NO];
        });
    } errorBlock:^(NSString *msg) {
        GCDMainBlock(^{
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
        //添加统计事件
        [StatisticsManager event:kEvent_Answer_Comment category:kCategory_Answer];
        ZWEAKSELF
        if (self.isPublishing) { return; }
        self.isPublishing = YES;
        if (self.commentType == 0) {
            if (content.length == 0 || content.length > kNumberAnswerCommentMaxLength) {
                [ZProgressHUD showError:[NSString stringWithFormat:kCMsgCommentContentRestrictedCharacter,kNumberAnswerCommentMaxLength]];
                self.isPublishing = NO;
                return;
            }
            ///评论答案
            [self.viewComment setButtonState:YES];
            [DataOper postSaveCommentWithUserId:[AppSetting getUserDetauleId] content:content objId:self.modelAB.ids type:@"0" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [ZProgressHUD showSuccess:kCMsgCommentSuccess];
                    
                    [weakSelf setIsPublishing:NO];
                    
                    [weakSelf setIsComment:YES];
                    
                    [weakSelf setLastRow:-1];
                    
                    [weakSelf actionSheetDidClickOnCancelButton];
                    
                    [weakSelf.viewComment setPublishSuccess];
                    
                    ModelAnswerComment *modelAC = [[ModelAnswerComment alloc] init];
                    [modelAC setIds:[Utils getSNSString:[result objectForKey:@"resultCommentId"]]];
                    [modelAC setContent:content];
                    
                    ModelUserBase *modelUB = [AppSetting getUserLogin];
                    [modelAC setUserId:modelUB.userId];
                    [modelAC setNickname:modelUB.nickname];
                    [modelAC setHead_img:modelUB.head_img];
                    [modelAC setCreateTime:kJust];
                    [modelAC setStatus:0];
                    
                    [weakSelf.tvMain addViewAnswerComment:modelAC];
                    
                    [weakSelf.tvMain setFrame:weakSelf.tvFrame];
                    
                    [sqlite addLocalAnswerCommentWithModel:modelAC answerId:weakSelf.modelAB.ids];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [ZProgressHUD showError:msg];
                    
                    [weakSelf setIsPublishing:NO];
                    
                    [weakSelf.viewComment setButtonState:NO];
                });
            }];
        } else {
            if (content.length == 0 || content.length > kNumberAnswerCommentMaxLength) {
                [ZProgressHUD showError:[NSString stringWithFormat:kCMsgReplyContentRestrictedCharacter, kNumberAnswerCommentMaxLength]];
                self.isPublishing = NO;
                return;
            }
            if (self.commentType == 1) {
                ///回复对答案评论的内容
                [DataOper130 postCommentReplyWithUserId:[AppSetting getUserDetauleId] content:content replyUserId:self.modelLastAC.userId commentId:self.modelLastAC.ids parent_id:kZero resultBlock:^(NSDictionary *result) {
                    GCDMainBlock(^{
                        [ZProgressHUD showSuccess:kCMsgReplySuccess];
                        
                        [weakSelf setIsPublishing:NO];
                        
                        [weakSelf setIsComment:YES];
                        
                        [weakSelf setCommentType:0];
                        
                        [weakSelf setLastRow:-1];
                        
                        [weakSelf actionSheetDidClickOnCancelButton];
                        
                        [weakSelf.viewComment setPublishSuccess];
                        
                        ModelCommentReply *modelCR = [[ModelCommentReply alloc] init];
                        [modelCR setIds:[Utils getSNSString:[result objectForKey:@"resultComReplyId"]]];
                        [modelCR setContent:content];
                        [modelCR setCommentId:weakSelf.modelLastAC.ids];
                        ModelUserBase *modelUB = [AppSetting getUserLogin];
                        [modelCR setUser_id:modelUB.userId];
                        [modelCR setHnickname:modelUB.nickname];
                        [modelCR setParent_id:kZero];
                        
                        [weakSelf.tvMain addViewCommentReply:modelCR];
                        
                        [weakSelf.tvMain setFrame:weakSelf.tvFrame];
                        
                        [sqlite addLocalAnswerCommentReplyWithModel:modelCR commentId:modelCR.commentId];
                    });
                } errorBlock:^(NSString *msg) {
                    GCDMainBlock(^{
                        [ZProgressHUD showError:msg];
                        
                        [weakSelf setIsPublishing:NO];
                        
                        [weakSelf.viewComment setButtonState:NO];
                    });
                }];
            } else {
                ///回复对评论回复的内容
                [DataOper130 postCommentReplyWithUserId:[AppSetting getUserDetauleId] content:content replyUserId:self.modelLastCR.user_id commentId:self.modelLastCR.commentId parent_id:self.modelLastCR.ids resultBlock:^(NSDictionary *result) {
                    GCDMainBlock(^{
                        [ZProgressHUD showSuccess:kCMsgReplySuccess];
                        
                        [weakSelf setIsPublishing:NO];
                        
                        [weakSelf setIsComment:YES];
                        
                        [weakSelf setCommentType:0];
                        
                        [weakSelf setLastRow:-1];
                        
                        [weakSelf actionSheetDidClickOnCancelButton];
                        
                        [weakSelf.viewComment setPublishSuccess];
                        
                        ModelCommentReply *modelCR = [[ModelCommentReply alloc] init];
                        [modelCR setIds:[Utils getSNSString:[result objectForKey:@"resultComReplyId"]]];
                        [modelCR setContent:content];
                        [modelCR setCommentId:weakSelf.modelLastCR.commentId];
                        ModelUserBase *modelUB = [AppSetting getUserLogin];
                        [modelCR setUser_id:modelUB.userId];
                        [modelCR setHnickname:modelUB.nickname];
                        [modelCR setParent_id:weakSelf.modelLastCR.ids];
                        [modelCR setReply_user_id:weakSelf.modelLastCR.user_id];
                        [modelCR setNickname:weakSelf.modelLastCR.hnickname];
                        
                        [weakSelf.tvMain addViewCommentReply:modelCR];
                        
                        [weakSelf.tvMain setFrame:weakSelf.tvFrame];
                        
                        [sqlite addLocalAnswerCommentReplyWithModel:modelCR commentId:modelCR.commentId];
                    });
                } errorBlock:^(NSString *msg) {
                    GCDMainBlock(^{
                        [ZProgressHUD showError:msg];
                        
                        [weakSelf setIsPublishing:NO];
                        
                        [weakSelf.viewComment setButtonState:NO];
                    });
                }];
            }
        }
    } else {
        [self showLoginVC];
    }
}

-(void)setViewDataWithModel:(ModelAnswerBase *)model
{
    [self setModelAB:model];
}

-(void)setDefaultCommentModel:(ModelAnswerComment *)model
{
    [self setModelAC:model];
}
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    [self setKeyboardH:height];
    
    CGRect commentFrame = self.viewComment.frame;
    
    CGRect mainFrame = self.tvFrame;
    mainFrame.size.height = APP_FRAME_HEIGHT-APP_TOP_HEIGHT-height-commentFrame.size.height;;
    
    commentFrame.origin.y = (APP_FRAME_HEIGHT-commentFrame.size.height-height);
    
    [self.tvMain setFrame:mainFrame];
    
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
        //添加统计事件
        [StatisticsManager event:kEvent_Answer_Agree category:kCategory_Answer];
        ZWEAKSELF
        if (self.isAgreeing) {return;}
        self.isAgreeing = YES;
        if (self.modelAB.isAgree == 0) {
            [DataOper postClickLikeWithAId:self.modelAB.ids userId:[AppSetting getUserDetauleId] type:@"2" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsAgreeing:NO];
                    [weakSelf.modelAB setIsAgree:1];
                    weakSelf.modelAB.agree += 1;
                    
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelAB];
                    
                    [sqlite updLocalAnswerDetailWithModel:weakSelf.modelAB userId:[AppSetting getUserDetauleId]];
                });
            } errorBlock:^(NSString *msg) {
                GCDMainBlock(^{
                    [weakSelf setIsAgreeing:NO];
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelAB];
                });
            }];
        } else {
            [DataOper postClickUnLikeWithAId:self.modelAB.ids userId:[AppSetting getUserDetauleId] type:@"2" resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    [weakSelf setIsAgreeing:NO];
                    [weakSelf.modelAB setIsAgree:0];
                    weakSelf.modelAB.agree -= 1;
                    
                    [weakSelf.tvMain setViewDataWithModel:weakSelf.modelAB];
                    
                    [sqlite updLocalAnswerDetailWithModel:weakSelf.modelAB userId:[AppSetting getUserDetauleId]];
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
    //页面还在加载数据
    if (self.isLoaded) {
        return;
    }
    [self.viewComment setKeyboardHidden];
    //添加统计事件
    [StatisticsManager event:kEvent_Answer_Share category:kCategory_Answer];
    //TODO:ZWW备注-分享-答案详情
    NSString *userIDA = self.modelAB.userId;
    NSString *userId = [AppSetting getUserDetauleId];
    ZShareView *shareView = nil;
    if ([userId isEqualToString:userIDA]) {
        shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeEditA)];
    } else {
        if (self.modelAB.isCollection == 0) {
            shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeReportCollection)];
        } else {
            shareView = [[ZShareView alloc] initWithShowShareType:(ZShowShareTypeReport)];
        }
    }
    ZWEAKSELF
    [shareView setOnItemClick:^(ZShareType shareType) {
        switch (shareType) {
            case ZShareTypeWeChat:
                //添加统计事件
                [StatisticsManager event:kEvent_Answer_Share_WeChat category:kCategory_Answer];
                
                [weakSelf btnWeChatClick];
                break;
            case ZShareTypeWeChatCircle:
                //添加统计事件
                [StatisticsManager event:kEvent_Answer_Share_WeChatCircle category:kCategory_Answer];
                
                [weakSelf btnWeChatCircleClick];
                break;
            case ZShareTypeQQ:
                //添加统计事件
                [StatisticsManager event:kEvent_Answer_Share_QQ category:kCategory_Answer];
                
                [weakSelf btnQQClick];
                break;
            case ZShareTypeQZone:
                //添加统计事件
                [StatisticsManager event:kEvent_Answer_Share_QZone category:kCategory_Answer];
                
                [weakSelf btnQZoneClick];
                break;
            case ZShareTypeEditAnswer:
                //添加统计事件
                [StatisticsManager event:kEvent_Answer_Edit category:kCategory_Answer];
                
                [weakSelf btnEditClick];
                break;
            case ZShareTypeDeleteAnswer:
                //添加统计事件
                [StatisticsManager event:kEvent_Answer_Delete category:kCategory_Answer];
                
                [weakSelf btnDeleteClick];
                break;
            case ZShareTypeReport:
                //添加统计事件
                [StatisticsManager event:kEvent_Answer_Report category:kCategory_Answer];
                
                [weakSelf btnReportClick];
                break;
            case ZShareTypeCollection:
                //添加统计事件
                [StatisticsManager event:kEvent_Answer_Collection category:kCategory_Answer];
                
                [weakSelf btnCollectionClick];
                break;
            default: break;
        }
    }];
    [shareView show];
}
///收藏
-(void)btnCollectionClick
{
    if ([AppSetting getAutoLogin]) {
        ZWEAKSELF
        if (self.modelAB.isCollection == 1 || self.isCollectioning) {
            return;
        }
        self.isCollectioning = YES;
        [DataOper getAddCollectionWithUserId:[AppSetting getUserDetauleId] cid:self.modelAB.ids flag:4 type:@"6" resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setIsCollectioning:NO];
                
                [weakSelf.modelAB setIsCollection:1];
                
                [sqlite updLocalAnswerDetailWithModel:weakSelf.modelAB userId:[AppSetting getUserDetauleId]];
                
                [ZProgressHUD showSuccess:kCMsgCollectionSuccess];
            });
        } errorBlock:^(NSString *msg) {
            GCDMainBlock(^{
                [ZProgressHUD showError:msg];
                
                [weakSelf setIsCollectioning:NO];
            });
        }];
    } else {
        [self showLoginVC];
    }
}
///举报
-(void)btnReportClick
{
    [self btnReportClickWithId:self.modelAB.ids type:ZReportTypeAnswer];
}
///通用分享内容
-(void)shareWithType:(WTPlatformType)type
{
    NSString *title = self.title;
    NSString *content = self.modelAB.title.imgReplacing;
    if (content.length > kShareContentLength) { content = [content substringToIndex:kShareContentLength]; }
    UIImage *image = [UIImage imageNamed:@"Icon"];
    NSString *webUrl = kShare_AnswerInfoUrl(self.modelAB.question_id, self.modelAB.ids);
    ZWEAKSELF
    [ShareManager shareWithTitle:title content:content imgObj:image webUrl:webUrl platformType:type resultBlock:^(bool isSuccess, NSString *msg) {
        if (!isSuccess && msg) {
            [ZProgressHUD showError:msg];
        } else {
            if ([AppSetting getAutoLogin]) {
                [DataOper postAddShareInfoWithShareId:weakSelf.modelAB.ids userId:[AppSetting getUserDetauleId] resultBlock:nil errorBlock:nil];
            }
        }
    }];
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
///删除问题回调
-(void)setDeleteAnswer:(ModelAnswerBase *)model
{

}
///删除回答
-(void)btnDeleteClick
{
    ZWEAKSELF
    if(self.isDeleteing) {return;}
    [ZAlertView showWithMessage:kCMsgDoneDeleteAnswer doneCompletion:^{
        [weakSelf setIsDeleteing:YES];
        [ZProgressHUD showMessage:kCMsgDeleting];
        [DataOper postDeleteAnswerWithAnswerId:weakSelf.modelAB.ids userId:[AppSetting getUserDetauleId] resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                [weakSelf setIsDeleteing:NO];
                [ZProgressHUD dismiss];
                [ZProgressHUD showSuccess:kCMsgAnswerDeleteSuccess];
                [weakSelf postPublishQuestionNotification];
                if (weakSelf.preVC != nil) {
                    [weakSelf.preVC performSelector:@selector(setDeleteAnswer:) withObject:weakSelf.modelAB afterDelay:NO];
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

#pragma mark - ZActionSheetDelegate

-(void)actionSheet:(ZActionSheet *)actionSheet didButtonClickWithIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 10://别人的评论
        {
            switch (buttonIndex) {
                case 0://回复
                {
                    self.commentType = 1;
                    self.isComment = NO;
                    [self.viewComment setPlaceholderText:[NSString stringWithFormat:@"%@%@:", kReply, self.modelLastAC.nickname]];
                    [self.viewComment setKeyboardShow];
                    [self.tvMain setViewScrollToRowAtRow:self.lastRow];
                    break;
                }
                case 1://举报
                {
                    [self btnReportClickWithId:self.modelLastAC.ids type:ZReportTypeComment];
                    break;
                }
                default: break;
            }
            break;
        }
        case 11://自己的评论
        {
            switch (buttonIndex) {
                case 0://删除
                {
                    if (!self.isDeleteing) {
                        ZWEAKSELF
                        self.isDeleteing = YES;
                        [DataOper130 postCommentReplyWithUserId:[AppSetting getUserDetauleId] ids:self.modelLastAC.ids type:0 resultBlock:^(NSDictionary *result) {
                            GCDMainBlock(^{
                                [weakSelf setIsDeleteing:NO];
                                
                                [weakSelf.tvMain deleteViewAnswerComment:weakSelf.modelLastAC];
                                
                                [sqlite delLocalAnswerCommentWithCommentId:weakSelf.modelLastAC.ids answerId:weakSelf.modelAB.ids];
                            });
                        } errorBlock:^(NSString *msg) {
                            GCDMainBlock(^{
                                [weakSelf setIsDeleteing:NO];
                            });
                        }];
                    }
                    break;
                }
                default: break;
            }
            break;
        }
        case 12://删除自己的回复
        {
            switch (buttonIndex) {
                case 0://删除
                {
                    if (!self.isDeleteing) {
                        ZWEAKSELF
                        self.isDeleteing = YES;
                        [DataOper130 postCommentReplyWithUserId:[AppSetting getUserDetauleId] ids:self.modelLastCR.ids type:1 resultBlock:^(NSDictionary *result) {
                            GCDMainBlock(^{
                                [weakSelf setIsDeleteing:NO];
                                
                                [weakSelf.tvMain deleteViewCommentReply:weakSelf.modelLastCR];
                                
                                [sqlite delLocalAnswerCommentReplyWithReplyId:weakSelf.modelLastCR.ids commentId:weakSelf.modelLastCR.commentId];
                            });
                        } errorBlock:^(NSString *msg) {
                            GCDMainBlock(^{
                                [weakSelf setIsDeleteing:NO];
                            });
                        }];
                    }
                    break;
                }
                default: break;
            }
            break;
        }
        case 13://回复别人的回复
        {
            switch (buttonIndex) {
                case 0://回复
                {
                    self.commentType = 2;
                    self.isComment = NO;
                    [self.viewComment setPlaceholderText:[NSString stringWithFormat:@"%@%@:", kReply, self.modelLastCR.hnickname]];
                    [self.viewComment setKeyboardShow];
                    [self.tvMain setViewScrollToRowAtRow:self.lastRow];
                    break;
                }
                default: break;
            }
            break;
        }
        default: break;
    }
}

-(void)actionSheetDidClickOnCancelButton
{
    if (self.isComment) {
        self.commentType = 0;
        self.lastRow = -1;
        [self.viewComment setPublishDefaultText];
        [self.viewComment setPlaceholderDefaultText];
    }
}

@end
