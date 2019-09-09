//
//  ZPlayButtonView.m
//  PlaneLive
//
//  Created by Daniel on 2017/1/6.
//  Copyright © 2017年 WT. All rights reserved.
//

#import "ZPlayButtonView.h"
#import "ZImageView.h"
#import "ZLabel.h"
#import "ZButton.h"

@interface ZPlayButtonView()

@property (strong, nonatomic) ZButton *btnPraise;
@property (strong, nonatomic) ZLabel *lbPraise;
@property (strong, nonatomic) ZButton *btnCollection;
@property (strong, nonatomic) ZLabel *lbCollection;
@property (strong, nonatomic) ZButton *btnDownload;

@property (strong, nonatomic) ModelPractice *model;
@property (strong, nonatomic) ModelCurriculum *modelC;
@property (assign, nonatomic) ZPlayTabBarViewType playType;

@end

@implementation ZPlayButtonView

///初始化
-(instancetype)initWithPoint:(CGPoint)point type:(ZPlayTabBarViewType)type
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, APP_FRAME_WIDTH, kZPlayButtonViewHeight)];
    if (self) {
        [self setPlayType:type];
        switch (type) {
            case ZPlayTabBarViewTypeSubscribe:
                [self innerInitCurriculum];
                break;
            default:
                [self innerInitPractice];
                break;
        }
    }
    return self;
}
-(void)innerInitPractice
{
    if (!self.btnPraise) {
        self.btnPraise = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPraise setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [self.btnPraise setImage:[SkinManager getImageWithName:@"up"] forState:(UIControlStateNormal)];
        [self.btnPraise setImage:[SkinManager getImageWithName:@"up"] forState:(UIControlStateHighlighted)];
        [self.btnPraise addTarget:self action:@selector(btnPraiseClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnPraise];
    }
    if (!self.lbPraise) {
        self.lbPraise = [[ZLabel alloc] init];
        [self.lbPraise setTextColor:COLORTEXT3];
        [self.lbPraise setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbPraise setNumberOfLines:1];
        [self.lbPraise setTextAlignment:NSTextAlignmentLeft];
        [self.lbPraise setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self addSubview:self.lbPraise];
    }
    if (!self.btnCollection) {
        self.btnCollection = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnCollection setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [self.btnCollection setImage:[SkinManager getImageWithName:@"favs"] forState:(UIControlStateNormal)];
        [self.btnCollection setImage:[SkinManager getImageWithName:@"favs"] forState:(UIControlStateHighlighted)];
        [self.btnCollection addTarget:self action:@selector(btnCollectionClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnCollection];
    }
    if (!self.lbCollection) {
        self.lbCollection = [[ZLabel alloc] init];
        [self.lbCollection setTextColor:COLORTEXT3];
        [self.lbCollection setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.lbCollection setNumberOfLines:1];
        [self.lbCollection setTextAlignment:(NSTextAlignmentLeft)];
        [self.lbCollection setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self addSubview:self.lbCollection];
    }
    if (!self.btnDownload) {
        self.btnDownload = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnDownload setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
        [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateNormal)];
        [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateHighlighted)];
        [self.btnDownload addTarget:self action:@selector(btnDownloadClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.btnDownload];
    }
    [self setViewFrame];
}
-(void)innerInitCurriculum
{
    [self innerInitPractice];
}
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    [self setViewFrame];
//}
-(void)setViewFrame
{
    CGFloat btnS = 35;
    CGFloat btnY = self.height/2-btnS/2;
    CGFloat btnPX = self.width/2-btnS/2;
    [self.btnPraise setFrame:(CGRectMake(btnPX, btnY, btnS, btnS))];
    CGFloat lbW = 42;
    CGFloat lbH = 25;
    CGFloat lbY = self.height/2-lbH/2;
    CGFloat lbPX = self.btnPraise.x + btnS;
    [self.lbPraise setFrame:(CGRectMake(lbPX, lbY, lbW, lbH))];
    
    CGFloat lbCX = self.btnPraise.x - lbW;
    [self.lbCollection setFrame:(CGRectMake(lbCX, lbY, lbW, lbH))];
    CGFloat btnCX = self.lbCollection.x - btnS;
    [self.btnCollection setFrame:(CGRectMake(btnCX, btnY, btnS, btnS))];
    
    [self.btnDownload setFrame:(CGRectMake(self.lbPraise.x + lbW, btnY, btnS, btnS))];
}
-(void)btnPraiseClick
{
    if (self.playType == ZPlayTabBarViewTypeSubscribe) {
        if (self.onCurriculumPraiseClick) {
            self.onCurriculumPraiseClick(self.modelC);
        }
    } else {
        if (self.onPracticePraiseClick) {
            self.onPracticePraiseClick(self.model);
        }
    }
}
-(void)btnCollectionClick
{
    if (self.playType == ZPlayTabBarViewTypeSubscribe) {
        if (self.onCurriculumCollectionClick) {
            self.onCurriculumCollectionClick(self.modelC);
        }
    } else {
        if (self.onPracticeCollectionClick) {
            self.onPracticeCollectionClick(self.model);
        }
    }
}
-(void)btnDownloadClick
{
    if (self.onDownloadClick) {
        self.onDownloadClick(self.btnDownload.tag);
    }
}
///设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
    
    [self.lbPraise setText:[NSString stringWithFormat:@"%ld", model.applauds]];
    [self.lbCollection setText:[NSString stringWithFormat:@"%ld", model.ccount]];
    
    [self setButtonImage:model.isPraise isCollection:model.isCollection];
    
    [self setViewFrame];
}
-(void)setButtonImage:(BOOL)isPraise isCollection:(BOOL)isCollection
{
    if (isPraise) {
        [self.btnPraise setImage:[SkinManager getImageWithName:@"up_s"] forState:(UIControlStateNormal)];
        [self.btnPraise setImage:[SkinManager getImageWithName:@"up_s"] forState:(UIControlStateHighlighted)];
    } else {
        [self.btnPraise setImage:[SkinManager getImageWithName:@"up"] forState:(UIControlStateNormal)];
        [self.btnPraise setImage:[SkinManager getImageWithName:@"up"] forState:(UIControlStateHighlighted)];
    }
    if (isCollection) {
        [self.btnCollection setImage:[SkinManager getImageWithName:@"favs_s"] forState:(UIControlStateNormal)];
        [self.btnCollection setImage:[SkinManager getImageWithName:@"favs_s"] forState:(UIControlStateHighlighted)];
    } else {
        [self.btnCollection setImage:[SkinManager getImageWithName:@"favs"] forState:(UIControlStateNormal)];
        [self.btnCollection setImage:[SkinManager getImageWithName:@"favs"] forState:(UIControlStateHighlighted)];
    }
}
///设置数据源
-(void)setViewDataWithModelCurriculum:(ModelCurriculum *)model
{
    [self setModelC:model];
    
    //[self.lbPraise setHidden:model.applauds==0];
    //[self.lbCollection setHidden:model.ccount==0];
    [self.lbPraise setText:[NSString stringWithFormat:@"%ld", model.applauds]];
    [self.lbCollection setText:[NSString stringWithFormat:@"%ld", model.ccount]];
    
    [self setButtonImage:model.isPraise isCollection:model.isCollection];
    
    [self setViewFrame];
}
/// 设置播放按钮状态-无暂停状态
-(void)setDownloadButtonImageNoSuspend:(ZDownloadStatus)status
{
    [self.btnDownload setTag:status];
    switch (status) {
        case ZDownloadStatusEnd:
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download_end"] forState:(UIControlStateNormal)];
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download_end"] forState:(UIControlStateHighlighted)];
            break;
        default:
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateNormal)];
            [self.btnDownload setImage:[SkinManager getImageWithName:@"download"] forState:(UIControlStateHighlighted)];
            break;
    }
}

@end
