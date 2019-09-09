//
//  ZPlayObjectInfoView.m
//  PlaneLive
//
//  Created by Daniel on 11/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPlayObjectInfoView.h"
#import "ZLabel.h"
#import "ZCalculateLabel.h"

#define viewSpace APP_FRAME_WIDTH/320

@interface ZPlayObjectInfoView()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollViewMain;
/// 图片
@property (strong, nonatomic) ZView *viewImage;
/// 实务内容
@property (strong, nonatomic) UIScrollView *viewPractice;
/// 订阅内容
@property (strong, nonatomic) UIScrollView *viewSubscribe;
/// 标题
@property (strong, nonatomic) ZLabel *lbTitle;
/// 时间
@property (strong, nonatomic) ZLabel *lbTime;
/// 实务图片
@property (strong, nonatomic) ZImageView *imgIcon;
/// 主讲人
@property (strong, nonatomic) ZLabel *lbSpeakerName;
/// 主讲人简介
@property (strong, nonatomic) ZLabel *lbSpeakerDesc;
/// 主讲人简介分割线
@property (strong, nonatomic) UIImageView *imgSpeakerDesc;
/// 主讲人简介内容
@property (strong, nonatomic) ZLabel *lbSpeakerDescContent;
/// 实务简介
@property (strong, nonatomic) ZLabel *lbPracitceDesc;
/// 实务简介内容
@property (strong, nonatomic) ZLabel *lbPracitceDescContent;
/// 每期课程
@property (strong, nonatomic) ZLabel *lbEachCourse;
/// 每期课程描述
@property (strong, nonatomic) ZLabel *lbEachCourseContent;

@property (strong, nonatomic) UIView *viewPoint1;
@property (strong, nonatomic) UIView *viewPoint2;

@property (assign, nonatomic) CGRect titleFrame;

@end

@implementation ZPlayObjectInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    self.scrollViewMain = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self.scrollViewMain setOpaque:NO];
    [self.scrollViewMain setDelegate:self];
    [self.scrollViewMain setPagingEnabled:YES];
    [self.scrollViewMain setBounces:NO];
    [self.scrollViewMain setScrollEnabled:YES];
    [self.scrollViewMain setShowsHorizontalScrollIndicator:NO];
    [self.scrollViewMain setShowsVerticalScrollIndicator:NO];
    [self.scrollViewMain setScrollsToTop:NO];
    [self.scrollViewMain setBackgroundColor:CLEARCOLOR];
    [self.scrollViewMain setContentSize:CGSizeMake(self.scrollViewMain.width*2, self.scrollViewMain.height)];
    [self addSubview:self.scrollViewMain];
    
    CGFloat pointW = 20;
    self.viewPoint1 = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-pointW-5, self.height-5, pointW, 2)];
    [self.viewPoint1 setBackgroundColor:WHITECOLOR];
    [self addSubview:self.viewPoint1];
    
    self.viewPoint2 = [[UIView alloc] initWithFrame:CGRectMake(self.width/2+5, self.height-5, pointW, 2)];
    [self.viewPoint2 setBackgroundColor:RGBCOLOR(159, 159, 159)];
    [self addSubview:self.viewPoint2];
    
    [self createImageView];
    
    [self createPracticeView];
    
    [self createSubscribeView];
    
    [self setImageViewFrame];
    
    [self setPracitceContentViewFrame];
    
    [self setSubscribeContentViewFrame];
}

