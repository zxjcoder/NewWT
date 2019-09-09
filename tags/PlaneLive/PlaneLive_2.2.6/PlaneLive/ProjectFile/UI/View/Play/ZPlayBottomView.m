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
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    UIView *viewContent = [self createContentView];
    [self addSubview:viewContent];
    
    UIButton *btnItem = [self createRewardButton];
    btnItem.frame = CGRectMake(0, 0, self.width, viewContent.height);
    [btnItem setTag:100];
    [viewContent addSubview:btnItem];
}
-(void)innerInitCurriculum
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    UIView *viewContent = [self createContentView];
    [self addSubview:viewContent];
    
    UIImageView *imgLine = [UIImageView getDLineView];
    [imgLine setFrame:CGRectMake(self.width/2, 5, kLineHeight, viewContent.height - 15)];
    [viewContent addSubview:imgLine];
    
    CGFloat btnW = self.width/2;
    UIButton *btnItem1 = [self createMessageButton];
    [btnItem1 setTag:101];
    btnItem1.frame = CGRectMake(0, 0, btnW, self.height);
    [viewContent addSubview:btnItem1];
    
    UIButton *btnItem2 = [self createRewardButton];
    [btnItem2 setTag:102];
    btnItem2.frame = CGRectMake(btnW, 0, btnW, self.height);
    [viewContent addSubview:btnItem2];
}
-(UIButton*)createRewardButton
{
    UIButton *btnItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnItem setTitle:kRewards forState:(UIControlStateNormal)];
    [btnItem setTitleColor:COLORTEXT2 forState:(UIControlStateNormal)];
    [[btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnItem setImage:[SkinManager getImageWithName:@"reward"] forState:(UIControlStateNormal)];
    [btnItem setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 5))];
    [btnItem setUserInteractionEnabled:true];
    [btnItem addTarget:self action:@selector(btnItemEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    return btnItem;
}
-(UIButton*)createMessageButton
{
    UIButton *btnItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnItem setTitle:kMessage forState:(UIControlStateNormal)];
    [btnItem setTitleColor:COLORTEXT2 forState:(UIControlStateNormal)];
    [[btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnItem setImage:[SkinManager getImageWithName:@"write"] forState:(UIControlStateNormal)];
    [btnItem setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 5))];
    [btnItem setUserInteractionEnabled:true];
    [btnItem addTarget:self action:@selector(btnItemEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    return btnItem;
}
-(UIView*)createContentView
{
    UIView *viewContent = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, self.width, self.height))];
    [viewContent.layer setShadowColor:COLORVIEWSHADOW.CGColor];
    [viewContent.layer setShadowOffset:(CGSizeMake(0, -3))];
    [viewContent.layer setShadowRadius:3];
    [viewContent.layer setShadowOpacity:0.20];
    [viewContent.layer setCornerRadius:10];
    [viewContent.layer setBorderWidth:1];
    [viewContent.layer setBorderColor:COLORVIEWBACKCOLOR2.CGColor];
    [viewContent setBackgroundColor:WHITECOLOR];
    return viewContent;
}
-(void)btnItemEvent:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {
            if (self.onPracticeRewardClick) {
                self.onPracticeRewardClick(self.model);
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
    
//    ZButton *btnItem1 = [self viewWithTag:100];
//    if (btnItem1 && model) {
//        if (model.qcount > kNumberMaxCount) {
//            [btnItem1 setTitle:[NSString stringWithFormat:@"%@(%d)", kInstructorAnswer, kNumberMaxCount] forState:(UIControlStateNormal)];
//        } else {
//            [btnItem1 setTitle:[NSString stringWithFormat:@"%@(%ld)", kInstructorAnswer, model.qcount] forState:(UIControlStateNormal)];
//        }
//    }
}
-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model
{
    [self setModelC:model];
//    ZButton *btnItem1 = [self viewWithTag:101];
//    if (btnItem1 && model) {
//        if (model.mcount > kNumberMaxCount) {
//            [btnItem1 setTitle:[NSString stringWithFormat:@"%@(%d)", kMessage, kNumberMaxCount] forState:(UIControlStateNormal)];
//        } else {
//            [btnItem1 setTitle:[NSString stringWithFormat:@"%@(%ld)", kMessage, model.mcount] forState:(UIControlStateNormal)];
//        }
//    }
}
/// 设置按钮是否可点
-(void)setButtonAllEnabled:(BOOL)isEnabled
{
    for (ZButton *btn in self.subviews) {
        [btn setEnabled:isEnabled];
    }
}
@end
