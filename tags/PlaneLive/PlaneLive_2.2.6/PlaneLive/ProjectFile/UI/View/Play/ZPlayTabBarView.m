//
//  ZPlayTabBarView.m
//  PlaneLive
//
//  Created by Daniel on 05/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPlayTabBarView.h"
#import "ZButton.h"

@interface ZPlayTabBarView()

@property (strong, nonatomic) ModelPractice *model;

@property (strong, nonatomic) ModelCurriculum *modelC;

@property (assign, nonatomic) ZPlayTabBarViewType playType;

@end

@implementation ZPlayTabBarView

-(instancetype)initWithPoint:(CGPoint)point
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, APP_FRAME_WIDTH, kZPlayTabBarViewHeight)];
    if (self) {
        [self setPlayType:ZPlayTabBarViewTypePractice];
        [self innerInitWithPractice];
    }
    return self;
}
///初始化
-(instancetype)initWithPoint:(CGPoint)point type:(ZPlayTabBarViewType)type
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, APP_FRAME_WIDTH, kZPlayTabBarViewHeight)];
    if (self) {
        [self setPlayType:type];
        switch (type) {
            case ZPlayTabBarViewTypePractice:
                [self innerInitWithPractice];
                break;
            case ZPlayTabBarViewTypeSubscribe:
                [self innerInitWithSubscribe];
                break;
            default:
                [self innerInitWithPractice];
                break;
        }
    }
    return self;
}

-(void)innerInitWithPractice
{
    CGFloat btnW = 50;
    CGFloat boderSpace = kSize20;
    CGFloat btnSpace = (APP_FRAME_WIDTH-boderSpace*2-btnW*6)/5;
    CGFloat btnH = 50;
    CGFloat btnY = 0;
    int index = 0;
    [self addButtonWithIndex:101 text:kNoteKey imageName:@"note" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 1;
    [self addButtonWithIndex:102 text:@"PPT" imageName:@"ppt" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 2;
    [self addButtonWithIndex:103 text:kZero imageName:@"playing_follow_btn_def" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 3;
    [self addButtonWithIndex:104 text:kZero imageName:@"collection_def" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 4;
    [self addButtonWithIndex:105 text:kPutQuestion imageName:@"question" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 5;
    [self addButtonWithIndex:106 text:kQuestionsAndAnswers imageName:@"qanda" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
}

-(void)innerInitWithSubscribe
{
    CGFloat btnW = 50;
    CGFloat boderSpace = kSize20;
    CGFloat btnSpace = (APP_FRAME_WIDTH-boderSpace*2-btnW*3)/2;
    CGFloat btnH = 50;
    CGFloat btnY = 0;
    int index = 0;
    [self addButtonWithIndex:108 text:kNoteKey imageName:@"note" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 1;
    [self addButtonWithIndex:109 text:@"PPT" imageName:@"ppt" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 2;
    [self addButtonWithIndex:110 text:kListKey imageName:@"play_list" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
}

-(void)innerInitWithFound
{
    CGFloat btnW = 50;
    CGFloat boderSpace = kSize20;
    CGFloat btnSpace = (APP_FRAME_WIDTH-boderSpace*2-btnW*5)/4;
    CGFloat btnH = 50;
    CGFloat btnY = 0;
    int index = 0;
    [self addButtonWithIndex:101 text:kNoteKey imageName:@"note" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 1;
    [self addButtonWithIndex:102 text:@"PPT" imageName:@"ppt" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 2;
    [self addButtonWithIndex:103 text:kZero imageName:@"playing_follow_btn_def" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 3;
    [self addButtonWithIndex:104 text:kZero imageName:@"collection_def" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
    
    index = 4;
    [self addButtonWithIndex:107 text:kListKey imageName:@"play_list" btnFrame:CGRectMake(boderSpace+(index*btnSpace)+(index*btnW), btnY, btnW, btnH)];
}

-(void)addButtonWithIndex:(NSInteger)index text:(NSString *)text imageName:(NSString *)imageName btnFrame:(CGRect)btnFrame
{
    ZButton *btnItem = [[ZButton alloc] initWithText:text imageName:imageName];
    [btnItem setBtnFrame:btnFrame];
    [btnItem setTag:index];
    [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnItem];
}

-(void)btnItemClick:(ZButton *)sender
{
    switch (sender.tag) {
        case 101://笔记
            if (self.onPracticeNoteClick) {
                self.onPracticeNoteClick(self.model);
            }
            break;
        case 102://PPT
            if (self.onPracticePPTClick) {
                self.onPracticePPTClick(self.model);
            }
            break;
        case 103://赞
            if (self.onPauseClick && self.model) {
                self.onPauseClick(self.model);
            }
            break;
        case 104://收藏
            if (self.onCollectionClick && self.model) {
                self.onCollectionClick(self.model);
            }
            break;
        case 105://提问
            if (self.onQuestionClick) {
                self.onQuestionClick(self.model);
            }
            break;
        case 106://问答
            if (self.onAnswerClick) {
                self.onAnswerClick(self.model);
            }
            break;
        case 107:///列表
            if (self.onPlayPracticeClick) {
                self.onPlayPracticeClick();
            }
            break;
        case 108://笔记
            if (self.onCurriculumNoteClick) {
                self.onCurriculumNoteClick(self.modelC);
            }
            break;
        case 109://PPT
            if (self.onCurriculumPPTClick) {
                self.onCurriculumPPTClick(self.modelC);
            }
            break;
        case 110:///列表
            if (self.onPlayCurriculumClick) {
                self.onPlayCurriculumClick();
            }
            break;
        default:
            break;
    }
}

-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
    
    ZButton *btnPraise = [self viewWithTag:103];
    [btnPraise setButtonText:[NSString stringWithFormat:@"%ld", model.applauds]];
    
    ZButton *btnCollection = [self viewWithTag:104];
    [btnCollection setButtonText:[NSString stringWithFormat:@"%ld", model.ccount]];
    
    if (model.isCollection) {
        [btnCollection setButtonImageName:@"collection_pre"];
    } else {
        [btnCollection setButtonImageName:@"collection_def"];
    }
    if (model.isPraise) {
        [btnPraise setButtonImageName:@"playing_followed_btn_pre"];
    } else {
        [btnPraise setButtonImageName:@"playing_follow_btn_def"];
    }
}

-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model
{
    [self setModelC:model];
}

/// 设置按钮是否可点
-(void)setButtonPPTEnabled:(BOOL)isEnabled
{
    ZButton *btnItem = [self viewWithTag:102];
    if (btnItem == nil) {
        btnItem = [self viewWithTag:109];
    }
    if (btnItem) {
        [btnItem setEnabled:isEnabled];
    }
}

/// 设置按钮是否可点
-(void)setButtonAllEnabled:(BOOL)isEnabled
{
    for (ZButton *btn in self.subviews) {
        [btn setEnabled:isEnabled];
    }
}

-(void)dealloc
{
    OBJC_RELEASE(_model);
    OBJC_RELEASE(_onPracticePPTClick);
    OBJC_RELEASE(_onPracticeNoteClick);
    OBJC_RELEASE(_onCurriculumPPTClick);
    OBJC_RELEASE(_onCurriculumNoteClick);
    OBJC_RELEASE(_onPauseClick);
    OBJC_RELEASE(_onAnswerClick);
    OBJC_RELEASE(_onPlayPracticeClick);
    OBJC_RELEASE(_onPlayCurriculumClick);
    OBJC_RELEASE(_onQuestionClick);
    OBJC_RELEASE(_onCollectionClick);
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
