//
//  ZQuestionPromptView.m
//  PlaneCircle
//
//  Created by Daniel on 8/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZQuestionPromptView.h"

@interface ZQuestionPromptView()

///背景
@property (strong, nonatomic) UIView *viewBG;
///内容
@property (strong, nonatomic) UIView *viewContent;
///图标
@property (strong, nonatomic) UIImageView *imgIcon;
///下一步
@property (strong, nonatomic) UIImageView *imgNext;
///知道了
@property (strong, nonatomic) UIButton *btnKNow;
///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;
///内容坐标
@property (assign, nonatomic) CGRect contentFrame;

@end

@implementation ZQuestionPromptView

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
    
    self.imgIcon = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"image_question_prompt"]];
    [self.imgIcon setUserInteractionEnabled:NO];
    [self.viewContent addSubview:self.imgIcon];
    
    self.imgNext = [[UIImageView alloc] initWithImage:[SkinManager getImageWithName:@"image_question_prompt_next"]];
    [self.imgNext setUserInteractionEnabled:YES];
    [self.viewContent addSubview:self.imgNext];
    
    UITapGestureRecognizer *imgClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)];
    [self.imgNext addGestureRecognizer:imgClick];
    
    self.btnKNow = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnKNow setImage:[SkinManager getImageWithName:@"btn_question_prompt"] forState:(UIControlStateNormal)];
    [self.btnKNow setImage:[SkinManager getImageWithName:@"btn_question_prompt"] forState:(UIControlStateHighlighted)];
    [self.btnKNow setImageEdgeInsets:(UIEdgeInsetsMake(2, 2, 2, 2))];
    [self.btnKNow addTarget:self action:@selector(btnKNowClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewContent addSubview:self.btnKNow];
    
    [self.viewContent sendSubviewToBack:self.imgIcon];
    
    [self.viewBG setFrame:self.bounds];
    [self.viewContent setFrame:self.bounds];
    
    CGFloat imgW = 614/2;
    CGFloat imgH = 773/2;
    if (IsIPadDevice) {
        CGFloat scale = (self.width-60*2)/imgW;
        CGFloat rightW = 25*scale;
        imgH = imgH*scale-30*scale;
        imgW = imgW*scale;
        [self.imgIcon setFrame:CGRectMake(60+rightW/2, 50, imgW, imgH)];
    } else {
        CGFloat scale = (self.width-30*2)/imgW;
        CGFloat rightW = 25*scale;
        imgH = imgH*scale-30*scale;
        imgW = imgW*scale;
        [self.imgIcon setFrame:CGRectMake(30+rightW/2, 50, imgW, imgH)];
    }
    [self.imgNext setFrame:CGRectMake(self.width-65, 25, 65, 35)];
    
    CGFloat btnW = 120;//194/2;
    CGFloat btnH = 45;//63/2;
    CGFloat btnX = self.width/2-btnW/2;
    CGFloat btnY = self.imgIcon.y+self.imgIcon.height+30;
    [self.btnKNow setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
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
    [self.viewContent setBackgroundColor:CLEARCOLOR];
    [self.viewContent setHidden:YES];
    [[self.viewContent layer] setMasksToBounds:YES];
    [self.viewContent setAlpha:1.0f];
    [self addSubview:self.viewContent];
    
    [self sendSubviewToBack:self.viewBG];
}

-(void)imgClick:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onButtonClick) {
            self.onButtonClick();
        }
        [self dismiss];
    }
}

-(void)btnKNowClick
{
    if (self.onButtonClick) {
        self.onButtonClick();
    }
    [self dismiss];
}

-(void)setViewNil
{
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_viewBG);
    OBJC_RELEASE(_imgIcon);
    OBJC_RELEASE(_btnKNow);
    OBJC_RELEASE(_onButtonClick);
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
        [self.viewBG setAlpha:0.55f];
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
