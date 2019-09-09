//
//  ZShowLawFirmInfoView.m
//  PlaneLive
//
//  Created by WT on 21/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZShowLawFirmInfoView.h"
#import "ZButton.h"
#import "ClassCategory.h"
#import "ZScrollView.h"
#import "ZLabel.h"
#import "Utils.h"

@interface ZShowLawFirmInfoView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;

@end

@implementation ZShowLawFirmInfoView

-(id)initWithModel:(ModelLawFirm *)model
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self innerInitItem:model];
    }
    return self;
}
-(void)innerInitItem:(ModelLawFirm *)model
{
    self.contentH = 100;
    
    self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR5];
    [self.viewBack setAlpha:kBackgroundOpacity];
    [self addSubview:self.viewBack];
    
    self.contentFrame = CGRectMake(10, self.height, self.width-20, self.contentH);
    self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
    [[self.viewContent layer] setMasksToBounds:true];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    [self sendSubviewToBack:self.viewBack];
    
    CGFloat contentW = self.viewContent.width-44;
    CGFloat contentX = 22;
    ZLabel *lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(contentX, 17, contentW, 26))];
    [lbTitle setFont:[UIFont systemFontOfSize:kFont_Huge_Size]];
    [lbTitle setTextColor:COLORTEXT1];
    [lbTitle setNumberOfLines:1];
    [lbTitle setText:model.title];
    [lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail)];
    [lbTitle setTextAlignment:(NSTextAlignmentCenter)];
    [self.viewContent addSubview:lbTitle];
    
    CGRect scFrame = CGRectMake(contentX, lbTitle.y+lbTitle.height+20, contentW, 0);
    ZScrollView *scView = [[ZScrollView alloc] initWithFrame:(scFrame)];
    [scView setScrollsToTop:false];
    [scView setBounces:false];
    [self.viewContent addSubview:scView];
    
    CGRect lbContentFrame = CGRectMake(0, 0, contentW, 20);
    ZLabel *lbContent = [[ZLabel alloc] initWithFrame:(lbContentFrame)];
    [lbContent setFont:[UIFont systemFontOfSize:16]];
    [lbContent setTextColor:COLORTEXT2];
    [lbContent setTextAlignment:(NSTextAlignmentLeft)];
    [lbContent setNumberOfLines:0];
    [lbContent setText:model.desc];
    [scView addSubview:lbContent];
    
    lbContentFrame.size.height = [lbContent getLabelHeightWithMinHeight:0];
    lbContent.frame = lbContentFrame;
    CGRect newscFrame = scFrame;
    if (lbContent.height > 350) {
        newscFrame.size.height = 350;
    } else {
        newscFrame.size.height = lbContent.height;
    }
    scView.frame = newscFrame;
    scView.contentSize = CGSizeMake(scView.width, lbContent.height);
    
    CGFloat btnCloseH = 46;
    self.contentH = scView.y+scView.height+28+btnCloseH;
    self.contentFrame = CGRectMake(10, self.height, self.width-20, self.contentH);
    self.viewContent.frame = self.contentFrame;
    
    UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnClose setTitle:kClose forState:(UIControlStateNormal)];
    [btnClose setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [[btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    btnClose.userInteractionEnabled = true;
    btnClose.backgroundColor = CLEARCOLOR;
    btnClose.frame = CGRectMake(0, self.viewContent.height-btnCloseH, self.viewContent.width, btnCloseH);
    [self.viewContent addSubview:btnClose];
    
    UIImageView *imageLine = [UIImageView getDLineView];
    imageLine.frame = CGRectMake(10, btnClose.y, self.viewContent.width-20, kLineHeight);
    [self.viewContent addSubview:imageLine];
    
    UITapGestureRecognizer *viewBGTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTapGesture:)];
    [self.viewBack addGestureRecognizer:viewBGTapGesture];
}

-(void)btnCloseEvent
{
    [self dismiss];
}
-(void)viewBGTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}
///显示
-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.viewBack.alpha = 0;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewBack.alpha = kBackgroundOpacity;
        CGRect contentFrame = self.contentFrame;
        contentFrame.origin.y -= (self.contentH+10);
        self.viewContent.frame = contentFrame;
    } completion:^(BOOL finished) {
        
    }];
}
///隐藏
-(void)dismiss
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewContent.frame = self.contentFrame;
        self.viewBack.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
