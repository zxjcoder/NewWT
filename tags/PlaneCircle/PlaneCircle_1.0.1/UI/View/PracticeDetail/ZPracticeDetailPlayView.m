//
//  ZPracticeDetailPlayView.m
//  PlaneCircle
//
//  Created by Daniel on 6/22/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPracticeDetailPlayView.h"
#import "Utils.h"
#import "ZSlider.h"

@interface ZPracticeDetailPlayView()

///滑动
@property (strong, nonatomic) UISlider *slider;
///内容区域
@property (strong, nonatomic) UIView *viewContent;
///总时长
@property (strong, nonatomic) UIImageView *imgTime;
///总时长
@property (strong, nonatomic) UILabel *lbTime;
///进度时间
@property (strong, nonatomic) UIImageView *imgProgress;
///进度时间
@property (strong, nonatomic) UILabel *lbProgress;
///上一条
@property (strong, nonatomic) UIButton *btnPre;
///下一条
@property (strong, nonatomic) UIButton *btnNext;
///停止.播放.暂停.等待
@property (strong, nonatomic) UIButton *btnStop;
///评论
@property (strong, nonatomic) UIButton *btnComment;
///是否不播放中
@property (assign, nonatomic) BOOL isPaying;
///是否等待中
@property (assign, nonatomic) BOOL isWaiting;
///是否显示进度条
@property (assign, nonatomic) BOOL isShowProgress;
///对象
@property (strong, nonatomic) ModelPractice *modelP;

@end

@implementation ZPracticeDetailPlayView

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

