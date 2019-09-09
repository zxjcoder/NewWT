//
//  ZUserInfoGridTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZUserInfoGridTVC.h"
#import "ZCollectionViewLayout.h"
#import "ZUserInfoGridCVC.h"

static NSString *const kZUserInfoGridTVCCellId = @"kZUserInfoGridTVCCellId";

@interface ZUserInfoGridTVC()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *arrayMain;
@property (strong, nonatomic) ModelUser *model;

@property (strong, nonatomic) UIImageView *imgLine1;
@property (strong, nonatomic) UIImageView *imgLine2;
@property (strong, nonatomic) UIImageView *imgLine3;
@property (strong, nonatomic) UIImageView *imgLine4;

@end

@implementation ZUserInfoGridTVC

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZUserInfoGridTVC getH];
    
    CGFloat itemS = 0;
    CGFloat cvWidth = self.cellW;
    CGFloat itemW = cvWidth/3;
    CGFloat itemH = 90;
    
    self.arrayMain = @[@(ZUserInfoGridCVCTypeColl),
                       @(ZUserInfoGridCVCTypeAtt),
                       @(ZUserInfoGridCVCTypeDownload),
                       @(ZUserInfoGridCVCTypeMessage),
                       @(ZUserInfoGridCVCTypeWaitAnswer),
                       @(ZUserInfoGridCVCTypeMessageCenter)];
    
    ZCollectionViewLayout *collectionViewFlowLayout = [[ZCollectionViewLayout alloc] init];
    collectionViewFlowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    CGFloat cvH = itemH*2;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(itemS, 0, cvWidth, cvH) collectionViewLayout:collectionViewFlowLayout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:CLEARCOLOR];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView setScrollsToTop:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ZUserInfoGridCVC class] forCellWithReuseIdentifier:kZUserInfoGridTVCCellId];
    [self.viewMain addSubview:self.collectionView];
    
    self.imgLine1 = [UIImageView getDLineView];
    [self.imgLine1 setFrame:CGRectMake(0, itemH, self.cellW, kLineHeight)];
    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [UIImageView getDLineView];
    [self.imgLine2 setFrame:CGRectMake(itemW, 0, kLineHeight, cvH)];
    [self.viewMain addSubview:self.imgLine2];
    
    self.imgLine3 = [UIImageView getDLineView];
    [self.imgLine3 setFrame:CGRectMake(itemW*2, 0, kLineHeight, cvH)];
    [self.viewMain addSubview:self.imgLine3];
    
    self.imgLine4 = [UIImageView getSLineView];
    [self.imgLine4 setFrame:CGRectMake(0, self.cellH-10, self.cellW, 10)];
    [self.viewMain addSubview:self.imgLine4];
    
    [self.viewMain sendSubviewToBack:self.collectionView];
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self setModel:model];
    
    [self.collectionView reloadData];
    
    return self.cellH;
}
+(CGFloat)getH
{
    return 190;
}
-(void)dealloc
{
    OBJC_RELEASE(_model);
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
    OBJC_RELEASE(_arrayMain);
    OBJC_RELEASE(_collectionView);
    [self setViewNil];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZUserInfoGridCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZUserInfoGridTVCCellId forIndexPath:indexPath];
    
    NSNumber *type = [self.arrayMain objectAtIndex:indexPath.row];
    switch ([type integerValue]) {
        case ZUserInfoGridCVCTypeWaitAnswer:
            [cell setViewDataWithType:[type integerValue] count:self.model.myWaitAnsCount];
            break;
        case ZUserInfoGridCVCTypeMessageCenter:
            [cell setViewDataWithType:[type integerValue] count:self.model.myNoticeCenterCount];
            break;
        case ZUserInfoGridCVCTypeMessage:
            [cell setViewDataWithType:[type integerValue] count:self.model.myMessageCount];
            break;
        default:
            [cell setViewDataWithType:[type integerValue] count:0];
            break;
    }
    ZWEAKSELF
    [cell setOnUserInfoCenterItemClick:^(ZUserInfoGridCVCType type) {
        if (weakSelf.onUserInfoCenterItemClick) {
            weakSelf.onUserInfoCenterItemClick(type);
        }
    }];
    
    return cell;
}

@end
