//
//  ZNewHomeLawView.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewHomeLawView.h"
#import "ZNewHomeButtonView.h"
#import "ZNewHomeLawItemCVC.h"
#import "ZCollectionViewLayout.h"

static NSString *const kZNewHomeLawViewCollectionViewCellId = @"kZNewHomeLawViewCollectionViewCellId";

@interface ZNewHomeLawView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) ZNewHomeButtonView *viewTop;
@property (strong, nonatomic) UICollectionView *cvView;
@property (strong, nonatomic) NSArray *arrayMain;

@property (assign, nonatomic) CGFloat itemHeight;

@end

@implementation ZNewHomeLawView

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
    [self setBackgroundColor:WHITECOLOR];
    
    if (!self.viewTop) {
        self.viewTop = [[ZNewHomeButtonView alloc] initWithTitle:@"专业机构" desc:kEmpty isMore:true];
        [self addSubview:self.viewTop];
    }
    CGFloat itemW = [ZNewHomeLawItemCVC getW];
    self.itemHeight = [ZNewHomeLawItemCVC getH];
    
    if (!self.cvView) {
        ZCollectionViewLayout *collectionViewFlowLayout = [[ZCollectionViewLayout alloc] init];
        collectionViewFlowLayout.itemSize = CGSizeMake(itemW, self.itemHeight);
        
        self.cvView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, self.viewTop.height, self.width-25, 0) collectionViewLayout:collectionViewFlowLayout];
        [self.cvView setDataSource:self];
        [self.cvView setDelegate:self];
        [self.cvView setBackgroundColor:CLEARCOLOR];
        [self.cvView setScrollEnabled:NO];
        [self.cvView setScrollsToTop:NO];
        [self.cvView setShowsVerticalScrollIndicator:NO];
        [self.cvView setShowsHorizontalScrollIndicator:NO];
        [self.cvView registerClass:[ZNewHomeLawItemCVC class] forCellWithReuseIdentifier:kZNewHomeLawViewCollectionViewCellId];
        [self addSubview:self.cvView];
    }
    [self innerEvent];
}
-(void)innerEvent
{
    ZWEAKSELF
    [self.viewTop setOnAllClick:^{
        if (weakSelf.onMoreClick) {
            weakSelf.onMoreClick();
        }
    }];
}
-(CGFloat)setViewData:(NSArray *)array
{
    self.arrayMain = array;
    
    CGRect mainFrame = self.cvView.frame;
    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0) {
        mainFrame.size.height = self.itemHeight;//*array.count;
    } else {
        mainFrame.size.height = 0;
    }
    self.cvView.frame = mainFrame;
    [self.cvView reloadData];
    return self.cvView.y+self.cvView.height+10;
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayMain.count>2?2:self.arrayMain.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZNewHomeLawItemCVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZNewHomeLawViewCollectionViewCellId forIndexPath:indexPath];
    
    [cell innerInit];
    [cell setTag:indexPath.row];
    ModelLawFirm *model = [self.arrayMain objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:model];
    ZWEAKSELF
    [cell setOnLawFirmClick:^(ModelLawFirm *modelLF) {
        if (weakSelf.onLawFirmClick) {
            weakSelf.onLawFirmClick(modelLF);
        }
    }];
    return cell;
}

@end
