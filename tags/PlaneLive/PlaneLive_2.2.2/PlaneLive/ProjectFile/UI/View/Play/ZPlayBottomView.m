//
//  ZPlayBottomView.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/6.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZPlayBottomView.h"
#import "ZButton.h"

@interface ZPlayBottomView()

@property (strong, nonatomic) ModelPractice *model;

@property (strong, nonatomic) ModelCurriculum *modelC;

@property (assign, nonatomic) ZPlayTabBarViewType playType;

@end

@implementation ZPlayBottomView

///初始化
-(instancetype)initWithPoint:(CGPoint)point type:(ZPlayTabBarViewType)type
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, APP_FRAME_WIDTH, kZPlayBottomViewHeight)];
    if (self) {
        [self setPlayType:type];
        switch (type) {
            case ZPlayTabBarViewTypeSubscribe:
                [self innerInitCurriculum];
                break;
            default:
                [self innerInitPractice];
                break;
        }
    }
    return self;
}
-(void)innerInitPractice
{
    UIImageView *imgLine1 = [UIImageView getDLineView];
    [imgLine1 setFrame:CGRectMake(0, 0, self.width, kLineHeight)];
    [self addSubview:imgLine1];
    
    CGFloat btnW = self.width/2;
    UIImageView *imgLine2 = [UIImageView getDLineView];
    [imgLine2 setFrame:CGRectMake(btnW, 0, kLineHeight, self.height)];
    [self addSubview:imgLine2];
    
    ZButton *btnItem1 = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [btnItem1 setTitle:kInstructorAnswer forState:(UIControlStateNormal)];
    [btnItem1 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [[btnItem1 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnItem1 setTag:100];
    [btnItem1 setFrame:CGRectMake(0, 0, btnW, self.height)];
    [btnItem1 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnItem1];
    
    ZButton *btnItem2 = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [btnItem2 setTitle:kRewards forState:(UIControlStateNormal)];
    [btnItem2 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [[btnItem2 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnItem2 setTag:110];
    [btnItem2 setFrame:CGRectMake(btnW, 0, btnW, self.height)];
    [btnItem2 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnItem2];
}
-(void)innerInitCurriculum
{
    UIImageView *imgLine1 = [UIImageView getDLineView];
    [imgLine1 setFrame:CGRectMake(0, 0, self.width, kLineHeight)];
    [self addSubview:imgLine1];
    
    CGFloat btnW = self.width/3;
    UIImageView *imgLine2 = [UIImageView getDLineView];
    [imgLine2 setFrame:CGRectMake(btnW, 0, kLineHeight, self.height)];
    [self addSubview:imgLine2];
    
    UIImageView *imgLine3 = [UIImageView getDLineView];
    [imgLine3 setFrame:CGRectMake(btnW*2, 0, kLineHeight, self.height)];
    [self addSubview:imgLine3];
    
    ZButton *btnItem1 = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [btnItem1 setTitle:kMessage forState:(UIControlStateNormal)];
    [btnItem1 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [[btnItem1 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnItem1 setTag:101];
    [btnItem1 setFrame:CGRectMake(0, 0, btnW, self.height)];
    [btnItem1 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnItem1];
    
    ZButton *btnItem2 = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [btnItem2 setTitle:kWriteMessage forState:(UIControlStateNormal)];
    [btnItem2 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [[btnItem2 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnItem2 setTag:102];
    [btnItem2 setFrame:CGRectMake(btnW, 0, btnW, self.height)];
    [btnItem2 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnItem2];
    
    ZButton *btnItem3 = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [btnItem3 setTitle:kRewards forState:(UIControlStateNormal)];
    [btnItem3 setTitleColor:BLACKCOLOR forState:(UIControlStateNormal)];
    [[btnItem3 titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnItem3 setTag:110];
    [btnItem3 setFrame:CGRectMake(btnW*2, 0, btnW, self.height)];
    [btnItem3 addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btnItem3];
}
-(void)btnItemClick:(ZButton *)sender
{
    switch (sender.tag) {
        case 100:
        {
            if (self.onAnswerClick) {
                self.onAnswerClick(self.model);
            }
            break;
        }
        case 101:
        {
            if (self.onMessageListClick) {
                self.onMessageListClick(self.modelC);
            }
            break;
        }
        case 102:
        {
            if (self.onMessageWriteClick) {
                self.onMessageWriteClick(self.modelC);
            }
            break;
        }
        case 110:
        {
            switch (self.playType) {
                case ZPlayTabBarViewTypeSubscribe:
                {
                    if (self.onCurriculumRewardClick) {
                        self.onCurriculumRewardClick(self.modelC);
                    }
                    break;
                }
                default:
                {
                    if (self.onPracticeRewardClick) {
                        self.onPracticeRewardClick(self.model);
                    }
                    break;
                }
            }
            break;
        }
        default: break;
    }
}
-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
    
    ZButton *btnItem1 = [self viewWithTag:100];
    if (btnItem1 && model) {
        if (model.qcount > kNumberMaxCount) {
            [btnItem1 setTitle:[NSString stringWithFormat:@"%@(%d)", kInstructorAnswer, kNumberMaxCount] forState:(UIControlStateNormal)];
        } else {
            [btnItem1 setTitle:[NSString stringWithFormat:@"%@(%ld)", kInstructorAnswer, model.qcount] forState:(UIControlStateNormal)];
        }
    }
}
-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model
{
    [self setModelC:model];
    ZButton *btnItem1 = [self viewWithTag:101];
    if (btnItem1 && model) {
        if (model.mcount > kNumberMaxCount) {
            [btnItem1 setTitle:[NSString stringWithFormat:@"%@(%d)", kMessage, kNumberMaxCount] forState:(UIControlStateNormal)];
        } else {
            [btnItem1 setTitle:[NSString stringWithFormat:@"%@(%ld)", kMessage, model.mcount] forState:(UIControlStateNormal)];
        }
    }
}
/// 设置按钮是否可点
-(void)setButtonAllEnabled:(BOOL)isEnabled
{
    for (ZButton *btn in self.subviews) {
        [btn setEnabled:isEnabled];
    }
}
@end