-(void)createImageView
{
    self.viewImage = [[ZView alloc] initWithFrame:self.scrollViewMain.bounds];
    [self.viewImage setBackgroundColor:CLEARCOLOR];
    [self.scrollViewMain addSubview:self.viewImage];
    
    CGFloat titleSpace = viewSpace*3;
    self.titleFrame = CGRectMake(kSizeSpace, titleSpace, self.width-kSizeSpace*2, 20);
    self.lbTitle = [[ZLabel alloc] initWithFrame:self.titleFrame];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTitle setNumberOfLines:2];
    [self.viewImage addSubview:self.lbTitle];
    
    self.lbSpeakerName = [[ZLabel alloc] init];
    [self.lbSpeakerName setTextColor:WHITECOLOR];
    [self.lbSpeakerName setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbSpeakerName setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbSpeakerName setNumberOfLines:1];
    [self.viewImage addSubview:self.lbSpeakerName];
    
    self.lbTime = [[ZLabel alloc] init];
    [self.lbTime setTextColor:WHITECOLOR];
    [self.lbTime setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbTime setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbTime setNumberOfLines:1];
    [self.viewImage addSubview:self.lbTime];
    
    self.imgIcon = [[ZImageView alloc] init];
    [self.imgIcon.layer setMasksToBounds:YES];
    self.imgIcon.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.imgIcon.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.imgIcon.layer.shadowOpacity = 0.58;//不透明度
    self.imgIcon.layer.shadowRadius = 10.0;//半径
    [self.imgIcon setViewRound:10 borderWidth:2 borderColor:WHITECOLOR];
    [self.viewImage addSubview:self.imgIcon];
}
-(void)createPracticeView
{
    self.viewPractice = [[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollViewMain.width, 0, self.scrollViewMain.width, self.scrollViewMain.height)];
    [self.viewPractice setHidden:YES];
    [self.viewPractice setOpaque:NO];
    [self.viewPractice setPagingEnabled:NO];
    [self.viewPractice setBounces:NO];
    [self.viewPractice setScrollEnabled:YES];
    [self.viewPractice setShowsHorizontalScrollIndicator:NO];
    [self.viewPractice setShowsVerticalScrollIndicator:NO];
    [self.viewPractice setScrollsToTop:NO];
    [self.viewPractice setBackgroundColor:CLEARCOLOR];
    [self.scrollViewMain addSubview:self.viewPractice];
    
    self.lbSpeakerDesc = [[ZLabel alloc] init];
    [self.lbSpeakerDesc setTextColor:WHITECOLOR];
    [self.lbSpeakerDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbSpeakerDesc setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbSpeakerDesc setNumberOfLines:1];
    [self.lbSpeakerDesc setText:kSpeakerIntroduction];
    [self.viewPractice addSubview:self.lbSpeakerDesc];
    
    self.lbSpeakerDescContent = [[ZLabel alloc] init];
    [self.lbSpeakerDescContent setTextColor:WHITECOLOR];
    [self.lbSpeakerDescContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbSpeakerDescContent setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbSpeakerDescContent setNumberOfLines:0];
    [self.viewPractice addSubview:self.lbSpeakerDescContent];
    
    self.imgSpeakerDesc = [UIImageView getTLineView];
    [self.viewPractice addSubview:self.imgSpeakerDesc];
    
    self.lbPracitceDesc = [[ZLabel alloc] init];
    [self.lbPracitceDesc setTextColor:WHITECOLOR];
    [self.lbPracitceDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbPracitceDesc setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbPracitceDesc setNumberOfLines:1];
    [self.lbPracitceDesc setText:kPracticalIntroduction];
    [self.viewPractice addSubview:self.lbPracitceDesc];
    
    self.lbPracitceDescContent = [[ZLabel alloc] init];
    [self.lbPracitceDescContent setTextColor:WHITECOLOR];
    [self.lbPracitceDescContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbPracitceDescContent setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbPracitceDescContent setNumberOfLines:0];
    [self.viewPractice addSubview:self.lbPracitceDescContent];
}
-(void)createSubscribeView
{
    self.viewSubscribe = [[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollViewMain.width, 0, self.scrollViewMain.width, self.scrollViewMain.height)];
    [self.viewSubscribe setHidden:YES];
    [self.viewSubscribe setOpaque:NO];
    [self.viewSubscribe setPagingEnabled:NO];
    [self.viewSubscribe setBounces:NO];
    [self.viewSubscribe setScrollEnabled:YES];
    [self.viewSubscribe setShowsHorizontalScrollIndicator:NO];
    [self.viewSubscribe setShowsVerticalScrollIndicator:NO];
    [self.viewSubscribe setScrollsToTop:NO];
    [self.viewSubscribe setBackgroundColor:CLEARCOLOR];
    [self.scrollViewMain addSubview:self.viewSubscribe];
    
    self.lbEachCourse = [[ZLabel alloc] init];
    [self.lbEachCourse setTextColor:WHITECOLOR];
    [self.lbEachCourse setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbEachCourse setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbEachCourse setNumberOfLines:1];
    [self.lbEachCourse setText:kEachCourseIntroduction];
    [self.viewSubscribe addSubview:self.lbEachCourse];
    
    self.lbEachCourseContent = [[ZLabel alloc] init];
    [self.lbEachCourseContent setTextColor:WHITECOLOR];
    [self.lbEachCourseContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbEachCourseContent setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbEachCourseContent setNumberOfLines:0];
    [self.viewSubscribe addSubview:self.lbEachCourseContent];
}
-(void)setImageViewFrame
{
    CGRect titleFrame = self.titleFrame;
    CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    titleFrame.size.height = titleMaxH;
    [self.lbTitle setFrame:titleFrame];
    
    CGFloat lbW = self.width-kSizeSpace*2;
    CGFloat nameY = self.lbTitle.y+self.lbTitle.height+kSize8;
    [self.lbSpeakerName setFrame:CGRectMake(kSizeSpace, nameY, lbW, 20)];
    
    [self.lbTime setFrame:CGRectMake(kSizeSpace, self.lbSpeakerName.y+self.lbSpeakerName.height+kSize3, lbW, 20)];
    
    CGFloat iconSize = 150;
    CGFloat iconX = self.width/2-iconSize/2;
    CGFloat iconY = self.lbTime.y+self.lbTime.height+(self.height-self.lbTime.y-self.lbTime.height-10)/2-iconSize/2;
    [self.imgIcon setFrame:CGRectMake(iconX, iconY, iconSize, iconSize)];
}
-(void)setPracitceContentViewFrame
{
    CGFloat lbX = kSizeSpace;
    CGFloat lbW = self.width-lbX*2;
    [self.lbSpeakerDesc setFrame:CGRectMake(lbX, 5, lbW, 20)];
    
    CGFloat sdContentY = self.lbSpeakerDesc.y+self.lbSpeakerDesc.height+kSize8;
    CGRect sdContentFrame = CGRectMake(lbX, sdContentY, lbW, 20);
    [self.lbSpeakerDescContent setFrame:sdContentFrame];
    CGFloat sdContentH = [self.lbSpeakerDescContent getLabelHeightWithMinHeight:20];
    sdContentFrame.size.height = sdContentH;
    [self.lbSpeakerDescContent setFrame:sdContentFrame];
    
    [self.imgSpeakerDesc setFrame:CGRectMake(lbX, sdContentY+sdContentH+kSize8, lbW, kLineHeight)];
    
    [self.lbPracitceDesc setFrame:CGRectMake(lbX, self.imgSpeakerDesc.y+self.imgSpeakerDesc.height+kSize8, lbW, 20)];
    
    CGFloat pdContentY = self.lbPracitceDesc.y+self.lbPracitceDesc.height+kSize8;
    CGRect pdContentFrame = CGRectMake(lbX, pdContentY, lbW, 20);
    [self.lbPracitceDescContent setFrame:pdContentFrame];
    CGFloat pdContentH = [self.lbPracitceDescContent getLabelHeightWithMinHeight:20];
    pdContentFrame.size.height = pdContentH;
    [self.lbPracitceDescContent setFrame:pdContentFrame];
    
    [self.viewPractice setContentSize:CGSizeMake(self.width, pdContentY+pdContentH)];
}
-(void)setSubscribeContentViewFrame
{
    CGFloat lbX = kSizeSpace;
    CGFloat lbW = self.width-lbX*2;
    [self.lbEachCourse setFrame:CGRectMake(lbX, 5, lbW, 20)];
    
    CGFloat ecContentY = self.lbEachCourse.y+self.lbEachCourse.height+kSize8;
    CGRect ecContentFrame = CGRectMake(lbX, ecContentY, lbW, 20);
    [self.lbEachCourseContent setFrame:ecContentFrame];
    CGFloat ecContentH = [self.lbEachCourseContent getLabelHeightWithMinHeight:20];
    ecContentFrame.size.height = ecContentH;
    [self.lbEachCourseContent setFrame:ecContentFrame];
    
    [self.viewPractice setContentSize:CGSizeMake(self.width, ecContentY+ecContentH)];
}
-(void)dealloc
{
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_imgSpeakerDesc);
    OBJC_RELEASE(_lbTime);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbEachCourse);
    OBJC_RELEASE(_lbSpeakerDesc);
    OBJC_RELEASE(_lbSpeakerName);
    OBJC_RELEASE(_lbPracitceDesc);
    OBJC_RELEASE(_lbEachCourseContent);
    OBJC_RELEASE(_lbSpeakerDescContent);
    OBJC_RELEASE(_lbPracitceDescContent);
    OBJC_RELEASE(_viewImage);
    OBJC_RELEASE(_viewPoint1);
    OBJC_RELEASE(_viewPoint2);
    OBJC_RELEASE(_viewPractice);
    OBJC_RELEASE(_viewSubscribe);
    OBJC_RELEASE(_scrollViewMain);
    OBJC_RELEASE(_onBackgroundChange);
}
-(void)setViewDataWithPracitce:(ModelPractice *)model
{
    ZWEAKSELF
    ///设置背景模糊
    [self.imgIcon setImageURLStr:model.speech_img completed:^(UIImage *image) {
        if (weakSelf.onBackgroundChange) {
            weakSelf.onBackgroundChange(image);
        }
    }];
    
    [self.lbTitle setText:model.title];
    
    [self.lbSpeakerName setText:[NSString stringWithFormat:@"- %@: %@ -", kSpeaker, model.nickname]];
    [self.lbTime setText:model.create_time];
    [self.lbSpeakerDescContent setText:model.person_synopsis];
    [self.lbPracitceDescContent setText:model.share_content];
    
    [self.viewSubscribe setHidden:YES];
    [self.viewPractice setHidden:NO];
    
    [self setPracitceContentViewFrame];
}

