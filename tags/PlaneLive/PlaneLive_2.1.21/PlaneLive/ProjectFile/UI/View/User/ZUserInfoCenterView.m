//
//  ZUserInfoCenterView.m
//  PlaneLive
//
//  Created by Daniel on 24/02/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZUserInfoCenterView.h"
#import "ZCollectionViewLayout.h"
#import "ZUserInfoCenterItemCVC.h"

#define kZUserInfoCenterViewCellId @"kZUserInfoCenterViewCellId"

@interface ZUserInfoCenterView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *arrayMain;
@property (strong, nonatomic) ModelUser *model;

@end

@implementation ZUserInfoCenterView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    CGFloat itemS = 0;
    CGFloat cvWidth = self.width;
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
    [self.collectionView registerClass:[ZUserInfoCenterItemCVC class] forCellWithReuseIdentifier:kZUserInfoCenterViewCellId];
    [self addSubview:self.collectionView];
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
-(void)setViewDataWithModel:(ModelUser *)model
{
    [self setModel:model];
    
    [self.collectionView reloadData];
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
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayMain.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZUserInfoCenterItemCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZUserInfoCenterViewCellId forIndexPath:indexPath];
    
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
