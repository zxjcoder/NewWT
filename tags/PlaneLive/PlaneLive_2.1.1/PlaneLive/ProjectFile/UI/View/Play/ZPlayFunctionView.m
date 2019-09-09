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
    /// 播放倍率
    int _playRate;
    /// 在拖动中
    BOOL _isDragSlider;
}
///播放进度
@property (strong, nonatomic) ZSlider *slider;
///缓冲进度
//@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIView *progressView;
///缓冲动画效果
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
///总时长
@property (strong, nonatomic) ZLabel *lbTime;
///进度时间
@property (strong, nonatomic) ZLabel *lbProgress;
///倍率
@property (strong, nonatomic) ZButton *btnRate;
///下载
@property (strong, nonatomic) ZButton *btnDownload;
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
    [self.btnPre setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnPre addTarget:self action:@selector(btnPreClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPre];
    
    self.btnNext = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnNext setImage:[SkinManager getImageWithName:@"next_btn"] forState:(UIControlStateNormal)];
    [self.btnNext setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
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
    [self.btnRate setTitleColor:TABLEVIEWCELL_TLINECOLOR forState:(UIControlStateNormal)];
    [[self.btnRate titleLabel] setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.btnRate addTarget:self action:@selector(btnRateClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnRate];
    
    CGFloat playS = 55;
    CGFloat playX = self.width/2-playS/2;
    
    [self.btnPlay setFrame:CGRectMake(playX, 0, playS, playS)];
    [self.btnPlay setViewRound:playS/2 borderWidth:2 borderColor:WHITECOLOR];
    
    CGFloat rateS = 35;
    CGFloat rateY = playS/2-rateS/2;
    CGFloat rateX = 25;
    [self.btnRate setFrame:CGRectMake(rateX, rateY, rateS, rateS)];
    [self.btnRate setViewRoundWithColor:WHITECOLOR];
    
    CGFloat downloadS = 35;
    CGFloat downloadX = self.width-25-downloadS;
    CGFloat downloadY = playS/2-downloadS/2;
    self.btnDownload = [[ZButton alloc] initWithDownloadWithFrame:CGRectMake(downloadX, downloadY, downloadS, downloadS)];
    [self.btnDownload setDownloadImage:@"icon_download_start"];
    [self.btnDownload setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.btnDownload addTarget:self action:@selector(btnDownloadClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnDownload setTag:ZDownloadStatusNomral];
    [self addSubview:self.btnDownload];
    
    CGFloat preS = 35;
    CGFloat preY = playS/2-preS/2;
    CGFloat preSpace = (playX-(rateX+rateS)-preS)/2;
    [self.btnPre setFrame:CGRectMake(playX-preSpace-preS, preY, preS, preS)];
    [self.btnNext setFrame:CGRectMake(playX+playS+preSpace, preY, preS, preS)];
    
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
    [self.slider addTarget:self action:@selector(sliderTouchTouchDownRepeat:) forControlEvents:(UIControlEventTouchDownRepeat)];
    [self.slider addTarget:self action:@selector(sliderTouchTouchDown:) forControlEvents:(UIControlEventTouchDown)];
    [self.slider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.slider];
    
    CGFloat progressViewX = self.slider.x+2;
    CGFloat progressViewH = 1.2;
    CGFloat progressViewY = sliderY+sliderH/2-progressViewH/2-0.3;
    CGFloat progressViewW = self.slider.width-2;
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
    [self.progressView setBackgroundColor:WHITECOLOR];
    //self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
    //[self.progressView setProgress:0.0f];
    //[self.progressView setProgressTintColor:RGBCOLOR(175, 175, 175)];
    //[self.progressView setTrackTintColor:WHITECOLOR];
    //[self.progressView setProgressViewStyle:(UIProgressViewStyleDefault)];
    [self addSubview:self.progressView];
    //创建出圆形贝塞尔曲线
    self.shapeLayer = [self createShapeLayerWithSize];
    //设置stroke起始点
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    [self.progressView.layer addSublayer:self.shapeLayer];
    
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
-(CAShapeLayer *)createShapeLayerWithSize
{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, 0)];
    [linePath addLineToPoint:CGPointMake(self.progressView.width, 0)];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = self.progressView.height;
    lineLayer.backgroundColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = RGBCOLOR(165, 165, 165).CGColor;
    lineLayer.path = linePath.CGPath;
    
    return lineLayer;
}
/// 设置播放按钮状态
-(void)setDownloadButtonImage:(ZDownloadStatus)status
{
    [self.btnDownload setTag:status];
    switch (status) {
        case ZDownloadStatusNomral:
            [self.btnDownload setDownloadImage:@"icon_download_pause"];
            [self.btnDownload setNeedsDisplay];
            break;
        case ZDownloadStatusStart:
            [self.btnDownload setDownloadImage:@"icon_download_start"];
            [self.btnDownload setNeedsDisplay];
            break;
        case ZDownloadStatusEnd:
            [self.btnDownload setDownloadProgress:0];
            [self.btnDownload setDownloadImage:@"icon_download_end"];
            [self.btnDownload setNeedsDisplay];
            break;
        default:
            break;
    }
}
/// 设置播放按钮状态-无暂停状态
-(void)setDownloadButtonImageNoSuspend:(ZDownloadStatus)status
{
    [self.btnDownload setTag:status];
    switch (status) {
        case ZDownloadStatusNomral:
        case ZDownloadStatusStart:
            [self.btnDownload setDownloadImage:@"icon_download_start"];
            [self.btnDownload setNeedsDisplay];
            break;
        case ZDownloadStatusEnd:
            [self.btnDownload setDownloadProgress:0];
            [self.btnDownload setDownloadImage:@"icon_download_end"];
            [self.btnDownload setNeedsDisplay];
            break;
        default:
            break;
    }
}
/// 设置下载进度
-(void)setDownloadProgress:(CGFloat)progress
{
    [self.btnDownload setDownloadProgress:progress];
}
-(void)btnDownloadClick:(ZButton *)sender
{
    if (self.onDownloadClick) {
        self.onDownloadClick(sender.tag);
    }
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
/// 多手指按下
-(void)sliderTouchTouchDownRepeat:(UISlider *)sender
{
    _isDragSlider = YES;
    if (self.onStopClick) {
        self.onStopClick();
    }
}
/// 单手指按下
-(void)sliderTouchTouchDown:(UISlider *)sender
{
    _isDragSlider = YES;
    if (self.onStopClick) {
        self.onStopClick();
    }
}
/// 手指起来
-(void)sliderTouchUpInside:(UISlider *)sender
{
    _isDragSlider = NO;
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
    GCDMainBlock(^{
        self.shapeLayer.strokeEnd  = 0;
        
        [self.progressView setNeedsDisplay];
    });
    
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
    GCDMainBlock(^{
        self.shapeLayer.strokeEnd  = progress;
        
        [self.progressView setNeedsDisplay];
    });
}
/// 设置播放时间
-(void)setViewCurrentTime:(NSTimeInterval)currentTime
{
    //拖动过程中不需要设置
    if (!_isDragSlider) {
        [self.slider setValue:currentTime];
        
        self.lbProgress.text = [Utils getHHMMSSFromSSTime:currentTime];
    }
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
    OBJC_RELEASE(_shapeLayer);
}

@end
