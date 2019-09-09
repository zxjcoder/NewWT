//
//  ZUserNoticeTVC.m
//  PlaneCircle
//
//  Created by Daniel on 7/11/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserNoticeTVC.h"
#import "ZCalculateLabel.h"
#import "ZImageView.h"
#import "ZLabel.h"

@interface ZUserNoticeTVC()

///内容区域
@property (strong, nonatomic) ZView *viewContent;
///通知图片
@property (strong, nonatomic) ZImageView *imageIcon;
///通知标题
@property (strong, nonatomic) ZLabel *lbTitle;
///通知内容
@property (strong, nonatomic) ZLabel *lbContent;
///发布时间
@property (strong, nonatomic) ZLabel *lbCreateTime;

///音频区域
@property (strong, nonatomic) ZView *viewAudio;
///音频图片
@property (strong, nonatomic) ZImageView *imageAudioIcon;
///音频遮罩层
@property (strong, nonatomic) ZView *viewAudioIconMask;
///音频遮罩层
@property (strong, nonatomic) ZImageView *imageAudioIconMask;
///音频标题
@property (strong, nonatomic) ZLabel *lbAudioTitle;
///音频主讲人
@property (strong, nonatomic) ZLabel *lbAudioSpeaker;

@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentItemX;
@property (assign, nonatomic) CGFloat contentItemW;
@property (assign, nonatomic) CGRect lbContentFrame;
@property (assign, nonatomic) CGRect audioViewFrame;

@property (strong, nonatomic) ModelNotice *modelN;

@end

