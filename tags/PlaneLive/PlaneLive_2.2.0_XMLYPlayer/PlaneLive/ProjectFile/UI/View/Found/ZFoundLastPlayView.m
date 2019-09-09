//
//  ZFoundLastPlayView.m
//  PlaneLive
//
//  Created by Daniel on 12/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZFoundLastPlayView.h"
#import "ZLabel.h"
#import "ZImageView.h"
#import "ZButton.h"

@interface ZFoundLastPlayView()

@property (strong, nonatomic) ZLabel *lbTitle;

@property (strong, nonatomic) ZButton *imgPlay;

@property (strong, nonatomic) ZImageView *imgNext;

@property (strong, nonatomic) UIImageView *imgLine;

@property (strong, nonatomic) ModelAudio *model;

@end

@implementation ZFoundLastPlayView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(instancetype)initWithPoint:(CGPoint)point
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, APP_FRAME_WIDTH, kZFoundLastPlayViewHeight)];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [self setBackgroundColor:WHITECOLOR];
    
    [self setUserInteractionEnabled:YES];
    
    self.imgLine = [UIImageView getDLineView];
    [self.imgLine setFrame:CGRectMake(0, 0, self.width, kLineHeight/2)];
    [self addSubview:self.imgLine];
    
    self.lbTitle = [[ZLabel alloc] initWithFrame:CGRectMake(kSizeSpace+30, self.height/2-12.5, self.width-kSizeSpace*2-35, 25)];
    [self.lbTitle setTextColor:DESCCOLOR];
    [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [self.lbTitle setNumberOfLines:1];
    [self.lbTitle setUserInteractionEnabled:NO];
    [self.lbTitle setLineBreakMode:(NSLineBreakByTruncatingTail|NSLineBreakByWordWrapping)];
    [self addSubview:self.lbTitle];
    
    self.imgPlay = [[ZButton alloc] initWithFrame:CGRectMake(kSizeSpace, 10, 20, self.height-20)];
    [self.imgPlay setImage:[SkinManager getImageWithName:@"playing_icon"] forState:(UIControlStateNormal)];
    [self.imgPlay setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.imgPlay setTitle:nil forState:(UIControlStateNormal)];
    [self.imgPlay setUserInteractionEnabled:NO];
    NSMutableArray *arrImages = [NSMutableArray array];
    for (int i = 1; i < 51; i++) {
        [arrImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"playing_icon_%d",i]]];
    }
    self.imgPlay.imageView.animationImages = arrImages;
    [self.imgPlay.imageView setAnimationDuration:1.0f];
    [self.imgPlay.imageView setAnimationRepeatCount:0];
    [self.imgPlay.imageView setUserInteractionEnabled:NO];
    [self addSubview:self.imgPlay];
    
    self.imgNext = [[ZImageView alloc] initWithFrame:CGRectMake(self.width-kSizeSpace-10, self.height/2-15/2, 8, 15)];
    [self.imgNext setImage:[UIImage imageWithCGImage:[SkinManager getImageWithName:@"btn_wentixiangqing_"].CGImage scale:1 orientation:(UIImageOrientationRight)]];
    [self.imgNext setUserInteractionEnabled:NO];
    [self addSubview:self.imgNext];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self addGestureRecognizer:viewTap];
}
///设置按钮是否动画起来
-(void)setPlayButtonIsAnimation:(BOOL)isAnimation
{
    if (isAnimation) {
        [self.imgPlay.imageView startAnimating];
    } else {
        [self.imgPlay.imageView stopAnimating];
    }
}

-(void)viewTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.onLastPlayViewClick) {
            self.onLastPlayViewClick(self.model);
        }
    }
}

///设置数据源
-(void)setViewDataWithModel:(ModelAudio *)model
{
    [self setModel:model];
    
    [self.lbTitle setText:model.audioTitle];
}

-(void)dealloc
{
    OBJC_RELEASE(_imgLine);
    OBJC_RELEASE(_imgNext);
    OBJC_RELEASE(_imgPlay);
    OBJC_RELEASE(_lbTitle);
    OBJC_RELEASE(_onLastPlayViewClick);
}

@end
