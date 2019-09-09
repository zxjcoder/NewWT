//
//  ZPlayInfoView.m
//  PlaneLive
//
//  Created by WT on 14/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZPlayInfoView.h"
#import "ZSlider.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "ZImageView.h"
#import "ZCalculateLabel.h"
#import "ZPlayMainScrollView.h"

@interface ZPlayInfoView()<UIScrollViewDelegate>
{
    /// 总时间
    NSUInteger _totalTime;
    /// 播放倍率
    CGFloat _playRate;
}

@property (strong, nonatomic) ZPlayMainScrollView *scMainView;
@property (strong, nonatomic) UIView *viewInfo;

/// 图片区域
@property (strong, nonatomic) UIView *viewInfoImage;
/// 图片
@property (strong, nonatomic) ZImageView *imageIcon;
/// 标题
@property (strong, nonatomic) UILabel *lbTitle;
/// 主讲人
@property (strong, nonatomic) UILabel *lbSpeaker;

/// 小按钮区域
@property (strong, nonatomic) UIView *viewInfoTopButton;
/// 详情
@property (strong, nonatomic) UIButton *btnDetail;
/// 发送邮件
@property (strong, nonatomic) UIButton *btnMail;
/// PPT
@property (strong, nonatomic) UIButton *btnPPT;

/// 滑动区域
@property (strong, nonatomic) UIView *viewInfoSlider;
/// 播放进度
@property (strong, nonatomic) ZSlider *slider;
/// 缓冲进度
@property (strong, nonatomic) UIView *progressView;
/// 缓冲动画效果
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
/// 功能按钮区域
@property (strong, nonatomic) UIView *viewInfoPlayButton;
/// 总时长
@property (strong, nonatomic) ZLabel *lbTime;
/// 进度时间
@property (strong, nonatomic) ZLabel *lbProgress;
/// 倍率
@property (strong, nonatomic) ZButton *btnRate;
/// 列表
@property (strong, nonatomic) ZButton *btnList;
/// 上一条
@property (strong, nonatomic) ZButton *btnPre;
/// 下一条
@property (strong, nonatomic) ZButton *btnNext;
/// 暂停或停止或播放中
@property (strong, nonatomic) UIView *viewButtonPlay;
@property (strong, nonatomic) ZButton *btnPlay;
@property (strong, nonatomic) ZImageView *imgPlay;

/// 详情介绍区域
@property (strong, nonatomic) UIView *viewDetail;
/// 详情介绍滑动区域
@property (strong, nonatomic) UIScrollView *scViewDetail;
/// 主讲人简介标题
@property (strong, nonatomic) UILabel *lbSpeakerProfileTitle;
/// 主讲人简介内容
@property (strong, nonatomic) UILabel *lbSpeakerProfileContent;
/// 音频简介标题
@property (strong, nonatomic) UILabel *lbProfileTitle;
/// 音频简介内容
@property (strong, nonatomic) UILabel *lbProfileContent;
/// 显示索引区域
@property (strong, nonatomic) UIView *viewPage;
@property (strong, nonatomic) UIImageView *viewPage1;
@property (strong, nonatomic) UIImageView *viewPage2;

@property (assign, nonatomic) CGFloat lbProgressH;
@property (assign, nonatomic) CGFloat lbProgressW;

@property (assign, nonatomic) CGFloat btnPlayH;
@property (assign, nonatomic) CGFloat btnItemSpace;

@property (assign, nonatomic) CGFloat pageViewH;
@property (assign, nonatomic) CGFloat mainViewTopSpace;
@property (assign, nonatomic) CGFloat viewXSpace;
@property (assign, nonatomic) CGFloat topButtonH;

@property (assign, nonatomic) CGFloat edgeSize;

@property (strong, nonatomic) ModelPractice *modelP;
@property (strong, nonatomic) ModelCurriculum *modelC;
@property (assign, nonatomic) ZPlayTabBarViewType tabType;

@end

