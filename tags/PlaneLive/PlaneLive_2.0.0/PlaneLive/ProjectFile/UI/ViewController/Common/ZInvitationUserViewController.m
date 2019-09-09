//
//  ZInvitationUserViewController.m
//  PlaneLive
//
//  Created by Daniel on 03/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZInvitationUserViewController.h"
#import "ZInvitationItemTVC.h"
#import "ZTextField.h"
#import "ZUserProfileViewController.h"
#import "ZTaskCompleteView.h"

@interface ZInvitationUserViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

///顶部区域
@property (strong, nonatomic) UIView *viewHeader;
///搜索区域
@property (strong, nonatomic) UIView *viewSearch;
///搜索输入框
@property (strong, nonatomic) ZTextField *textField;
///搜索Icon
@property (strong, nonatomic) UIImageView *imgSearch;

@property (strong, nonatomic) ZTableView *tvMain;
///主视图坐标
@property (assign, nonatomic) CGRect tvFrame;
///列表集合
@property (strong, nonatomic) NSMutableArray *arrMain;
///推荐用户
@property (strong, nonatomic) NSArray *arrHot;

@property (assign, nonatomic) int pageNum;

@property (assign, nonatomic) BOOL isInvitationing;
///最后搜索记录
@property (strong, nonatomic) NSString *lastContent;

@property (strong, nonatomic) ModelQuestionBase *modelQB;

@end

@implementation ZInvitationUserViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:kInvitationQuestionAnswer];
    
    [self innerInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_viewSearch);
    OBJC_RELEASE(_textField);
    OBJC_RELEASE(_tvMain);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    self.arrMain = [NSMutableArray array];
    
    self.tvFrame = VIEW_ITEM_FRAME;
    
    self.viewHeader = [[UIView alloc] init];
    [self.viewHeader setBackgroundColor:WHITECOLOR];
    
    self.viewSearch = [[UIView alloc] init];
    [self.viewSearch setViewRound:4 borderWidth:0 borderColor:CLEARCOLOR];
    [self.viewSearch setBackgroundColor:RGBCOLOR(246, 246, 246)];
    [self.viewHeader addSubview:self.viewSearch];
    
    self.textField = [[ZTextField alloc] init];
    [self.textField setTextFieldIndex:ZTextFieldIndexInvitationUser];
    [self.textField setPlaceholder:kInvitationYourLikeUser];
    [self.textField setContentMode:(UIViewContentModeLeft)];
    [self.textField setReturnKeyType:(UIReturnKeyDone)];
    [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textField setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.textField setTextColor:BLACKCOLOR1];
    [self.textField setMaxLength:kSearchContentMaxLength];
    [self.viewSearch addSubview:self.textField];
    
    self.imgSearch = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_quanzi_huatiyaoqing_search"]];
    [self.viewSearch addSubview:self.imgSearch];
    
    self.tvMain = [[ZTableView alloc] init];
    [self.tvMain innerInit];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvMain setRowHeight:[ZInvitationItemTVC getH]];
    [self.view addSubview:self.tvMain];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [self setViewFrame];
    
    [self innerData];
    
    [super innerInit];
}
///TODO:ZWW备注-单行文本输入监听事件
-(void)textFieldDidChange:(NSNotification *)sender
{
    UITextField *textField = sender.object;
    NSString *content = textField.text;
    if (content.length > kSearchContentMaxLength) {
        [textField setText:[content substringToIndex:kSearchContentMaxLength]];
    }
    if ([self.lastContent isEqualToString:content]) {
        return;
    }
    [self setLastContent:content];
    if (content.length > 0) {
        ZWEAKSELF
        NSString *userId = [AppSetting getUserDetauleId];
        [DataOper getSearchUserWithUserId:userId questionId:self.modelQB.ids flag:@"1" content:content pageNum:1 resultBlock:^(NSDictionary *result) {
            GCDMainBlock(^{
                NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                
                [weakSelf setUserArrayWithDictionary:dicResult];
            });
        } errorBlock:nil];
    } else {
        [self.arrMain removeAllObjects];
        [self.arrMain addObjectsFromArray:self.arrHot];
        [self.tvMain reloadData];
    }
}
-(void)viewTapClick:(UIGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}

