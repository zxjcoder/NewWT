//
//  ZNewSearchHistoryView.m
//  PlaneLive
//
//  Created by Daniel on 28/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewSearchHistoryView.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "ZScrollView.h"

@interface ZNewSearchHistoryView()<UIScrollViewDelegate>

@property (strong, nonatomic) ZScrollView *scrollView;
@property (strong, nonatomic) ZView *viewHot;
@property (strong, nonatomic) ZView *viewHistory;
@property (strong, nonatomic) ZLabel *lbHot;
@property (strong, nonatomic) ZView *viewHistoryTitle;
@property (strong, nonatomic) ZLabel *lbHistory;
@property (strong, nonatomic) ZButton *btnDelete;

@property (strong, nonatomic) NSArray *arrayHot;
@property (strong, nonatomic) NSArray *arrayHistory;

@end

@implementation ZNewSearchHistoryView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}
#define kSearchItemCount 9
-(void)innerInit
{
    if (!self.scrollView) {
        self.scrollView = [[ZScrollView alloc] initWithFrame:self.bounds];
        [self.scrollView setBackgroundColor:WHITECOLOR];
        [self.scrollView setDelegate:self];
        [self addSubview:self.scrollView];
    }
    if (!self.viewHot) {
        self.viewHot = [[ZView alloc] init];
        [self.viewHot setUserInteractionEnabled:true];
        [self.scrollView addSubview:self.viewHot];
    }
    if (!self.viewHistory) {
        self.viewHistory = [[ZView alloc] init];
        [self.viewHistory setUserInteractionEnabled:true];
        [self.scrollView addSubview:self.viewHistory];
    }
    if (self.viewHot.subviews.count == 0) {
        for (int i=0; i<kSearchItemCount; i++) {
            ZButton *btnItem = [ZButton buttonWithType:(UIButtonTypeCustom)];
            [btnItem setTag:100+i];
            [btnItem setUserInteractionEnabled:true];
            [btnItem setTitleColor:COLORTEXT2 forState:(UIControlStateNormal)];
            [[btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
            [btnItem setViewRound:2 borderWidth:1 borderColor:COLORVIEWBACKCOLOR3];
            [btnItem setBackgroundImage:[UIImage createImageWithColor:WHITECOLOR] forState:(UIControlStateNormal)];
            [btnItem setBackgroundImage:[UIImage createImageWithColor:COLORVIEWBACKCOLOR2] forState:(UIControlStateHighlighted)];
            [btnItem addTarget:self action:@selector(btnHotItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.viewHot addSubview:btnItem];
        }
    }
    if (self.viewHistory.subviews.count == 0) {
        for (int i=0; i<kSearchItemCount; i++) {
            ZButton *btnItem = [ZButton buttonWithType:(UIButtonTypeCustom)];
            [btnItem setTag:100+i];
            [btnItem setUserInteractionEnabled:true];
            [btnItem setTitleColor:COLORTEXT2 forState:(UIControlStateNormal)];
            [[btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
            [btnItem setViewRound:2 borderWidth:1 borderColor:COLORVIEWBACKCOLOR3];
            [btnItem setBackgroundImage:[UIImage createImageWithColor:WHITECOLOR] forState:(UIControlStateNormal)];
            [btnItem setBackgroundImage:[UIImage createImageWithColor:COLORVIEWBACKCOLOR2] forState:(UIControlStateHighlighted)];
            [btnItem addTarget:self action:@selector(btnHistoryItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.viewHistory addSubview:btnItem];
        }
    }
    if (!self.viewHistoryTitle) {
        self.viewHistoryTitle = [[ZView alloc] init];
        [self.viewHistoryTitle setUserInteractionEnabled:true];
        [self.scrollView addSubview:self.viewHistoryTitle];
        
        self.lbHistory = [[ZLabel alloc] init];
        [self.lbHistory setTextColor:COLORTEXT3];
        [self.lbHistory setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.viewHistoryTitle addSubview:self.lbHistory];
        
        self.btnDelete = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnDelete setUserInteractionEnabled:true];
        [self.btnDelete setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
        [self.btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewHistoryTitle addSubview:self.btnDelete];
    }
    if (!self.lbHot) {
        self.lbHot = [[ZLabel alloc] initWithFrame:(CGRectMake(20, 20, 200, 20))];
        [self.lbHot setTextColor:COLORTEXT3];
        [self.lbHot setText:@"热门搜索"];
        [self.lbHot setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.scrollView addSubview:self.lbHot];
    }
    [self setViewFrame];
}
-(void)setViewFrame
{
    CGRect hotFrame = CGRectMake(20, self.lbHot.y+self.lbHot.height+12, self.width-40, 0);
    [self.viewHot setFrame:hotFrame];
    [self.viewHistory setFrame:hotFrame];
    CGFloat hotItemX = 0;
    CGFloat hotItemY = 0;
    CGFloat hotItemH = 30;
    
    CGFloat historyItemX = 0;
    CGFloat historyItemY = 0;
    CGFloat historyItemH = 30;
    for (NSInteger i=0; i<kSearchItemCount; i++) {
        /// 处理热门搜索
        ZButton *btnHotItem = [self.viewHot viewWithTag:i+100];
        [btnHotItem setHidden:true];
        [btnHotItem setTitle:kEmpty forState:(UIControlStateNormal)];
        if (i<self.arrayHot.count) {
            [btnHotItem setHidden:false];
            
            NSString *textKeyword = [self.arrayHot objectAtIndex:i];
            [btnHotItem setTitle:textKeyword forState:(UIControlStateNormal)];
            
            CGRect itemFrame = CGRectMake(0, 0, 30, hotItemH);
            [btnHotItem setFrame:itemFrame];
            CGFloat newWidth = [btnHotItem.titleLabel getLabelWidthWithMinWidth:0] + 30;
            if ((hotItemX+newWidth) >= self.viewHot.width) {
                hotItemX = 0;
                hotItemY = hotItemY + hotItemH + 10;
            }
            itemFrame = CGRectMake(hotItemX, hotItemY, newWidth, hotItemH);
            [btnHotItem setFrame:itemFrame];
            
            hotItemX = hotItemX + newWidth + 20;
        }
        /// 处理历史搜索
        ZButton *btnHistoryItem = [self.viewHistory viewWithTag:i+100];
        [btnHistoryItem setHidden:true];
        [btnHistoryItem setTitle:kEmpty forState:(UIControlStateNormal)];
        if (i<self.arrayHistory.count) {
            [btnHistoryItem setHidden:false];
            
            NSString *textKeyword = [self.arrayHistory objectAtIndex:i];
            [btnHistoryItem setTitle:textKeyword forState:(UIControlStateNormal)];
            
            CGRect itemFrame = CGRectMake(0, 0, 0, historyItemH);
            [btnHistoryItem setFrame:itemFrame];
            CGFloat newWidth = [btnHistoryItem.titleLabel getLabelWidthWithMinWidth:0] + 30;
            if ((historyItemX+newWidth) >= self.viewHistory.width) {
                historyItemX = 0;
                historyItemY = historyItemY + historyItemH + 10;
            }
            itemFrame = CGRectMake(historyItemX, historyItemY, newWidth, historyItemH);
            [btnHistoryItem setFrame:itemFrame];
            
            historyItemX = historyItemX + newWidth + 20;
        }
    }
    hotFrame.size.height = hotItemY+hotItemH;
    [self.viewHot setFrame:hotFrame];
    [self.viewHistoryTitle setFrame:(CGRectMake(0, self.viewHot.y+self.viewHot.height+10, self.width, 40))];
    CGFloat historyH = historyItemY+historyItemH;
    CGRect historyFrame = CGRectMake(20, self.viewHistoryTitle.y+self.viewHistoryTitle.height, self.width-40, historyH);
    [self.viewHistory setFrame:historyFrame];
    
    [self.lbHistory setFrame:CGRectMake(20, 10, 200, 20)];
    [self.btnDelete setFrame:(CGRectMake(self.width-50, 0, 40, 40))];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.viewHistory.y+self.viewHistory.height+20);
}
-(void)btnHistoryItemClick:(ZButton *)sender
{
    if (self.onKeywordClick) {
        self.onKeywordClick([self.arrayHistory objectAtIndex:sender.tag-100]);
    }
}
-(void)btnHotItemClick:(ZButton *)sender
{
    if (self.onKeywordClick) {
        self.onKeywordClick([self.arrayHot objectAtIndex:sender.tag-100]);
    }
}
-(void)btnDeleteClick
{
    if (self.onDelegateClick) {
        self.onDelegateClick();
    }
}
-(void)setViewHotData:(NSArray *)array
{
    self.arrayHot = array;
    
    [self setViewFrame];
}
-(void)setViewHistoryData:(NSArray *)array
{
    self.arrayHistory = array;
    [self.lbHistory setText:@"历史搜索"];
    self.btnDelete.hidden = array.count==0;
    [self.btnDelete setImage:[SkinManager getImageWithName:@"delete"] forState:(UIControlStateNormal)];
    
    [self setViewFrame];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.onContentOffsetChange) {
        self.onContentOffsetChange(scrollView.contentOffset.y);
    }
}

@end
