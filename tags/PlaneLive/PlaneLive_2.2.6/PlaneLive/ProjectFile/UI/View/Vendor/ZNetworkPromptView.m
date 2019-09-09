//
//  ZNetworkPromptView.m
//  PlaneCircle
//
//  Created by Daniel on 8/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZNetworkPromptView.h"

@interface ZNetworkPromptView()

@property (strong, nonatomic) UIView *viewContent;

@property (strong, nonatomic) UILabel *lbContent;

///是否在动画
@property (assign, nonatomic) BOOL isAnimateing;

@end

static ZNetworkPromptView *networkPromptView;

@implementation ZNetworkPromptView

+(ZNetworkPromptView *)shareNetworkPromptView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkPromptView = [[ZNetworkPromptView alloc] initWithFrame:CGRectMake(0, APP_TOP_HEIGHT, APP_FRAME_WIDTH, 45)];
        
        [networkPromptView setHidden:YES];
        [networkPromptView setAlpha:0.0f];
        
        [networkPromptView setUserInteractionEnabled:NO];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:networkPromptView];
    });
    return networkPromptView;
}

-(id)init
{
    self = [super init];
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
    [self setBackgroundColor:CLEARCOLOR];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self createContentView];
    [self createContentLabel];
}

-(void)createContentView
{
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_FRAME_WIDTH, 45)];
    [self.viewContent setBackgroundColor:MAINCOLOR];
    [self.viewContent setUserInteractionEnabled:NO];
    [self addSubview:self.viewContent];
}

-(void)createContentLabel
{
    self.lbContent = [[UILabel alloc] initWithFrame:CGRectMake(kSize15, self.viewContent.height/2-25/2, APP_FRAME_WIDTH, 25)];
    [self.lbContent setText:kTheCurrentNetworkIsNotAvailable];
    [self.lbContent setTextColor:WHITECOLOR];
    [self.lbContent setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbContent setNumberOfLines:1];
    [self.lbContent setUserInteractionEnabled:NO];
    [self.viewContent addSubview:self.lbContent];
}

///显示
-(void)show
{
    if (self.isAnimateing) {return;}
    [self setIsAnimateing:YES];
    [self setAlpha:0];
    [self setHidden:NO];
    
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
    }];
}

@end