@implementation ZPlayInfoView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.edgeSize = 20;
    self.lbProgressH = 17;
    self.lbProgressW = 100;
    self.btnPlayH = 48;
    self.topButtonH = 42;
    //播放按钮View - X偏移量
    self.viewXSpace = 10;
    self.btnItemSpace = (self.width-self.edgeSize*2-self.self.btnPlayH*4-self.btnPlayH-self.viewXSpace*2)/4;
    self.pageViewH =47;
    self.mainViewTopSpace = 23;
    if (IsIPhone4 || IsIPhone5) {
        self.pageViewH = 30;
        self.mainViewTopSpace = 15;
    }
    [self setViewFrame];
    [self setUserInteractionEnabled:true];
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self.scMainView setDelegate:self];
    [self.scMainView setUserInteractionEnabled:true];
    [self.scMainView setBackgroundColor:[UIColor clearColor]];
    [self.scMainView setContentSize:(CGSizeMake(self.width*2-30, self.scMainView.height))];
    
    [self.viewInfo setBackgroundColor:[UIColor whiteColor]];
    [self.viewInfo setUserInteractionEnabled:true];
    [self.viewInfoImage setUserInteractionEnabled:true];
    [self.viewInfoPlayButton setUserInteractionEnabled:true];
    [self.viewInfoSlider setUserInteractionEnabled:true];
    [self.viewInfoTopButton setUserInteractionEnabled:true];
    
    [self.viewPage setBackgroundColor:[UIColor clearColor]];
    [self.viewPage1 setBackgroundColor:[UIColor clearColor]];
    [self.viewPage2 setBackgroundColor:[UIColor clearColor]];
    
    self.lbTitle.text = kEmpty;
    self.lbSpeaker.text = kEmpty;
    [self.btnDetail setUserInteractionEnabled:true];
    [self.btnMail setUserInteractionEnabled:true];
    [self.btnPPT setUserInteractionEnabled:true];
    
    [self.slider setUserInteractionEnabled:true];
    [self.progressView setUserInteractionEnabled:false];
    //设置stroke起始点
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    self.lbProgress.text = @"00:00";
    self.lbTime.text = @"00:00";
    
    [self.btnRate setUserInteractionEnabled:true];
    [self.btnPre setUserInteractionEnabled:true];
    
    [self.viewButtonPlay setUserInteractionEnabled:true];
    [self.btnPlay setUserInteractionEnabled:true];
    [self.imgPlay setUserInteractionEnabled:false];
    
    [self.btnNext setUserInteractionEnabled:true];
    [self.btnList setUserInteractionEnabled:true];
    
