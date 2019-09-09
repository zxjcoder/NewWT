//
//  ZCircleTableView.m
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZCircleTableView.h"
#import "ZBackgroundView.h"

@interface ZCircleTableView()

///背景
@property (strong, nonatomic) ZBackgroundView *viewBG;
///背景状态
@property (assign, nonatomic) ZBackgroundState viewBGState;

@end

@implementation ZCircleTableView

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    __weak typeof(self) weakSelf = self;
    self.viewBG = [[ZBackgroundView alloc] init];
    [self.viewBG setOnButtonClick:^{
        if (weakSelf.onBackgroundClick) {
            weakSelf.onBackgroundClick(weakSelf.viewBGState);
        }
    }];
    [self setBackgroundView:self.viewBG];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    [self.viewBG setFrame:self.bounds];
}

-(void)setBackgroundViewWithState:(ZBackgroundState)backState
{
    [self setViewBGState:backState];
    [self.viewBG setViewStateWithState:(self.viewBGState)];
    [self setViewFrame];
}

-(void)setViewDataWithDictionary:(NSDictionary *)dicResult
{
//    [self setDicRawData:dicResult];
}

-(void)setViewKeyword:(NSString *)keyword
{
    
}

-(void)dealloc
{
    OBJC_RELEASE(_viewBG);
}

@end