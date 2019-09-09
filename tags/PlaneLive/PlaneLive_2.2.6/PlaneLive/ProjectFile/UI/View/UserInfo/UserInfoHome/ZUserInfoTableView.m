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
@property (strong, nonatomic) ZUserInfoItemTVC *tvcCS;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcLY;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcXX;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcFK;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcBD;
@property (strong, nonatomic) ZUserInfoItemTVC *tvcSZ;
@property (strong, nonatomic) ZUserInfoSpaceTVC *tvcSpace1;

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
    [self.tvcHeader setOnDownloadClick:^{
        if (weakSelf.onDownloadClick) {
            weakSelf.onDownloadClick();
        }
    }];
    self.tvcCS = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcCS" type:(ZUserInfoItemTVCTypeCollection)];
    self.tvcLY = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcLY" type:(ZUserInfoItemTVCTypeMessage)];
    self.tvcXX = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcXX" type:(ZUserInfoItemTVCTypeNews)];
    self.tvcFK = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcFK" type:(ZUserInfoItemTVCTypeFeedback)];
    self.tvcBD = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcBD" type:(ZUserInfoItemTVCTypeBind)];
    self.tvcSZ = [[ZUserInfoItemTVC alloc] initWithReuseIdentifier:@"tvcSZ" type:(ZUserInfoItemTVCTypeSetting)];
    
    self.tvcSpace1 = [[ZUserInfoSpaceTVC alloc] initWithReuseIdentifier:@"tvcSpace1"];
    
    [self setDataSource:self];
    [self setDelegate:self];
    [self setBackgroundColor:VIEW_BACKCOLOR1];
}
-(void)setViewDataWithModel:(ModelUser *)model
{
    if (kIsAppAudit) {
        self.arrayMain = @[self.tvcHeader,
                           self.tvcCS,
                           self.tvcLY,
                           self.tvcXX,
                           self.tvcFK,
                           self.tvcSZ,
                           self.tvcSpace1];
    } else {
        self.arrayMain = @[self.tvcHeader,
                           self.tvcCS,
                           self.tvcLY,
                           self.tvcXX,
                           self.tvcFK,
                           self.tvcBD,
                           self.tvcSZ,
                           self.tvcSpace1];
    }
    [self.tvcHeader setCellDataWithModel:model];
    [self.tvcCS setCellDataWithModel:model];
    [self.tvcLY setCellDataWithModel:model];
    [self.tvcXX setCellDataWithModel:model];
    [self.tvcFK setCellDataWithModel:model];
    [self.tvcBD setCellDataWithModel:model];
    [self.tvcSZ setCellDataWithModel:model];
    [self setBackgroundViewWithState:(ZBackgroundStateNone)];
    [self reloadData];
}

-(void)dealloc
{
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
            self.onUserInfoItemClick([(ZUserInfoItemTVC*)cell getType]);
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (self.onContentOffsetY) {
        CGFloat alpha = offsetY / 124;
        if (alpha > 1) { alpha = 1; }
        else if (alpha < 0) { alpha = 0; }
        self.onContentOffsetY(alpha);
    }
}

@end
