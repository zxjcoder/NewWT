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
#import "ZButton.h"
#import "Utils.h"
#import "ZScrollView.h"

@interface ZPlayObjectInfoView()<UIScrollViewDelegate>

@property (strong, nonatomic) ZScrollView *scrollViewMain;
/// 图片
@property (strong, nonatomic) ZView *viewImage;
/// 实务内容
@property (strong, nonatomic) ZScrollView *viewPractice;
/// 订阅内容
@property (strong, nonatomic) ZScrollView *viewSubscribe;
/// 标题
@property (strong, nonatomic) ZLabel *lbTitle;
/// 实务图片
@property (strong, nonatomic) ZImageView *imgIcon;
/// 主讲人
@property (strong, nonatomic) ZLabel *lbSpeakerName;
/// 主讲人单位
@property (strong, nonatomic) ZLabel *lbSpeakerCompany;
/// 主讲人简介
@property (strong, nonatomic) ZLabel *lbSpeakerDesc;
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

@property (strong, nonatomic) UIView *viewButton;
@property (strong, nonatomic) UIView *viewButtonSpace;
@property (strong, nonatomic) ZButton *btnText;
@property (strong, nonatomic) ZButton *btnPPT;

@property (assign, nonatomic) CGRect titleFrame;
@property (assign, nonatomic) CGFloat buttonViewSpace;

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
    if (!self.scrollViewMain) {
        self.scrollViewMain = [[ZScrollView alloc] initWithFrame:self.bounds];
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
    }
    CGFloat pointW = 20;
    self.buttonViewSpace = 20*kViewSace;
    if (!self.viewPoint1) {
        self.viewPoint1 = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-pointW-5, self.height-self.buttonViewSpace, pointW, 2)];
        [self.viewPoint1 setBackgroundColor:COLORCONTENT1];
        [self addSubview:self.viewPoint1];
    }
    if (!self.viewPoint2) {
        self.viewPoint2 = [[UIView alloc] initWithFrame:CGRectMake(self.width/2+5, self.height-self.buttonViewSpace, pointW, 2)];
        [self.viewPoint2 setBackgroundColor:COLORVIEWBACKCOLOR3];
        [self addSubview:self.viewPoint2];
    }
    [self createImageView];
    
    [self createPracticeView];
    
    [self createSubscribeView];
    
    [self setImageViewFrame];
    [self setPracitceContentViewFrame];
    [self setSubscribeContentViewFrame];
}