//    [self.btnDetail setBackgroundColor:[UIColor greenColor]];
//    [self.btnMail setBackgroundColor:[UIColor greenColor]];
//    [self.btnPPT setBackgroundColor:[UIColor greenColor]];
//    [self.btnRate setBackgroundColor:[UIColor greenColor]];
//    [self.btnPre setBackgroundColor:[UIColor greenColor]];
//    [self.btnNext setBackgroundColor:[UIColor greenColor]];
//    [self.btnList setBackgroundColor:[UIColor greenColor]];
    
    [self.btnDetail addTarget:self action:@selector(btnDetailEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnMail addTarget:self action:@selector(btnMailEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnPPT addTarget:self action:@selector(btnPPTEvent) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnPlay addTarget:self action:@selector(btnPlayClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnRate addTarget:self action:@selector(btnRateClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnList addTarget:self action:@selector(btnListClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnNext addTarget:self action:@selector(btnNextClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnPre addTarget:self action:@selector(btnPreClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    
    [self.viewDetail setBackgroundColor:[UIColor whiteColor]];
    [self.scViewDetail setBackgroundColor:[UIColor clearColor]];
    
    [self.lbSpeakerProfileTitle setUserInteractionEnabled:false];
    [self.lbSpeakerProfileContent setUserInteractionEnabled:false];
    [self.lbProfileTitle setUserInteractionEnabled:false];
    [self.lbProfileContent setUserInteractionEnabled:false];
}
-(void)setViewFrame
{
    CGFloat bottomHeight = self.height-self.mainViewTopSpace-self.pageViewH;
    self.scMainView.frame = CGRectMake(0, self.mainViewTopSpace, self.width, bottomHeight);
    self.viewInfo.frame = CGRectMake(self.edgeSize, 0, self.scMainView.width-self.edgeSize*2, self.scMainView.height);
    /// 播放切换按钮区域
    CGFloat spaceInfoPlayButton = 30;
    if (IsIPhone5) {
        spaceInfoPlayButton = 15;
    } else if (IsIPhone4) {
        spaceInfoPlayButton = 20;
    }
    self.viewInfoPlayButton.frame = CGRectMake(self.viewXSpace, self.viewInfo.height-spaceInfoPlayButton-self.btnPlayH, self.viewInfo.width-self.viewXSpace*2, self.btnPlayH);
    /// 滑动播放条区域
    CGFloat spaceInfoSlider = 17;
    if (IsIPhone5) {
        spaceInfoSlider = 10;
    } else if (IsIPhone4) {
        spaceInfoSlider = 15;
    }
    CGFloat itemInfoSliderHeight = 32;
    self.viewInfoSlider.frame = CGRectMake(self.edgeSize, self.viewInfoPlayButton.y-spaceInfoSlider-itemInfoSliderHeight, self.viewInfo.width-self.edgeSize*2, itemInfoSliderHeight);
    /// 功能按钮区域
    CGFloat spaceInfoTopButton = 13;
    if (IsIPhone5) {
        spaceInfoTopButton = 5;
    } else if (IsIPhone4) {
        spaceInfoTopButton = 5;
    }
    self.viewInfoTopButton.frame = CGRectMake(self.viewXSpace, self.viewInfoSlider.y-spaceInfoTopButton-self.topButtonH, self.viewInfo.width-self.viewXSpace*2, self.topButtonH);
    CGFloat viewInfoImageH = self.viewInfo.height-self.viewInfoTopButton.y;
    /// 图片标题区域
    self.viewInfoImage.frame = CGRectMake(self.edgeSize, 0, self.viewInfo.width-self.edgeSize*2, viewInfoImageH);
  
    CGFloat imageSize = 110;
    CGFloat imageY = 30;
    if (IsIPhone4) {
        imageY = 15;
        imageSize = 80;
    } else if (IsIPhone5) {
        imageY = 20;
        imageSize = 100;
    }
    self.imageIcon.frame = (CGRectMake(self.viewInfoImage.width/2-imageSize/2, imageY, imageSize, imageSize));
    
    CGFloat titlex = 0;
    CGFloat titley = self.imageIcon.y+self.imageIcon.height+15;
    CGFloat titlew = self.viewInfoImage.width;
    if (IsIPhone4) {
       titlex = self.imageIcon.x+self.imageIcon.width+10;
       titley = self.imageIcon.y+6;
       titlew = self.viewInfoImage.width-titlex;
    } else if (IsIPhone5) {
        titley = self.imageIcon.y+self.imageIcon.height+10;
    }
    self.lbTitle.frame = CGRectMake(titlex, titley, titlew, 20);
    
    CGFloat speakerx = self.lbTitle.x;
    CGFloat speakerw = self.lbTitle.width;
    CGFloat speakery = self.lbTitle.y+self.lbTitle.height+15;
    if (IsIPhone4) {
       speakerx = self.imageIcon.x+self.imageIcon.width+10;
       speakerw = self.viewInfoImage.width-speakerx;
       speakery = self.lbTitle.y+self.lbTitle.height+10;
    }
    self.lbSpeaker.frame = (CGRectMake(speakerx, speakery, speakerw, 20));
    
    self.btnDetail.frame = CGRectMake(0, 0, self.topButtonH, self.topButtonH);
    self.btnMail.frame = CGRectMake(self.topButtonH+1, 0, self.topButtonH, self.topButtonH);
    self.btnPPT.frame = CGRectMake(self.viewInfoTopButton.width-self.topButtonH, 0, self.topButtonH, self.topButtonH);
    
    self.slider.frame = CGRectMake(0, 0, self.viewInfoSlider.width, 16);
    CGFloat progressViewX = self.slider.x+1;
    CGFloat progressViewH = 2;
    CGFloat progressViewY = self.slider.height/2-progressViewH/2-0.3;
    CGFloat progressViewW = self.slider.width-2;
    self.progressView.frame = CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH);
    
    self.lbProgress.frame = CGRectMake(0, self.slider.y+self.slider.height+1, self.lbProgressW, self.lbProgressH);
    self.lbTime.frame = CGRectMake(self.viewInfoSlider.width-self.lbProgressW+1, self.lbProgress.y, self.lbProgressW, self.lbProgressH);
    
    CGFloat btnSize = self.btnPlayH;
    CGFloat btnRateY = 0;
    CGFloat btnRateX = 0;
    self.btnRate.frame = CGRectMake(btnRateX, btnRateY, btnSize, btnSize);
    
    CGFloat btnPreX = self.btnRate.x+self.btnRate.width+self.btnItemSpace;
    CGFloat btnPreY = self.btnPlayH/2-btnSize/2;
    self.btnPre.frame = CGRectMake(btnPreX, btnPreY, btnSize, btnSize);
    
    CGFloat btnPlayX = self.btnPre.x+self.btnPre.width+self.btnItemSpace;
    self.viewButtonPlay.frame = CGRectMake(btnPlayX, 0, btnSize, btnSize);
    [self.viewButtonPlay setAllShadowColorNoBorderWithRadius:btnSize/2];
    self.btnPlay.frame = self.viewButtonPlay.bounds;
    [self.btnPlay setViewRoundNoBorder];
    CGFloat playImageSize = 15;
    CGFloat playImageX = btnSize/2 - playImageSize/2;
    CGFloat playImageY = playImageX;
    self.imgPlay.frame = CGRectMake(playImageX, playImageY, playImageSize, playImageSize);
    
    CGFloat btnNextX = self.viewButtonPlay.x+self.viewButtonPlay.width+self.btnItemSpace;
    CGFloat btnNextY = self.btnPlayH/2-btnSize/2;
    self.btnNext.frame = CGRectMake(btnNextX, btnNextY, btnSize, btnSize);
    
    CGFloat btnListX = self.viewInfoPlayButton.width-btnSize;
    CGFloat btnListY = self.viewInfoPlayButton.height/2-btnSize/2;
    self.btnList.frame = CGRectMake(btnListX, btnListY, btnSize, btnSize);
    
    self.viewPage.frame = CGRectMake(self.width/2-23, self.height-self.pageViewH/2-1, 46, 2);
    self.viewPage1.frame = CGRectMake(0, 0, 16, 2);
    self.viewPage2.frame = CGRectMake(self.viewPage.width-16, 0, 16, 2);
    
    /// 详细介绍区域
    self.viewDetail.frame = CGRectMake(self.scMainView.width-10, 0, self.viewInfo.width, self.viewInfo.height);
    self.scViewDetail.frame = CGRectMake(5, 5, self.viewDetail.width-10, self.viewDetail.height-10);
    
    [self setNeedsDisplay];
}
-(UIScrollView *)scMainView
{
    if (!_scMainView) {
        _scMainView = [[ZPlayMainScrollView alloc] init];
        [_scMainView setBackgroundColor:[UIColor clearColor]];
        [_scMainView setShowsVerticalScrollIndicator:false];
        [_scMainView setShowsHorizontalScrollIndicator:false];
        [_scMainView setPagingEnabled:true];
        [_scMainView setScrollsToTop:false];
        [_scMainView setBounces:false];
        [self addSubview:_scMainView];
    }
    return _scMainView;
}
-(UIView *)viewInfo
{
    if (!_viewInfo) {
        _viewInfo = [[UIView alloc] init];
        [_viewInfo setViewRound:8];
        [_viewInfo setBackgroundColor:[UIColor whiteColor]];
        [self.scMainView addSubview:_viewInfo];
    }
    return _viewInfo;
}
-(UIView *)viewInfoImage
{
    if (!_viewInfoImage) {
        _viewInfoImage = [[UIView alloc] init];
        [self.viewInfo addSubview:_viewInfoImage];
    }
    return _viewInfoImage;
}
-(UIView *)viewInfoTopButton
{
    if (!_viewInfoTopButton) {
        _viewInfoTopButton = [[UIView alloc] init];
        [self.viewInfo addSubview:_viewInfoTopButton];
    }
    return _viewInfoTopButton;
}
-(UIView *)viewInfoSlider
{
    if (!_viewInfoSlider) {
        _viewInfoSlider = [[UIView alloc] init];
        [self.viewInfo addSubview:_viewInfoSlider];
    }
    return _viewInfoSlider;
}
-(UIView *)viewInfoPlayButton
{
    if (!_viewInfoPlayButton) {
        _viewInfoPlayButton = [[UIView alloc] init];
        [self.viewInfo addSubview:_viewInfoPlayButton];
    }
    return _viewInfoPlayButton;
}
-(ZImageView *)imageIcon
{
    if (!_imageIcon) {
        _imageIcon = [[ZImageView alloc] initWithImage:[SkinManager getDefaultImage]];
        [_imageIcon setViewRound:10];
        [self.viewInfoImage addSubview:_imageIcon];
    }
    return _imageIcon;
}
-(UILabel *)lbTitle
{
    if (!_lbTitle) {
         _lbTitle = [[UILabel alloc] init];
        [_lbTitle setFont:[ZFont boldSystemFontOfSize:18]];
        [_lbTitle setTextColor:COLORTEXT1];
        [_lbTitle setNumberOfLines:2];
        [_lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        [self.viewInfoImage addSubview:_lbTitle];
    }
    return _lbTitle;
}
-(UILabel *)lbSpeaker
{
    if (!_lbSpeaker) {
         _lbSpeaker = [[UILabel alloc] init];
        [_lbSpeaker setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [_lbSpeaker setTextColor:COLORTEXT2];
        [_lbSpeaker setNumberOfLines:1];
        [_lbSpeaker setTextAlignment:(NSTextAlignmentCenter)];
        [self.viewInfoImage addSubview:_lbSpeaker];
    }
    return _lbSpeaker;
}
-(UIButton *)btnDetail
{
    if (!_btnDetail) {
        _btnDetail = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnDetail setImage:[SkinManager getImageWithName:@"album"] forState:(UIControlStateNormal)];
        [_btnDetail setImage:[SkinManager getImageWithName:@"album"] forState:(UIControlStateHighlighted)];
        [_btnDetail setImageEdgeInsets:(UIEdgeInsetsMake(7, 7, 7, 7))];
        [self.viewInfoTopButton addSubview:_btnDetail];
    }
    return _btnDetail;
}
-(UIButton *)btnMail
{
    if (!_btnMail) {
        _btnMail = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnMail setImage:[SkinManager getImageWithName:@"email"] forState:(UIControlStateNormal)];
        [_btnMail setImage:[SkinManager getImageWithName:@"email"] forState:(UIControlStateHighlighted)];
        [_btnMail setImageEdgeInsets:(UIEdgeInsetsMake(7, 7, 7, 7))];
        [self.viewInfoTopButton addSubview:_btnMail];
    }
    return _btnMail;
}
-(UIButton *)btnPPT
{
    if (!_btnPPT) {
        _btnPPT = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnPPT setImage:[SkinManager getImageWithName:@"ppt"] forState:(UIControlStateNormal)];
        [_btnPPT setImage:[SkinManager getImageWithName:@"ppt"] forState:(UIControlStateHighlighted)];
        [_btnPPT setImageEdgeInsets:(UIEdgeInsetsMake(7, 7, 7, 7))];
        [self.viewInfoTopButton addSubview:_btnPPT];
    }
    return _btnPPT;
}
-(ZSlider *)slider
{
    if (!_slider) {
        _slider = [[ZSlider alloc] initWithFrame:(CGRectMake(0, 0, self.viewInfoSlider.width, 16))];
        [_slider setContinuous:YES];
        [_slider setMaximumTrackTintColor:CLEARCOLOR];
        //[_slider setMinimumTrackTintColor:RGBCOLOR(106,205,108)];
        [_slider setMinimumTrackImage:[SkinManager getImageWithName:@"btn_gra3"] forState:(UIControlStateNormal)];
        [_slider setMinimumTrackImage:[SkinManager getImageWithName:@"btn_gra3"] forState:(UIControlStateHighlighted)];
        [_slider setThumbImage:[SkinManager getImageWithName:@"play_progress"] forState:(UIControlStateNormal)];
        [_slider setThumbImage:[SkinManager getImageWithName:@"play_progress"] forState:(UIControlStateHighlighted)];
        [self.viewInfoSlider addSubview:_slider];
    }
    return _slider;
}
-(UIView *)progressView
{
    if (!_progressView) {
        CGFloat progressViewX = self.slider.x+1;
        CGFloat progressViewH = 2;
        CGFloat progressViewY = self.slider.height/2-progressViewH/2-0.3;
        CGFloat progressViewW = self.slider.width-2;
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(progressViewX, progressViewY, progressViewW, progressViewH)];
        [_progressView setBackgroundColor:RGBCOLORA(209, 216, 223, 0.80)];
        [self.viewInfoSlider addSubview:_progressView];
        
        [self.viewInfoSlider sendSubviewToBack:_progressView];
    }
    return _progressView;
}
-(CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        //创建出圆形贝塞尔曲线
        _shapeLayer = [self createShapeLayerWithSize];
        [self.progressView.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
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
-(ZLabel *)lbProgress
{
    if (!_lbProgress) {
        _lbProgress = [[ZLabel alloc] initWithFrame:CGRectMake(0, self.slider.y+self.slider.height+1, self.lbProgressW, self.lbProgressH)];
        [_lbProgress setText:@"00:00"];
        [_lbProgress setTextColor:COLORTEXT3];
        [_lbProgress setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
        [_lbProgress setNumberOfLines:1];
        [_lbProgress setTextAlignment:(NSTextAlignmentLeft)];
        [_lbProgress setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.viewInfoSlider addSubview:_lbProgress];
    }
    return _lbProgress;
}
-(ZLabel *)lbTime
{
    if (!_lbTime) {
        _lbTime = [[ZLabel alloc] initWithFrame:CGRectMake(self.viewInfoSlider.width-self.lbProgressW+1, self.lbProgress.y, self.lbProgressW, self.lbProgressH)];
        [_lbTime setText:@"00:00"];
        [_lbTime setTextColor:COLORTEXT3];
        [_lbTime setFont:[UIFont systemFontOfSize:kFont_Min_Size]];
        [_lbTime setNumberOfLines:1];
        [_lbTime setTextAlignment:(NSTextAlignmentRight)];
        [_lbTime setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
        [self.viewInfoSlider addSubview:_lbTime];
    }
    return _lbTime;
}
-(ZButton *)btnRate
{
    if (!_btnRate) {
        _playRate = [AppSetting getRate];
        _btnRate = [ZButton buttonWithType:(UIButtonTypeCustom)];
        if (_playRate == 1.5) {
            [_btnRate setTitle:@"1.5" forState:(UIControlStateNormal)];
        } else if (_playRate == 1.25) {
            [_btnRate setTitle:@"1.25" forState:(UIControlStateNormal)];
        } else {
            [_btnRate setTitle:@"1.0" forState:(UIControlStateNormal)];
        }
        [_btnRate setTitleColor:RGBCOLOR(123,135,163) forState:(UIControlStateNormal)];
        [[_btnRate titleLabel] setFont:[UIFont systemFontOfSize:8]];
        [_btnRate setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 2))];
        [self.viewInfoPlayButton addSubview:_btnRate];
        
        ZImageView *imgRate = [[ZImageView alloc] initWithFrame:CGRectMake(12, 11, 24, 24)];
        [imgRate setImageName:@"fast"];
        [imgRate setUserInteractionEnabled:NO];
        [_btnRate addSubview:imgRate];
    }
    return _btnRate;
}
-(ZButton *)btnPre
{
    if (!_btnPre) {
        _btnPre = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [_btnPre setImage:[SkinManager getImageWithName:@"pre"] forState:(UIControlStateNormal)];
        [_btnPre setImage:[SkinManager getImageWithName:@"pre"] forState:(UIControlStateHighlighted)];
        [_btnPre setImageEdgeInsets:(UIEdgeInsetsMake(12, 12, 12, 12))];
        [self.viewInfoPlayButton addSubview:_btnPre];
    }
    return _btnPre;
}
-(UIView *)viewButtonPlay
{
    if (!_viewButtonPlay) {
        _viewButtonPlay = [[UIView alloc] init];
        [self.viewInfoPlayButton addSubview:_viewButtonPlay];
    }
    return _viewButtonPlay;
}
-(ZButton *)btnPlay
{
    if (!_btnPlay) {
        _btnPlay = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [_btnPlay setTag:1];
        [_btnPlay setBackgroundImage:[SkinManager getImageWithName:@"btn_gra3"] forState:(UIControlStateNormal)];
        [_btnPlay setBackgroundImage:[SkinManager getImageWithName:@"btn_gra3_c"] forState:(UIControlStateHighlighted)];
        [_btnPlay setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
        [self.viewButtonPlay addSubview:_btnPlay];
    }
    return _btnPlay;
}
-(ZImageView *)imgPlay
{
    if (!_imgPlay) {
        _imgPlay = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"play_ing"]];
        [self.btnPlay addSubview:_imgPlay];
    }
    return _imgPlay;
}
-(ZButton *)btnNext
{
    if (!_btnNext) {
        _btnNext = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [_btnNext setImage:[SkinManager getImageWithName:@"next"] forState:(UIControlStateNormal)];
        [_btnNext setImage:[SkinManager getImageWithName:@"next"] forState:(UIControlStateHighlighted)];
        [_btnNext setImageEdgeInsets:(UIEdgeInsetsMake(12, 12, 12, 12))];
        [self.viewInfoPlayButton addSubview:_btnNext];
    }
    return _btnNext;
}
-(ZButton *)btnList
{
    if (!_btnList) {
        _btnList = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnList setImage:[SkinManager getImageWithName:@"play_list"] forState:(UIControlStateNormal)];
        [_btnList setImage:[SkinManager getImageWithName:@"play_list"] forState:(UIControlStateHighlighted)];
        [_btnNext setImageEdgeInsets:(UIEdgeInsetsMake(12, 12, 12, 12))];
        [self.viewInfoPlayButton addSubview:_btnList];
    }
    return _btnList;
}
-(UIView *)viewPage
{
    if (!_viewPage) {
        _viewPage = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-23, self.height-self.pageViewH/2-1, 46, 2)];
        [_viewPage setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_viewPage];
    }
    return _viewPage;
}
-(UIImageView *)viewPage1
{
    if (!_viewPage1) {
        _viewPage1 = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, 16, 2))];
        _viewPage1.image = [SkinManager getImageWithName:@"page_s"];
        [self.viewPage addSubview:_viewPage1];
    }
    return _viewPage1;
}
-(UIImageView *)viewPage2
{
    if (!_viewPage2) {
        _viewPage2 = [[UIImageView alloc] initWithFrame:(CGRectMake(self.viewPage.width-16, 0, 16, 2))];
        _viewPage2.image = [SkinManager getImageWithName:@"page"];
        [self.viewPage addSubview:_viewPage2];
    }
    return _viewPage2;
}
-(UIView *)viewDetail
{
    if (!_viewDetail) {
        _viewDetail = [[UIView alloc] initWithFrame:(CGRectMake(self.scMainView.width-10, 0, self.viewInfo.width, self.viewInfo.height))];
        [_viewDetail setViewRound:8];
        [_viewDetail setBackgroundColor:[UIColor whiteColor]];
        [self.scMainView addSubview:_viewDetail];
    }
    return _viewDetail;
}
-(UIScrollView *)scViewDetail
{
    if (!_scViewDetail) {
        _scViewDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, self.viewDetail.width-10, self.viewDetail.height-10)];
        [_scViewDetail setBackgroundColor:[UIColor whiteColor]];
        [_scViewDetail setScrollsToTop:false];
        [self.viewDetail addSubview:_scViewDetail];
    }
    return _scViewDetail;
}
-(UILabel *)lbSpeakerProfileTitle
{
    if (!_lbSpeakerProfileTitle) {
        _lbSpeakerProfileTitle = [[UILabel alloc] initWithFrame:(CGRectMake(22, 26, self.scViewDetail.width-44, 25))];
        [_lbSpeakerProfileTitle setTextColor:COLORCONTENT1];
        [_lbSpeakerProfileTitle setFont:[ZFont boldSystemFontOfSize:18]];
        [_lbSpeakerProfileTitle setNumberOfLines:1];
        [self.scViewDetail addSubview:_lbSpeakerProfileTitle];
    }
    return _lbSpeakerProfileTitle;
}
-(UILabel *)lbSpeakerProfileContent
{
    if (!_lbSpeakerProfileContent) {
        CGFloat itemY = self.lbSpeakerProfileTitle.y+self.lbSpeakerProfileTitle.height+6;
        _lbSpeakerProfileContent = [[UILabel alloc] initWithFrame:(CGRectMake(22, itemY, self.lbSpeakerProfileTitle.width, 20))];
        [_lbSpeakerProfileContent setFont:[ZFont systemFontOfSize:16]];
        [_lbSpeakerProfileContent setTextColor:COLORTEXT2];
        [_lbSpeakerProfileContent setNumberOfLines:0];
        [self.scViewDetail addSubview:_lbSpeakerProfileContent];
    }
    return _lbSpeakerProfileContent;
}
-(UILabel *)lbProfileTitle
{
    if (!_lbProfileTitle) {
        CGFloat itemY = self.lbSpeakerProfileContent.y+self.lbSpeakerProfileContent.height+11;
        _lbProfileTitle = [[UILabel alloc] initWithFrame:(CGRectMake(22, itemY, self.lbSpeakerProfileTitle.width, 25))];
        [_lbProfileTitle setTextColor:COLORCONTENT1];
        [_lbProfileTitle setFont:[ZFont boldSystemFontOfSize:18]];
        [self.scViewDetail addSubview:_lbProfileTitle];
    }
    return _lbProfileTitle;
}
-(UILabel *)lbProfileContent
{
    if (!_lbProfileContent) {
        CGFloat itemY = self.lbProfileTitle.y+self.lbProfileTitle.height+6;
        _lbProfileContent = [[UILabel alloc] initWithFrame:(CGRectMake(22, itemY, self.lbSpeakerProfileTitle.width, 20))];
        [_lbProfileContent setFont:[ZFont systemFontOfSize:16]];
        [_lbProfileContent setTextColor:COLORTEXT2];
        [_lbProfileContent setNumberOfLines:0];
        [self.scViewDetail addSubview:_lbProfileContent];
    }
    return _lbProfileContent;
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
/// 设置总时长
-(void)setTotalDuration:(NSInteger)duration
{
    if (duration == NAN || duration <= 0) {
        _totalTime = 0.0000f;
        [self.lbTime setText:@"00:00"];
    } else {
        _totalTime = duration;
        [self.lbTime setText:[Utils getHHMMSSFromSSTime:duration]];
    }
}
/// 设置缓冲进度
-(void)setViewCacheProgress:(CGFloat)progress
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
/// 改变值
-(void)sliderValueChanged:(UISlider *)sender
{
    self.lbProgress.text = [Utils getHHMMSSFromSSTime:sender.value*_totalTime];
    if (self.onSliderValueChange) {
        self.onSliderValueChange(sender.value);
    }
}
-(void)setContentViewFrame
{
    CGFloat titleH = [[ZCalculateLabel shareCalculateLabel] getALineHeightWithFont:self.lbTitle.font width:self.lbTitle.width];
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    if (titleMaxH > titleH*2) {
        self.lbTitle.frame = CGRectMake(self.lbTitle.x, self.lbTitle.y, self.lbTitle.width, titleH*2);
    } else {
        self.lbTitle.frame = CGRectMake(self.lbTitle.x, self.lbTitle.y, self.lbTitle.width, titleH);
    }
    self.lbSpeaker.frame = CGRectMake(self.lbSpeaker.x, self.lbTitle.y+self.lbTitle.height+5, self.lbSpeaker.width, 20);
    
    CGFloat lbSpeakerProfileContentH = [self.lbSpeakerProfileContent getLabelHeightWithMinHeight:20];
    self.lbSpeakerProfileContent.frame = CGRectMake(self.lbSpeakerProfileContent.x, self.lbSpeakerProfileContent.y, self.lbSpeakerProfileContent.width, lbSpeakerProfileContentH);
    
    self.lbProfileTitle.frame = CGRectMake(self.lbProfileTitle.x, self.lbSpeakerProfileContent.y+self.lbSpeakerProfileContent.height+12, self.lbProfileTitle.width, self.lbProfileTitle.height);
    
    CGFloat contentH = [self.lbProfileContent getLabelHeightWithMinHeight:20];
    CGFloat contentY = self.lbProfileTitle.y+self.lbProfileTitle.height+6;
    self.lbProfileContent.frame = CGRectMake(self.lbProfileContent.x, contentY, self.lbProfileContent.width, contentH);
    
    [self.scViewDetail setContentSize:(CGSizeMake(self.scViewDetail.width, self.lbProfileContent.y+self.lbProfileContent.height+20))];
}
/// 设置微课数据
-(void)setViewDataWithPracitce:(ModelPractice *)model
{
    [self setModelC:nil];
    [self setModelP:model];
    [self setTabType:(ZPlayTabBarViewTypePractice)];
    
    [self.imageIcon setImageURLStr:model.speech_img placeImage:[SkinManager getDefaultImage]];
    
    [self.lbTitle setText:model.title];
    [self.lbSpeaker setText:[NSString stringWithFormat:@"主讲人: %@", model.nickname]];
    
    [self.lbSpeakerProfileTitle setText:@"主讲人介绍"];
    [self.lbSpeakerProfileContent setText:model.person_synopsis];
    
    [self.lbProfileTitle setText:@"微课介绍"];
    [self.lbProfileContent setText:model.share_content];
    
    GCDMainBlock(^{
        [self setViewButtonFrameChange];
        [self setContentViewFrame];
    });
}
/// 设置订阅数据
-(void)setViewDataWithSubscribe:(ModelCurriculum *)model
{
    [self setModelP:nil];
    [self setModelC:model];
    [self setTabType:(ZPlayTabBarViewTypeSubscribe)];
    
    [self.imageIcon setImageURLStr:[Utils getMiddlePicture:model.audio_picture] placeImage:[SkinManager getDefaultImage]];
    
    [self.lbTitle setText:model.ctitle];
    [self.lbSpeaker setText:[NSString stringWithFormat:@"主讲人: %@", model.speaker_name]];
    
    [self.lbSpeakerProfileTitle setText:@"嘉宾介绍"];
    [self.lbSpeakerProfileContent setText:model.content];
    
    [self.lbProfileTitle setText:@" "];
    [self.lbProfileContent setText:@" "];
    
    GCDMainBlock(^{
        [self setViewButtonFrameChange];
        [self setContentViewFrame];
    });
}
/// 恢复到默认的偏移
-(void)setContentDefaultOffX
{
    [self.scMainView setContentOffset:(CGPointMake(0, 0))];
    [self.scViewDetail setContentOffset:(CGPointMake(0, 0))];
}
-(void)btnDetailEvent
{
    if (self.onDetailClick) {
        self.onDetailClick();
    }
}
-(void)btnMailEvent
{
    if (self.onMailClick) {
        self.onMailClick();
    }
}
-(void)btnPPTEvent
{
    if (self.onPPTClick) {
        self.onPPTClick();
    }
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
-(void)setViewTabType:(ZPlayTabBarViewType)type
{
    [self setTabType:type];
    GCDMainBlock(^{
        [self setViewButtonFrameChange];
    });
}
-(void)setViewButtonFrameChange
{
    [self.btnPPT setHidden:true];
    [self.btnMail setHidden:true];
    [self.btnDetail setHidden:true];
    switch (self.tabType) {
        case ZPlayTabBarViewTypePractice:
            if (self.modelP) {
                if (self.modelP.is_notice == 0) {
                    [self.btnPPT setHidden:false];
                    [self.btnMail setHidden:false];
                    self.btnMail.frame = CGRectMake(0, 0, self.topButtonH, self.topButtonH);
                    self.btnPPT.frame = CGRectMake(self.viewInfoTopButton.width-self.topButtonH, 0, self.topButtonH, self.topButtonH);
                }
            }
            break;
        default:
            if (self.modelC) {
                if (self.modelC.free_read == 1) {
                    [self.btnDetail setHidden:false];
                    self.btnDetail.frame = CGRectMake(0, 0, self.topButtonH, self.topButtonH);
                } else {
                    [self.btnPPT setHidden:false];
                    [self.btnMail setHidden:false];
                    [self.btnDetail setHidden:false];
                    self.btnDetail.frame = CGRectMake(0, 0, self.topButtonH, self.topButtonH);
                    self.btnMail.frame = CGRectMake(self.topButtonH+1, 0, self.topButtonH, self.topButtonH);
                    self.btnPPT.frame = CGRectMake(self.viewInfoTopButton.width-self.topButtonH, 0, self.topButtonH, self.topButtonH);
                }
            }
            break;
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
-(void)playTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onPlayClick) {
            self.onPlayClick(self.btnPlay.tag==1);
        }
    }
}
-(void)btnPlayClick:(UIButton *)sender
{
    if (self.onPlayClick) {
        self.onPlayClick(sender.tag==1);
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offsetIndex = abs((int)(scrollView.contentOffset.x/(scrollView.width-30)));
    if (offsetIndex == 0) {
        [self.viewPage1 setImage:[SkinManager getImageWithName:@"page_s"]];
        [self.viewPage2 setImage:[SkinManager getImageWithName:@"page"]];
    } else {
        [self.viewPage1 setImage:[SkinManager getImageWithName:@"page"]];
        [self.viewPage2 setImage:[SkinManager getImageWithName:@"page_s"]];
    }
    //GBLog(@"scrollView.contentOffset.x: %lf, scrollView.width: %lf, offsetIndex: %d", scrollView.contentOffset.x, scrollView.width, offsetIndex);
}

@end
