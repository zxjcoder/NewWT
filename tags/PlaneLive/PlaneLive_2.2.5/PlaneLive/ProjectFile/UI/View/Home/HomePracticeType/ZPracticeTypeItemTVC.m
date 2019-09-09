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
///微课分类
@property (strong, nonatomic) ZScrollView *scrollView;
///分页显示
@property (strong, nonatomic) ZView *viewType;
///数据源
@property (strong, nonatomic) NSArray *svArray;
///标题
@property (strong, nonatomic) ZView *viewTitle;
///全部实物
@property (strong, nonatomic) UILabel *lbTitle;
///分割线
@property (strong, nonatomic) UIImageView *imageLine1;
///分割线
@property (strong, nonatomic) UIImageView *imageLine2;
///排序
@property (strong, nonatomic) UIButton *btnSort;
///排序
@property (strong, nonatomic) ZLabel *lbSort;
@property (strong, nonatomic) ZImageView *imgSort;
@property (assign, nonatomic) CGFloat itemCount;

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
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.scrollView = [[ZScrollView alloc] init];
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
    
    if (IsIPadDevice) {
        self.itemCount = 8;
    } else {
        self.itemCount = 4;
    }
    [self createItemButton:0];
    [self createItemButton:1];
    [self createItemButton:2];
    //[self createItemButton:3];
    //[self createItemButton:4];
    
    self.viewType = [[ZView alloc] init];
    [self.viewMain addSubview:self.viewType];
    
    for (int i = 0; i < 5; i++) {
        ZImageView *viewPage = [[ZImageView alloc] init];
        [viewPage setHidden:true];
        [viewPage setTag:i+100];
        [self.viewType addSubview:viewPage];
    }
    
    self.viewTitle = [[ZView alloc] init];
    self.viewTitle.userInteractionEnabled = true;
    [self.viewMain addSubview:self.viewTitle];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setText:kAllPractice];
    [self.lbTitle setTextColor:COLORTEXT1];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewTitle addSubview:self.lbTitle];
    
    self.btnSort = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSort setTag:ZPracticeTypeSortRecommend];
    [self.btnSort setUserInteractionEnabled:true];
    [self.btnSort addTarget:self action:@selector(btnSortClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewTitle addSubview:self.btnSort];
    
    self.lbSort = [[ZLabel alloc] init];
    [self.lbSort setText:@"按推荐排序"];
    [self.lbSort setTextColor:COLORTEXT3];
    [self.lbSort setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbSort setTextAlignment:(NSTextAlignmentRight)];
    self.lbSort.userInteractionEnabled = false;
    [self.btnSort addSubview:self.lbSort];
    
    self.imgSort = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"arrow_down"]];
    self.imgSort.userInteractionEnabled = false;
    [self.btnSort addSubview:self.imgSort];
    
    self.imageLine1 = [UIImageView getDLineView];
    [self.viewTitle addSubview:self.imageLine1];
    
    self.imageLine2 = [UIImageView getDLineView];
    [self.viewTitle addSubview:self.imageLine2];
    
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
}
-(void)createItemButton:(NSInteger)index
{
    ///左右间距
    CGFloat itemS = 20+(index*APP_FRAME_WIDTH);
    CGFloat itemW = 52;
    CGFloat itemH = 55;
    CGFloat itemSpace = (APP_FRAME_WIDTH-20*2-itemW*self.itemCount)/(self.itemCount-1);
    for (int i = 0; i < self.itemCount*2; i++) {
        ///起始x
        CGFloat itemX = itemS+itemW*i+itemSpace*i;
        CGFloat itemY = 10;
        if (i>=self.itemCount) {
            itemY = 10+itemH+15;
            itemX = itemS+itemW*(i-self.itemCount)+itemSpace*(i-self.itemCount);
        }
        ZButton *btnItem = [[ZButton alloc] initWithFrame:(CGRectMake(itemX, itemY, itemW, itemH))];
        btnItem.hidden = true;
        [btnItem setTag:100+(i)*(index+1)];
        btnItem.userInteractionEnabled = true;
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.scrollView addSubview:btnItem];
        
        CGFloat imageItemSize = 32;
        ZImageView *imageItem = [[ZImageView alloc] initWithFrame:(CGRectMake(btnItem.width/2-imageItemSize/2, 0, imageItemSize, imageItemSize))];
        imageItem.userInteractionEnabled = false;
        [imageItem setTag:10];
        [btnItem addSubview:imageItem];
        CGFloat lbW = 80;
        ZLabel *lbItem = [[ZLabel alloc] initWithFrame:(CGRectMake(btnItem.width/2-lbW/2, btnItem.height-20, lbW, 20))];
        [lbItem setTextColor:COLORTEXT2];
        [lbItem setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [lbItem setTextAlignment:(NSTextAlignmentCenter)];
        [lbItem setTag:11];
        lbItem.userInteractionEnabled = false;
        [btnItem addSubview:lbItem];
    }
}
-(void)setViewFrame
{
    for (ZButton *btn in self.scrollView.subviews) {
        btn.hidden = true;
    }
    CGFloat itemH = 55;
    if (self.svArray.count <= self.itemCount) {
        [self.scrollView setFrame:(CGRectMake(0, 0, self.cellW, itemH+20))];
    } else {
        [self.scrollView setFrame:(CGRectMake(0, 0, self.cellW, itemH*2+40))];
    }
    int typePage = 1;
    if (self.svArray.count > self.itemCount*2 && self.svArray.count <= self.itemCount*4) {
        //第二页存在
        typePage = 2;
        [self.scrollView setContentSize:(CGSizeMake(self.scrollView.width*2, self.scrollView.height))];
    } else if (self.svArray.count > self.itemCount*4 && self.svArray.count <= self.itemCount*6) {
        //第三页存在
        typePage = 3;
        [self.scrollView setContentSize:(CGSizeMake(self.scrollView.width*3, self.scrollView.height))];
    } else if (self.svArray.count > self.itemCount*6 && self.svArray.count <= self.itemCount*8) {
        //第四页存在
        typePage = 4;
        [self.scrollView setContentSize:(CGSizeMake(self.scrollView.width*4, self.scrollView.height))];
    } else if (self.svArray.count > self.itemCount*8 && self.svArray.count <= self.itemCount*10) {
        //第五页存在
        typePage = 5;
        [self.scrollView setContentSize:(CGSizeMake(self.scrollView.width*5, self.scrollView.height))];
    } else {
        //只存在一页
        typePage = 1;
        [self.scrollView setContentSize:(CGSizeMake(self.scrollView.width, self.scrollView.height))];
    }
    [self.scrollView setBackgroundColor:BLUECOLOR];
    [self.scrollView setContentOffset:(CGPointMake(0, 0)) animated:false];
    int index = 0;
    for (ModelPracticeType *modelPT in self.svArray) {
        ZButton *btnItem = [self.scrollView viewWithTag:100+index];
        btnItem.hidden = false;
        ZImageView *image = [btnItem viewWithTag:10];
        [image setImageURLStr:modelPT.spe_img placeImage:[SkinManager getDefaultImage]];
        ZLabel *lbItem = [btnItem viewWithTag:11];
        lbItem.text = modelPT.type;
        index++;
    }
    [self.viewType setFrame:CGRectMake(0, self.scrollView.y+self.scrollView.height+10, self.width, 20)];
    for (int i = 0; i<5; i++) {
        ZImageView *viewPage = [self.viewType viewWithTag:100+i];
        viewPage.hidden = true;
        viewPage.image = [SkinManager getImageWithName:@"page"];
    }
    CGFloat pageW = 15;
    CGFloat pageH = 2;
    CGFloat pageS = 10;
    CGFloat pageY = self.viewType.height/2-pageH/2;
    switch (typePage) {
        case 1:{
            ZImageView *viewPage = [self.viewType viewWithTag:100];
            viewPage.hidden = false;
            viewPage.image = [SkinManager getImageWithName:@"pages_s"];
            CGFloat viewPageX = self.viewType.width/2-pageW/2;
            viewPage.frame = CGRectMake(viewPageX, pageY, pageW, pageH);
            break;
        }
        case 2:{
            ZImageView *viewPage1 = [self.viewType viewWithTag:100];
            viewPage1.hidden = false;
            viewPage1.image = [SkinManager getImageWithName:@"pages_s"];
            CGFloat viewPage1X = self.viewType.width/2-pageW-pageS/2;
            viewPage1.frame = CGRectMake(viewPage1X, pageY, pageW, pageH);
            ZImageView *viewPage2 = [self.viewType viewWithTag:101];
            viewPage2.hidden = false;
            CGFloat viewPage2X = self.viewType.width/2+pageS/2;
            viewPage2.frame = CGRectMake(viewPage2X, pageY, pageW, pageH);
            break;
        }
        case 3:{
            ZImageView *viewPage1 = [self.viewType viewWithTag:100];
            viewPage1.hidden = false;
            viewPage1.image = [SkinManager getImageWithName:@"pages_s"];
            CGFloat viewPage1X = self.viewType.width/2-pageW-pageS-pageW/2;
            viewPage1.frame = CGRectMake(viewPage1X, pageY, pageW, pageH);
            ZImageView *viewPage2 = [self.viewType viewWithTag:101];
            viewPage2.hidden = false;
            CGFloat viewPage2X = self.viewType.width/2-pageW/2;
            viewPage2.frame = CGRectMake(viewPage2X, pageY, pageW, pageH);
            ZImageView *viewPage3 = [self.viewType viewWithTag:102];
            viewPage3.hidden = false;
            CGFloat viewPage3X = self.viewType.width/2+pageW/2+pageS;
            viewPage3.frame = CGRectMake(viewPage3X, pageY, pageW, pageH);
            break;
        }
        case 4:{
            ZImageView *viewPage1 = [self.viewType viewWithTag:100];
            viewPage1.hidden = false;
            viewPage1.image = [SkinManager getImageWithName:@"pages_s"];
            CGFloat viewPage1X = self.viewType.width/2-pageS/2-pageW-pageS-pageW;
            viewPage1.frame = CGRectMake(viewPage1X, pageY, pageW, pageH);
            ZImageView *viewPage2 = [self.viewType viewWithTag:101];
            viewPage2.hidden = false;
            CGFloat viewPage2X = self.viewType.width/2-pageS/2-pageW;
            viewPage2.frame = CGRectMake(viewPage2X, pageY, pageW, pageH);
            ZImageView *viewPage3 = [self.viewType viewWithTag:102];
            viewPage3.hidden = false;
            CGFloat viewPage3X = self.viewType.width/2+pageS/2;
            viewPage3.frame = CGRectMake(viewPage3X, pageY, pageW, pageH);
            ZImageView *viewPage4 = [self.viewType viewWithTag:103];
            viewPage4.hidden = false;
            CGFloat viewPage4X = self.viewType.width/2+pageS/2+pageW+pageS;
            viewPage4.frame = CGRectMake(viewPage4X, pageY, pageW, pageH);
            break;
        }
        case 5:{
            ZImageView *viewPage1 = [self.viewType viewWithTag:100];
            viewPage1.hidden = false;
            viewPage1.image = [SkinManager getImageWithName:@"pages_s"];
            CGFloat viewPage1X = self.viewType.width/2-pageW/2-pageW*2-pageS*2;
            viewPage1.frame = CGRectMake(viewPage1X, pageY, pageW, pageH);
            ZImageView *viewPage2 = [self.viewType viewWithTag:101];
            viewPage2.hidden = false;
            CGFloat viewPage2X = self.viewType.width/2-pageW/2-pageW-pageS;
            viewPage2.frame = CGRectMake(viewPage2X, pageY, pageW, pageH);
            ZImageView *viewPage3 = [self.viewType viewWithTag:102];
            viewPage3.hidden = false;
            CGFloat viewPage3X = self.viewType.width/2-pageW/2;
            viewPage3.frame = CGRectMake(viewPage3X, pageY, pageW, pageH);
            ZImageView *viewPage4 = [self.viewType viewWithTag:103];
            viewPage4.hidden = false;
            CGFloat viewPage4X = self.viewType.width/2+pageW/2+pageS;
            viewPage4.frame = CGRectMake(viewPage4X, pageY, pageW, pageH);
            ZImageView *viewPage5 = [self.viewType viewWithTag:104];
            viewPage5.hidden = false;
            CGFloat viewPage5X = self.viewType.width/2+pageW/2+pageS*2+pageW;
            viewPage5.frame = CGRectMake(viewPage5X, pageY, pageW, pageH);
            break;
        }
        default:
            break;
    }
    [self.viewTitle setFrame:(CGRectMake(0, self.viewType.y+self.viewType.height, self.cellW, 30))];
    [self.lbTitle setFrame:(CGRectMake(self.space, 5, 100, 20))];
    [self.btnSort setFrame:(CGRectMake(self.viewType.width-self.space-120, 0, 120, self.viewTitle.height))];
    [self.lbSort setFrame:(CGRectMake(0, self.btnSort.height/2-self.lbH/2, self.btnSort.width-25, self.lbH))];
    self.imgSort.frame = CGRectMake(self.btnSort.width-24, 3, 24, 24);
    [self.imageLine1 setFrame:(CGRectMake(self.space, 0, self.cellW-self.space*2, kLineHeight))];
    [self.imageLine2 setFrame:(CGRectMake(self.space, self.viewTitle.height-kLineHeight, self.cellW-self.space*2, kLineHeight))];
    
    self.cellH = self.imageLine2.y+self.imageLine2.height;
    [self.viewMain setFrame:[self getMainFrame]];
}

