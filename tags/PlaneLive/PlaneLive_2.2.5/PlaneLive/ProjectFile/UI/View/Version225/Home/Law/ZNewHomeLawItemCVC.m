//
//  ZNewHomeLawItemCVC.m
//  PlaneLive
//
//  Created by Daniel on 24/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewHomeLawItemCVC.h"
#import "ZView.h"
#import "ZLabel.h"
#import "ZImageView.h"

@interface ZNewHomeLawItemCVC()

///内容区域
@property (strong, nonatomic) ZView *viewMain;
@property (strong, nonatomic) ZView *viewContent;
///LOGO
@property (strong, nonatomic) ZImageView *imgLogo;
///多少门课程
@property (strong, nonatomic) ZLabel *lbTotal;

@property (strong, nonatomic) UIImageView *imageLine;

@property (strong, nonatomic) ModelLawFirm *model;

@end

@implementation ZNewHomeLawItemCVC

 
-(void)innerInit
{
    if (!self.viewMain) {
        CGFloat contentW = [ZNewHomeLawItemCVC getW];
        CGFloat contentH = [ZNewHomeLawItemCVC getH];
        self.userInteractionEnabled = true;
        self.contentView.userInteractionEnabled = true;
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        self.viewMain = [[ZView alloc] initWithFrame:(CGRectMake(15, 15, contentW-15, contentH-30))];
        [self.viewMain setAllShadowColorWithRadius:kVIEW_ROUND_SIZE];
        [self.viewMain setBackgroundColor:WHITECOLOR];
        [self.viewMain setUserInteractionEnabled:true];
        [self.contentView addSubview:self.viewMain];
        
        self.viewContent = [[ZView alloc] initWithFrame:self.viewMain.frame];
        [[self.viewContent layer] setMasksToBounds:true];
        self.viewContent.userInteractionEnabled = true;
        [self.viewContent setBackgroundColor:CLEARCOLOR];
        [self.viewContent setViewRound:kVIEW_ROUND_SIZE borderWidth:0 borderColor:CLEARCOLOR];
        [self.contentView addSubview:self.viewContent];
        
        [self.contentView sendSubviewToBack:self.viewMain];
        
        CGFloat bottomH = 32;
        self.imgLogo = [[ZImageView alloc] initWithFrame:(CGRectMake(0, 0, self.viewContent.width, self.viewContent.height-bottomH))];
        self.imgLogo.userInteractionEnabled = true;
        self.imgLogo.image = [SkinManager getMaxImage];
        [self.viewContent addSubview:self.imgLogo];
        
        self.imageLine = [UIImageView getDLineView];
        self.imageLine.frame = CGRectMake(0, self.imgLogo.y+self.imgLogo.height, self.viewContent.width, kLineHeight);
        [self.viewContent addSubview:self.imageLine];
        
        CGFloat totalH = 20;
        self.lbTotal = [[ZLabel alloc] initWithFrame:(CGRectMake(0, self.imageLine.y+bottomH/2-totalH/2, self.viewContent.width, totalH))];
        [self.lbTotal setText:@"课程数:  0"];
        [self.lbTotal setTextColor:COLORTEXT2];
        [self.lbTotal setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbTotal setTextAlignment:(NSTextAlignmentCenter)];
        [self.lbTotal setLabelColorWithRange:(NSMakeRange(0, 4)) color:COLORTEXT3];
        [self.viewContent addSubview:self.lbTotal];
        
        UITapGestureRecognizer *imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapGesture:)];
        [self.imgLogo addGestureRecognizer:imageTapGesture];
    }
}
-(void)imageTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onLawFirmClick) {
            self.onLawFirmClick(self.model);
        }
    }
}
-(void)setCellDataWithModel:(ModelLawFirm *)model
{
    self.model = model;
    [self.lbTotal setText:[NSString stringWithFormat:@"课程数:  %d", model.total]];
    [self.lbTotal setTextColor:COLORTEXT2];
    [self.lbTotal setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTotal setLabelColorWithRange:(NSMakeRange(0, 4)) color:COLORTEXT3];
    [self.imgLogo setImageURLStr:model.logo placeImage:[SkinManager getMaxImage]];
}
+(CGFloat)getW
{
    return (APP_FRAME_WIDTH-25)/2;
}
+(CGFloat)getH
{
    return 150*APP_FRAME_WIDTH/375;
}

@end
