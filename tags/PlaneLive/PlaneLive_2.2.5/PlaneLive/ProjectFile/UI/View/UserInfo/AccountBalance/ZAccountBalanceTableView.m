//
//  ZAccountBalanceTableView.m
//  PlaneLive
//
//  Created by Daniel on 10/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZAccountBalanceTableView.h"
#import "ZAccountBalanceItemTVC.h"
#import "ZAccountBalanceHeaderTVC.h"
#import "AccountBalanceFooterTVC.h"

@interface ZAccountBalanceTableView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ZAccountBalanceHeaderTVC *tvcHeader;

@property (strong, nonatomic) ZAccountBalanceItemTVC *tvcNone;
@property (strong, nonatomic) ZAccountBalanceItemTVC *tvcTwo;
@property (strong, nonatomic) ZAccountBalanceItemTVC *tvcThree;
@property (strong, nonatomic) ZAccountBalanceItemTVC *tvcFour;
@property (strong, nonatomic) ZAccountBalanceItemTVC *tvcFive;

@property (strong, nonatomic) AccountBalanceFooterTVC *tvcFooter;

@property (strong, nonatomic) NSArray *arrayMain;

@end

@implementation ZAccountBalanceTableView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    ZWEAKSELF
    self.tvcHeader = [[ZAccountBalanceHeaderTVC alloc] initWithReuseIdentifier:@"tvcHeader"];
    
    self.tvcNone = [[ZAccountBalanceItemTVC alloc] initWithReuseIdentifier:@"tvcNone" type:(ZAccountBalanceItemTVCTypeNone)];
    [self.tvcNone setOnRechargeClick:^(NSString *money) {
        if (weakSelf.onRechargeClick) {
            weakSelf.onRechargeClick(money);
        }
    }];
    self.tvcTwo = [[ZAccountBalanceItemTVC alloc] initWithReuseIdentifier:@"tvcTwo" type:(ZAccountBalanceItemTVCTypeTwo)];
    [self.tvcTwo setOnRechargeClick:^(NSString *money) {
        if (weakSelf.onRechargeClick) {
            weakSelf.onRechargeClick(money);
        }
    }];
    self.tvcThree = [[ZAccountBalanceItemTVC alloc] initWithReuseIdentifier:@"tvcThree" type:(ZAccountBalanceItemTVCTypeThree)];
    [self.tvcThree setOnRechargeClick:^(NSString *money) {
        if (weakSelf.onRechargeClick) {
            weakSelf.onRechargeClick(money);
        }
    }];
    self.tvcFour = [[ZAccountBalanceItemTVC alloc] initWithReuseIdentifier:@"tvcFour" type:(ZAccountBalanceItemTVCTypeFour)];
    [self.tvcFour setOnRechargeClick:^(NSString *money) {
        if (weakSelf.onRechargeClick) {
            weakSelf.onRechargeClick(money);
        }
    }];
    self.tvcFive = [[ZAccountBalanceItemTVC alloc] initWithReuseIdentifier:@"tvcFive" type:(ZAccountBalanceItemTVCTypeFive)];
    [self.tvcFive setOnRechargeClick:^(NSString *money) {
        if (weakSelf.onRechargeClick) {
            weakSelf.onRechargeClick(money);
        }
    }];
    self.tvcFooter = [[AccountBalanceFooterTVC alloc] initWithReuseIdentifier:@"tvcFooter"];
    [self.tvcFooter setOnLinkClick:^{
        if (weakSelf.onLinkClick) {
            weakSelf.onLinkClick();
        }
    }];
    [self.tvcFooter setOnWechatLinkClick:^{
        if (weakSelf.onWeChatLinkClick) {
            weakSelf.onWeChatLinkClick();
        }
    }];
    self.arrayMain = @[//self.tvcHeader,
                       self.tvcNone,
                       self.tvcTwo,
                       self.tvcThree,
                       self.tvcFour,
                       self.tvcFive,
                       self.tvcFooter];
    
    [self setDelegate:self];
    [self setDataSource:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    [self setViewDataWithModel:nil];
}

-(void)setViewDataWithModel:(ModelUser *)model
{
    [self.tvcHeader setCellDataWithModel:model];
    
    [self reloadData];
}

///设置账户余额
-(void)setBalanceValue:(NSString *)value
{
    [self.tvcHeader setCellDataWithBalance:value];
}

-(void)dealloc
{
    OBJC_RELEASE(_tvcHeader);
    OBJC_RELEASE(_tvcNone);
    OBJC_RELEASE(_tvcTwo);
    OBJC_RELEASE(_tvcThree);
    OBJC_RELEASE(_tvcFour);
    OBJC_RELEASE(_tvcFive);
    OBJC_RELEASE(_tvcFooter);
    OBJC_RELEASE(_arrayMain);
    self.dataSource = nil;
    self.delegate = nil;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.tvcHeader.getH;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tvcHeader.viewMain;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.arrayMain objectAtIndex:indexPath.row] getH];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.arrayMain objectAtIndex:indexPath.row];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.onContentOffsetY) {
        CGFloat alpha = offsetY / 200;
        if (alpha > 1) { alpha = 1; }
        else if (alpha < 0) { alpha = 0; }
        self.onContentOffsetY(alpha);
    }
}

@end
