//
//  ZLawFirmDetailTVC.m
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmDetailTVC.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "ZCalculateLabel.h"
//#import "ZNewLawFirmHeaderView.h"

@interface ZLawFirmDetailTVC()

@property (strong, nonatomic) ZView *viewContent;
/// 律师事务所描述
@property (strong, nonatomic) ZLabel *lbDesc;
/// 更多按钮
@property (strong, nonatomic) ZButton *btnMore;
/// 背景图片
@property (strong, nonatomic) ZImageView *imgBackground;
/// 第一个导航
//@property (strong, nonatomic) ZNewLawFirmHeaderView *viewHeader;
/// 数据模型
@property (strong, nonatomic) ModelLawFirm *model;

@end

@implementation ZLawFirmDetailTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    [super innerInit];
    self.cellH = [ZLawFirmDetailTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    self.viewContent = [[ZView alloc] initWithFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    [self.viewContent setBackgroundColor:CLEARCOLOR];
    [self.viewMain addSubview:self.viewContent];
    
    self.lbDesc = [[ZLabel alloc] initWithFrame:(CGRectMake(20, 82, self.cellW, 18))];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbDesc setTextColor:WHITECOLOR];
    [self.lbDesc setAlpha:0.7];
    [self.lbDesc setNumberOfLines:0];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbDesc];
    
    self.btnMore = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMore setImage:[SkinManager getImageWithName:@"arrow_down"] forState:(UIControlStateNormal)];
    [self.btnMore setImage:[SkinManager getImageWithName:@"arrow_up"] forState:(UIControlStateSelected)];
    [self.btnMore setImageEdgeInsets:(UIEdgeInsetsMake(5, 5, 5, 5))];
    [self.btnMore setHidden:YES];
    self.btnMore.selected = false;
    //[self.btnMore setAlpha:0.8];
    //[self.btnMore setBackgroundColor:COLORVIEWBACKCOLOR1];
    //[[self.btnMore layer] setMasksToBounds:true];
    //[self.btnMore setViewRound:15 borderWidth:0 borderColor:CLEARCOLOR];
    [self.btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnMore];
    
    self.imgBackground = [[ZImageView alloc] initWithFrame:self.viewContent.bounds];
    [self.imgBackground setCenter:self.center];
    [self.imgBackground setContentMode:(UIViewContentModeScaleToFill)];
    // 创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 毛玻璃视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.imgBackground.bounds;
    effectView.center = self.imgBackground.center;
    [effectView setTag:1001];
    UIView *imgViewBG = [[UIView alloc] initWithFrame:self.imgBackground.bounds];
    [imgViewBG setBackgroundColor:COLORVIEWBACKCOLOR1];
    [imgViewBG setAlpha:0.7];
    [imgViewBG setTag:1002];
    [imgViewBG setFrame:effectView.bounds];
    
    [self.imgBackground addSubview:effectView];
    [self.imgBackground addSubview:imgViewBG];
    [self.imgBackground bringSubviewToFront:effectView];
    [self.imgBackground bringSubviewToFront:imgViewBG];
    [self.viewContent addSubview:self.imgBackground];
    
    [self.viewContent sendSubviewToBack:self.imgBackground];
    [self.viewContent bringSubviewToFront:self.lbDesc];
    
}
-(void)btnMoreClick:(ZButton *)sender
{
    self.btnMore.selected = !self.btnMore.selected;
    
    [self setViewFrame];
}
-(void)setViewFrame
{
    CGRect contentFrame = CGRectMake(0, 0, self.cellW, 82);
    [self.viewContent setFrame:contentFrame];
    
    CGFloat contentW = self.cellW-20*2;
    CGRect descFrame = CGRectMake(20, 82, contentW, 0);
    [self.lbDesc setFrame:descFrame];
    CGFloat descMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbDesc line:4];
    CGFloat descH = [self.lbDesc getLabelHeightWithMinHeight:0];
    [self.btnMore setHidden:descH<=descMaxH];
    //展开
    if (self.btnMore.selected) {
        descFrame.size.height = descH;
    } else {//折叠
        descFrame.size.height = descMaxH;
    }
    [self.lbDesc setFrame:descFrame];
    
    contentFrame.size.height = self.lbDesc.y+self.lbDesc.height+20;
    [self.viewContent setFrame:contentFrame];
    
    [self.imgBackground setFrame:self.viewContent.bounds];
    [self.imgBackground setCenter:self.viewContent.center];
    [[self.imgBackground viewWithTag:1001] setFrame:self.imgBackground.bounds];
    [[self.imgBackground viewWithTag:1001] setCenter:self.imgBackground.center];
    [[self.imgBackground viewWithTag:1002] setFrame:self.imgBackground.bounds];
    
    CGFloat btnW = 30;
    CGFloat btnH = 30;
    [self.btnMore setFrame:CGRectMake(self.cellW-btnW-20, self.viewContent.y+self.viewContent.height-btnH, btnW, btnH)];
    
    self.cellH = self.viewContent.y+self.viewContent.height;
    [self.viewMain setFrame:CGRectMake(0, 0, self.cellW, self.cellH)];
    [self.viewMain bringSubviewToFront:self.btnMore];
    
    if (self.onViewHeightChange) {
        self.onViewHeightChange(self.cellH);
    }
}
-(void)setViewDataWithLawFirm:(ModelLawFirm *)model
{
    [self setModel:model];
    
    [self.lbDesc setText:model.desc];
    [self.imgBackground setImageURLStr:model.picture placeImage:[SkinManager getImageWithName:@"play_background_default"]];
    
    [self setViewFrame];
}
-(void)dealloc
{
    OBJC_RELEASE(_imgBackground);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_btnMore);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_onViewHeightChange);
}

@end