-(void)createImageView
{
    if (!self.viewImage) {
        self.viewImage = [[ZView alloc] initWithFrame:self.scrollViewMain.bounds];
        [self.viewImage setBackgroundColor:CLEARCOLOR];
        [self.scrollViewMain addSubview:self.viewImage];
    }
    /// 处理标题和顶部的间隔
    CGFloat titleSpace = 20*kViewSace;
    CGFloat spaceMarge = 20;
    self.titleFrame = CGRectMake(spaceMarge, titleSpace, self.width-spaceMarge*2, 20);
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] initWithFrame:self.titleFrame];
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Huge_Size]];
        [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        [self.lbTitle setNumberOfLines:2];
        [self.viewImage addSubview:self.lbTitle];
    }
    if (!self.lbSpeakerName) {
        self.lbSpeakerName = [[ZLabel alloc] init];
        [self.lbSpeakerName setTextColor:COLORTEXT2];
        [self.lbSpeakerName setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbSpeakerName setTextAlignment:(NSTextAlignmentCenter)];
        [self.lbSpeakerName setNumberOfLines:1];
        [self.viewImage addSubview:self.lbSpeakerName];
    }
    if (!self.lbSpeakerCompany) {
        self.lbSpeakerCompany = [[ZLabel alloc] init];
        [self.lbSpeakerCompany setTextColor:COLORTEXT3];
        [self.lbSpeakerCompany setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbSpeakerCompany setTextAlignment:(NSTextAlignmentCenter)];
        [self.lbSpeakerCompany setNumberOfLines:1];
        [self.viewImage addSubview:self.lbSpeakerCompany];
    }
    if (!self.imgIcon) {
        self.imgIcon = [[ZImageView alloc] init];
        [self.imgIcon.layer setMasksToBounds:YES];
        [self.imgIcon setViewRound:10 borderWidth:0 borderColor:CLEARCOLOR];
        [self.viewImage addSubview:self.imgIcon];
    }
    if (!self.viewButton) {
        self.viewButton = [[UIView alloc] init];
        [self.viewImage addSubview:self.viewButton];
    }
    if (!self.viewButtonSpace) {
        self.viewButtonSpace = [[UIView alloc] init];
        [self.viewButton addSubview:self.viewButtonSpace];
    }
    if (!self.btnText) {
        self.btnText = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnText setTitleColor:COLORTEXT1 forState:(UIControlStateNormal)];
        [[self.btnText titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnText addTarget:self action:@selector(btnTextClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewButton addSubview:self.btnText];
    }
    if (!self.btnPPT) {
        self.btnPPT = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPPT setTitleColor:COLORTEXT1 forState:(UIControlStateNormal)];
        [[self.btnPPT titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnPPT addTarget:self action:@selector(btnPPTClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewButton addSubview:self.btnPPT];
    }
    [self.btnText setTitle:kCourseware forState:(UIControlStateNormal)];
    [self.btnPPT setTitle:@"PPT" forState:(UIControlStateNormal)];
}
-(void)createPracticeView
{
    if (!self.viewPractice) {
        self.viewPractice = [[ZScrollView alloc] initWithFrame:CGRectMake(self.scrollViewMain.width, 0, self.scrollViewMain.width, self.scrollViewMain.height-self.buttonViewSpace-5)];
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
    }
    if (!self.lbSpeakerDesc) {
        self.lbSpeakerDesc = [[ZLabel alloc] init];
        [self.lbSpeakerDesc setTextColor:COLORTEXT1];
        [self.lbSpeakerDesc setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.lbSpeakerDesc setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbSpeakerDesc setNumberOfLines:1];
        [self.lbSpeakerDesc setText:kSpeakerIntroduction];
        [self.viewPractice addSubview:self.lbSpeakerDesc];
    }
    if (!self.lbSpeakerDescContent) {
        self.lbSpeakerDescContent = [[ZLabel alloc] init];
        [self.lbSpeakerDescContent setTextColor:COLORTEXT2];
        [self.lbSpeakerDescContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.lbSpeakerDescContent setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbSpeakerDescContent setNumberOfLines:0];
        [self.viewPractice addSubview:self.lbSpeakerDescContent];
    }
    if (!self.lbPracitceDesc) {
        self.lbPracitceDesc = [[ZLabel alloc] init];
        [self.lbPracitceDesc setTextColor:COLORTEXT1];
        [self.lbPracitceDesc setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.lbPracitceDesc setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbPracitceDesc setNumberOfLines:1];
        [self.lbPracitceDesc setText:kPracticalIntroduction];
        [self.viewPractice addSubview:self.lbPracitceDesc];
    }
    if (!self.lbPracitceDescContent) {
        self.lbPracitceDescContent = [[ZLabel alloc] init];
        [self.lbPracitceDescContent setTextColor:COLORTEXT2];
        [self.lbPracitceDescContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.lbPracitceDescContent setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbPracitceDescContent setNumberOfLines:0];
        [self.viewPractice addSubview:self.lbPracitceDescContent];
    }
}
-(void)createSubscribeView
{
    if (!self.viewSubscribe) {
        self.viewSubscribe = [[ZScrollView alloc] initWithFrame:CGRectMake(self.scrollViewMain.width, 0, self.scrollViewMain.width, self.scrollViewMain.height-self.buttonViewSpace-5)];
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
    }
    if (!self.lbEachCourse) {
        self.lbEachCourse = [[ZLabel alloc] init];
        [self.lbEachCourse setTextColor:COLORTEXT1];
        [self.lbEachCourse setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.lbEachCourse setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbEachCourse setNumberOfLines:1];
        [self.lbEachCourse setText:kEachCourseIntroduction];
        [self.viewSubscribe addSubview:self.lbEachCourse];
    }
    if (!self.lbEachCourseContent) {
        self.lbEachCourseContent = [[ZLabel alloc] init];
        [self.lbEachCourseContent setTextColor:COLORTEXT2];
        [self.lbEachCourseContent setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
        [self.lbEachCourseContent setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbEachCourseContent setNumberOfLines:0];
        [self.viewSubscribe addSubview:self.lbEachCourseContent];
    }
}
/// 图片大小
+(CGFloat)getViewImageHeight
{
    CGFloat iconSize = 120*kViewSace;
    if (IsIPadDevice) {
        iconSize = 200;
    }
    if (IsIPhone4) {
        iconSize = 0;
    }
    return iconSize;
}
-(void)setImageViewFrame
{
    CGFloat spaceSize = 20;
    if (IsIPhone4) {
        CGFloat iconSize = 50;
        CGRect titleFrame = self.titleFrame;
        titleFrame.origin.x = spaceSize+iconSize+10;
        titleFrame.size.width = self.width-titleFrame.origin.x-spaceSize;
        [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbTitle setFrame:titleFrame];
        CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
        titleFrame.size.height = titleMaxH;
        [self.lbTitle setFrame:titleFrame];
        
        CGFloat lbW = self.width-spaceSize*2;
        CGFloat nameY = self.lbTitle.y+self.lbTitle.height+20;
        CGFloat lbX = spaceSize+iconSize+10;
        CGFloat buttonViewH = 32;
        CGFloat buttonViewSpace = 20*kViewSace;
        [self.imgIcon setFrame:CGRectMake(spaceSize, self.lbTitle.y, iconSize, iconSize)];
        
        CGRect nameFrame =  CGRectMake(spaceSize, nameY, lbW, 10);
        [self.lbSpeakerName setFrame:nameFrame];
        nameFrame.size.height = [self.lbSpeakerName getLabelHeightWithMinHeight:10];
        [self.lbSpeakerName setFrame:nameFrame];
        CGFloat companyY = self.lbSpeakerName.y+self.lbSpeakerName.height+10;
        CGRect companyFrame = CGRectMake(spaceSize, companyY, lbW, 10);
        companyFrame.size.height = [self.lbSpeakerCompany getLabelHeightWithMinHeight:10];
        [self.lbSpeakerCompany setFrame:companyFrame];
        
        CGFloat buttonViewW = 120;
        CGFloat buttonViewX = self.width/2-buttonViewW/2;
        CGFloat buttonViewY = self.viewPoint1.y - buttonViewH - buttonViewSpace;
        [self.viewButton setFrame:(CGRectMake(buttonViewX, buttonViewY, buttonViewW, buttonViewH))];
        [self.viewButtonSpace setFrame:(CGRectMake(buttonViewW/2-1, 2, 2, buttonViewH-4))];
        [self.viewButtonSpace setBackgroundColor:COLORVIEWBACKCOLOR2];
        [self.viewButton setViewRound:18 borderWidth:1 borderColor:COLORVIEWBACKCOLOR2];
        [self.btnText setFrame:CGRectMake(0, 0, buttonViewW/2, buttonViewH)];
        [self.btnPPT setFrame:CGRectMake(buttonViewW/2, 0, buttonViewW/2, buttonViewH)];
    } else {
        CGRect titleFrame = self.titleFrame;
        CGFloat titleMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
        titleFrame.size.height = titleMaxH;
        [self.lbTitle setFrame:titleFrame];
        
        CGFloat lbSpace = 10*kViewSace;
        CGFloat lbW = self.width-spaceSize*2;
        CGFloat nameY = self.lbTitle.y+self.lbTitle.height+lbSpace;
        
        CGRect nameFrame =  CGRectMake(spaceSize, nameY, lbW, 10);
        [self.lbSpeakerName setFrame:nameFrame];
        nameFrame.size.height = [self.lbSpeakerName getLabelHeightWithMinHeight:10];
        [self.lbSpeakerName setFrame:nameFrame];
        CGFloat companyY = self.lbSpeakerName.y+self.lbSpeakerName.height+lbSpace;
        CGRect companyFrame = CGRectMake(spaceSize, companyY, lbW, 10);
        companyFrame.size.height = [self.lbSpeakerCompany getLabelHeightWithMinHeight:10];
        [self.lbSpeakerCompany setFrame:companyFrame];
        
        CGFloat iconSize = [ZPlayObjectInfoView getViewImageHeight];
        CGFloat iconX = self.viewImage.width/2-iconSize/2;
        CGFloat buttonViewH = 32;
        CGFloat buttonViewSpace = 20*kViewSace;
        ///图片区域空白高度
        CGFloat iconContentY = self.lbSpeakerCompany.y+self.lbSpeakerCompany.height;
        CGFloat iconContentH = self.viewPoint1.y - iconContentY - buttonViewH - buttonViewSpace;
        ///图片坐标
        CGFloat iconY = iconContentY + iconContentH/2 - iconSize/2;
        [self.imgIcon setFrame:CGRectMake(iconX, iconY, iconSize, iconSize)];
        
        CGFloat buttonViewW = 120;
        CGFloat buttonViewX = self.viewImage.width/2-buttonViewW/2;
        CGFloat buttonViewY = self.viewPoint1.y - buttonViewH - buttonViewSpace;
        [self.viewButton setFrame:(CGRectMake(buttonViewX, buttonViewY, buttonViewW, buttonViewH))];
        [self.viewButtonSpace setFrame:(CGRectMake(buttonViewW/2-1, 2, 2, buttonViewH-4))];
        [self.viewButtonSpace setBackgroundColor:COLORVIEWBACKCOLOR2];
        [self.viewButton setViewRound:18 borderWidth:1 borderColor:COLORVIEWBACKCOLOR2];
        [self.btnText setFrame:CGRectMake(0, 0, buttonViewW/2, buttonViewH)];
        [self.btnPPT setFrame:CGRectMake(buttonViewW/2, 0, buttonViewW/2, buttonViewH)];
    }
}
-(void)setPracitceContentViewFrame
{
    CGFloat lbX = 20;
    CGFloat lbW = self.width-lbX*2;
    [self.lbSpeakerDesc setFrame:CGRectMake(lbX, 20, lbW, 20)];
    
    CGFloat sdContentY = self.lbSpeakerDesc.y+self.lbSpeakerDesc.height+kSize12;
    CGRect sdContentFrame = CGRectMake(lbX, sdContentY, lbW, 20);
    [self.lbSpeakerDescContent setFrame:sdContentFrame];
    CGFloat sdContentH = [self.lbSpeakerDescContent getLabelHeightWithMinHeight:20];
    sdContentFrame.size.height = sdContentH;
    [self.lbSpeakerDescContent setFrame:sdContentFrame];
    
    [self.lbPracitceDesc setFrame:CGRectMake(lbX, self.lbSpeakerDescContent.y+self.lbSpeakerDescContent.height+kSize15, lbW, 20)];
    
    CGFloat pdContentY = self.lbPracitceDesc.y+self.lbPracitceDesc.height+kSize8;
    CGRect pdContentFrame = CGRectMake(lbX, pdContentY, lbW, 20);
    [self.lbPracitceDescContent setFrame:pdContentFrame];
    CGFloat pdContentH = [self.lbPracitceDescContent getLabelHeightWithMinHeight:20];
    pdContentFrame.size.height = pdContentH;
    [self.lbPracitceDescContent setFrame:pdContentFrame];
    
    [self.viewPractice setContentSize:CGSizeMake(self.width, pdContentY+pdContentH+5)];
}
-(void)setSubscribeContentViewFrame
{
    CGFloat lbX = 20;
    CGFloat lbW = self.width-lbX*2;
    [self.lbEachCourse setFrame:CGRectMake(lbX, 20, lbW, 20)];
    
    CGFloat ecContentY = self.lbEachCourse.y+self.lbEachCourse.height+kSize8;
    CGRect ecContentFrame = CGRectMake(lbX, ecContentY, lbW, 20);
    [self.lbEachCourseContent setFrame:ecContentFrame];
    CGFloat ecContentH = [self.lbEachCourseContent getLabelHeightWithMinHeight:20];
    ecContentFrame.size.height = ecContentH;
    [self.lbEachCourseContent setFrame:ecContentFrame];
    
    [self.viewSubscribe setContentSize:CGSizeMake(self.width, ecContentY+ecContentH+5)];
}
-(void)btnTextClick
{
    if (self.onTextClick) {
        self.onTextClick();
    }
}
-(void)btnPPTClick
{
    if (self.onPPTClick) {
        self.onPPTClick();
    }
}
-(void)dealloc
{
    OBJC_RELEASE(_imgIcon);
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
    [self.imgIcon setImageURLStr:model.speech_img];
    
    [self.lbTitle setText:model.title];
    
    [self.lbSpeakerName setText:[NSString stringWithFormat:@"%@: %@", kSpeaker, model.nickname]];
    [self.lbSpeakerCompany setText:model.person_title];
    
    [self.lbSpeakerDescContent setText:model.person_synopsis];
    [self.lbPracitceDescContent setText:model.share_content];
    
    [self.viewSubscribe setHidden:YES];
    [self.viewPractice setHidden:NO];
    
    [self setPracitceContentViewFrame];
}
-(void)setViewDataWithSubscribe:(ModelCurriculum *)model
{
    [self.imgIcon setImageURLStr:[Utils getMiddlePicture:model.audio_picture]];
    
    [self.lbTitle setText:model.ctitle];
    
    [self.lbSpeakerName setText:[NSString stringWithFormat:@"%@: %@", kSpeaker, model.speaker_name]];
    [self.lbSpeakerCompany setText:model.team_name];
    
    [self.lbEachCourseContent setText:model.content];
    
    [self.viewSubscribe setHidden:NO];
    [self.viewPractice setHidden:YES];
    
    [self setSubscribeContentViewFrame];
}

/// 恢复到默认的偏移
-(void)setContentDefaultOffX
{
    [self.scrollViewMain setContentOffset:(CGPointMake(0, 0))];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offsetIndex = abs((int)(scrollView.contentOffset.x/scrollView.width));
    if (offsetIndex == 0) {
        [self.viewPoint1 setBackgroundColor:COLORCONTENT1];
        [self.viewPoint2 setBackgroundColor:COLORVIEWBACKCOLOR3];
    } else {
        [self.viewPoint2 setBackgroundColor:COLORCONTENT1];
        [self.viewPoint1 setBackgroundColor:COLORVIEWBACKCOLOR3];
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