-(void)innerInit
{
    [self setBackgroundColor:CLEARCOLOR];
    
    CGFloat proW = 130/2;
    CGFloat proH = 66/2;
    self.imgProgress = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"p_progress_time_bg"]];
    [self.imgProgress setHidden:YES];
    [self.imgProgress setAlpha:0.0f];
    [self.imgProgress setFrame:CGRectMake(self.width/2-proW/2, -30, proW, proH)];
    [self addSubview:self.imgProgress];
    
    self.lbProgress = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, proW, 20)];
    [self.lbProgress setTextColor:WHITECOLOR];
    [self.lbProgress setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.lbProgress setText:@"00:00:00"];
    [self.lbProgress setTextAlignment:(NSTextAlignmentCenter)];
    [self.imgProgress addSubview:self.lbProgress];
    
    self.slider = [[ZSlider alloc] initWithFrame:CGRectMake(0, 0, self.width, 15)];
    [self.slider setContinuous:YES];
    [self.slider setMinimumValue:0.0000f];
    [self.slider setMaximumValue:1.0000f];
    [self.slider setMinimumTrackTintColor:MAINCOLOR];
    [self.slider setMaximumTrackTintColor:RGBCOLOR(246, 246, 246)];
    [self.slider setThumbTintColor:MAINCOLOR];
    [self.slider setThumbImage:[SkinManager getImageWithName:@"p_progess_btn"] forState:(UIControlStateNormal)];
    [self.slider setThumbImage:[SkinManager getImageWithName:@"p_progess_btn"] forState:(UIControlStateHighlighted)];
    [self.slider setMinimumTrackImage:[SkinManager getImageWithName:@"p_progess_s"] forState:(UIControlStateNormal)];
    [self.slider setMinimumTrackImage:[SkinManager getImageWithName:@"p_progess_s"] forState:(UIControlStateHighlighted)];
    [self.slider setMaximumTrackImage:[SkinManager getImageWithName:@"p_progess_d"] forState:(UIControlStateNormal)];
    [self.slider setMaximumTrackImage:[SkinManager getImageWithName:@"p_progess_d"] forState:(UIControlStateHighlighted)];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [self.slider addTarget:self action:@selector(sliderRemoveFocus:) forControlEvents:(UIControlEventTouchUpOutside)];
    [self.slider addTarget:self action:@selector(sliderRemoveFocus:) forControlEvents:(UIControlEventTouchCancel)];
    [self.slider addTarget:self action:@selector(sliderRemoveFocus:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.slider];
    
    CGFloat contentY = 6;
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, contentY, self.width, self.height-contentY)];
    [self.viewContent setBackgroundColor:RGBCOLOR(254,241,231)];
    [self addSubview:self.viewContent];
    
    CGFloat timeS = 12;
    self.imgTime = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.viewContent.height/2-timeS/2, timeS, timeS)];
    [self.imgTime setImage:[SkinManager getImageWithName:@"p_timeicon_black"]];
    [self.viewContent addSubview:self.imgTime];
    
    CGFloat lbH = 20;
    self.lbTime = [[UILabel alloc] initWithFrame:CGRectMake(self.imgTime.x+timeS+3, self.viewContent.height/2-lbH/2, 70, lbH)];
    [self.lbTime setText:@"00:00:00"];
    [self.lbTime setTextColor:DESCCOLOR];
    [self.lbTime setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbTime];
    
    CGFloat btnS = self.viewContent.height-5;
    CGFloat btnY = 2.5;
    self.btnPre = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPre setImage:[SkinManager getImageWithName:@"p_shape_b"] forState:(UIControlStateNormal)];
    [self.btnPre setFrame:CGRectMake(self.viewContent.width/2-btnS-30, btnY, btnS, btnS)];
    [self.btnPre setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnPre addTarget:self action:@selector(btnPreClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnPre];
    
    self.btnStop = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnStop setImage:[SkinManager getImageWithName:@"p_play_play"] forState:(UIControlStateNormal)];
    [self.btnStop setFrame:CGRectMake(self.viewContent.width/2-btnS/2, btnY, btnS, btnS)];
    [self.btnStop setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnStop addTarget:self action:@selector(btnStopClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnStop];
    
    self.btnNext = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnNext setImage:[SkinManager getImageWithName:@"p_shape_g"] forState:(UIControlStateNormal)];
    [self.btnNext setFrame:CGRectMake(self.viewContent.width/2+30, btnY, btnS, btnS)];
    [self.btnNext setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnNext addTarget:self action:@selector(btnNextClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnNext];
    
    CGFloat btnW = 43;
    CGFloat btnH = 28;
    CGFloat btnCX = self.viewContent.width-btnW-8;
    CGFloat btnCY = self.viewContent.height/2-btnH/2;
    self.btnComment = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnComment setFrame:CGRectMake(btnCX, btnCY, btnW, btnH)];
    [self.btnComment setTitle:@"评论" forState:(UIControlStateNormal)];
    [self.btnComment setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnComment setViewRound:4 borderWidth:1 borderColor:MAINCOLOR];
    [[self.btnComment titleLabel] setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
    [self.btnComment addTarget:self action:@selector(btnCommentClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnComment];
    
    [self sendSubviewToBack:self.viewContent];
}
///评论按钮
-(void)btnCommentClick
{
    if (self.onCommentClick) {
        self.onCommentClick();
    }
}
///上一条数据
-(void)btnPreClick
{
    [self.slider setValue:0.0f animated:YES];
    [self.lbProgress setText:@"00:00:00"];
    if (self.onPreClick) {
        self.onPreClick(self.slider.value, self.slider.value/self.slider.maximumValue);
    }
}
///下一条数据
-(void)btnNextClick
{
    [self.slider setValue:0.0f animated:YES];
    [self.lbProgress setText:@"00:00:00"];
    if (self.onNextClick) {
        self.onNextClick(self.slider.value, self.slider.value/self.slider.maximumValue);
    }
}
///开始播放
-(void)setStartPlay
{
    self.isPaying = YES;
    self.isWaiting = NO;
    [self.btnStop setImage:[SkinManager getImageWithName:@"p_shape_stop"] forState:(UIControlStateNormal)];
}
///停止播放
-(void)setStopPlay
{
    self.isPaying = NO;
    self.isWaiting = NO;
    [self.btnStop setImage:[SkinManager getImageWithName:@"p_play_play"] forState:(UIControlStateNormal)];
}
///缓冲中
-(void)setWaitingPlay
{
    self.isPaying = NO;
    self.isWaiting = YES;
    [self.btnStop setImage:[SkinManager getImageWithName:@"p_play_waiting"] forState:(UIControlStateNormal)];
}
///上一页播放
-(void)setPrePlay
{
    self.isPaying = NO;
    self.isWaiting = NO;
    [self btnPreClick];
}
///下一页播放
-(void)setNextPlay
{
    self.isPaying = NO;
    self.isWaiting = NO;
    [self btnNextClick];
}
///停止
-(void)btnStopClick
{
    if (self.isPaying) {
        if (self.onStopClick) {
            self.onStopClick();
        }
    } else {
        if (self.onPlayClick) {
            self.onPlayClick();
        }
    }
}
///停止拖动
-(void)sliderRemoveFocus:(UISlider *)sender
{
    if (self.isShowProgress) {
        self.isShowProgress = NO;
        [self.imgProgress setAlpha:1.0f];
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self.imgProgress setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.imgProgress setHidden:YES];
        }];
    }
}
///改变值
-(void)sliderValueChanged:(UISlider *)sender
{
    if (!self.isShowProgress) {
        self.isShowProgress = YES;
        [self.imgProgress setHidden:NO];
        [self.imgProgress setAlpha:0.0f];
        [UIView animateWithDuration:kANIMATION_TIME animations:^{
            [self.imgProgress setAlpha:1.0f];
        }];
    }
    
    [self.lbProgress setText:[Utils getHHMMSSFromSS:[NSString stringWithFormat:@"%f", (sender.value * [self.modelP.time floatValue])]]];
    if (self.onSlideValueChanged) {
        self.onSlideValueChanged(sender.value);
    }
}
///隐藏显示功能键
-(void)setShowPreOrNextButton:(BOOL)isShow
{
    [self.btnPre setHidden:!isShow];
    [self.btnNext setHidden:!isShow];
}
///设置值
-(void)setSliderValue:(CGFloat)ratio
{
    [self.slider setValue:ratio animated:YES];
    [self.lbProgress setText:[Utils getHHMMSSFromSS:[NSString stringWithFormat:@"%f", (ratio * [self.modelP.time floatValue])]]];
}
///设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self setModelP:model];
    
    NSString *strTime = [Utils getHHMMSSFromSS:model.time];
    [self.lbTime setText:strTime];
    [self.slider setValue:model.play_time/[model.time floatValue] animated:NO];
}

-(void)dealloc
{
    OBJC_RELEASE(_slider);
    OBJC_RELEASE(_imgTime);
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_btnPre);
    OBJC_RELEASE(_btnNext);
    OBJC_RELEASE(_btnStop);
    OBJC_RELEASE(_btnComment);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_onPreClick);
    OBJC_RELEASE(_onNextClick);
    OBJC_RELEASE(_onPlayClick);
    OBJC_RELEASE(_onStopClick);
    OBJC_RELEASE(_onCommentClick);
    OBJC_RELEASE(_onSlideValueChanged);
}

@end
