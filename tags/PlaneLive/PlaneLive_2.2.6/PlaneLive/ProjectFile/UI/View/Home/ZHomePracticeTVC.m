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
#import "ZBaseTableView.h"
#import "ZHomePracticeItemTVC.h"

static NSString *const kZHomePracticeTVCCellId = @"kZHomePracticeTVCCellId";

@interface ZHomePracticeTVC()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ZHomeItemNavView *viewHeader;

@property (strong, nonatomic) ZBaseTableView *tvMain;

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
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.viewHeader = [[ZHomeItemNavView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, kZHomeItemNavViewHeight) title:kClassicPractice];
    [self addSubview:self.viewHeader];
    
    self.tvMain = [[ZBaseTableView alloc] initWithFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height-5, self.cellW, [ZHomePracticeItemTVC getH])];
    [self.tvMain setDelegate:self];
    [self.tvMain setDataSource:self];
    [self.tvMain setBounces:NO];
    [self.tvMain setScrollEnabled:NO];
    [self.tvMain setScrollsToTop:NO];
    [self.tvMain setRowHeight:[ZHomePracticeItemTVC getH]];
    [self.viewMain addSubview:self.tvMain];
    
//    CGFloat itemS = kSizeSpace/2;
//    CGFloat itemW = [[self class] getItemW];
//    CGFloat itemH = [[self class] getItemH];
//    
//    ZCollectionViewLayout *collectionViewFlowLayout = [[ZCollectionViewLayout alloc] init];
//    collectionViewFlowLayout.itemSize = CGSizeMake(itemW, itemH);
    
//    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(itemS*2, self.viewHeader.y+self.viewHeader.height+13, cvWidth, itemH*2) collectionViewLayout:collectionViewFlowLayout];
//    [self.collectionView setDataSource:self];
//    [self.collectionView setDelegate:self];
//    [self.collectionView setBackgroundColor:CLEARCOLOR];
//    [self.collectionView setScrollEnabled:NO];
//    [self.collectionView setScrollsToTop:NO];
//    [self.collectionView setShowsVerticalScrollIndicator:NO];
//    [self.collectionView setShowsHorizontalScrollIndicator:NO];
//    [self.collectionView registerClass:[ZHomePracticeCVC class] forCellWithReuseIdentifier:kZHomePracticeTVCCollectionViewCellId];
//    [self.viewMain addSubview:self.collectionView];
    
    //self.imgLine1 = [UIImageView getDLineView];
    //[self.imgLine1 setFrame:CGRectMake(0, self.viewHeader.y+self.viewHeader.height, self.cellW, kLineHeight)];
    //[self.viewMain addSubview:self.imgLine1];
    
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
    _tvMain.delegate = nil;
    _tvMain.dataSource = nil;
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
    OBJC_RELEASE(_tvMain);
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
    [self setViewFrame];
    [self.tvMain reloadData];
}
///根据数据设置高度
-(void)setViewFrame
{
//    CGFloat itemH = [[self class] getItemH];
    CGRect tvFrame = self.tvMain.frame;
    if (self.arrMain.count > 0) {
        tvFrame.size.height = self.arrMain.count*[ZHomePracticeItemTVC getH];
    } else {
        tvFrame.size.height = [ZHomePracticeItemTVC getH];
    }
    [self.tvMain setFrame:tvFrame];
    
//    CGRect cvFrame = self.tvMain.frame;
//    if (self.arrMain.count > kPracticeLineNumber) {
//        cvFrame.size.height = itemH*2;
//    } else {
//        cvFrame.size.height = itemH;
//    }
//    [self.collectionView setFrame:cvFrame];
    
    [self.imgLine2 setFrame:CGRectMake(0, self.tvMain.y+self.tvMain.height+5, self.cellW, kSize10)];
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
//每个微课的高度
+(CGFloat)getItemH
{
    CGFloat itemH = [[self class] getItemW]+kZHomePracticeTVCTitleHeight;
    return itemH;
}
//每个微课的宽度
+(CGFloat)getItemW
{
    CGFloat itemS = kSizeSpace/2;
    CGFloat cvWidth = [[self class] getContentW];
    CGFloat itemW = cvWidth/3-itemS;
    return itemW;
}
//微课列表的宽度
+(CGFloat)getContentW
{
    return APP_FRAME_WIDTH-kSizeSpace*2;;
}
//当前视图的高度
+(CGFloat)getH
{
    return kZHomeItemNavViewHeight+[[self class] getItemH]+5;
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMain.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHomePracticeItemTVC *cell = [tableView dequeueReusableCellWithIdentifier:kZHomePracticeTVCCellId];
    if (!cell) {
        cell = [[ZHomePracticeItemTVC alloc] initWithReuseIdentifier:kZHomePracticeTVCCellId];
    }
    [cell setCellDataWithModel:[self.arrMain objectAtIndex:indexPath.row]];
    [cell setIsHiddenLineView: indexPath.row >= self.arrMain.count-1];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.onPracticeClick) {
        self.onPracticeClick(self.arrMain, indexPath.row);
    }
}

@end
