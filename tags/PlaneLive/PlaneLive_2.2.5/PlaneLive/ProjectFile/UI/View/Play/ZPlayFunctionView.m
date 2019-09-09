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
    NSUInteger _totalTime;
    /// 播放倍率
    CGFloat _playRate;
}
///播放进度
@property (strong, nonatomic) ZSlider *slider;
///缓冲进度
@property (strong, nonatomic) UIView *progressView;
///缓冲动画效果
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (strong, nonatomic) UIView *viewButton;
///总时长
@property (strong, nonatomic) ZLabel *lbTime;
///进度时间
@property (strong, nonatomic) ZLabel *lbProgress;
///倍率
@property (strong, nonatomic) ZButton *btnRate;
//@property (strong, nonatomic) ZImageView *imgRate;
///列表
@property (strong, nonatomic) UIButton *btnList;
///上一条
@property (strong, nonatomic) ZButton *btnPre;
///下一条
@property (strong, nonatomic) ZButton *btnNext;
///暂停或停止或播放中
@property (strong, nonatomic) ZButton *btnPlay;
@property (strong, nonatomic) ZImageView *imgPlay;

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
    CGFloat lbH = 20;
    CGFloat lbY = 10;
    CGFloat lbPX = 20;
    CGFloat lbW = 55;
    if (!self.lbProgress) {
        self.lbProgress = [[ZLabel alloc] initWithFrame:CGRectMake(lbPX, lbY, lbW, lbH)];
        [self.lbProgress setText:@"00:00"];
        [self.lbProgress setTextColor:COLORTEXT3];
        [self.lbProgress setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbProgress setNumberOfLines:1];
        [self.lbProgress setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbProgress setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self addSubview:self.lbProgress];
    }
    CGFloat lbTX = self.width-lbW-lbPX;
    if (!self.lbTime) {
        self.lbTime = [[ZLabel alloc] initWithFrame:CGRectMake(lbTX, lbY, lbW, lbH)];
        [self.lbTime setText:@"00:00"];
        [self.lbTime setTextColor:COLORTEXT3];
        [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbTime setNumberOfLines:1];
        [self.lbTime setTextAlignment:(NSTextAlignmentRight)];
        [self.lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self addSubview:self.lbTime];
    }
    CGFloat sliderX = lbPX+lbW;
    CGFloat sliderY = lbY;
    CGFloat sliderW = self.width-lbPX*2-lbW*2-2;
    CGFloat sliderH = 20;
    if (!self.slider) {
        self.slider = [[ZSlider alloc] initWithFrame:CGRectMake(sliderX, sliderY, sliderW, sliderH)];
        [self.slider setContinuous:YES];
        [self.slider setThumbTintColor:COLORCONTENT1];
        [self.slider setMaximumTrackTintColor:CLEARCOLOR];
        [self.slider setMinimumTrackTintColor:COLORCONTENT1];
        [self.slider setThumbImage:[SkinManager getImageWithName:@"play_progress"] forState:(UIControlStateNormal)];
        [self.slider setThumbImage:[SkinManager getImageWithName:@"play_progress"] forState:(UIControlStateHighlighted)];
        [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
        [self addSubview:self.slider];
    }
    CGFloat progressViewX = self.slider.x+2;
    CGFloat progressViewH = 2;
    CGFloat progressViewY = sliderY+sliderH/2-progressViewH/2-0.3;
    CGFloat progressViewW = self.slider.width-2;
    if (!self.progressView) {
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
        [self.progressView setBackgroundColor:RGBCOLORA(32, 162, 243, 0.10)];
        [self addSubview:self.progressView];
    }
    if (!self.shapeLayer) {
        //创建出圆形贝塞尔曲线
        self.shapeLayer = [self createShapeLayerWithSize];
        [self.progressView.layer addSublayer:self.shapeLayer];
    }
    //设置stroke起始点
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    
    CGFloat buttonViewY = self.slider.y + self.slider.height + 5;
    if (!self.viewButton) {
        self.viewButton = [[UIView alloc]initWithFrame:(CGRectMake(0, buttonViewY, self.width, self.height - buttonViewY))];
        [self addSubview:self.viewButton];
    }
    if (!self.btnPre) {
        self.btnPre = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPre setImage:[SkinManager getImageWithName:@"pre"] forState:(UIControlStateNormal)];
        [self.btnPre setImage:[SkinManager getImageWithName:@"pre"] forState:(UIControlStateHighlighted)];
        [self.btnPre setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [self.btnPre addTarget:self action:@selector(btnPreClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewButton addSubview:self.btnPre];
    }
    if (!self.btnNext) {
        self.btnNext = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnNext setImage:[SkinManager getImageWithName:@"next"] forState:(UIControlStateNormal)];
        [self.btnNext setImage:[SkinManager getImageWithName:@"next"] forState:(UIControlStateHighlighted)];
        [self.btnNext setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [self.btnNext addTarget:self action:@selector(btnNextClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewButton addSubview:self.btnNext];
    }
    
    CGFloat btnY = 0;
    CGFloat playS = 70;
    CGFloat playX = self.width/2-playS/2;
    if (!self.btnPlay) {
        self.btnPlay = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPlay setTag:1];
        [self.btnPlay setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1"] forState:(UIControlStateNormal)];
        [self.btnPlay setBackgroundImage:[SkinManager getImageWithName:@"btn_gra1_c"] forState:(UIControlStateHighlighted)];
        [self.btnPlay setImageEdgeInsets:(UIEdgeInsetsMake(10, 10, 10, 10))];
        [self.btnPlay addTarget:self action:@selector(btnPlayClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        UIView *viewBtnPlay = [[UIView alloc] initWithFrame:CGRectMake(playX, btnY, playS, playS)];
        [viewBtnPlay setButtonShadowColorCircular];
        [self.viewButton addSubview:viewBtnPlay];
        [self.btnPlay setFrame:viewBtnPlay.bounds];
        [self.btnPlay.layer setMasksToBounds:YES];
        [self.btnPlay setViewRound:playS/2 borderWidth:0 borderColor:WHITECOLOR];
        [viewBtnPlay addSubview:self.btnPlay];
    }
    _playRate = [AppSetting getRate];
    CGFloat rateS = 35;
    CGFloat rateY = playS/2-rateS/2;
    CGFloat rateX = 25;
    if (!self.btnRate) {
        self.btnRate = [ZButton buttonWithType:(UIButtonTypeCustom)];
        if (_playRate == 1.5) {
            [self.btnRate setTitle:@"1.5" forState:(UIControlStateNormal)];
        } else if (_playRate == 1.25) {
            [self.btnRate setTitle:@"1.25" forState:(UIControlStateNormal)];
        } else {
            [self.btnRate setTitle:@"1.0" forState:(UIControlStateNormal)];
        }
        [self.btnRate setTitleColor:RGBCOLOR(173,192,200) forState:(UIControlStateNormal)];
        [[self.btnRate titleLabel] setFont:[ZFont systemFontOfSize:8]];
        [self.btnRate addTarget:self action:@selector(btnRateClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewButton addSubview:self.btnRate];
        
        
        [self.btnRate setFrame:CGRectMake(rateX, btnY+rateY, rateS, rateS)];
        ZImageView *imgRate = [[ZImageView alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
        [imgRate setImageName:@"fast"];
        [imgRate setUserInteractionEnabled:NO];
        [self.btnRate addSubview:imgRate];
    }
    CGFloat playImageSize = 24;
    CGFloat playImageX = playS / 2 - playImageSize / 2;
    CGFloat playImageY = playImageX;
    if (!self.imgPlay) {
        self.imgPlay = [[ZImageView alloc] initWithFrame:(CGRectMake(playImageX, playImageY, playImageSize, playImageSize))];
        [self.imgPlay setImageName:@"play_ing"];
        [self.imgPlay setUserInteractionEnabled:false];
        [self.btnPlay addSubview:self.imgPlay];
    }
    CGFloat listS = 35;
    CGFloat listX = self.width-25-listS;
    CGFloat listY = playS/2-listS/2;
    if (!self.btnList) {
        self.btnList = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnList setFrame:CGRectMake(listX, btnY+listY, listS, listS)];
        [self.btnList setImage:[SkinManager getImageWithName:@"play_list"] forState:(UIControlStateNormal)];
        [self.btnList setImage:[SkinManager getImageWithName:@"play_list"] forState:(UIControlStateHighlighted)];
        [self.btnList setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [self.btnList addTarget:self action:@selector(btnListClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewButton addSubview:self.btnList];
    }
    CGFloat preS = 35;
    CGFloat preY = playS/2-preS/2;
    CGFloat preSpace = (playX-(rateX+rateS)-preS)/2;
    [self.btnPre setFrame:CGRectMake(playX-preSpace-preS, btnY+preY, preS, preS)];
    [self.btnNext setFrame:CGRectMake(playX+playS+preSpace, btnY+preY, preS, preS)];
    
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
    lineLayer.strokeColor = self.progressView.backgroundColor.CGColor;
    lineLayer.path = linePath.CGPath;
    
    return lineLayer;
}
-(void)btnListClick
{
    if (self.onListClick) {
        self.onListClick();
    }
}
-(void)btnRateClick:(ZButton *)sender
{
    if (_playRate == 1.5) {
        _playRate = 1.0;
        [self.btnRate setTitle:@"1.0" forState:(UIControlStateNormal)];
    } else if (_playRate == 1.25) {
        _playRate = 1.5;
        [self.btnRate setTitle:@"1.5" forState:(UIControlStateNormal)];
    } else {
        _playRate = 1.25;
        [self.btnRate setTitle:@"1.25" forState:(UIControlStateNormal)];
    }
    if (self.onRateChange) {
        self.onRateChange(_playRate);
    }
    [AppSetting setRate:_playRate];
    [AppSetting save];
}
/// 改变值
-(void)sliderValueChanged:(UISlider *)sender
{
    self.lbProgress.text = [Utils getHHMMSSFromSSTime:sender.value*_totalTime];
    if (self.onSliderValueChange) {
        self.onSliderValueChange(sender.value);
    }
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
/// 获取当前倍率播放
-(CGFloat)getRate
{
    return _playRate;
}
/// 状态是否播放中
-(BOOL)isPlaying
{
    return self.btnPlay.tag == 2;
}
/// 停止播放
-(void)setStopPlay
{
    self.shapeLayer.strokeEnd  = 0;
    [self.shapeLayer setNeedsDisplay];
    
    [self.lbProgress setText:@"00:00"];
    [self.slider setValue:0.0];
    
    [self.btnPlay setTag:1];
    [self.imgPlay setImageName:@"play_ing"];
}
/// 开始播放
-(void)setStartPlay
{
    [self.btnPlay setTag:2];
    [self.imgPlay setImageName:@"play_stop2"];
}
/// 暂停播放
-(void)setPausePlay
{
    [self.btnPlay setTag:1];
    [self.imgPlay setImageName:@"play_ing"];
}
/// 设置缓冲进度
-(void)setViewProgress:(CGFloat)progress
{
    GCDMainBlock(^{
        self.shapeLayer.strokeEnd  = progress;
        [self.shapeLayer setNeedsDisplay];
    });
}
/// 设置播放时间
-(void)setViewCurrentTime:(NSUInteger)currentTime percent:(CGFloat)percent
{
    GCDMainBlock(^{
        [self.slider setValue:percent];
        self.lbProgress.text = [Utils getHHMMSSFromSSTime:currentTime];
    });
}
/// 设置最大播放时间
-(void)setMaxDuratuin:(NSUInteger)duration
{
    if (duration == NAN || duration <= 0) {
        _totalTime = 0.0000f;
        [self.lbTime setText:@"00:00"];
    } else {
        _totalTime = duration;
        [self.lbTime setText:[Utils getHHMMSSFromSSTime:duration]];
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbProgress);
    OBJC_RELEASE(_btnPre);
    OBJC_RELEASE(_btnNext);
    OBJC_RELEASE(_btnList);
    OBJC_RELEASE(_btnPlay);
    OBJC_RELEASE(_slider);
    OBJC_RELEASE(_progressView);
    OBJC_RELEASE(_shapeLayer);
}

@end
