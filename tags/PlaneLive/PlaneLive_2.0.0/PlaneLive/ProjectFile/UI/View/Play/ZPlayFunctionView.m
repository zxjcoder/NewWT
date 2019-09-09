//
//  ZPlayFunctionView.m
//  PlaneLive
//
//  Created by Daniel on 07/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPlayFunctionView.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "Utils.h"
#import "ZSlider.h"

@interface ZPlayFunctionView()
{
    /// 总时间
    NSTimeInterval _totalTime;
    int _playRate;
}
///播放进度
@property (strong, nonatomic) ZSlider *slider;
///缓冲进度
@property (strong, nonatomic) UIProgressView *progressView;
///总时长
@property (strong, nonatomic) ZLabel *lbTime;
///进度时间
@property (strong, nonatomic) ZLabel *lbProgress;
///倍率
@property (strong, nonatomic) ZButton *btnRate;

///上一条
@property (strong, nonatomic) ZButton *btnPre;
///下一条
@property (strong, nonatomic) ZButton *btnNext;
///暂停或停止或播放中
@property (strong, nonatomic) ZButton *btnPlay;

@end

@implementation ZPlayFunctionView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(instancetype)initWithPoint:(CGPoint)point
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, APP_FRAME_WIDTH, kZPlayFunctionViewHeight)];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    self.btnPre = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPre setImage:[SkinManager getImageWithName:@"last_btn"] forState:(UIControlStateNormal)];
    [self.btnPre setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnPre addTarget:self action:@selector(btnPreClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPre];
    
    self.btnNext = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnNext setImage:[SkinManager getImageWithName:@"next_btn"] forState:(UIControlStateNormal)];
    [self.btnNext setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnNext addTarget:self action:@selector(btnNextClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnNext];
    
    self.btnPlay = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPlay setTag:1];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_btn"] forState:(UIControlStateNormal)];
    [self.btnPlay setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnPlay addTarget:self action:@selector(btnPlayClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPlay];
    
    _playRate = [AppSetting getRate];
    
    self.btnRate = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnRate setTag:_playRate];
    switch (_playRate) {
        case 1:
            [self.btnRate setTitle:@"1.0x" forState:(UIControlStateNormal)];
            break;
        case 2:
            [self.btnRate setTitle:@"1.25x" forState:(UIControlStateNormal)];
            break;
        case 3:
            [self.btnRate setTitle:@"1.5x" forState:(UIControlStateNormal)];
            break;
        default:
            [self.btnRate setTitle:@"1.0x" forState:(UIControlStateNormal)];
            break;
    }
    [self.btnRate setViewRound:kVIEW_ROUND_SIZE borderWidth:1 borderColor:TABLEVIEWCELL_TLINECOLOR];
    [self.btnRate setTitleColor:TABLEVIEWCELL_TLINECOLOR forState:(UIControlStateNormal)];
    [[self.btnRate titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.btnRate addTarget:self action:@selector(btnRateClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnRate];
    
    CGFloat playS = 55;
    CGFloat playX = self.width/2-playS/2;
    
    CGFloat preS = 35;
    CGFloat preX = playX-preS-15*APP_FRAME_WIDTH/320;
    CGFloat preY = playS/2-preS/2;
    
    CGFloat nextX = playX+playS+15*APP_FRAME_WIDTH/320;
    
    CGFloat rateX = self.width-40-25;
    [self.btnRate setFrame:CGRectMake(rateX, preY+5, 40, 25)];
    
    [self.btnPlay setFrame:CGRectMake(playX, 0, playS, playS)];
    [self.btnPlay setViewRound:playS/2 borderWidth:2 borderColor:WHITECOLOR];
    
    [self.btnPre setFrame:CGRectMake(preX, preY, preS, preS)];
    [self.btnNext setFrame:CGRectMake(nextX, preY, preS, preS)];
    
    CGFloat spaceX = 30;
    CGFloat sliderY = self.btnPlay.y+self.btnPlay.height+18;
    CGFloat sliderW = self.width-spaceX*2;
    CGFloat sliderH = 20;
    self.slider = [[ZSlider alloc] initWithFrame:CGRectMake(spaceX, sliderY, sliderW, sliderH)];
    [self.slider setContinuous:YES];
    [self.slider setMinimumValue:0.0000f];
    [self.slider setMaximumValue:0.0000f];
    [self.slider setThumbTintColor:MAINCOLOR];
    [self.slider setMaximumTrackTintColor:CLEARCOLOR];
    [self.slider setMinimumTrackTintColor:MAINCOLOR];
    [self.slider setThumbImage:[SkinManager getImageWithName:@"p_progess_btn"] forState:(UIControlStateNormal)];
    [self.slider setThumbImage:[SkinManager getImageWithName:@"p_progess_btn"] forState:(UIControlStateHighlighted)];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [self.slider addTarget:self action:@selector(sliderRemoveFocus:) forControlEvents:(UIControlEventTouchUpOutside)];
    [self.slider addTarget:self action:@selector(sliderRemoveFocus:) forControlEvents:(UIControlEventTouchCancel)];
    [self.slider addTarget:self action:@selector(sliderRemoveFocus:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.slider];
    
    CGFloat progressViewX = self.slider.x+2;
    CGFloat progressViewH = 1;
    CGFloat progressViewY = sliderY+sliderH/2-progressViewH/2-0.3;
    CGFloat progressViewW = self.slider.width-2;
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
    [self.progressView setProgress:0.0f];
    [self.progressView setProgressTintColor:RGBCOLOR(175, 175, 175)];
    [self.progressView setTrackTintColor:WHITECOLOR];
    [self.progressView setProgressViewStyle:(UIProgressViewStyleDefault)];
    [self addSubview:self.progressView];
    
    CGFloat lbH = 20;
    CGFloat lbY = sliderY+sliderH+kSize5;
    CGFloat lbPX = progressViewX;
    CGFloat lbW = 70;
    self.lbProgress = [[ZLabel alloc] initWithFrame:CGRectMake(lbPX, lbY, lbW, lbH)];
    [self.lbProgress setText:@"00:00"];
    [self.lbProgress setTextColor:WHITECOLOR];
    [self.lbProgress setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbProgress setNumberOfLines:1];
    [self.lbProgress setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbProgress setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbProgress];
    
    CGFloat lbTX = self.slider.x+self.slider.width-lbW;
    self.lbTime = [[ZLabel alloc] initWithFrame:CGRectMake(lbTX, lbY, lbW, lbH)];
    [self.lbTime setText:@"00:00"];
    [self.lbTime setTextColor:WHITECOLOR];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTime setNumberOfLines:1];
    [self.lbTime setTextAlignment:(NSTextAlignmentRight)];
    [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbTime];
    
    [self sendSubviewToBack:self.progressView];
}
-(void)btnRateClick:(ZButton *)sender
{
    switch (_playRate) {
        case 1:
            _playRate = 2;
            [self.btnRate setTitle:@"1.25x" forState:(UIControlStateNormal)];
            if (self.onRateChange) {
                self.onRateChange(1.25);
            }
            break;
        case 2:
            _playRate = 3;
            [self.btnRate setTitle:@"1.5x" forState:(UIControlStateNormal)];
            if (self.onRateChange) {
                self.onRateChange(1.5);
            }
            break;
        case 3:
            _playRate = 1;
            [self.btnRate setTitle:@"1.0x" forState:(UIControlStateNormal)];
            if (self.onRateChange) {
                self.onRateChange(1.0);
            }
            break;
        default:
            break;
    }
    [AppSetting setRate:_playRate];
    
    [AppSetting save];
}
/// 停止拖动
-(void)sliderRemoveFocus:(UISlider *)sender
{
    if (self.onSliderValueChange) {
        self.onSliderValueChange(sender.value, sender.maximumValue);
    }
}
/// 改变值
-(void)sliderValueChanged:(UISlider *)sender
{
    self.lbProgress.text = [Utils getHHMMSSFromSSTime:sender.value];
}
/// 设置按钮是否可点
-(void)setOperEnabled:(BOOL)isEnabled
{
    [self.btnPre setEnabled:isEnabled];
    [self.btnNext setEnabled:isEnabled];
}
-(void)btnPreClick
{
    if (self.onPreClick) {
        self.onPreClick();
    }
}
-(void)btnNextClick
{
    if (self.onNextClick) {
        self.onNextClick();
    }
}
-(void)btnPlayClick:(UIButton *)sender
{
    if (sender.tag == 1) {
        if (self.onPlayClick) {
            self.onPlayClick();
        }
    } else {
        if (self.onStopClick) {
            self.onStopClick();
        }
    }
}
/// 停止播放
-(void)setStopPlay
{
    [self.progressView setProgress:0.0 animated:NO];
    [self.progressView setHidden:YES];
    [self.progressView setProgress:0.0 animated:NO];
    [self.progressView setHidden:NO];
    
    [self.lbProgress setText:@"00:00"];
    [self.slider setValue:0.0];
    
    [self.btnPlay setTag:1];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.btnPlay setImage:[SkinManager getImageWithName:@"play_btn"] forState:(UIControlStateNormal)];
    }];
}
/// 开始播放
-(void)setStartPlay
{
    [self.btnPlay setTag:2];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.btnPlay setImage:[SkinManager getImageWithName:@"pause_btn"] forState:(UIControlStateNormal)];
    }];
}
/// 暂停播放
-(void)setPausePlay
{
    [self.btnPlay setTag:1];
    [UIView animateWithDuration:kANIMATION_TIME animations:^{
        [self.btnPlay setImage:[SkinManager getImageWithName:@"play_btn"] forState:(UIControlStateNormal)];
    }];
}
/// 设置播放进度
-(void)setViewProgress:(CGFloat)progress
{
    [self.progressView setProgress:progress animated:YES];
}
/// 设置播放时间
-(void)setViewCurrentTime:(NSTimeInterval)currentTime
{
    //拖动过程中不需要设置
    if (fabs(self.slider.value-currentTime) <= 1) {
        [self.slider setValue:currentTime];
    }
    self.lbProgress.text = [Utils getHHMMSSFromSSTime:currentTime];
}
/// 设置初始化播放时间
-(void)setViewInitializeCurrentTime:(NSTimeInterval)currentTime
{
    [self.slider setValue:currentTime];
    
    self.lbProgress.text = [Utils getHHMMSSFromSSTime:currentTime];
}
/// 设置最大滑动值
-(void)setMaxDuratuin:(NSTimeInterval)duration
{
    if (duration == NAN || duration <= 0) {
        _totalTime = 0.0000f;
        [self.slider setMaximumValue:0.0000f];
        [self.lbTime setText:@"00:00"];
    } else {
        _totalTime = (float)duration;
        [self.slider setMaximumValue:(float)duration];
        [self.lbTime setText:[Utils getHHMMSSFromSSTime:duration]];
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbProgress);
    OBJC_RELEASE(_btnPre);
    OBJC_RELEASE(_btnNext);
    OBJC_RELEASE(_btnPlay);
    OBJC_RELEASE(_slider);
    OBJC_RELEASE(_progressView);
}

@end