-(void)setViewDataWithSubscribe:(ModelCurriculum *)model
{
    ZWEAKSELF
    ///设置背景模糊
    [self.imgIcon setImageURLStr:model.audio_picture completed:^(UIImage *image) {
        if (weakSelf.onBackgroundChange) {
            weakSelf.onBackgroundChange(image);
        }
    }];
    
    [self.lbTitle setText:model.title];
    
    [self.lbSpeakerName setText:[NSString stringWithFormat:@"- %@: %@ -", kSpeaker, model.speaker_name]];
    [self.lbTime setText:model.create_time];
    [self.lbEachCourseContent setText:model.content];
    
    [self.viewSubscribe setHidden:NO];
    [self.viewPractice setHidden:YES];
    
    [self setSubscribeContentViewFrame];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    if (offsetIndex == 0) {
        [self.viewPoint1 setBackgroundColor:WHITECOLOR];
        [self.viewPoint2 setBackgroundColor:RGBCOLOR(158, 158, 158)];
    } else {
        [self.viewPoint2 setBackgroundColor:WHITECOLOR];
        [self.viewPoint1 setBackgroundColor:RGBCOLOR(158, 158, 158)];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alpha1 = (self.width-scrollView.contentOffset.x)/self.width;
    CGFloat alpha2 = (scrollView.contentOffset.x)/self.width;
    
    [self.viewImage setAlpha:alpha1];
    
    [self.viewPractice setAlpha:alpha2];
    [self.viewSubscribe setAlpha:alpha2];
}

@end




