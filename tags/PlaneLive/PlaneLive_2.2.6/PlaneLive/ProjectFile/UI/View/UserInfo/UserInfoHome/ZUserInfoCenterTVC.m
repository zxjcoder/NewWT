//
//  ZUserInfoCenterTVC.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoCenterTVC.h"
#import "ZCollectionViewLayout.h"
#import "ZUserInfoCenterItemCVC.h"

static NSString *const kZUserInfoCenterCellId = @"kZUserInfoCenterCellId";

@interface ZUserInfoCenterTVC()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *arrayMain;

@property (strong, nonatomic) ModelUser *model;

@end

@implementation ZUserInfoCenterTVC

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
    
    self.cellH = [ZUserInfoCenterTVC getH];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    CGFloat itemS = 0;
    CGFloat cvWidth = self.cellW;
    CGFloat itemW = cvWidth/4;
    CGFloat itemH = 94;
    
    ZCollectionViewLayout *collectionViewFlowLayout = [[ZCollectionViewLayout alloc] init];
    collectionViewFlowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    CGFloat cvH = itemH*3;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(itemS, 0, cvWidth, cvH) collectionViewLayout:collectionViewFlowLayout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:CLEARCOLOR];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView setScrollsToTop:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ZUserInfoCenterItemCVC class] forCellWithReuseIdentifier:kZUserInfoCenterCellId];
    [self.viewMain addSubview:self.collectionView];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
///设置是否审核状态
-(void)setIsAuditStatus:(BOOL)status
{
    if (status) {
        self.arrayMain = @[@(ZUserInfoCenterItemTypeCollection),
                           @(ZUserInfoCenterItemTypeAttention),
                           @(ZUserInfoCenterItemTypeAnswer),
                           @(ZUserInfoCenterItemTypeComment),
                           @(ZUserInfoCenterItemTypeDownload),
                           @(ZUserInfoCenterItemTypeMessage),
                           @(ZUserInfoCenterItemTypeFeedback),
                           @(ZUserInfoCenterItemTypeSetting)];
    } else {
        self.arrayMain = @[@(ZUserInfoCenterItemTypeCollection),
                           @(ZUserInfoCenterItemTypeAttention),
                           @(ZUserInfoCenterItemTypeAnswer),
                           @(ZUserInfoCenterItemTypeComment),
                           @(ZUserInfoCenterItemTypeDownload),
                           @(ZUserInfoCenterItemTypeAccount),
                           @(ZUserInfoCenterItemTypeMessage),
                           @(ZUserInfoCenterItemTypeFeedback),
                           @(ZUserInfoCenterItemTypeSetting)];
    }
    [self.collectionView reloadData];
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    [self setModel:model];
    
    [self.collectionView reloadData];
    
    return self.cellH;
}

+(CGFloat)getH
{
    return 94*3+45;
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
    ZUserInfoCenterItemCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZUserInfoCenterCellId forIndexPath:indexPath];
    
    NSNumber *type = [self.arrayMain objectAtIndex:indexPath.row];
    switch ([type integerValue]) {
        case ZUserInfoCenterItemTypeComment:
            [cell setViewDataWithType:[type integerValue] count:self.model.myCommentReplyCount];
            break;
        case ZUserInfoCenterItemTypeMessage:
            [cell setViewDataWithType:[type integerValue] count:self.model.myNoticeCenterCount];
            break;
        default:
            [cell setViewDataWithType:[type integerValue] count:0];
            break;
    }
    ZWEAKSELF
    [cell setOnUserInfoCenterItemClick:^(ZUserInfoCenterItemType type) {
        if (weakSelf.onUserInfoCenterItemClick) {
            weakSelf.onUserInfoCenterItemClick(type);
        }
    }];
    
    return cell;
}

@end
