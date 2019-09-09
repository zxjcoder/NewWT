//
//  ZInvitationUserViewController.m
//  PlaneCircle
//
//  Created by Daniel on 6/13/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZInvitationUserViewController.h"
#import "ZInvitationItemTVC.h"

#import "ZUserProfileViewController.h"

@interface ZInvitationUserViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>

///顶部区域
@property (strong, nonatomic) UIView *viewHeader;
///搜索区域
@property (strong, nonatomic) UIView *viewSearch;
///搜索输入框
@property (strong, nonatomic) UITextField *textField;
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
///底部提示区域
//@property (strong, nonatomic) UIView *viewFooter;
//@property (strong, nonatomic) UILabel *lbFooter;
///最后搜索记录
@property (strong, nonatomic) NSString *lastContent;

@property (strong, nonatomic) ModelQuestionBase *modelQB;

@end

@implementation ZInvitationUserViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"邀请回答"];
    
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
//    OBJC_RELEASE(_viewFooter);
//    OBJC_RELEASE(_lbFooter);
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
    
    //TODO: ZWW修改-不需要底部邀请10个人回答区域
//    self.viewFooter = [[UIView alloc] init];
//    [self.viewFooter setBackgroundColor:MAINCOLOR];
//    [self.viewFooter setAlpha:0.0f];
//    [self.viewFooter setHidden:YES];
//    [self.view addSubview:self.viewFooter];
    //TODO: ZWW修改-不需要底部邀请10个人回答内容
//    self.lbFooter = [[UILabel alloc] init];
//    [self.lbFooter setText:@"超过10个人就不能再邀请了哦"];
//    [self.lbFooter setTextColor:WHITECOLOR];
//    [self.lbFooter setHidden:YES];
//    [self.lbFooter setAlpha:0.0f];
//    [self.lbFooter setTextAlignment:(NSTextAlignmentCenter)];
//    [self.lbFooter setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
//    [self.view addSubview:self.lbFooter];
    
    self.textField = [[UITextField alloc] init];
    [self.textField setDelegate:self];
    [self.textField setPlaceholder:@"搜索你想邀请的用户"];
    [self.textField setContentMode:(UIViewContentModeLeft)];
    [self.textField setReturnKeyType:(UIReturnKeyDone)];
    [self.textField setKeyboardType:(UIKeyboardTypeDefault)];
    [self.textField setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewSearch addSubview:self.textField];
    
    self.imgSearch = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"icon_quanzi_huatiyaoqing_search"]];
    [self.viewSearch addSubview:self.imgSearch];
    
    self.tvMain = [[ZTableView alloc] init];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setBackgroundColor:VIEW_BACKCOLOR1];
    [self.tvMain setRowHeight:[ZInvitationItemTVC getH]];
    [self.view addSubview:self.tvMain];
    
//    [self.view sendSubviewToBack:self.tvMain];
//    [self.view bringSubviewToFront:self.viewFooter];
//    [self.view bringSubviewToFront:self.lbFooter];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
    [self.view addGestureRecognizer:tap];
    
    [self setViewFrame];
    
    [self innerData];
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
    [self.textField setFrame:CGRectMake(10, 1, self.viewSearch.width-20-imgW-5, 38)];
    [self.imgSearch setFrame:CGRectMake(self.viewSearch.width-imgW-10, self.viewSearch.height/2-imgH/2, imgW, imgH)];
    
    [self.viewHeader setFrame:CGRectMake(0, 0, self.view.width, self.viewSearch.height+self.viewSearch.y)];
//    CGFloat footerH = 0;//self.tvMain.sectionFooterHeight;
//    [self.viewFooter setFrame:CGRectMake(0, APP_FRAME_HEIGHT-footerH, self.view.width, footerH)];
//    [self.lbFooter setFrame:CGRectMake(0, APP_FRAME_HEIGHT-footerH, self.view.width, footerH)];
    
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
            [self.arrMain addObjectsFromArray:arrU];
            [self.tvMain reloadData];
        }
    }
    ZWEAKSELF
    self.pageNum = 1;
    NSString *userId = [AppSetting getUserDetauleId];
    [sns getRecommendUserWithUserId:userId questionId:self.modelQB.ids pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
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
    BOOL isHot = [[dicResult objectForKey:@"isHotArray"] boolValue];
    if (!isHot) {
        if (self.arrHot.count > 0) {
            [self.arrMain addObjectsFromArray:self.arrHot];
        }
    }
    ZWEAKSELF
    if (arrU.count >= kPAGE_MAXCOUNT) {
        [self.tvMain addRefreshFooterWithEndBlock:^{
            [weakSelf setRefreshFooter];
        }];
    } else {
        [self.tvMain removeRefreshFooter];
    }
    [self.arrMain addObjectsFromArray:arrU];
    [self.tvMain reloadData];
}
///刷新底部数据
-(void)setRefreshFooter
{
    ZWEAKSELF
    self.pageNum += 1;
    NSString *userId = [AppSetting getUserDetauleId];
    [sns getSearchUserWithUserId:userId questionId:self.modelQB.ids flag:@"1" content:self.lastContent pageNum:self.pageNum resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
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
    [sns postInviteUserWithUserId:userId hisId:model.userId questionId:self.modelQB.ids resultBlock:^(NSDictionary *result) {
        GCDMainBlock(^{
            [weakSelf setIsInvitationing:NO];
            ModelUserInvitation *modelUI = [weakSelf.arrMain objectAtIndex:tvc.tag];
            [modelUI setIsInvitation:1];
            [weakSelf.tvMain reloadData];
        });
    } errorBlock: ^(NSString *msg) {
        GCDMainBlock(^{
            [weakSelf setIsInvitationing:NO];
            [ZProgressHUD showError:msg toView:weakSelf.view];
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

#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange:(NSNotification *)sender
{
    if (self.textField.text.toTrim.length > 0) {
        if (![self.lastContent isEqualToString:self.textField.text.toTrim]) {
            
            [self setLastContent:self.textField.text.toTrim];
            
            if ([Utils isContainsEmoji:self.textField.text.toTrim]) {
                [self.textField setText:[self.textField.text stringByReplacingOccurrencesOfString:self.lastContent withString:kEmpty]];
                return;
            }
            
            ZWEAKSELF
            NSString *userId = [AppSetting getUserDetauleId];
            [sns getSearchUserWithUserId:userId questionId:self.modelQB.ids flag:@"1" content:self.textField.text.toTrim pageNum:1 resultBlock:^(NSDictionary *result) {
                GCDMainBlock(^{
                    NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:result];
                    [dicResult setObject:@"YES" forKey:kIsHeaderKey];
                    [dicResult setObject:@"YES" forKey:@"isHotArray"];
                    
                    [weakSelf setUserArrayWithDictionary:dicResult];
                });
            } errorBlock:nil];
        }
    } else {
        [self.arrMain removeAllObjects];
        [self.arrMain addObjectsFromArray:self.arrHot];
        [self.tvMain reloadData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
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
    if (![modelI.userId isEqualToString:[AppSetting getUserId]]) {
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
