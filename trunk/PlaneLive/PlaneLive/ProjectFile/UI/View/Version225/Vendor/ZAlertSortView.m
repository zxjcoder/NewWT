//
//  ZAlertSortView.m
//  PlaneLive
//
//  Created by Daniel on 26/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertSortView.h"

@interface ZAlertSortView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContentShadow;
@property (strong, nonatomic) ZView *viewContent;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;
@property (assign, nonatomic) CGFloat contentW;

@end

@implementation ZAlertSortView

-(id)init
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    self.contentH = 186;
    self.contentW = 130;
    
    self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR5];
    [self.viewBack setAlpha:0.1];
    [self addSubview:self.viewBack];
    
    self.contentFrame = CGRectMake(0, 0, self.contentW, self.contentH);
    self.viewContentShadow = [[ZView alloc] initWithFrame:self.contentFrame];
    [self.viewContentShadow.layer setShadowColor:RGBCOLORA(121, 140, 163, 0.2).CGColor];
    [self.viewContentShadow.layer setShadowOffset:(CGSizeMake(0, 0))];
    [self.viewContentShadow.layer setShadowRadius:10];
    [self.viewContentShadow.layer setShadowOpacity:0.2];
    [self addSubview:self.viewContentShadow];
    
    self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
    [self.viewContent setViewRound:8];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContentShadow addSubview:self.viewContent];
    
    [self sendSubviewToBack:self.viewBack];
   
    CGFloat btnW = 130;
    CGFloat btnH = 54;
    CGFloat btnY = 12;
    for (NSInteger i = 0; i < 3; i++) {
        
        UIButton *btnItem = [[UIButton alloc] initWithFrame:(CGRectMake(0, btnY, btnW, btnH))];
        [btnItem setTag:i];
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewContent addSubview:btnItem];
        
        ZImageView *imageView = [[ZImageView alloc] initWithFrame:(CGRectMake(37, 18, 18, 18))];
        imageView.userInteractionEnabled = false;
        [btnItem addSubview:imageView];
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(imageView.x+imageView.width+9, 17, 45, 20))];
        [lbTitle setTextColor:COLORTEXT2];
        [lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [lbTitle setTextAlignment:(NSTextAlignmentLeft)];
        [lbTitle setUserInteractionEnabled:false];
        [btnItem addSubview:lbTitle];
        
        switch (i) {
            case ZPracticeTypeSortNew:
                lbTitle.text = kNewest;
                imageView.image = [SkinManager getImageWithName:@"new"];
                break;
            case ZPracticeTypeSortHot:
                lbTitle.text = kHot;
                imageView.image = [SkinManager getImageWithName:@"hot"];
                break;
            default:
                lbTitle.text = kRecommend;
                imageView.image = [SkinManager getImageWithName:@"recomend1"];
                break;
        }
        btnY = btnY+btnH;
    }
    UITapGestureRecognizer *viewBGTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTapGesture:)];
    [self.viewBack addGestureRecognizer:viewBGTapGesture];
}
-(void)btnItemClick:(UIButton*)sender
{
    if (self.onSortClick) {
        self.onSortClick(sender.tag);
    }
    [self dismiss];
}
-(void)viewBGTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}
///显示
-(void)show:(CGPoint)point
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.contentFrame = CGRectMake(point.x, point.y, self.contentW, self.contentH);
    self.viewContentShadow.frame = self.contentFrame;
    self.viewContentShadow.alpha = 0;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewContentShadow.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
///隐藏
-(void)dismiss
{
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        self.viewContentShadow.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
