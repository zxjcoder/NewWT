//
//  ZHomeLawFirmCVC.m
//  PlaneLive
//
//  Created by Daniel on 11/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZHomeLawFirmCVC.h"
#import "ZView.h"
#import "ZImageView.h"
#import "ZLabel.h"

@interface ZHomeLawFirmCVC()

///内容区域
@property (strong, nonatomic) ZView *viewMain;
///LOGO区域
@property (strong, nonatomic) ZView *viewLogoBG;
///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///多少门课程图片
@property (strong, nonatomic) ZImageView *imgTotal;
///多少门课程
@property (strong, nonatomic) ZLabel *lbTotal;

@property (strong, nonatomic) ModelLawFirm *model;

@end

@implementation ZHomeLawFirmCVC

-(void)innerInit
{
    if (!self.viewMain) {
        self.viewMain = [[ZView alloc] init];
        [self.viewMain setBackgroundColor:CLEARCOLOR];
        [self.viewMain setUserInteractionEnabled:YES];
        [self.contentView addSubview:self.viewMain];
    }
    if (!self.viewLogoBG) {
        self.viewLogoBG = [[UIView alloc] init];
        [self.viewLogoBG setBackgroundColor:WHITECOLOR];
        [self.viewLogoBG setUserInteractionEnabled:YES];
        [self.viewLogoBG.layer setMasksToBounds:YES];
        [self.viewLogoBG setViewRound:kVIEW_ROUND_SIZE borderWidth:1 borderColor:RGBCOLOR(211, 211, 211)];
        [self.viewMain addSubview:self.viewLogoBG];
        
        //UITapGestureRecognizer *logoClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setLogoClick:)];
        //[self.viewLogoBG addGestureRecognizer:logoClick];
    }
    if (!self.imgLogo) {
        self.imgLogo = [[ZImageView alloc] init];
        [self.imgLogo setUserInteractionEnabled:NO];
        [self.viewLogoBG addSubview:self.imgLogo];
    }
    if (!self.imgTotal) {
        self.imgTotal = [[ZImageView alloc] init];
        [self.imgTotal setUserInteractionEnabled:NO];
        [self.imgTotal setImageName:@"lawfirm_title_icon"];
        [self.viewLogoBG addSubview:self.imgTotal];
    }
    if (!self.lbTotal) {
        self.lbTotal = [[ZLabel alloc] init];
        [self.lbTotal setUserInteractionEnabled:NO];
        [self.lbTotal setTextColor:WHITECOLOR];
        [self.lbTotal setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbTotal setNumberOfLines:1];
        [self.lbTotal setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.imgTotal addSubview:self.lbTotal];
    }
    [self.viewLogoBG bringSubviewToFront:self.imgTotal];
}
-(void)setLogoClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onLogoClick) {
            self.onLogoClick(self.model);
        }
    }
}
-(void)setViewFrame
{
    [self.viewMain setFrame:CGRectMake(0, 0, self.width, self.height)];
    CGFloat space = kSizeSpace;
    CGFloat imgW = self.width-space-space/2;
    CGFloat imgH = self.height-space;
    //偶数
    if (self.tag%2 == 0) {
        [self.viewLogoBG setFrame:CGRectMake(space, space, imgW, imgH)];
    } else {
        [self.viewLogoBG setFrame:CGRectMake(space/2, space, imgW, imgH)];
    }
    [self.imgLogo setFrame:self.viewLogoBG.bounds];
    
    CGFloat totalW = 68;
    CGFloat totalH = 22;
    [self.imgTotal setFrame:CGRectMake(0, 0, totalW, totalH)];
    [self.lbTotal setFrame:CGRectMake(8, 0, totalW, totalH)];
}

///设置数据源
-(void)setCellDataWithModel:(ModelLawFirm *)model
{
    [self setModel:model];
    [self innerInit];
    [self.lbTotal setText:[NSString stringWithFormat:@"%d%@", model.total, kLawFirmCourse]];
    [self.imgLogo setImageURLStr:model.logo placeImage:[SkinManager getMaxImage]];
    [self setViewFrame];
}

-(void)dealloc
{
    OBJC_RELEASE(_viewMain);
    OBJC_RELEASE(_viewLogoBG);
    OBJC_RELEASE(_imgLogo);
    OBJC_RELEASE(_imgTotal);
    OBJC_RELEASE(_lbTotal);
}

@end
