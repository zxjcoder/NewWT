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
    self.btnPraise = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnPraise setImage:[SkinManager getImageWithName:@"play_praise_icon"] forState:(UIControlStateNormal)];
    [self.btnPraise setImage:[SkinManager getImageWithName:@"play_praise_icon"] forState:(UIControlStateHighlighted)];
    [self.btnPraise setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnPraise addTarget:self action:@selector(btnPraiseClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnPraise];
    
    self.lbPraise = [[ZLabel alloc] init];
    [self.lbPraise setTextColor:RGBCOLOR(192, 192, 192)];
    [self.lbPraise setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbPraise setNumberOfLines:1];
    [self.lbPraise setTextAlignment:NSTextAlignmentLeft];
    [self.lbPraise setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self addSubview:self.lbPraise];
    
    self.btnCollection = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCollection setImage:[SkinManager getImageWithName:@"play_collection_icon"] forState:(UIControlStateNormal)];
    [self.btnCollection setImage:[SkinManager getImageWithName:@"play_collection_icon"] forState:(UIControlStateHighlighted)];
    [self.btnCollection setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnCollection addTarget:self action:@selector(btnCollectionClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnCollection];
    
    self.lbCollection = [[ZLabel alloc] init];
    [self.lbCollection setTextColor:RGBCOLOR(192, 192, 192)];
    [self.lbCollection setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbCollection setNumberOfLines:1];
    [self.lbCollection setTextAlignment:(NSTextAlignmentLeft)];
    [self.lbCollection setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
    [self addSubview:self.lbCollection];
    
    self.btnDownload = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnDownload setImage:[SkinManager getImageWithName:@"play_download_icon"] forState:(UIControlStateNormal)];
    [self.btnDownload setImage:[SkinManager getImageWithName:@"play_download_icon"] forState:(UIControlStateHighlighted)];
    [self.btnDownload setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnDownload addTarget:self action:@selector(btnDownloadClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnDownload];
    
    [self setViewFrame];
}
-(void)innerInitCurriculum
{
    [self innerInitPractice];
}
-(void)setViewFrame
{
    CGFloat iconS = 35;
    CGFloat btnY = self.height/2-iconS/2;
    CGFloat collectionX = self.width/2-iconS/2-10;
    CGRect collectionFrame = CGRectMake(collectionX, btnY, iconS, iconS);
    [self.btnCollection setFrame:collectionFrame];
    
    CGFloat lbH = 25;
    CGFloat lbY = self.height/2-lbH/2;
    CGFloat lbW = 45;
    CGRect collectionLbFrame = CGRectMake(collectionFrame.origin.x+collectionFrame.size.width, lbY, lbW, lbH);
    [self.lbCollection setFrame:collectionLbFrame];
    
    CGRect praiseLbFrame = CGRectMake(0, lbY, lbW, lbH);
    praiseLbFrame.origin.x = self.btnCollection.x-lbW;
    [self.lbPraise setFrame:praiseLbFrame];
    
    CGRect praiseFrame = CGRectMake(praiseLbFrame.origin.x-iconS, btnY, iconS, iconS);
    [self.btnPraise setFrame:praiseFrame];
    
    CGFloat downloadX = collectionLbFrame.origin.x+collectionLbFrame.size.width;
    CGRect downloadFrame = CGRectMake(downloadX, btnY, iconS, iconS);
    [self.btnDownload setFrame:downloadFrame];
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
    
    //[self.lbPraise setHidden:model.applauds==0];
    //[self.lbCollection setHidden:model.ccount==0];
    [self.lbPraise setText:[NSString stringWithFormat:@"%ld", model.applauds]];
    [self.lbCollection setText:[NSString stringWithFormat:@"%ld", model.ccount]];
    
    [self setButtonImage:model.isPraise isCollection:model.isCollection];
    
    [self setViewFrame];
}
-(void)setButtonImage:(BOOL)isPraise isCollection:(BOOL)isCollection
{
    if (!isPraise) {
        [self.btnPraise setImage:[SkinManager getImageWithName:@"play_praise_icon"] forState:(UIControlStateNormal)];
        [self.btnPraise setImage:[SkinManager getImageWithName:@"play_praise_icon"] forState:(UIControlStateHighlighted)];
    } else {
        [self.btnPraise setImage:[SkinManager getImageWithName:@"play_praise_icon_pre"] forState:(UIControlStateNormal)];
        [self.btnPraise setImage:[SkinManager getImageWithName:@"play_praise_icon_pre"] forState:(UIControlStateHighlighted)];
    }
    if (!isCollection) {
        [self.btnCollection setImage:[SkinManager getImageWithName:@"play_collection_icon"] forState:(UIControlStateNormal)];
        [self.btnCollection setImage:[SkinManager getImageWithName:@"play_collection_icon"] forState:(UIControlStateHighlighted)];
    } else {
        [self.btnCollection setImage:[SkinManager getImageWithName:@"play_collection_icon_pre"] forState:(UIControlStateNormal)];
        [self.btnCollection setImage:[SkinManager getImageWithName:@"play_collection_icon_pre"] forState:(UIControlStateHighlighted)];
    }
    [self.btnPraise setNeedsDisplay];
    [self.btnCollection setNeedsDisplay];
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
            [self.btnDownload setImage:[SkinManager getImageWithName:@"play_download_icon_pre"] forState:(UIControlStateNormal)];
            [self.btnDownload setImage:[SkinManager getImageWithName:@"play_download_icon_pre"] forState:(UIControlStateHighlighted)];
            [self.btnDownload setNeedsDisplay];
            break;
        default:
            [self.btnDownload setImage:[SkinManager getImageWithName:@"play_download_icon"] forState:(UIControlStateNormal)];
            [self.btnDownload setImage:[SkinManager getImageWithName:@"play_download_icon"] forState:(UIControlStateHighlighted)];
            [self.btnDownload setNeedsDisplay];
            break;
    }
}

@end
