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

@interface ZLawFirmDetailView()

@property (strong, nonatomic) ZView *viewContent;
/// 律师事务所名称
@property (strong, nonatomic) ZLabel *lbTitle;
/// 标题分割线
@property (strong, nonatomic) UIImageView *imgLine;
/// 律师事务所描述
@property (strong, nonatomic) ZLabel *lbDesc;
/// 更多按钮
@property (strong, nonatomic) ZButton *btnMore;
/// 背景图片
@property (strong, nonatomic) ZImageView *imgBackground;
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
    self.viewContent = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewContent setBackgroundColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    
    self.lbTitle = [[ZLabel alloc] init];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.lbTitle setTextColor:WHITECOLOR];
    [self.lbTitle setNumberOfLines:0];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbTitle];
    
    self.imgLine = [[UIImageView alloc] init];
    [self.imgLine setBackgroundColor:WHITECOLOR];
    [self.viewContent addSubview:self.imgLine];
    
    self.lbDesc = [[ZLabel alloc] init];
    [self.lbDesc setFont:[ZFont systemFontOfSize:kFont_Least_Size]];
    [self.lbDesc setTextColor:WHITECOLOR];
    [self.lbDesc setNumberOfLines:0];
    [self.lbDesc setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.viewContent addSubview:self.lbDesc];
    
    //lawfirm_open_icon | lawfirm_close_icon
    self.btnMore = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnMore setImage:[SkinManager getImageWithName:@"lawfirm_open_icon"] forState:(UIControlStateNormal)];
    [self.btnMore setImage:[SkinManager getImageWithName:@"lawfirm_open_icon"] forState:(UIControlStateHighlighted)];
    [self.btnMore setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnMore setTitleColor:MAINCOLOR forState:(UIControlStateHighlighted)];
    [self.btnMore setImageEdgeInsets:(UIEdgeInsetsMake(0, 35, 0, 0))];
    [self.btnMore setTitle:kOpen forState:(UIControlStateNormal)];
    [self.btnMore setTitle:kOpen forState:(UIControlStateHighlighted)];
    [self.btnMore setTitleEdgeInsets:(UIEdgeInsetsMake(0, -42, 0, 0))];
    [[self.btnMore titleLabel] setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.btnMore setTag:1];
    [self.btnMore setHidden:YES];
    [self.btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnMore];
    
    self.imgBackground = [[ZImageView alloc] initWithFrame:self.bounds];
    [self.imgBackground setImage:[SkinManager getImageWithName:@"play_background_default"]];
    [self.imgBackground setCenter:self.center];
    // 创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 毛玻璃视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.imgBackground.bounds;
    effectView.center = self.imgBackground.center;
    [effectView setTag:1001];
    UIImageView *imgViewBG = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"play_transparent_back"]];
    [imgViewBG setTag:1002];
    [imgViewBG setFrame:effectView.bounds];
    
    [self.imgBackground addSubview:effectView];
    [self.imgBackground addSubview:imgViewBG];
    [self.imgBackground bringSubviewToFront:effectView];
    [self.imgBackground bringSubviewToFront:imgViewBG];
    [self addSubview:self.imgBackground];
    
    [self sendSubviewToBack:self.imgBackground];
    [self bringSubviewToFront:self.viewContent];
}
-(void)btnMoreClick:(ZButton *)sender
{
    if (self.btnMore.tag == 1) {
        [self.btnMore setTag:2];
        [self.btnMore setTitle:kPackUp forState:(UIControlStateNormal)];
        [self.btnMore setTitle:kPackUp forState:(UIControlStateHighlighted)];
        [self.btnMore setImage:[SkinManager getImageWithName:@"lawfirm_close_icon"] forState:(UIControlStateNormal)];
        [self.btnMore setImage:[SkinManager getImageWithName:@"lawfirm_close_icon"] forState:(UIControlStateHighlighted)];
    } else {
        [self.btnMore setTag:1];
        [self.btnMore setTitle:kOpen forState:(UIControlStateNormal)];
        [self.btnMore setTitle:kOpen forState:(UIControlStateHighlighted)];
        [self.btnMore setImage:[SkinManager getImageWithName:@"lawfirm_open_icon"] forState:(UIControlStateNormal)];
        [self.btnMore setImage:[SkinManager getImageWithName:@"lawfirm_open_icon"] forState:(UIControlStateHighlighted)];
    }
    [self setViewFrame];
}
-(void)setViewFrame
{
    CGFloat viewH = APP_TOP_HEIGHT;
    CGFloat btnW = 60;
    CGFloat btnH = 30;
    CGRect contentFrame = CGRectMake(0, APP_TOP_HEIGHT, self.width, 0);
    [self.viewContent setFrame:contentFrame];
    
    CGFloat contentW = self.width-kSizeSpace*2;
    CGRect titleFrame = CGRectMake(kSizeSpace, 5, contentW, 0);
    [self.lbTitle setFrame:titleFrame];
    CGFloat titleH = [self.lbTitle getLabelHeightWithMinHeight:20];
    titleFrame.size.height = titleH;
    [self.lbTitle setFrame:titleFrame];
    
    CGRect lineFrame = CGRectMake(kSizeSpace, self.lbTitle.y+self.lbTitle.height+8, contentW, kLineHeight);
    [self.imgLine setFrame:lineFrame];
    
    CGRect descFrame = CGRectMake(kSizeSpace, self.imgLine.y+self.imgLine.height+8, contentW, 0);
    [self.lbDesc setFrame:descFrame];
    CGFloat descMaxH = [[ZCalculateLabel shareCalculateLabel] getMaxLineHeightWithLabel:self.lbDesc line:4];
    CGFloat descH = [self.lbDesc getLabelHeightWithMinHeight:0];
    if (descH > descMaxH) {
        [self.btnMore setHidden:NO];
        if (self.btnMore.tag == 1) {
            descFrame.size.height = descMaxH;
        } else {
            descFrame.size.height = descH;
        }
        [self.btnMore setFrame:CGRectMake(self.width-btnW-kSizeSpace, descFrame.origin.y+descFrame.size.height, btnW, btnH)];
    } else {
        [self.btnMore setHidden:YES];
        descFrame.size.height = descH;
        [self.btnMore setFrame:CGRectMake(self.width-btnW-kSizeSpace, descFrame.origin.y+descFrame.size.height, btnW, 15)];
    }
    [self.lbDesc setFrame:descFrame];
    
    contentFrame.size.height = self.btnMore.y+self.btnMore.height+5;
    [self.viewContent setFrame:contentFrame];
    
    viewH = self.viewContent.y+self.viewContent.height;
    [self setFrame:CGRectMake(self.x, self.y, self.width, viewH)];
    
    [self setFrame:CGRectMake(self.x, self.y, self.width, viewH)];
    [self.imgBackground setFrame:self.bounds];
    [self.imgBackground setCenter:self.center];
    [[self.imgBackground viewWithTag:1001] setFrame:self.imgBackground.bounds];
    [[self.imgBackground viewWithTag:1001] setCenter:self.imgBackground.center];
    [[self.imgBackground viewWithTag:1002] setFrame:self.imgBackground.bounds];
    
    if (self.onViewHeightChange) {
        self.onViewHeightChange(viewH);
    }
}
-(void)setViewDataWithLawFirm:(ModelLawFirm *)model
{
    [self setModel:model];
    
    [self.lbTitle setText:model.title];
    [self.lbDesc setText:model.desc];
    [self.imgBackground setImageURLStr:model.picture placeImage:[SkinManager getImageWithName:@"play_background_default"]];
    
    [self setViewFrame];
}
-(void)dealloc
{
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_imgBackground);
    OBJC_RELEASE(_lbDesc);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_btnMore);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_onViewHeightChange);
}

@end