@implementation ZUserNoticeTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.cellH = [ZUserNoticeTVC getH];
    self.space = 20;
    [self.viewMain setBackgroundColor:WHITECOLOR];
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.contentFrame = CGRectMake(self.space, 10, self.cellW-self.space*2, self.cellH);
    self.viewContent = [[ZView alloc] initWithFrame:(self.contentFrame)];
    [self.viewContent setViewRound:8];
    [self.viewContent setBackgroundColor:COLORVIEWBACKCOLOR3];
    [self.viewMain addSubview:self.viewContent];
    
    self.contentItemX = 16;
    self.contentItemW = self.viewContent.width-self.contentItemX*2;
    self.imageIcon = [[ZImageView alloc] initWithFrame:(CGRectMake(self.contentItemX, 16, 18, 18))];
    [self.viewContent addSubview:self.imageIcon];
    
    CGFloat titleX = self.imageIcon.x+self.imageIcon.width+2;
    self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(titleX, 14, 200, 22))];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbTitle];
    
    CGFloat timeY = self.imageIcon.y+self.imageIcon.height+5;
    self.lbCreateTime = [[ZLabel alloc] initWithFrame:(CGRectMake(self.contentItemX, timeY, self.contentItemW, 18))];
    [self.lbCreateTime setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.lbCreateTime setTextColor:COLORTEXT3];
    [self.viewContent addSubview:self.lbCreateTime];
    
    CGFloat lbContentY = self.lbCreateTime.y+self.lbCreateTime.height+10;
    self.lbContentFrame = CGRectMake(self.contentItemX, lbContentY, self.contentItemW, 20);
    self.lbContent = [[ZLabel alloc] initWithFrame:(self.lbContentFrame)];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbContent setTextColor:COLORTEXT1];
    [self.lbContent setNumberOfLines:0];
    [self.viewContent addSubview:self.lbContent];
    
    self.audioViewFrame = CGRectMake(self.contentItemX, self.lbContent.y+self.lbContent.height+10, self.contentItemW, 66);
    self.viewAudio = [[ZView alloc] initWithFrame:(self.audioViewFrame)];
    [self.viewAudio setBackgroundColor:WHITECOLOR];
    [self.viewAudio setViewRound:8];
    [self.viewAudio setHidden:true];
    [self.viewAudio setUserInteractionEnabled:true];
    [self.viewContent addSubview:self.viewAudio];
    
    self.imageAudioIcon = [[ZImageView alloc] initWithFrame:(CGRectMake(11, 11, 44, 44))];
    [self.imageAudioIcon setViewRound:4];
    [self.imageAudioIcon setUserInteractionEnabled:false];
    [self.viewAudio addSubview:self.imageAudioIcon];
    
    self.viewAudioIconMask = [[ZView alloc] initWithFrame:(self.imageAudioIcon.frame)];
    [self.viewAudioIconMask setViewRound:4];
    [self.viewAudioIconMask setUserInteractionEnabled:false];
    [self.viewAudioIconMask setBackgroundColor:RGBCOLORA(0, 0, 0, 0.3)];
    [self.viewAudio addSubview:self.viewAudioIconMask];
    
    self.imageAudioIconMask = [[ZImageView alloc] initWithFrame:(CGRectMake(18, 16, 9.62, 11.84))];
    [self.imageAudioIconMask setUserInteractionEnabled:false];
    [self.imageAudioIconMask setImageName:@"play_ing"];
    [self.viewAudioIconMask addSubview:self.imageAudioIconMask];
    [self.viewAudio sendSubviewToBack:self.imageAudioIcon];
    
    CGFloat audiolbX = self.imageAudioIcon.x+self.imageAudioIcon.width+10;
    CGFloat audiolbW = self.viewAudio.width-audiolbX-10;
    self.lbAudioTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(audiolbX, 10, audiolbW, 24))];
    [self.lbAudioTitle setTextColor:COLORTEXT1];
    [self.lbAudioTitle setNumberOfLines:1];
    [self.lbAudioTitle setUserInteractionEnabled:false];
    [self.lbAudioTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewAudio addSubview:self.lbAudioTitle];
    
    self.lbAudioSpeaker = [[ZLabel alloc] initWithFrame:(CGRectMake(audiolbX, self.viewAudio.height-12-18, audiolbW, 18))];
    [self.lbAudioSpeaker setTextColor:COLORTEXT3];
    [self.lbAudioSpeaker setNumberOfLines:1];
    [self.lbAudioSpeaker setUserInteractionEnabled:false];
    [self.lbAudioSpeaker setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [self.viewAudio addSubview:self.lbAudioSpeaker];
    
    UITapGestureRecognizer *audioTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewAudioTap:)];
    [self.viewAudio addGestureRecognizer:audioTapGesture];
}
-(void)viewAudioTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onCourseEvent) {
            self.onCourseEvent(self.modelN.modelCourse);
        }
    }
}
-(void)setViewFrame
{
    CGRect lbContentFrame = self.lbContentFrame;
    lbContentFrame.size.height = [self.lbContent getLabelHeightWithMinHeight:20];
    [self.lbContent setFrame:lbContentFrame];
    
    switch (self.modelN.type) {
        case ZNoticeTypeCourse:
        {
            if (self.modelN.modelCourse) {
                CGRect viewAudioFrame = self.audioViewFrame;
                viewAudioFrame.origin.y = self.lbContent.y+self.lbContent.height+10;
                [self.viewAudio setFrame:viewAudioFrame];
                
                CGRect contentFrame = self.contentFrame;
                contentFrame.size.height = self.viewAudio.y+self.viewAudio.height+15;
                [self.viewContent setFrame:contentFrame];
                
            } else {
                CGRect contentFrame = self.contentFrame;
                contentFrame.size.height = self.lbContent.y+self.lbContent.height+15;
                [self.viewContent setFrame:contentFrame];
            }
            break;
        }
        default:
        {
            CGRect contentFrame = self.contentFrame;
            contentFrame.size.height = self.lbContent.y+self.lbContent.height+15;
            [self.viewContent setFrame:contentFrame];
            break;
        }
    }
    self.cellH = self.viewContent.y+self.viewContent.height+2;
    [self.viewMain setFrame:[self getMainFrame]];
}
/// 设置是否播放状态
-(void)setAudioPlayStatus:(BOOL)isPlay
{
    if (isPlay) {
        [self.imageAudioIconMask setImageName:@"play_stop2"];
    } else {
        [self.imageAudioIconMask setImageName:@"play_ing"];
    }
}
-(CGFloat)setCellDataWithModel:(ModelNotice *)model
{
    [self setModelN:model];
    if (model) {
        switch (model.type) {
            case ZNoticeTypeCourse:
            {
                [self.imageIcon setImageName:@"update"];
                [self.lbTitle setTextColor:RGBCOLOR(79, 125, 234)];
                [self.lbTitle setText:@"课程更新"];
                if (model.modelCourse) {
                    [self.imageAudioIcon setImageURLStr:model.modelCourse.icon placeImage:[SkinManager getDefaultImage]];
                    [self.lbAudioTitle setText:model.modelCourse.title];
                    if (model.modelCourse.stitle.length > 0) {
                        [self.lbAudioSpeaker setText:[NSString stringWithFormat:@"%@ %@", model.modelCourse.speaker, model.modelCourse.stitle]];
                    } else {
                        [self.lbAudioSpeaker setText:model.modelCourse.speaker];
                    }
                    [self.viewAudio setHidden:false];
                } else {
                    [self.viewAudio setHidden:true];
                }
                break;
            }
            default:
                [self.viewAudio setHidden:true];
                [self.imageIcon setImageName:@"system"];
                [self.lbTitle setTextColor:RGBCOLOR(37, 165, 232)];
                [self.lbTitle setText:@"系统消息"];
                break;
        }
        [self.lbCreateTime setText:model.createtime];
        [self.lbContent setText:model.content];
    }
    [self setViewFrame];
    
    return self.cellH;
}

-(void)setViewNil
{
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}
+(CGFloat)getH
{
    return 60;
}

@end
