//
//  ZPlaySuccessView.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZPlaySuccessView.h"

@interface ZPlaySuccessView()

///背景
@property (strong, nonatomic) UIView *viewBG;
///内容
@property (strong, nonatomic) UIView *viewContent;
///图标
@property (strong, nonatomic) UIImageView *imgIcon;
///任务描述
@property (strong, nonatomic) UILabel *lbContent;
///取消
@property (strong, nonatomic) UIButton *btnCancel;
///接受
@property (strong, nonatomic) UIButton *btnSubmit;
///按钮分割线
@property (strong, nonatomic) UIView *viewLine1;
///按钮分割线
@property (strong, nonatomic) UIView *viewLine2;
///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;
///内容坐标
@property (assign, nonatomic) CGRect contentFrame;
///0,只有一个按钮 1,两个按钮
@property (assign, nonatomic) int type;

@end

@implementation ZPlaySuccessView

-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInit];
    }
    return self;
}

///初始化 0,只有一个按钮 1,两个按钮
-(instancetype)initWithType:(int)type
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self setType:type];
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
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self getBgView];
    [self getContentView];
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"alertview_complete_icon"]];
    [self.viewContent addSubview:self.imgIcon];
    
    self.lbContent = [[UILabel alloc] init];
    [self.lbContent setText:kRechargeSuccess];
    [self.lbContent setTextColor:BLACKCOLOR1];
    [self.lbContent setTextAlignment:(NSTextAlignmentCenter)];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.viewContent addSubview:self.lbContent];
    
    self.viewLine1 = [[UIView alloc] init];
    [self.viewLine1 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine1];
    
    self.viewLine2 = [[UIView alloc] init];
    [self.viewLine2 setBackgroundColor:TABLEVIEWCELL_LINECOLOR];
    [self.viewContent addSubview:self.viewLine2];
    
    self.btnSubmit = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnSubmit setTitle:kReturn forState:(UIControlStateNormal)];
    [[self.btnSubmit titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.btnSubmit setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnSubmit];
    
    self.btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel setTitle:kClose forState:(UIControlStateNormal)];
    [[self.btnCancel titleLabel] setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [self.btnCancel setTitleColor:BLACKCOLOR1 forState:(UIControlStateNormal)];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnCancel];
    
    [self.viewBG setFrame:self.bounds];
    
    CGFloat viewW = self.viewBG.width;
    CGFloat viewH = self.viewBG.height;
    CGFloat contentW = 260;
    
    CGFloat topY = 18;
    CGFloat imgW = 220/2;
    CGFloat imgH = 150/2;
    [self.imgIcon setFrame:CGRectMake(contentW/2-imgW/2, topY, imgW, imgH)];
    
    [self.lbContent setFrame:CGRectMake(0, topY*2+imgH, contentW, 20)];
    
    [self.viewLine1 setFrame:CGRectMake(0, self.lbContent.y+self.lbContent.height+topY, contentW, 1)];
    CGFloat btnH = 40;
    CGFloat btnY = self.viewLine1.y+self.viewLine1.height;
    switch (self.type) {
        case 1:
            [self.btnCancel setFrame:CGRectMake(0, btnY, contentW/2-0.5, btnH)];
            [self.viewLine2 setFrame:CGRectMake(contentW/2-0.5, btnY, 1, btnH)];
            [self.btnSubmit setFrame:CGRectMake(self.viewLine2.x+1, btnY, contentW/2-0.5, btnH)];
            break;
        default:
        {
            [self.btnCancel setHidden:YES];
            [self.viewLine2 setHidden:YES];
            [self.btnSubmit setTitle:kDetermine forState:(UIControlStateNormal)];
            [self.btnSubmit setFrame:CGRectMake(0, btnY, contentW, btnH)];
            break;
        }
    }
    CGFloat contentH = self.btnSubmit.y+self.btnSubmit.height;
    [self.viewContent setFrame:CGRectMake(viewW/2-contentW/2, viewH/2-contentH/2, contentW, contentH)];
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
    [self dismiss];
}

-(void)setViewNil
{
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_viewLine1);
    OBJC_RELEASE(_viewLine2);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_onSubmitClick);
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
