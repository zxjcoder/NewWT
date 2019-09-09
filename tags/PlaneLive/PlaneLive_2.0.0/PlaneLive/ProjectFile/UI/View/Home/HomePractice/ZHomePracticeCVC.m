//
//  ZHomePracticeCVC.m
//  PlaneLive
//
//  Created by Daniel on 29/09/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomePracticeCVC.h"
#import "ZImageView.h"
#import "ZView.h"
#import "ZLabel.h"
#import "ZCalculateLabel.h"

@interface ZHomePracticeCVC()

///内容区域
@property (strong, nonatomic) ZView *viewMain;
///图片
@property (strong, nonatomic) ZImageView *imgIcon;
///游戏名称
@property (strong, nonatomic) ZLabel *lbTitle;
///数据源
@property (strong, nonatomic) ModelPractice *model;

@end

@implementation ZHomePracticeCVC

-(void)innerInit
{
    if (!self.viewMain) {
        self.viewMain = [[ZView alloc] init];
        [self.viewMain setBackgroundColor:WHITECOLOR];
        [self.viewMain setUserInteractionEnabled:YES];
        [self.contentView addSubview:self.viewMain];
    }
    if (!self.imgIcon) {
        self.imgIcon = [[ZImageView alloc] init];
        [self.imgIcon setUserInteractionEnabled:YES];
        [self.imgIcon.layer setMasksToBounds:YES];
        [self.imgIcon setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
        [self.viewMain addSubview:self.imgIcon];
    }
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] init];
        [self.lbTitle setTextColor:BLACKCOLOR1];
        [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbTitle setNumberOfLines:2];
        [self.lbTitle setFont:[UIFont systemFontOfSize:kFont_Least_Size]];
        [self.viewMain addSubview:self.lbTitle];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.viewMain setFrame:self.contentView.bounds];
    
    CGFloat space = 5;
    CGFloat imgSize = self.width;
    CGFloat imgSpace = (self.viewMain.width-imgSize)/2;
    [self.imgIcon setFrame:CGRectMake(imgSpace, space, imgSize, imgSize)];
    
    CGRect titleFrame = CGRectMake(self.imgIcon.x, self.imgIcon.y+self.imgIcon.height+kSize3, self.imgIcon.width, 0);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleHeight = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbTitle];
    titleFrame.size.height = titleHeight;
    [self.lbTitle setFrame:titleFrame];
}

-(void)setCellDataWithModel:(ModelPractice *)model
{
    [self setModel:model];
    
    [self innerInit];
    
    [self.lbTitle setText:model.title];
    [self.imgIcon setImageURLStr:model.speech_img placeImage:[SkinManager getPracticeImage]];
    
    [self setNeedsDisplay];
}

-(void)dealloc
{
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_model);
}

@end
