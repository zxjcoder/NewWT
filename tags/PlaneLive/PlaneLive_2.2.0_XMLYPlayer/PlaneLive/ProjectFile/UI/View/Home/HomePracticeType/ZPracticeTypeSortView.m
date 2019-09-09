//
//  ZPracticeTypeSortView.m
//  PlaneLive
//
//  Created by Daniel on 10/03/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZPracticeTypeSortView.h"

@interface ZPracticeTypeSortView()

@property (strong, nonatomic) UIButton *btnTimeSort;
@property (strong, nonatomic) UIImageView *imgLine;
@property (strong, nonatomic) UIButton *btnPlaySort;

@end

@implementation ZPracticeTypeSortView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setHidden:YES];
        [self setAlpha:0];
        [self setBackgroundColor:WHITECOLOR];
        [self.layer setMasksToBounds:YES];
        [self setViewRound:5 borderWidth:1 borderColor:DESCCOLOR];
        
        self.btnTimeSort = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnTimeSort setFrame:CGRectMake(0, 0, self.width, self.height/2)];
        [self.btnTimeSort setTitle:kReverseChronologicalOrder forState:(UIControlStateNormal)];
        [self.btnTimeSort setTitleColor:BLACKCOLOR1 forState:UIControlStateNormal];
        [[self.btnTimeSort titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
        [self.btnTimeSort setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
        [self.btnTimeSort setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
        [self.btnTimeSort addTarget:self action:@selector(btnTimeSortClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnTimeSort];
        
        self.imgLine = [UIImageView getDLineView];
        [self.imgLine setFrame:CGRectMake(0, self.btnTimeSort.height, self.width, kLineHeight)];
        [self addSubview:self.imgLine];
        
        self.btnPlaySort = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPlaySort setFrame:CGRectMake(0, self.btnTimeSort.height, self.width, self.height/2)];
        [self.btnPlaySort setTitle:kListenToTheReverse forState:(UIControlStateNormal)];
        [self.btnPlaySort setTitleColor:BLACKCOLOR1 forState:UIControlStateNormal];
        [[self.btnPlaySort titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
        [self.btnPlaySort setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
        [self.btnPlaySort setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
        [self.btnPlaySort addTarget:self action:@selector(btnPlaySortClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnPlaySort];
    }
    return self;
}
-(void)dealloc
{
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_btnTimeSort);
    OBJC_RELEASE(_btnPlaySort);
}
-(void)btnTimeSortClick:(UIButton *)sender
{
    [self setHiddenSortViewWithAnimate];
    if (self.onSortClick) {
        self.onSortClick(0);
    }
}
-(void)btnPlaySortClick:(UIButton *)sender
{
    [self setHiddenSortViewWithAnimate];
    if (self.onSortClick) {
        self.onSortClick(1);
    }
}
-(void)setShowSortViewWithAnimate
{
    [self setHidden:NO];
    [self setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        [self setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)setHiddenSortViewWithAnimate
{
    [self setHidden:NO];
    [self setAlpha:1];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}
-(void)setHiddenSortView
{
    [self setAlpha:0];
    [self setHidden:YES];
}

@end
