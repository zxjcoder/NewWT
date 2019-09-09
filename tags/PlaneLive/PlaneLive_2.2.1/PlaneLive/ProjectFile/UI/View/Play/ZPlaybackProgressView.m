//
//  ZPlaybackProgressView.m
//  PlaneLive
//
//  Created by Daniel on 03/03/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZPlaybackProgressView.h"
#import "ZButton.h"
#import "ZSlider.h"
#import "ZLabel.h"
#import "Utils.h"

@interface ZPlaybackProgressView()
{
    /// 总时间
    NSUInteger _totalTime;
    /// 在拖动中
    BOOL _isDragSlider;
}
@property (strong, nonatomic) ZButton *btnPlay;
///播放进度
@property (strong, nonatomic) ZSlider *slider;
///缓冲进度
@property (strong, nonatomic) UIView *progressView;
///缓冲动画效果
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
///进度时间
@property (strong, nonatomic) ZLabel *lbProgress;
///总时长
@property (strong, nonatomic) ZLabel *lbTotalDuration;

@end

@implementation ZPlaybackProgressView

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
    CGFloat btnS = 35;
    self.btnPlay = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPlay setTag:1];
    [self.btnPlay setFrame:CGRectMake(kSizeSpace, 7, btnS, btnS)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_start_icon"] forState:(UIControlStateNormal)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_start_icon"] forState:(UIControlStateHighlighted)];
    [self.btnPlay setImageEdgeInsets:(UIEdgeInsetsMake(3, 3, 3, 3))];
    [self.btnPlay addTarget:self action:@selector(btnPlayClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPlay];
    
    CGFloat lbH = 20;
    CGFloat lbY = 15;
    CGFloat lbPX = kSizeSpace+btnS+3;
    CGFloat lbW = 52;
    self.lbProgress = [[ZLabel alloc] initWithFrame:CGRectMake(lbPX, lbY, lbW, lbH)];
    [self.lbProgress setText:@"00:00"];
    [self.lbProgress setTextColor:DESCCOLOR];
    [self.lbProgress setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbProgress setNumberOfLines:1];
    [self.lbProgress setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbProgress setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbProgress];
    
    CGFloat lbTDX = self.width-lbW-kSizeSpace;
    self.lbTotalDuration = [[ZLabel alloc] initWithFrame:CGRectMake(lbTDX, lbY, lbW, lbH)];
    [self.lbTotalDuration setText:@"00:00"];
    [self.lbTotalDuration setTextColor:DESCCOLOR];
    [self.lbTotalDuration setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbTotalDuration setNumberOfLines:1];
    [self.lbTotalDuration setTextAlignment:(NSTextAlignmentRight)];
    [self.lbTotalDuration setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbTotalDuration];
    
    CGFloat sliderX = lbPX+lbW;
    CGFloat sliderY = lbY;
    CGFloat sliderW = lbTDX-lbPX-lbW;
    CGFloat sliderH = 20;
    self.slider = [[ZSlider alloc] initWithFrame:CGRectMake(sliderX, sliderY, sliderW, sliderH)];
    [self.slider setContinuous:YES];
    [self.slider setThumbTintColor:MAINCOLOR];
    [self.slider setMaximumTrackTintColor:CLEARCOLOR];
    [self.slider setMinimumTrackTintColor:MAINCOLOR];
    [self.slider setThumbImage:[SkinManager getImageWithName:@"play_progress_icon"] forState:(UIControlStateNormal)];
    [self.slider setThumbImage:[SkinManager getImageWithName:@"play_progress_icon"] forState:(UIControlStateHighlighted)];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    [self addSubview:self.slider];
    
    CGFloat progressViewX = self.slider.x+2;
    CGFloat progressViewH = 1.2;
    CGFloat progressViewY = sliderY+sliderH/2-progressViewH/2-0.3;
    CGFloat progressViewW = self.slider.width-2;
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
    [self.progressView setBackgroundColor:RGBCOLOR(236, 236, 236)];
    [self addSubview:self.progressView];
    //创建出圆形贝塞尔曲线
    self.shapeLayer = [self createShapeLayerWithSize];
    //设置stroke起始点
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    [self.progressView.layer addSublayer:self.shapeLayer];
    
    [self sendSubviewToBack:self.progressView];
    [self bringSubviewToFront:self.slider];
}
-(CAShapeLayer *)createShapeLayerWithSize
{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, 0)];
    [linePath addLineToPoint:CGPointMake(self.progressView.width, 0)];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = self.progressView.height;
    lineLayer.backgroundColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = RGBCOLOR(214, 214, 214).CGColor;
    lineLayer.path = linePath.CGPath;
    
    return lineLayer;
}
/// 改变值
-(void)sliderValueChanged:(UISlider *)sender
{
    self.lbProgress.text = [Utils getHHMMSSFromSSTime:sender.value*_totalTime];
    if (self.onSliderValueChange) {
        self.onSliderValueChange(sender.value);
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
    self.shapeLayer.strokeEnd  = 0;
    [self.shapeLayer setNeedsDisplay];
    
    [self.lbProgress setText:@"00:00"];
    [self.slider setValue:0.0];
    
    [self.btnPlay setTag:1];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_start_icon"] forState:(UIControlStateNormal)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_start_icon"] forState:(UIControlStateHighlighted)];
}
/// 开始播放
-(void)setStartPlay
{
    [self.btnPlay setTag:2];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_stop_icon"] forState:(UIControlStateNormal)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_stop_icon"] forState:(UIControlStateHighlighted)];
}
/// 设置总时长
-(void)setTotalDuration:(NSInteger)duration
{
    if (duration == NAN || duration <= 0) {
        _totalTime = 0.0000f;
        [self.lbTotalDuration setText:@"00:00"];
    } else {
        _totalTime = duration;
        [self.lbTotalDuration setText:[Utils getHHMMSSFromSSTime:duration]];
    }
}
/// 暂停播放
-(void)setPausePlay
{
    [self.btnPlay setTag:1];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_start_icon"] forState:(UIControlStateNormal)];
    [self.btnPlay setImage:[SkinManager getImageWithName:@"play_start_icon"] forState:(UIControlStateHighlighted)];
}
/// 设置缓冲进度
-(void)setViewProgress:(CGFloat)progress
{
    self.shapeLayer.strokeEnd  = progress;
    [self.shapeLayer setNeedsDisplay];
}
/// 设置播放时间
-(void)setViewCurrentTime:(NSUInteger)currentTime percent:(CGFloat)percent
{
    [self.slider setValue:percent];
    self.lbProgress.text = [Utils getHHMMSSFromSSTime:currentTime];
}
-(void)dealloc
{
    OBJC_RELEASE(_slider);
    OBJC_RELEASE(_btnPlay);
    OBJC_RELEASE(_lbProgress);
    OBJC_RELEASE(_onPlayClick);
    OBJC_RELEASE(_onStopClick);
    OBJC_RELEASE(_shapeLayer);
}

@end
