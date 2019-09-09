//
//  ZHomePracticeTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/3.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZHomePracticeTVC.h"
#import "ZHomeItemNavView.h"
#import "ZCollectionViewLayout.h"
#import "ZHomePracticeCVC.h"

static NSString *const kZHomePracticeTVCCollectionViewCellId = @"kZHomePracticeTVCCollectionViewCellId";

@interface ZHomePracticeTVC()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) ZHomeItemNavView *viewHeader;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIImageView *imgLine1;
@property (strong, nonatomic) UIImageView *imgLine2;

@property (strong, nonatomic) NSArray *arrMain;

@end

@implementation ZHomePracticeTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.cellH = [ZHomePracticeTVC getH];
    
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.viewHeader = [[ZHomeItemNavView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, kZHomeItemNavViewHeight) title:@"经典实务"];
    [self addSubview:self.viewHeader];
    
    CGFloat itemS = kSizeSpace/2;
    CGFloat cvWidth = self.cellW-kSizeSpace*2;
    CGFloat itemW = cvWidth/3-itemS;
    CGFloat itemH = itemW+kZHomePracticeTVCTitleHeight;
    
    ZCollectionViewLayout *collectionViewFlowLayout = [[ZCollectionViewLayout alloc] init];
    collectionViewFlowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(itemS*2, self.viewHeader.y+self.viewHeader.height+15, cvWidth, itemH) collectionViewLayout:collectionViewFlowLayout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:CLEARCOLOR];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView setScrollsToTop:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ZHomePracticeCVC class] forCellWithReuseIdentifier:kZHomePracticeTVCCollectionViewCellId];
    [self.viewMain addSubview:self.collectionView];
    
    self.imgLine1 = [UIImageView getDLineView];
    [self.imgLine1 setFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height, self.cellW, kLineHeight)];
    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.imgLine2 setFrame:CGRectMake(0, self.cellH-kSize10, self.cellW, kSize10)];
    [self.viewMain addSubview:self.imgLine2];
    
    ZWEAKSELF
    [self.viewHeader setOnAllClick:^{
        if (weakSelf.onAllClick) {
            weakSelf.onAllClick();
        }
    }];
}

-(void)setViewNil
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
    OBJC_RELEASE(_collectionView);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_onPracticeClick);
    OBJC_RELEASE(_onAllClick);
    
    [super setViewNil];
}
///设置数据源
-(void)setViewDataWithArray:(NSArray*)array
{
    [self setArrMain:array];
    
    [self.collectionView reloadData];
}
-(void)dealloc
{
    [self setViewNil];
}
-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getH
{
    return 240;
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrMain.count>kPracticeLineNumber?kPracticeLineNumber:self.arrMain.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomePracticeCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZHomePracticeTVCCollectionViewCellId forIndexPath:indexPath];
    
    ModelPractice *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onPracticeClick) {
        self.onPracticeClick(self.arrMain, indexPath.row);
    }
}

@end
