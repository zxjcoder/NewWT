//
//  ZHomePracticeView.m
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomePracticeView.h"
#import "ZHomeItemNavView.h"
#import "ZCollectionViewLayout.h"
#import "ZHomePracticeCVC.h"

static NSString *const kHomePracticeCollectionViewCellId = @"kHomePracticeCollectionViewCellId";

@interface ZHomePracticeView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) ZHomeItemNavView *viewHeader;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) NSArray *mainArray;

@end

@implementation ZHomePracticeView

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
    [self setBackgroundColor:WHITECOLOR];
    
    self.viewHeader = [[ZHomeItemNavView alloc] initWithFrame:CGRectMake(0, 0, self.width, kZHomeItemNavViewHeight) title:kPractice];
    [self addSubview:self.viewHeader];
    
    CGFloat itemS = kSizeSpace/2;
    CGFloat cvWidth = self.width-kSizeSpace*2;
    CGFloat itemW = cvWidth/3-itemS;
    CGFloat itemH = itemW+kHomePracticeViewTitleHeight;
    
    ZCollectionViewLayout *collectionViewFlowLayout = [[ZCollectionViewLayout alloc] init];
    collectionViewFlowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(itemS*2, self.viewHeader.y+self.viewHeader.height, cvWidth, itemH*2) collectionViewLayout:collectionViewFlowLayout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:CLEARCOLOR];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView setScrollsToTop:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ZHomePracticeCVC class] forCellWithReuseIdentifier:kHomePracticeCollectionViewCellId];
    [self addSubview:self.collectionView];
    
    self.imgLine = [UIImageView getSLineView];
    [self.imgLine setFrame:CGRectMake(0, self.collectionView.y+self.collectionView.height+kSize10, self.width, kLineMaxHeight)];
    [self addSubview:self.imgLine];
    
    ZWEAKSELF
    [self.viewHeader setOnAllClick:^{
        if (weakSelf.onAllClick) {
            weakSelf.onAllClick();
        }
    }];
}

+(CGFloat)getViewHeight
{
    return kHomePracticeViewHeight;
}

///设置数据源
-(void)setViewDataWithArray:(NSArray*)array
{
    [self setMainArray:array];
    
    [self.collectionView reloadData];
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
    return self.mainArray.count>kPracticeLineNumber*2?kPracticeLineNumber*2:self.mainArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomePracticeCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomePracticeCollectionViewCellId forIndexPath:indexPath];
    
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
