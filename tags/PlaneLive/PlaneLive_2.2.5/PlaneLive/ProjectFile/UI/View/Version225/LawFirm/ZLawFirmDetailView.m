//
//  ZLawFirmDetailView.m
//  PlaneLive
//
//  Created by Daniel on 12/04/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZLawFirmDetailView.h"
#import "ZLabel.h"
#import "ZButton.h"
#import "ZCalculateLabel.h"
#import "ZNewLawFirmHeaderView.h"

@interface ZLawFirmDetailView()

@property (strong, nonatomic) ZView *viewContent;
/// 律师事务所描述
@property (strong, nonatomic) ZLabel *lbDesc;
/// 更多按钮
@property (strong, nonatomic) ZButton *btnMore;
/// 背景图片
@property (strong, nonatomic) ZImageView *imgBackground;
/// 第一个导航
@property (strong, nonatomic) ZNewLawFirmHeaderView *viewHeader;
/// 数据模型
@property (strong, nonatomic) ModelLawFirm *model;

@end

@implementation ZLawFirmDetailView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewContent = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewContent setBackgroundColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    
    self.lbDesc = [[ZLabel alloc] initWithFrame:(CGRectMake(20, 82, self.width, 18))];
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
    [self.btnMore setBackgroundColor:COLORVIEWBACKCOLOR1];
    [[self.btnMore layer] setMasksToBounds:true];
    [self.btnMore setViewRound:15 borderWidth:0 borderColor:CLEARCOLOR];
    [self.btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnMore];
    
    self.imgBackground = [[ZImageView alloc] initWithFrame:self.viewContent.bounds];
    [self.imgBackground setImage:[SkinManager getImageWithName:@"play_background_default"]];
    [self.imgBackground setCenter:self.center];
    // 创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 毛玻璃视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.imgBackground.bounds;
    effectView.center = self.imgBackground.center;
    [effectView setTag:1001];
    UIView *imgViewBG = [[UIView alloc] init];
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
    
    self.viewHeader = [[ZNewLawFirmHeaderView alloc] initWithFrame:(CGRectMake(0, self.viewContent.y+self.viewContent.height, self.width, [ZNewLawFirmHeaderView getH])) title:kLawFirmRecommendedPractice isMore:false];
    ZWEAKSELF
    [self.viewHeader setOnMoreClick:^{
        if (weakSelf.onMoreClick) {
            weakSelf.onMoreClick();
        }
    }];
    [self addSubview:self.viewHeader];
}
-(void)btnMoreClick:(ZButton *)sender
{
    self.btnMore.selected = !self.btnMore.selected;
    
    [self setViewFrame];
}
///标题设置
-(void)setTitleText:(NSString *)text
{
    [self.viewHeader setTitleText:text];
}
///隐藏更多按钮
-(void)setMoreHidden:(BOOL)hidden
{
    [self.viewHeader setMoreHidden:hidden];
}
-(void)setViewFrame
{
    CGRect contentFrame = CGRectMake(0, 0, self.width, 82);
    [self.viewContent setFrame:contentFrame];
    
    CGFloat contentW = self.width-20*2;
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
    
    [self.viewHeader setFrame:(CGRectMake(0, self.viewContent.y+self.viewContent.height, self.width, [ZNewLawFirmHeaderView getH]))];
    
    CGFloat btnW = 30;
    CGFloat btnH = 30;
    [self.btnMore setFrame:CGRectMake(self.width-btnW-20, self.viewContent.y+self.viewContent.height-15, btnW, btnH)];
    
    CGFloat viewH = self.viewHeader.y+self.viewHeader.height;
    [self setFrame:CGRectMake(self.x, self.y, self.width, viewH)];
    [self bringSubviewToFront:self.btnMore];
    
    if (self.onViewHeightChange) {
        self.onViewHeightChange(viewH);
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
