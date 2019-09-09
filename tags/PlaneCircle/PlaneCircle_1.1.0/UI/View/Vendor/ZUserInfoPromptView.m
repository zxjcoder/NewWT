//
//  ZUserInfoPromptView.m
//  PlaneCircle
//
//  Created by Daniel on 7/22/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZUserInfoPromptView.h"

@interface ZUserInfoPromptView()

///背景
@property (strong, nonatomic) UIView *viewBG;
///内容
@property (strong, nonatomic) UIView *viewContent;
///图标
@property (strong, nonatomic) UIImageView *imgIcon;
///神秘人物
@property (strong, nonatomic) UILabel *lbName;
///您的个人资料太少啦
@property (strong, nonatomic) UILabel *lbDesc;
///不再提示
@property (strong, nonatomic) UIButton *btnCancel;
///立即完善
@property (strong, nonatomic) UIButton *btnSubmit;
///按钮分割线
@property (strong, nonatomic) UIView *viewLine1;
///按钮分割线
@property (strong, nonatomic) UIView *viewLine2;
///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;
///内容坐标
@property (assign, nonatomic) CGRect contentFrame;

@end

@implementation ZUserInfoPromptView

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInit];
    }
    return self;
}

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
    [self getBgView];
    [self getContentView];
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"pic_compele"]];
    [self.viewContent addSubview:self.imgIcon];
    
    self.lbName = [[UILabel alloc] init];
    [self.lbName setText:@"神秘人物"];
    [self.lbName setTextColor:BLACKCOLOR1];
    [self.lbName setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbName setFont:[UIFont systemFontOfSize:kFont_Middle_Size]];
    [self.viewContent addSubview:self.lbName];
    
    self.lbDesc = [[UILabel alloc] init];
    [self.lbDesc setText:@"您的个人资料太少啦"];
    [self.lbDesc setTextColor:BLACKCOLOR1];
    [self.lbDesc setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbDesc setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbDesc];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine2];
    
    self.btnSubmit = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSubmit setTitle:@"立即完善" forState:(UIControlStateNormal)];
    [[self.btnSubmit titleLabel] setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.btnSubmit setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnSubmit];
    
    self.btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel setTitle:@"不再提示" forState:(UIControlStateNormal)];
    [[self.btnCancel titleLabel] setFont:[UIFont systemFontOfSize:kFont_Small_Size]];
    [self.btnCancel setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnCancel];
    
    [self.viewBG setFrame:self.bounds];
    
    CGFloat viewW = self.viewBG.width;
    CGFloat viewH = self.viewBG.height;
    CGFloat contentW = 240;
    CGFloat contentH = 231;
    [self.viewContent setFrame:CGRectMake(viewW/2-contentW/2, viewH/2-contentH/2, contentW, contentH)];
    
    CGFloat imgY = 20;
    CGFloat imgS = 90;
    [self.imgIcon setFrame:CGRectMake(contentW/2-imgS/2, imgY, imgS, imgS)];
    
    [self.lbName setFrame:CGRectMake(0, imgY*2+imgS, contentW, 20)];
    [self.lbDesc setFrame:CGRectMake(0, self.lbName.y+self.lbName.height, contentW, 20)];
    
    [self.viewLine1 setFrame:CGRectMake(0, self.lbDesc.y+self.lbDesc.height+20, contentW, 1)];
    CGFloat btnH = 40;
    CGFloat btnY = self.viewLine1.y+self.viewLine1.height;
    [self.btnCancel setFrame:CGRectMake(0, btnY, contentW/2-0.5, btnH)];
    [self.viewLine2 setFrame:CGRectMake(contentW/2-0.5, btnY, 1, btnH)];
    [self.btnSubmit setFrame:CGRectMake(self.viewLine2.x+1, btnY, contentW/2-0.5, btnH)];
}

-(void)getBgView
{
    self.viewBG = [[UIView alloc] init];
    [self.viewBG setBackgroundColor:BLACKCOLOR];
    [self.viewBG setAlpha:0.4f];
    [self addSubview:self.viewBG];
}

-(void)getContentView
{
    self.viewContent = [[UIView alloc] init];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setHidden:YES];
    [[self.viewContent layer] setMasksToBounds:YES];
    [self.viewContent setViewRoundWithNoBorder];
    [self.viewContent setAlpha:1.0f];
    [self addSubview:self.viewContent];
    
    [self sendSubviewToBack:self.viewBG];
}

-(void)btnSubmitClick
{
    if (self.onSubmitClick) {
        self.onSubmitClick();
    }
    [self dismiss];
}
-(void)btnCancelClick
{
    if (self.onCancelClick) {
        self.onCancelClick();
    }
    [self dismiss];
}

-(void)setViewNil
{
    
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewBG);
}
-(void)dealloc
{
    [self setViewNil];
}
///显示
-(void)show
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [self.viewBG setAlpha:0];
    [self.viewContent setHidden:NO];
    [self.viewContent setAlpha:0];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.viewBG setAlpha:0.4f];
        [self.viewContent setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
    }];
}
///隐藏
-(void)dismiss
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.viewBG setAlpha:0.0f];
        [self.viewContent setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
        [self.viewContent setHidden:YES];
        [self setViewNil];
        [self removeFromSuperview];
    }];
}


@end
