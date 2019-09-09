//
//  ZPracticeTypeSortView.m
//  PlaneLive
//
//  Created by Daniel on 10/03/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZPracticeTypeSortView.h"

#define kPTSorButtonCount 3

@interface ZPracticeTypeSortView()

@property (strong, nonatomic) UIButton *btnTimeSort;
@property (strong, nonatomic) UIImageView *imgLine1;
@property (strong, nonatomic) UIButton *btnPlaySort;
@property (strong, nonatomic) UIImageView *imgLine2;
@property (strong, nonatomic) UIButton *btnRecommendSort;

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
        
        self.btnRecommendSort = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnRecommendSort setFrame:CGRectMake(0, 0, self.width, self.height/kPTSorButtonCount)];
        [self.btnRecommendSort setTitle:kSortByRecommendation forState:(UIControlStateNormal)];
        [self.btnRecommendSort setTitleColor:BLACKCOLOR1 forState:UIControlStateNormal];
        [[self.btnRecommendSort titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
        [self.btnRecommendSort setTag:ZPracticeTypeSortRecommendation];
        [self.btnRecommendSort setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
        [self.btnRecommendSort setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
        [self.btnRecommendSort addTarget:self action:@selector(btnPlaySortClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnRecommendSort];
        
        self.imgLine1 = [UIImageView getDLineView];
        [self.imgLine1 setFrame:CGRectMake(0, self.btnTimeSort.height, self.width, kLineHeight)];
        [self addSubview:self.imgLine1];
        
        self.btnPlaySort = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPlaySort setFrame:CGRectMake(0, self.height/kPTSorButtonCount*1, self.width, self.height/kPTSorButtonCount)];
        [self.btnPlaySort setTitle:kSortByHot forState:(UIControlStateNormal)];
        [self.btnPlaySort setTitleColor:BLACKCOLOR1 forState:UIControlStateNormal];
        [[self.btnPlaySort titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
        [self.btnPlaySort setTag:ZPracticeTypeSortHot];
        [self.btnPlaySort setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
        [self.btnPlaySort setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
        [self.btnPlaySort addTarget:self action:@selector(btnPlaySortClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnPlaySort];
        
        self.imgLine2 = [UIImageView getDLineView];
        [self.imgLine2 setFrame:CGRectMake(0, self.btnPlaySort.y+self.btnPlaySort.height, self.width, kLineHeight)];
        [self addSubview:self.imgLine2];
        
        self.btnTimeSort = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnTimeSort setFrame:CGRectMake(0, self.height/kPTSorButtonCount*2, self.width, self.height/kPTSorButtonCount)];
        [self.btnTimeSort setTitle:kSortByNew forState:(UIControlStateNormal)];
        [self.btnTimeSort setTitleColor:BLACKCOLOR1 forState:UIControlStateNormal];
        [[self.btnTimeSort titleLabel] setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
        [self.btnTimeSort setTag:ZPracticeTypeSortNew];
        [self.btnTimeSort setContentVerticalAlignment:(UIControlContentVerticalAlignmentCenter)];
        [self.btnTimeSort setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentCenter)];
        [self.btnTimeSort addTarget:self action:@selector(btnPlaySortClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnTimeSort];
    }
    return self;
}
-(void)dealloc
{
    OBJC_RELEASE(_imgLine1);
    OBJC_RELEASE(_imgLine2);
    OBJC_RELEASE(_btnTimeSort);
    OBJC_RELEASE(_btnPlaySort);
    OBJC_RELEASE(_btnRecommendSort);
}
-(void)btnPlaySortClick:(UIButton *)sender
{
    [self setHiddenSortViewWithAnimate];
    if (self.onSortClick) {
        self.onSortClick(sender.tag);
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
