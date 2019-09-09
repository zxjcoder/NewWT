//
//  ZButton.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZButton.h"
#import "ClassCategory.h"
#import "ZImageView.h"

@interface ZButton()

///下载动画效果
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
///分享显示图标
@property (strong, nonatomic) ZImageView *imgIcon;
///分享标题
@property (strong, nonatomic) UILabel *lbTitle;

///选中文本
@property (strong, nonatomic) UILabel *lbText;
///举报分类
@property (assign, nonatomic) ZReportViewType rtype;

@end

@implementation ZButton

///初始化
-(id)initWithDownloadWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerDownloadInit];
    }
    return self;
}

///初始化
-(id)initWithShareType:(ZShareType)type
{
    self = [super init];
    if (self) {
        [self setType:type];
        [self innerShareInit];
    }
    return self;
}

///初始化
-(id)initWithReportType:(ZReportViewType)type
{
    self = [super init];
    if (self) {
        [self setRtype:type];
        [self innerCheckInit];
    }
    return self;
}
///初始化
-(id)initWithCount:(NSString *)count imageName:(NSString *)imageName
{
    self = [super init];
    if (self) {
        [self innerCountInit:count imageName:imageName];
    }
    return self;
}
///初始化
-(id)initWithText:(NSString *)text imageName:(NSString *)imageName
{
    self = [super init];
    if (self) {
        [self innerTextInit:text imageName:imageName];
    }
    return self;
}
///初始化
-(id)initWithText:(NSString *)text imageUrl:(NSString *)imageUrl
{
    self = [super init];
    if (self) {
        [self innerTextInit:text imageUrl:imageUrl];
    }
    return self;
}

-(NSString *)getText
{
    return self.lbText.text;
}

-(NSString *)getTitle
{
    return self.lbTitle.text;
}
-(void)innerCountInit:(NSString *)count imageName:(NSString *)imageName
{
    [self setUserInteractionEnabled:YES];
    
    self.imgIcon = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:imageName]];
    [self.imgIcon setUserInteractionEnabled:NO];
    [self addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:RGBCOLOR(192, 192, 192)];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Minimum_Size]];
    [self.lbTitle setText:count];
    [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self addSubview:self.lbTitle];
}
-(void)innerTextInit:(NSString *)text imageName:(NSString *)imageName
{
    [self setUserInteractionEnabled:YES];
    
    self.imgIcon = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:imageName]];
    [self.imgIcon setUserInteractionEnabled:NO];
    [self addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:TABLEVIEWCELL_TLINECOLOR];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Minimum_Size]];
    [self.lbTitle setText:text];
    [self addSubview:self.lbTitle];
}
-(void)innerTextInit:(NSString *)text imageUrl:(NSString *)imageUrl
{
    [self setUserInteractionEnabled:YES];
    
    self.imgIcon = [[ZImageView alloc] init];
    [self.imgIcon setImageURLStr:imageUrl placeImage:[SkinManager getPracticeImage]];
    [self.imgIcon setUserInteractionEnabled:NO];
    [self addSubview:self.imgIcon];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTitle setText:text];
    [self addSubview:self.lbTitle];
}
-(void)innerCheckInit
{
    [self setUserInteractionEnabled:YES];
    
    [self setTag:self.rtype];
    
    self.lbText = [[UILabel alloc] init];
    [self.lbText setTextColor:BLACKCOLOR1];
    [self.lbText setUserInteractionEnabled:NO];
    [self.lbText setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbText setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self addSubview:self.lbText];
    
    switch (self.rtype) {
        case ZReportViewTypeLJGG:
            [self.lbText setText:kJunkAds];
            break;
        case ZReportViewTypeBYSNR:
            [self.lbText setText:kNotFriendlyContent];
            break;
        case ZReportViewTypeWFXX:
            [self.lbText setText:kIllegalInformation];
            break;
        case ZReportViewTypeZZMG:
            [self.lbText setText:kPoliticallySensitive];
            break;
        case ZReportViewTypeOther:
            [self.lbText setText:kOther];
            break;
        default:
            break;
    }
    
}

-(void)innerDownloadInit
{
    [self setUserInteractionEnabled:YES];
    
    self.imgIcon = [[ZImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imgIcon];
    
    //创建出圆形贝塞尔曲线
    self.shapeLayer = [self createShapeLayerWithSize:self.width/2 lineWith:1.2 color:MAINCOLOR];
    //设置stroke起始点
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    
    [self.layer addSublayer:self.shapeLayer];
}
//创建圆环
-(CAShapeLayer *)createShapeLayerWithSize:(CGFloat)radius lineWith:(CGFloat)lineWidth color:(UIColor *)color
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                radius:radius-lineWidth/2
                                            startAngle:-M_PI/2
                                              endAngle:M_PI/180*270
                                             clockwise:YES].CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = lineWidth;
    layer.lineCap = @"round";
    
    return layer;
}
///设置下载图片
-(void)setDownloadImage:(NSString *)image
{
    [self.imgIcon setImage:[SkinManager getImageWithName:image]];
}
///设置下载进度
-(void)setDownloadProgress:(double)progress
{
    if (progress < 1 && progress > 0) {
        [self.shapeLayer setHidden:NO];
        self.shapeLayer.strokeEnd  = progress;
    } else {
        [self.shapeLayer setHidden:YES];
        self.shapeLayer.strokeEnd  = 0;
    }
    [self setNeedsDisplay];
}

