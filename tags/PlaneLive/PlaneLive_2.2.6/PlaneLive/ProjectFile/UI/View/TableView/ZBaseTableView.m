//
//  ZBaseTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZBaseTableView()<UIScrollViewDelegate>

///背景
@property (strong, nonatomic) ZBackgroundView *viewBG;
///背景状态
@property (assign, nonatomic) ZBackgroundState viewBGState;

@end

@implementation ZBaseTableView

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

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    if (!self.viewBG) {
        [self setDelegate:self];
        [self setUserInteractionEnabled:true];
        [self setBackgroundColor:VIEW_BACKCOLOR1];
        [self setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        
        ZWEAKSELF
        self.viewBG = [[ZBackgroundView alloc] initWithFrame:self.bounds];
        [self.viewBG setOnButtonClick:^{
            if (weakSelf.onBackgroundClick) {
                weakSelf.onBackgroundClick(weakSelf.viewBGState);
            }
        }];
        [self setBackgroundView:self.viewBG];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.viewBG) {
        [self.viewBG setFrame:self.bounds];
    }
}
-(void)setFontSizeChange
{
    
}

-(void)setBackgroundViewWithState:(ZBackgroundState)backState
{
    if (self.viewBG) {
        [self.viewBG setFrame:self.bounds];
        [self setViewBGState:backState];
        [self.viewBG setViewStateWithState:(self.viewBGState)];
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_viewBG);
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
    
}

-(void)setViewDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader
{
    
}

-(void)setViewKeyword:(NSString *)keyword
{
    
}

#pragma mark - UIScrollViewDelegate

/// 滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.oldOffsetY >= scrollView.contentOffset.y) {///下滑动
        [[NSNotificationCenter defaultCenter] postNotificationName:ZScrollViewDelegateNotification object:@(2)];
    } else {///上滑动
        [[NSNotificationCenter defaultCenter] postNotificationName:ZScrollViewDelegateNotification object:@(1)];
    }
}
/// 开始滑动时调用，只调用一次，手指不松开只算一次
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.oldOffsetY = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZScrollViewDelegateNotification object:@(2)];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ZScrollViewDelegateNotification object:@(2)];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZScrollViewDelegateNotification object:@(2)];
    }
}

@end