-(void)setViewFrame
{
    [self.viewSearch setFrame:CGRectMake(10, 10, self.view.width-20, 40)];
    CGFloat imgW = 28/2;
    CGFloat imgH = 32/2;
    [self.textField setViewFrame:CGRectMake(10, 1, self.viewSearch.width-20-imgW-5, 38)];
    [self.imgSearch setFrame:CGRectMake(self.viewSearch.width-imgW-10, self.viewSearch.height/2-imgH/2, imgW, imgH)];
    
    [self.viewHeader setFrame:CGRectMake(0, 0, self.view.width, self.viewSearch.height+self.viewSearch.y)];
    
    [self.tvMain setTableHeaderView:self.viewHeader];
    [self.tvMain setSectionHeaderHeight:self.viewHeader.height];
    [self.tvMain setFrame:self.tvFrame];
}
-(void)innerData
{
    NSDictionary *dicLocal = [sqlite getLocalCacheDataWithPathKay:@"RecommendUserArrayKey"];
    if (dicLocal && [dicLocal isKindOfClass:[NSDictionary class]]) {
        NSArray *arrUser = [dicLocal objectForKey:kResultKey];
        if (arrUser && [arrUser isKindOfClass:[NSArray class]]) {
            NSMutableArray *arrU = [NSMutableArray array];
            for (NSDictionary *dic in arrUser) {
                ModelUserInvitation *modelUser = [[ModelUserInvitation alloc] initWithCustom:dic];
                [arrU addObject:modelUser];
            }
            [self setArrHot:arrU];
            [self.arrMain removeAllObjects];
            [self.arrMain addObjectsFromArray:arrU];
            [self.tvMain reloadData];
        }
    }
    ZWEAKSELF
    self.pageNum = 1;
    NSString *userId = [AppSetting getUserDetauleId];
    [DataOper getRecommendUserWithUserId:userId questionId:self.modelQB.ids pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [sqlite setLocalCacheDataWithDictionary:result pathKay:@"RecommendUserArrayKey"];
            NSArray *arrUser = [result objectForKey:kResultKey];
            if (arrUser && [arrUser isKindOfClass:[NSArray class]]) {
                NSMutableArray *arrU = [NSMutableArray array];
                for (NSDictionary *dic in arrUser) {
                    ModelUserInvitation *modelUser = [[ModelUserInvitation alloc] initWithCustom:dic];
                    [arrU addObject:modelUser];
                }
                [weakSelf setArrHot:arrU];
                [weakSelf.arrMain removeAllObjects];
                [weakSelf.arrMain addObjectsFromArray:arrU];
                [weakSelf.tvMain reloadData];
            }
        });
    } errorBlock:nil];
}
///设置用户搜索数据源
-(void)setUserArrayWithDictionary:(NSDictionary *)dicResult
{
    NSArray *arrUser = [dicResult objectForKey:kUserKey];
    NSMutableArray *arrU = [NSMutableArray array];
    if (arrUser && [arrUser isKindOfClass:[NSArray class]] && arrUser.count > 0) {
        for (NSDictionary *dic in arrUser) {
            ModelUserInvitation *modelUser = [[ModelUserInvitation alloc] initWithCustom:dic];
            [arrU addObject:modelUser];
        }
    }
    BOOL isHeader = [[dicResult objectForKey:kIsHeaderKey] boolValue];
    if (isHeader) {
        [self.arrMain removeAllObjects];
    }
    if (self.lastContent.length == 0) {
        if (self.arrHot.count > 0) {
            [self.arrMain addObjectsFromArray:self.arrHot];
        }
    }
    ZWEAKSELF
    [self.tvMain removeRefreshFooter];
    if (arrU.count >= kPAGE_MAXCOUNT) {
        [self.tvMain addRefreshFooterWithEndBlock:^{
            [weakSelf setRefreshFooter];
        }];
    }
    [self.arrMain addObjectsFromArray:arrU];
    [self.tvMain reloadData];
}
///刷新底部数据
-(void)setRefreshFooter
{
    ZWEAKSELF
    NSString *userId = [AppSetting getUserDetauleId];
    [DataOper getSearchUserWithUserId:userId questionId:self.modelQB.ids flag:@"1" content:self.lastContent pageNum:self.pageNum+1 resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            weakSelf.pageNum += 1;
            
            [weakSelf setUserArrayWithDictionary:result];
        });
    } errorBlock:nil];
}
///邀请
-(void)btnInvitationClick:(ModelUserInvitation *)model itemTVC:(ZInvitationItemTVC *)tvc
{
    if(self.isInvitationing || model.isInvitation == 1){return;}
    ZWEAKSELF
    [weakSelf setIsInvitationing:YES];
    NSString *userId = [AppSetting getUserDetauleId];
    [DataOper postInviteUserWithUserId:userId hisId:model.userId questionId:self.modelQB.ids resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setIsInvitationing:NO];
            ModelUserInvitation *modelUI = [weakSelf.arrMain objectAtIndex:tvc.tag];
            [modelUI setIsInvitation:1];
            [weakSelf.tvMain reloadData];
        });
    } errorBlock: ^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf setIsInvitationing:NO];
            [ZProgressHUD showError:msg];
        });
    }];
}
///键盘高度
-(void)keyboardFrameChange:(CGFloat)height
{
    [super keyboardFrameChange:height];
    CGRect tvFrame = self.tvFrame;
    tvFrame.size.height -= height;
    [self.tvMain setFrame:tvFrame];
}

-(void)setViewDataWithModel:(ModelQuestionBase *)model
{
    [self setModelQB:model];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"tvcellid";
    ZInvitationItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ZInvitationItemTVC alloc] initWithReuseIdentifier:cellid];
    }
    [cell setTag:indexPath.row];
    ModelUserInvitation *modelI = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:modelI];
    ZWEAKSELF
    [cell setOnInvitationClick:^(ModelUserInvitation *model, ZInvitationItemTVC *tvc) {
        [weakSelf btnInvitationClick:model itemTVC:tvc];
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelUserInvitation *modelI = [self.arrMain objectAtIndex:indexPath.row];
    if (![Utils isMyUserId:modelI.userId]) {
        ModelUserBase *modelUB = [[ModelUserBase alloc] init];
        [modelUB setUserId:modelI.userId];
        [modelUB setNickname:modelI.nickname];
        [modelUB setHead_img:modelI.head_img];
        [modelUB setSign:modelI.sign];
        [self showUserProfileVC:modelUB];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