-(void)innerShareInit
{
    [self setUserInteractionEnabled:YES];
    
    self.lbTitle = [[UILabel alloc] init];
    [self.lbTitle setTextColor:BLACKCOLOR1];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self addSubview:self.lbTitle];
    
    self.imgIcon = [[ZImageView alloc] init];
    [self.imgIcon setUserInteractionEnabled:NO];
    [self addSubview:self.imgIcon];
    
    [self innerShareData];
}

-(void)innerShareData
{
    switch (self.type) {
        case ZShareTypeWeChat:
        {
            [self.lbTitle setText:kCWeChatFriend];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_weixin"]];
            break;
        }
        case ZShareTypeWeChatCircle:
        {
            [self.lbTitle setText:kCWeChatTimeline];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_pengyouquan"]];
            break;
        }
        case ZShareTypeQQ:
        {
            [self.lbTitle setText:kCQQFriend];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_qq"]];
            break;
        }
        case ZShareTypeQZone:
        {
            [self.lbTitle setText:kCQZone];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_qzone"]];
            break;
        }
        case ZShareTypeReport:
        {
            [self.lbTitle setText:kReport];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_jubao"]];
            break;
        }
        case ZShareTypeBlackList:
        {
            [self.lbTitle setText:kJoinBlacklist];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_heimingdan"]];
            break;
        }
        case ZShareTypeEdit:
        {
            [self.lbTitle setText:kEdit];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_bianjidaan"]];
            break;
        }
        case ZShareTypeDelete:
        {
            [self.lbTitle setText:kDelete];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_delete"]];
            break;
        }
        case ZShareTypeEditAnswer:
        {
            [self.lbTitle setText:kEditAnswer];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_bianjidaan"]];
            break;
        }
        case ZShareTypeDeleteAnswer:
        {
            [self.lbTitle setText:kDeleteAnswer];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_delete"]];
            break;
        }
        case ZShareTypeEditQuestion:
        {
            [self.lbTitle setText:kEditQuestion];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_bianjidaan"]];
            break;
        }
        case ZShareTypeDeleteQuestion:
        {
            [self.lbTitle setText:kDeleteQuestion];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_delete"]];
            break;
        }
        case ZShareTypeDownload:
        {
            [self.lbTitle setText:kDownload];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_download"]];
            break;
        }
        case ZShareTypeCollection:
        {
            [self.lbTitle setText:kCollection];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_shoucang"]];
            break;
        }
        case ZShareTypeYouDao:
        {
            [self.lbTitle setText:kYouDaoYunBiJi];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_youdao"]];
            break;
        }
        case ZShareTypeYinXiang:
        {
            [self.lbTitle setText:kYinXiangBiJi];
            [self.imgIcon setImage:[SkinManager getImageWithName:@"btn_share_yinxiang"]];
            break;
        }
        default: break;
    }
}

-(void)setButtonText:(NSString *)text
{
    if (self.lbText) {
        [self.lbText setText:text];
    }
    if (self.lbTitle) {
        [self.lbTitle setText:text];
    }
}
///设置按钮文字颜色
-(void)setButtonTextColor:(UIColor *)color
{
    if (self.lbTitle) {
        [self.lbTitle setTextColor:color];
    }
}

///设置按钮文字大小
-(void)setButtonTextFontSize:(CGFloat)size
{
    if (self.lbTitle) {
        [self.lbTitle setFont:[ZFont systemFontOfSize:size]];
    }
}

-(void)setButtonImageName:(NSString *)imageName
{
    [self.imgIcon setImage:[SkinManager getImageWithName:imageName]];
}

-(void)dealloc
{
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_imgIcon);
    
    OBJC_RELEASE(_lbText);
    OBJC_RELEASE(_model);
    
    OBJC_RELEASE(_shapeLayer);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setViewFrame];
}

-(void)setViewFrame
{
    if (self.imgIcon && self.imgIcon.frame.size.width==0) {
        CGFloat imgSize = 50;
        [self.imgIcon setFrame:CGRectMake(self.width/2-imgSize/2, 0, imgSize, imgSize)];
    }
    if (self.lbTitle && self.lbTitle.frame.size.width==0) {
        [self.lbTitle setFrame:CGRectMake(0, self.height-25, self.width, 25)];
    }
    if (self.lbText && self.lbText.frame.size.width==0) {
        CGFloat lbH = 22;
        [self.lbText setFrame:CGRectMake(0, self.height/2-lbH/2, self.width, lbH)];
    }
}
-(void)setIconFrame:(CGRect)frame
{
    [self setFrame:frame];
    
    CGFloat imgSize = self.width-10;
    [self.imgIcon setFrame:CGRectMake(5, 5, imgSize, imgSize)];
    
    [self.lbTitle setFrame:CGRectMake(0, self.height-25, self.width, 25)];
}
-(void)setIconRoundNoBorder
{
    [self.imgIcon setViewRoundNoBorder];
}
-(void)setBtnFrame:(CGRect)frame
{
    [self setFrame:frame];
    
    CGFloat imgSize = 25;
    [self.imgIcon setFrame:CGRectMake(self.width/2-imgSize/2, 0, imgSize, imgSize)];
    
    [self.lbTitle setFrame:CGRectMake(0, self.height-25, self.width, 25)];
}
-(void)setButtonFrame:(CGRect)frame
{
    [self setFrame:frame];
    CGFloat imgSize = 15;
    [self.imgIcon setFrame:CGRectMake(0, self.height/2-imgSize/2, imgSize, imgSize)];
    [self.lbTitle setFrame:CGRectMake(imgSize+5, self.height/2-10, self.width-imgSize-5, 20)];
}
-(void)setBtnPoint:(CGPoint)point
{
    [self setFrame:CGRectMake(point.x, point.y, kButtonShareW, kButtonShareH)];
    [self setViewFrame];
}

@end