///设置数据源
-(CGFloat)setViewDataWithArray:(NSArray *)array
{
    for (UIView *view in self.viewType.subviews) {
        [view removeFromSuperview];
    }
    self.svArray = nil;
    self.svArray = [NSArray arrayWithArray:array];
    
    [self setViewFrame];
    
    return self.cellH;
}
-(void)btnItemClick:(ZButton *)sender
{
    if (sender.tag<self.svArray.count) {
        ModelPracticeType *modelP = [self.svArray objectAtIndex:sender.tag];
        if (self.onTypeClick) {
            self.onTypeClick(modelP);
        }
    }
}
-(void)btnSortClick:(UIButton *)sender
{
    if (self.onSortClick) {
        self.onSortClick(sender.tag);
    }
}
-(void)setSortButtonTag:(ZPracticeTypeSort)tag
{
    [self.btnSort setTag:tag];
    switch (tag) {
        case ZPracticeTypeSortRecommend:
            self.lbSort.text = @"按推荐排序";
            break;
        case ZPracticeTypeSortHot:
            self.lbSort.text = @"按热门排序";
        case ZPracticeTypeSortNew:
            self.lbSort.text = @"按最新排序";
        default: break;
    }
}
-(ZPracticeTypeSort)getSortValue
{
    return self.btnSort.tag;
}
+(CGFloat)getH
{
    return 110;
}
-(void)dealloc
{
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
    for (int i = 0; i<5; i++) {
        ZImageView *viewPage = [self.viewType viewWithTag:i+1];
        viewPage.image = [SkinManager getImageWithName:@"page"];
    }
    ZImageView *viewPage = [self.viewType viewWithTag:_currentPage+1];
    viewPage.image = [SkinManager getImageWithName:@"page_s"];
}

@end
