//
//  ZHomeSubscribeTrailerView.m
//  PlaneLive
//
//  Created by Daniel on 21/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZHomeSubscribeTrailerView.h"
#import "ZScrollView.h"

@interface ZHomeSubscribeTrailerView()

@property (strong, nonatomic) UIView *viewBack;

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) UIImageView *imgHeader;

@property (strong, nonatomic) UILabel *lbTitle;

@property (strong, nonatomic) ZScrollView *svContent;

@property (strong, nonatomic) UILabel *lbContent;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) UIButton *btnCancel;

///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;

@end

@implementation ZHomeSubscribeTrailerView

///初始化对象
-(instancetype)initWithModel:(ModelSubscribe *)model
{
    self = [super initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT)];
    if (self) {
        [self innerInitWithModel:model];
    }
    return self;
}

-(void)innerInitWithModel:(ModelSubscribe *)model
{
    [self getBgView];
    
    CGFloat viewW = 280;
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, 0)];
    self.viewContent.clipsToBounds = YES;
    self.viewContent.backgroundColor = WHITECOLOR;
    [self.viewContent.layer setCornerRadius:5.0f];
    
    [self addSubview:self.viewContent];
    
    self.imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewContent.width, 100)];
    [self.imgHeader setImage:[SkinManager getImageWithName:@"home_subscribe_alert"]];
    [self.viewContent addSubview:self.imgHeader];
    
    CGFloat lbW = self.viewContent.width-kSizeSpace*2;
    CGRect titleFrame = CGRectMake(kSizeSpace, self.imgHeader.y+self.imgHeader.height+kSize5, lbW, 20);
    self.lbTitle = [[UILabel alloc] initWithFrame:titleFrame];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setTextColor:MAINCOLOR];
    [self.viewContent addSubview:self.lbTitle];
    
    [self.lbTitle setText:model.title];
    
    CGRect contentFrame = CGRectMake(kSizeSpace, self.lbTitle.y+self.lbTitle.height+kSize8, lbW, 20);
    self.svContent = [[ZScrollView alloc] initWithFrame:contentFrame];
    [self.svContent setUserInteractionEnabled:YES];
    [self.svContent setBackgroundColor:WHITECOLOR];
    [self.svContent setShowsHorizontalScrollIndicator:NO];
    [self.svContent setShowsVerticalScrollIndicator:NO];
    [self.svContent setScrollsToTop:NO];
    [self.viewContent addSubview:self.svContent];
    
    self.lbContent = [[UILabel alloc] initWithFrame:self.svContent.bounds];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Middle_Size]];
    [self.lbContent setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self.lbContent setNumberOfLines:0];
    [self.lbContent setTextColor:BLACKCOLOR];
    [self.svContent addSubview:self.lbContent];
    
    [self.lbContent setText:model.theme_intro];
    
    CGFloat contentH = [self.lbContent getLabelHeightWithMinHeight:20];
    [self.svContent setContentSize:CGSizeMake(contentFrame.size.width, contentH)];
    [self.lbContent setFrame:CGRectMake(0, 0, contentFrame.size.width, contentH)];
    if ((contentH+contentFrame.origin.y) > (self.height-140)) {
        contentH = self.height-140-contentFrame.origin.y;
        [self.svContent setScrollEnabled:YES];
    } else {
        [self.svContent setScrollEnabled:NO];
    }
    contentFrame.size.height = contentH;
    [self.svContent setFrame:contentFrame];
    
    [self getCancelBtn];
    
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setFrame:CGRectMake(0, self.svContent.y+self.svContent.height+kSize10, self.viewContent.width, kLineHeight)];
    [self.viewContent addSubview:self.imgLine];
    
    CGFloat btnY = self.imgLine.y+self.imgLine.height;
    [self.btnCancel setFrame:CGRectMake(0, btnY, self.viewContent.width, 40)];
    
    CGFloat viewH = self.btnCancel.y+self.btnCancel.height;
    CGRect viewFrame = CGRectMake(self.width/2-viewW/2, self.height/2-viewH/2, viewW, viewH);
    [self.viewContent setFrame:viewFrame];
    
    [self sendSubviewToBack:self.viewBack];
}

-(void)getBgView
{
    self.viewBack = [[UIView alloc] initWithFrame:self.bounds];
    [self.viewBack setBackgroundColor:BLACKCOLOR];
    [self.viewBack setAlpha:0.4f];
    [self addSubview:self.viewBack];
}
-(void)getCancelBtn
{
    self.btnCancel = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCancel setTitle:kIKnew forState:(UIControlStateNormal)];
    [self.btnCancel setTitleColor:MAINCOLOR forState:(UIControlStateNormal)];
    [[self.btnCancel titleLabel] setFont:[ZFont boldSystemFontOfSize:kFont_Middle_Size]];
    [self.viewContent addSubview:self.btnCancel];
}
-(void)btnCancelClick
{
    [self dismiss];
}
///显示
-(void)show
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [self setAlpha:0];
    [self setHidden:NO];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
    }];
}
///隐藏
-(void)dismiss
{
    if (self.isAnimateing || self.hidden) {return;}
    
    [self setIsAnimateing:YES];
    
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self setIsAnimateing:NO];
        [self setHidden:YES];
        [self setViewNil];
    }];
}
-(void)setViewNil
{
    OBJC_RELEASE(_viewBack);
    OBJC_RELEASE(_viewContent);
    OBJC_RELEASE(_btnCancel);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_lbContent);
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_imgHeader);
    OBJC_RELEASE(_svContent);
    [self removeFromSuperview];
}

@end
