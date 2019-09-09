//
//  ZPracticeTypeTVC.m
//  PlaneLive
//
//  Created by Daniel on 02/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeTypeTVC.h"
#import "ZCollectionViewLayout.h"
#import "ZHomePracticeCVC.h"

static NSString *const kHomePracticeTypeTVCId = @"kHomePracticeTypeTVCId";

@interface ZPracticeTypeTVC()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) ZHomeItemNavView *viewHeader;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) NSArray *mainArray;

@property (strong, nonatomic) ModelPracticeType *model;

@end

@implementation ZPracticeTypeTVC

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
    
    self.cellH = [ZPracticeTypeTVC getH];
    
    self.viewHeader = [[ZHomeItemNavView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, kZHomeItemNavViewHeight)];
    [self.viewMain addSubview:self.viewHeader];
    
    CGFloat itemS = kSizeSpace/2;
    CGFloat cvWidth = self.cellW-kSizeSpace*2;
    CGFloat itemW = cvWidth/3-itemS;
    CGFloat itemH = itemW+kPracticeTVCTitleHeight;
    
    ZCollectionViewLayout *collectionViewFlowLayout = [[ZCollectionViewLayout alloc] init];
    collectionViewFlowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(itemS*2, self.viewHeader.y+self.viewHeader.height, cvWidth, itemH) collectionViewLayout:collectionViewFlowLayout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:CLEARCOLOR];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView setScrollsToTop:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ZHomePracticeCVC class] forCellWithReuseIdentifier:kHomePracticeTypeTVCId];
    [self.viewMain addSubview:self.collectionView];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.collectionView.y+self.collectionView.height+kSize10, self.cellW, kLineMaxHeight)];
    [self.viewMain addSubview:self.imgLine];
    
    ZWEAKSELF
    [self.viewHeader setOnAllClick:^{
        if (weakSelf.onAllClick) {
            weakSelf.onAllClick(weakSelf.model);
        }
    }];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}

+(CGFloat)getH
{
    return kPracticeTVCHeight;
}

///设置数据源
-(CGFloat)setCellDataWithModel:(ModelPracticeType *)model
{
    [self setModel:model];
    
    [self.viewHeader setViewTitle:model.type];
    
    [self setMainArray:model.arrPractice];
    
    [self.collectionView reloadData];
    
    return self.cellH;
}

-(void)dealloc
{
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_mainArray);
    
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    
    OBJC_RELEASE(_onAllClick);
    OBJC_RELEASE(_onPracticeClick);
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mainArray.count>kPracticeLineNumber?kPracticeLineNumber:self.mainArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomePracticeCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomePracticeTypeTVCId forIndexPath:indexPath];
    
    ModelPractice *model = [self.mainArray objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onPracticeClick) {
        self.onPracticeClick(self.mainArray, indexPath.row);
    }
}


@end
