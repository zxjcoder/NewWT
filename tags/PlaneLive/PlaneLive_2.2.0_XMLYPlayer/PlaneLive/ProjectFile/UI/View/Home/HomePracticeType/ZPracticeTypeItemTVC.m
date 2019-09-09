//
//  ZPracticeTypeItemTVC.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/4.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZPracticeTypeItemTVC.h"

@interface ZPracticeTypeItemTVC()<UIScrollViewDelegate>
{
    ///分页索引
    NSInteger _currentPage;
}
///实务分类
@property (strong, nonatomic) ZScrollView *scrollView;
///分页显示
@property (strong, nonatomic) UIPageControl *pageControl;
///数据源
@property (strong, nonatomic) NSArray *svArray;
///全部实物
@property (strong, nonatomic) UILabel *lbTitle;
///排序
@property (strong, nonatomic) UIButton *btnSort;

@end

@implementation ZPracticeTypeItemTVC

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
    
    self.cellH = [ZPracticeTypeItemTVC getH];
    
    self.scrollView = [[ZScrollView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, 125)];
    [self.scrollView setBounces:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setBackgroundColor:WHITECOLOR];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
    [self.viewMain addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 105, 0, 20)];
    [self.pageControl setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
    [self.pageControl setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
    [self.pageControl setUserInteractionEnabled:NO];
    [self.pageControl setCurrentPageIndicatorTintColor:RGBCOLOR(253, 176, 81)];
    [self.pageControl setPageIndicatorTintColor:RGBCOLOR(216, 216, 216)];
    [self.viewMain addSubview:self.pageControl];
    
    [self.viewMain sendSubviewToBack:self.scrollView];
    
    CGFloat bottomY = self.scrollView.y+self.scrollView.height;
    [self.viewMain setBackgroundColor:RGBCOLOR(242, 242, 242)];
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(kSizeSpace, bottomY+15, 100, 20)];
    [self.lbTitle setText:kAllPractice];
    [self.lbTitle setTextColor:RGBCOLOR(122, 122, 122)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewMain addSubview:self.lbTitle];
    
    self.btnSort = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSort setFrame:CGRectMake(self.cellW-100, bottomY, 100, 40)];
    [self.btnSort setImage:[SkinManager getImageWithName:@"sort_icon"] forState:(UIControlStateNormal)];
    [self.btnSort setTitle:kReverseChronologicalOrder forState:(UIControlStateNormal)];
    [self.btnSort setTitleColor:RGBCOLOR(122, 122, 122) forState:UIControlStateNormal];
    [[self.btnSort titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.btnSort setImageEdgeInsets:(UIEdgeInsetsMake(10, 75, 0, 0))];
    [self.btnSort setTitleEdgeInsets:(UIEdgeInsetsMake(7, -35, 0, 0))];
    [self.btnSort addTarget:self action:@selector(btnSortClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewMain addSubview:self.btnSort];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(void)btnSortClick:(UIButton *)sender
{
    if (self.onSortClick) {
        self.onSortClick((int)sender.tag);
    }
}
-(void)setSortButtonTag:(NSInteger)tag
{
    [self.btnSort setTag:tag];
}
-(void)setSortButtonText:(NSString *)text
{
    [self.btnSort setTitle:text forState:(UIControlStateNormal)];
}
+(CGFloat)getH
{
    return 165;
}
///设置数据源
-(void)setViewDataWithArray:(NSArray *)array
{
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    if (array == nil) {
        self.svArray = nil;
    } else {
        self.svArray = [NSArray arrayWithArray:array];
    }
    CGFloat itemCount = 4;
    if (IsIPadDevice) { itemCount = 8; }
    CGFloat itemW = 70;
    CGFloat itemH = 100;
    CGFloat itemY = 10;
    CGFloat itemSpace = (self.cellW-itemW*itemCount)/(itemCount+1);
    CGFloat itemX = 0;
    int index = 0;
    int pageCount = 0;
    for (ModelPracticeType *model in self.svArray) {
        if (IsIPadDevice) {
            if (index%8==0 && index > 0) {
                itemX += itemSpace*2+itemW;
                pageCount +=1;
            } else if(index==0 ) {
                pageCount = 1;
                itemX += itemSpace;
            } else {
                itemX += itemSpace+itemW;
            }
        } else {
            if (index%4==0 && index > 0) {
                itemX += itemSpace*2+itemW;
                pageCount +=1;
            } else if(index==0 ) {
                pageCount = 1;
                itemX += itemSpace;
            } else {
                itemX += itemSpace+itemW;
            }
        }
        ZButton *btnItem = [[ZButton alloc] initWithText:model.type imageUrl:model.spe_img];
        [btnItem setIconFrame:CGRectMake(itemX, itemY, itemW, itemH)];
        [btnItem setIconRoundNoBorder];
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [btnItem setTag:index];
        [self.scrollView addSubview:btnItem];
        index++;
    }
    [self.pageControl setNumberOfPages:pageCount];
    [self.pageControl setHidden:pageCount<=1];
    [self.scrollView setContentSize:CGSizeMake(pageCount*self.scrollView.width, self.scrollView.height)];
}
-(void)btnItemClick:(ZButton *)sender
{
    ModelPracticeType *modelP = [self.svArray objectAtIndex:sender.tag];
    if (self.onTypeClick) {
        self.onTypeClick(modelP);
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_pageControl);
    OBJC_RELEASE(_btnSort);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_onSortClick);
    _scrollView.delegate = nil;
    OBJC_RELEASE(_scrollView);
    OBJC_RELEASE(_svArray);
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentPage = (NSInteger)ceilf(scrollView.contentOffset.x / scrollView.width);
    [self.pageControl setCurrentPage:_currentPage];
}

@end
