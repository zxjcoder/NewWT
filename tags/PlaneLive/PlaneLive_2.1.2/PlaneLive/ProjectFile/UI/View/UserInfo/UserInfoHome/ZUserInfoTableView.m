//
//  ZUserInfoTableView.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoTableView.h"
#import "ZUserInfoHeaderTVC.h"
#import "ZUserInfoGridTVC.h"
#import "ZUserInfoItemTVC.h"
#import "ZUserInfoSpaceTVC.h"

@interface ZUserInfoTableView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ZUserInfoHeaderTVC *tvcHeader;
@property (strong, nonatomic) ZUserInfoGridTVC *tvcGrid;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcQuestion;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcAnswer;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcComment;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcFans;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcFeedback;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcServer;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcAccount;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcSetting;
@property (strong, nonatomic) ZUserInfoSpaceTVC *tvcSpace1;
@property (strong, nonatomic) ZUserInfoSpaceTVC *tvcSpace2;

@property (strong, nonatomic) NSArray *arrayMain;

@end

@implementation ZUserInfoTableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    ZWEAKSELF
    self.tvcHeader = [[ZUserInfoHeaderTVC alloc] initWithReuseIdentifier:@"tvcHeader"];
    [self.tvcHeader setOnUserPhotoClick:^{
        if (weakSelf.onUserPhotoClick) {
            weakSelf.onUserPhotoClick();
        }
    }];
    [self.tvcHeader setOnShopCartClick:^{
        if (weakSelf.onShopCartClick) {
            weakSelf.onShopCartClick();
        }
    }];
    [self.tvcHeader setOnPurchaseRecordClick:^{
        if (weakSelf.onPurchaseRecordClick) {
            weakSelf.onPurchaseRecordClick();
        }
    }];
    [self.tvcHeader setOnBalanceClick:^{
        if (weakSelf.onBalanceClick) {
            weakSelf.onBalanceClick();
        }
    }];
    self.tvcGrid = [[ZUserInfoGridTVC alloc] initWithReuseIdentifier:@"tvcGrid"];
    [self.tvcGrid setOnUserInfoCenterItemClick:^(ZUserInfoGridCVCType type) {
        if (weakSelf.onUserInfoGridClick) {
            weakSelf.onUserInfoGridClick(type);
        }
    }];
    self.tvcQuestion = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcQuestion" type:(ZUserInfoItemTVCQuestion)];
    self.tvcAnswer = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcAnswer" type:(ZUserInfoItemTVCAnswer)];
    self.tvcComment = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcComment" type:(ZUserInfoItemTVCComment)];
    self.tvcFans = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcFans" type:(ZUserInfoItemTVCFans)];
    [self.tvcFans setHiddenLineView];
    
    self.tvcFeedback = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcFeedback" type:(ZUserInfoItemTVCFeedback)];
    self.tvcServer = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcServer" type:(ZUserInfoItemTVCServer)];
    self.tvcAccount = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcAccount" type:(ZUserInfoItemTVCAccount)];
    self.tvcSetting = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcSetting" type:(ZUserInfoItemTVCSetting)];
    [self.tvcSetting setHiddenLineView];
    
    self.tvcSpace1 = [[ZUserInfoSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace1"];
    self.tvcSpace2 = [[ZUserInfoSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace2"];
    [self.tvcSpace2 setCellBackColor:WHITECOLOR];
    [self.tvcSpace2 setCellRowH:55];
    
    [self setBounces:NO];
    [self setDataSource:self];
    [self setDelegate:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
}
-(void)setViewDataWithModel:(ModelUser *)model
{
    if (model) {
        self.arrayMain = @[self.tvcHeader,
                           self.tvcGrid,
                           self.tvcQuestion,
                           self.tvcAnswer,
                           self.tvcComment,
                           self.tvcFans,
                           self.tvcSpace1,
                           self.tvcFeedback,
                           self.tvcServer,
                           self.tvcAccount,
                           self.tvcSetting,
                           self.tvcSpace2];
     
        [self.tvcHeader setCellDataWithModel:model];
        [self.tvcGrid setCellDataWithModel:model];
        [self.tvcQuestion setCellDataWithModel:model];
        [self.tvcAnswer setCellDataWithModel:model];
        [self.tvcComment setCellDataWithModel:model];
        [self.tvcFans setCellDataWithModel:model];
    } else {
        self.arrayMain = nil;
        [self setBackgroundViewWithState:(ZBackgroundStateLoginNull)];
    }
    [self reloadData];
}

-(void)dealloc
{
    OBJC_RELEASE(_tvcFans);
    OBJC_RELEASE(_tvcGrid);
    OBJC_RELEASE(_arrayMain);
    OBJC_RELEASE(_tvcAnswer);
    OBJC_RELEASE(_tvcHeader);
    OBJC_RELEASE(_tvcServer);
    OBJC_RELEASE(_tvcSpace1);
    OBJC_RELEASE(_tvcSpace2);
    OBJC_RELEASE(_tvcAccount);
    OBJC_RELEASE(_tvcComment);
    OBJC_RELEASE(_tvcSetting);
    OBJC_RELEASE(_tvcFeedback);
    OBJC_RELEASE(_tvcQuestion);
    OBJC_RELEASE(_onContentOffsetY);
    OBJC_RELEASE(_onUserPhotoClick);
    OBJC_RELEASE(_onUserInfoGridClick);
    OBJC_RELEASE(_onUserInfoItemClick);
    self.dataSource = nil;
    self.delegate = nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(ZBaseTVC*)[self.arrayMain objectAtIndex:indexPath.row] getH];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrayMain objectAtIndex:indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBaseTVC *cell = [self.arrayMain objectAtIndex:indexPath.row];
    if ([cell isKindOfClass:[ZUserInfoItemTVC class]]) {
        if (self.onUserInfoItemClick) {
            self.onUserInfoItemClick([(ZUserInfoItemTVC*)cell getCellType]);
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.onContentOffsetY) {
        CGFloat alpha = offsetY / 124;
        if (alpha > 1) { alpha = 1; }
        else if (alpha < 0) { alpha = 0; }
        self.onContentOffsetY(alpha);
    }
}

@end
