//
//  ZHomeLawFirmTVC.m
//  PlaneLive
//
//  Created by Daniel on 11/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZHomeLawFirmTVC.h"
#import "ZHomeItemNavView.h"
#import "ZHomeLawFirmCVC.h"
#import "ZCollectionViewLayout.h"

static NSString *const kZHomeLawFirmTVCCollectionViewCellId = @"kZHomeLawFirmTVCCollectionViewCellId";

@interface ZHomeLawFirmTVC()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) ZHomeItemNavView *viewHeader;

@property (strong, nonatomic) UICollectionView *collectionView;

//@property (strong, nonatomic) UIImageView *imgLine1;
@property (strong, nonatomic) UIImageView *imgLine2;

@property (strong, nonatomic) NSArray *arrMain;

@end

@implementation ZHomeLawFirmTVC

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
    
    self.cellH = [ZHomeLawFirmTVC getH];
    
    [self.viewMain setBackgroundColor:WHITECOLOR];
    
    self.viewHeader = [[ZHomeItemNavView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, kZHomeItemNavViewHeight) title:kLawFirmGoodLawFirm];
    [self addSubview:self.viewHeader];
    
    CGFloat itemW = [[self class] getItemW];
    CGFloat itemH = kZHomeLawFirmCVCHeight;
    
    ZCollectionViewLayout *collectionViewFlowLayout = [[ZCollectionViewLayout alloc] init];
    collectionViewFlowLayout.itemSize = CGSizeMake(itemW, itemH);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height-5, self.cellW, itemH) collectionViewLayout:collectionViewFlowLayout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:CLEARCOLOR];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView setScrollsToTop:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView registerClass:[ZHomeLawFirmCVC class] forCellWithReuseIdentifier:kZHomeLawFirmTVCCollectionViewCellId];
    [self.viewMain addSubview:self.collectionView];
    
//    self.imgLine1 = [UIImageView getDLineView];
//    [self.imgLine1 setFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height, self.cellW, kLineHeight)];
//    [self.viewMain addSubview:self.imgLine1];
    
    self.imgLine2 = [UIImageView getSLineView];
    [self.viewMain addSubview:self.imgLine2];
    
    ZWEAKSELF
    [self.viewHeader setOnAllClick:^{
        if (weakSelf.onAllClick) {
            weakSelf.onAllClick();
        }
    }];
    [self setViewFrame];
}

-(void)setViewNil
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
//    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
    OBJC_RELEASE(_collectionView);
    OBJC_RELEASE(_viewHeader);
    OBJC_RELEASE(_arrMain);
    OBJC_RELEASE(_onLawFirmClick);
    OBJC_RELEASE(_onAllClick);
    
    [super setViewNil];
}
///设置数据源
-(void)setViewDataWithArray:(NSArray*)array
{
    [self setArrMain:array];
    [self setViewFrame];
    [self.collectionView reloadData];
}
///根据数据设置高度
-(void)setViewFrame
{
    CGRect cvFrame = self.collectionView.frame;
    CGFloat itemW = [[self class] getItemW];
    CGFloat itemH = kZHomeLawFirmCVCHeight;
    if (self.arrMain.count > 2) {
        cvFrame.size.height = itemH*2;
    } else {
        cvFrame.size.height = itemH;
    }
    [self.collectionView setFrame:cvFrame];
    [self.imgLine2 setFrame:CGRectMake(0, self.collectionView.y+self.collectionView.height+10, self.cellW, kSize10)];
    self.cellH = self.imgLine2.y+self.imgLine2.height;
}
-(void)dealloc
{
    [self setViewNil];
}
-(CGFloat)getH
{
    return self.cellH;
}
+(CGFloat)getItemW
{
    CGFloat itemW = APP_FRAME_WIDTH/2;
    return itemW;
}
+(CGFloat)getH
{
    return kZHomeItemNavViewHeight+kZHomeLawFirmCVCHeight+25;
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrMain.count>4?4:self.arrMain.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomeLawFirmCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZHomeLawFirmTVCCollectionViewCellId forIndexPath:indexPath];
    
    [cell setTag:indexPath.row];
    ModelLawFirm *model = [self.arrMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onLawFirmClick) {
        ModelLawFirm *model = [self.arrMain objectAtIndex:indexPath.row];
        self.onLawFirmClick(model);
    }
}

@end
