//
//  ZAlertPhotoView.m
//  PlaneLive
//
//  Created by Daniel on 09/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZAlertPhotoView.h"

@interface ZAlertPhotoView()

@property (strong, nonatomic) ZView *viewBack;
@property (strong, nonatomic) ZView *viewContent;
@property (assign, nonatomic) CGRect contentFrame;
@property (assign, nonatomic) CGFloat contentH;

@end

@implementation ZAlertPhotoView

-(id)init
{
    self = [super initWithFrame:(CGRectMake(0, 0, APP_FRAME_WIDTH, APP_FRAME_HEIGHT))];
    if (self) {
        [self innerInit];
    }
    return self;
}
-(void)innerInit
{
    self.contentH = 148;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.viewBack = [[ZView alloc] initWithFrame:self.bounds];
    [self.viewBack setBackgroundColor:COLORVIEWBACKCOLOR3];
    [self.viewBack setAlpha:kBackgroundOpacity];
    [self addSubview:self.viewBack];
    
    self.contentFrame = CGRectMake(10, self.height, self.width-20, self.contentH+20);
    self.viewContent = [[ZView alloc] initWithFrame:self.contentFrame];
    [[self.viewContent layer] setMasksToBounds:true];
    [self.viewContent setBackgroundColor:WHITECOLOR];
    [self.viewContent setViewRound:8 borderWidth:0 borderColor:CLEARCOLOR];
    [self addSubview:self.viewContent];
    [self sendSubviewToBack:self.viewBack];
    
    CGFloat btnCloseH = 36;
    CGFloat btnW = 55;
    CGFloat btnH = 67;
    CGFloat btnY = 25;
    CGFloat imageSize = 40;
    CGFloat itemSpace = (self.viewContent.width-btnW*2)/3;
    for (NSInteger i = 0; i < 2; i++) {
        CGFloat itemX = itemSpace*(i+1)+btnW*i;
        UIButton *btnItem = [[UIButton alloc] initWithFrame:(CGRectMake(itemX, btnY, btnW, btnH))];
        [btnItem setTag:i];
        [btnItem addTarget:self action:@selector(btnItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.viewContent addSubview:btnItem];
        
        ZImageView *imageView = [[ZImageView alloc] initWithFrame:(CGRectMake(btnW/2-imageSize/2, 5, imageSize, imageSize))];
        imageView.userInteractionEnabled = false;
        [btnItem addSubview:imageView];
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:(CGRectMake(0, btnItem.height-20, btnItem.width, 20))];
        [lbTitle setTextColor:COLORTEXT2];
        [lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        [lbTitle setUserInteractionEnabled:false];
        [btnItem addSubview:lbTitle];
        
        switch (i) {
            case 1:
                lbTitle.text = kCPhotograph;
                imageView.image = [SkinManager getImageWithName:@"photo"];
                break;
            default:
                lbTitle.text = kCAlbum;
                imageView.image = [SkinManager getImageWithName:@"album"];
                break;
        }
    }
    
    UIButton *btnClose = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnClose setTitle:kCancel forState:(UIControlStateNormal)];
    [btnClose setTitleColor:COLORTEXT3 forState:(UIControlStateNormal)];
    [[btnClose titleLabel] setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [btnClose addTarget:self action:@selector(btnCloseEvent) forControlEvents:(UIControlEventTouchUpInside)];
    btnClose.userInteractionEnabled = true;
    btnClose.backgroundColor = CLEARCOLOR;
    btnClose.frame = CGRectMake(0, self.viewContent.height-20-36, self.viewContent.width, 36);
    [self.viewContent addSubview:btnClose];
    
    UIImageView *imageLine = [UIImageView getDLineView];
    imageLine.frame = CGRectMake(20, btnClose.y, self.viewContent.width-40, kLineHeight);
    [self.viewContent addSubview:imageLine];
    
    UITapGestureRecognizer *viewBGTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBGTapGesture:)];
    [self.viewBack addGestureRecognizer:viewBGTapGesture];
}
-(void)btnItemClick:(UIButton*)sender
{
    if (self.onButtonClick) {
        self.onButtonClick(sender.tag);
    }
    [self dismiss];
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
        contentFrame.origin.y -= self.contentH;
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
