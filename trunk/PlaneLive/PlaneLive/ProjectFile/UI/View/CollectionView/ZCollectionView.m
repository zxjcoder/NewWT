//
//  ZCollectionView.m
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZCollectionView.h"
#import "ZBackgroundView.h"

@interface ZCollectionView()

///背景
@property (strong, nonatomic) ZBackgroundView *viewBG;
///背景状态
@property (assign, nonatomic) ZBackgroundState viewBGState;

@end

@implementation ZCollectionView

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:VIEW_BACKCOLOR1];
    
    if (!self.viewBG) {
        __weak typeof(self) weakSelf = self;
        self.viewBG = [[ZBackgroundView alloc] initWithFrame:self.bounds];
        [self.viewBG setOnButtonClick:^{
            if (weakSelf.onBackgroundClick) {
                weakSelf.onBackgroundClick(weakSelf.viewBGState);
            }
        }];
        [self setBackgroundView:self.viewBG];
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_viewBG);
}
-(void)setBackgroundViewWithState:(ZBackgroundState)backState
{
    [self.viewBG setFrame:self.bounds];
    [self setViewBGState:backState];
    [self.viewBG setViewStateWithState:(self.viewBGState)];
}

@end
