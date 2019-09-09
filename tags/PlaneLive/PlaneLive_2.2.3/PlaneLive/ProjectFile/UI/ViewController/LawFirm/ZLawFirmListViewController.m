//
//  ZLawFirmListViewController.m
//  PlaneLive
//
//  Created by Daniel on 11/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmListViewController.h"
#import "ZCollectionViewLayout.h"
#import "ZHomeLawFirmCVC.h"
#import "ZCollectionView.h"
#import "ZLawFirmDetailViewController.h"

static NSString *const kZLawFirmListVCCollectionViewCellId = @"kZLawFirmListVCCollectionViewCellId";

@interface ZLawFirmListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) ZCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *arrMain;
@property (assign, nonatomic) int pageNum;

@end

@implementation ZLawFirmListViewController

#pragma mark - SuperMethod

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:kLawFirmGoodLawFirm];
    [self innerInit];
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
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    OBJC_RELEASE(_collectionView);
    OBJC_RELEASE(_arrMain);
    [super setViewNil];
}
-(void)dealloc
{
    [self setViewNil];
}

#pragma mark - PrivateMethod

-(void)innerInit
{
    CGFloat itemW = self.view.width/2;
    CGFloat itemH = kZHomeLawFirmCVCHeight;
    
    ZCollectionViewLayout *collectionViewFlowLayout = [[ZCollectionViewLayout alloc] init];
    collectionViewFlowLayout.itemSize = CGSizeMake(itemW, itemH);
    collectionViewFlowLayout.footerReferenceSize = CGSizeMake(self.view.width, 15);
    
    self.collectionView = [[ZCollectionView alloc] initWithFrame:VIEW_ITEM_FRAME collectionViewLayout:collectionViewFlowLayout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.collectionView setScrollEnabled:YES];
    [self.collectionView setScrollsToTop:YES];
    [self.collectionView setShowsVerticalScrollIndicator:YES];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ZHomeLawFirmCVC class] forCellWithReuseIdentifier:kZLawFirmListVCCollectionViewCellId];
    [self.view addSubview:self.collectionView];
    
    ZWEAKSELF
    [self.collectionView setRefreshHeaderWithRefreshBlock:^{
        [weakSelf setRefreshHeader];
    }];
    [self.collectionView setOnBackgroundClick:^(ZBackgroundState state){
        [weakSelf.collectionView setBackgroundViewWithState:(ZBackgroundStateLoading)];
        [weakSelf setRefreshHeader];
    }];
    [self innerData];
    [super innerInit];
}
-(void)innerData
{
    NSArray *arrMain = [sqlite getLocalLawFirmListWithArrayAll];
    if (arrMain && arrMain.count > 0) {
        [self.arrMain addObjectsFromArray:arrMain];
        [self.collectionView setBackgroundViewWithState:(ZBackgroundStateNone)];
        [self.collectionView reloadData];
    } else {
        [self.collectionView setBackgroundViewWithState:(ZBackgroundStateLoading)];
    }
    [self setRefreshHeader];
}
-(NSMutableArray *)arrMain
{
    if (!_arrMain) {
        _arrMain = [NSMutableArray array];
    }
    return _arrMain;
}
-(void)addRefreshFooter
{
    ZWEAKSELF
    [self.collectionView setRefreshFooterWithEndBlock:^{
        [weakSelf setRefreshFooter];
    }];
}
-(void)setRefreshHeader
{
    ZWEAKSELF
    self.pageNum = 1;
    [snsV2 getLawFirmListWithPageNum:self.pageNum resultBlock:^(NSArray *result) {
        if (result && result.count > 0) {
            [weakSelf.arrMain removeAllObjects];
            [weakSelf.arrMain addObjectsFromArray:result];
            [weakSelf.collectionView setBackgroundViewWithState:(ZBackgroundStateNone)];
        } else {
            [weakSelf.collectionView setBackgroundViewWithState:(ZBackgroundStateNull)];
        }
        if (result.count >= kPAGE_MAXCOUNT) {
            [weakSelf addRefreshFooter];
        } else {
            [weakSelf.collectionView removeRefreshFooter];
        }
        [weakSelf.collectionView endRefreshHeader];
        [sqlite setLocalLawFirmListWithArray:result];
        [weakSelf.collectionView reloadData];
    } errorBlock:^(NSString *msg) {
        [weakSelf.collectionView endRefreshHeader];
        [weakSelf.collectionView setBackgroundViewWithState:(ZBackgroundStateFail)];
    }];
}
-(void)setRefreshFooter
{
    ZWEAKSELF
    [snsV2 getLawFirmListWithPageNum:self.pageNum+1 resultBlock:^(NSArray *result) {
        weakSelf.pageNum += 1;
        if (result && result.count > 0) {
            [weakSelf.arrMain addObjectsFromArray:result];
        }
        if (result.count >= kPAGE_MAXCOUNT) {
            [weakSelf addRefreshFooter];
        } else {
            [weakSelf.collectionView removeRefreshFooter];
        }
        [weakSelf.collectionView endRefreshFooter];
        [weakSelf.collectionView reloadData];
    } errorBlock:^(NSString *msg) {
        [weakSelf.collectionView endRefreshFooter];
    }];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrMain.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomeLawFirmCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZLawFirmListVCCollectionViewCellId forIndexPath:indexPath];
    
    [cell setTag:indexPath.row];
    ModelLawFirm *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModelLawFirm *model = [self.arrMain objectAtIndex:indexPath.row];
    
    ZLawFirmDetailViewController *itemVC = [[ZLawFirmDetailViewController alloc] init];
    [itemVC setViewDataWithModel:model];
    [self.navigationController pushViewController:itemVC animated:YES];
}

@end
