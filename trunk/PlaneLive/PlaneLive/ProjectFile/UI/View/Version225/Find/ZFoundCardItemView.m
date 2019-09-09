//
//  ZFoundCardItemView.m
//  PlaneLive
//
//  Created by Daniel on 01/11/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZFoundCardItemView.h"
#import "ZImageView.h"
#import "ZLabel.h"
#import "ZView.h"
#import "ZLabel.h"
#import "ZButton.h"

@interface ZFoundCardItemView()

@property (strong, nonatomic) ZView *viewMain;
@property (strong, nonatomic) ZView *viewType;
@property (strong, nonatomic) ZImageView *imgType;
@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZView *viewContent;
@property (strong, nonatomic) ZLabel *lbPractice1;
@property (strong, nonatomic) ZLabel *lbPractice2;
@property (strong, nonatomic) ZLabel *lbPractice3;
@property (strong, nonatomic) ZView *viewPlay;
@property (strong, nonatomic) ZButton *btnPlay;
@property (strong, nonatomic) ModelPracticeType *model;
@property (strong, nonatomic) ZImageView *imagePlay;
@property (assign, nonatomic) BOOL isDowning;

@end

@implementation ZFoundCardItemView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
///创建控件
-(void)innerInitItem
{
    self.cvcW = [ZFoundCardItemView getW];
    self.cvcH = [ZFoundCardItemView getH];
    
    if (!self.viewMain) {
        self.viewMain = [[ZView alloc] init];
        [self.viewMain setBackgroundColor:WHITECOLOR];
        [self.viewMain setUserInteractionEnabled:true];
        [self.viewMain setAllShadowColorWithRadius:8];
        [self addSubview:self.viewMain];
        
        self.viewType = [[ZView alloc] init];
        [self.viewType setUserInteractionEnabled:false];
        [[self.viewType layer] setMasksToBounds:true];
        [self.viewType setBackgroundColor:COLORVIEWBACKCOLOR2];
        [self.viewType setViewRound:30 borderWidth:0 borderColor:CLEARCOLOR];
        [self.viewMain addSubview:self.viewType];
        
        self.imgType = [[ZImageView alloc] init];
        [self.imgType setUserInteractionEnabled:false];
        [self.viewType addSubview:self.imgType];
        
        self.lbTitle = [[UILabel alloc] init];
        [self.lbTitle setTextColor:COLORTEXT1];
        [self.lbTitle setFont:[ZFont systemFontOfSize:20]];
        [self.lbTitle setNumberOfLines:1];
        [self.lbTitle setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        [self.lbTitle setTextAlignment:(NSTextAlignmentCenter)];
        [self.viewMain addSubview:self.lbTitle];
        
        self.viewContent = [[UIView alloc] init];
        [self.viewContent setBackgroundColor:WHITECOLOR];
        [self addSubview:self.viewContent];
        
        self.lbPractice1 = [[UILabel alloc] init];
        [self.lbPractice1 setTextColor:COLORTEXT2];
        [self.lbPractice1 setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbPractice1 setNumberOfLines:1];
        [self.lbPractice1 setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        if (IsIPadDevice) {
            [self.lbPractice1 setTextAlignment:(NSTextAlignmentCenter)];
        } else {
            [self.lbPractice1 setTextAlignment:(NSTextAlignmentLeft)];
        }
        [self.viewContent addSubview:self.lbPractice1];
        
        self.lbPractice2 = [[UILabel alloc] init];
        [self.lbPractice2 setTextColor:COLORTEXT2];
        [self.lbPractice2 setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbPractice2 setNumberOfLines:1];
        [self.lbPractice2 setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        if (IsIPadDevice) {
            [self.lbPractice2 setTextAlignment:(NSTextAlignmentCenter)];
        } else {
            [self.lbPractice2 setTextAlignment:(NSTextAlignmentLeft)];
        }
        [self.viewContent addSubview:self.lbPractice2];
        
        self.lbPractice3 = [[UILabel alloc] init];
        [self.lbPractice3 setTextColor:COLORTEXT2];
        [self.lbPractice3 setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.lbPractice3 setNumberOfLines:1];
        [self.lbPractice3 setLineBreakMode:(NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail)];
        if (IsIPadDevice) {
            [self.lbPractice3 setTextAlignment:(NSTextAlignmentCenter)];
        } else {
            [self.lbPractice3 setTextAlignment:(NSTextAlignmentLeft)];
        }
        [self.viewContent addSubview:self.lbPractice3];
        
        self.btnPlay = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnPlay setTitle:@"立即播放" forState:(UIControlStateNormal)];
        [self.btnPlay setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
        [[self.btnPlay titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnPlay setBackgroundImage:[SkinManager getImageWithName:@"btn_gra3"] forState:(UIControlStateNormal)];
        [self.btnPlay setBackgroundImage:[SkinManager getImageWithName:@"btn_gra3"] forState:(UIControlStateHighlighted)];
        [self.btnPlay addTarget:self action:@selector(btnPlayerUpInside) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnPlay addTarget:self action:@selector(btnPlayerDown) forControlEvents:(UIControlEventTouchDown)];
        [self.btnPlay addTarget:self action:@selector(btnPlayerUpOutside) forControlEvents:(UIControlEventTouchUpOutside)];
        
        self.viewPlay = [[ZView alloc] init];
        [self.viewPlay setButtonShadowColorWithRadius:18];
        [self.viewMain addSubview:self.viewPlay];
        [self.viewPlay addSubview:self.btnPlay];
        
        self.imagePlay = [[ZImageView alloc] initWithImage:[SkinManager getImageWithName:@"play_ing"]];
        [self.imagePlay setUserInteractionEnabled:false];
        [self.btnPlay addSubview:self.imagePlay];
        [self.btnPlay setTitleEdgeInsets:(UIEdgeInsetsMake(0, 22, 0, 0))];
    }
    [self setViewChangeFrame];
}
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    [self setViewChangeFrame];
//}
///设置坐标
-(void)setViewChangeFrame
{
    [self.viewMain setFrame:(CGRectMake(0, 0, self.cvcW, self.cvcH))];
    CGFloat lbX = 30;
    if (APP_FRAME_WIDTH<375) {
        lbX = lbX*kViewSace;
    }
    CGFloat lbW = self.viewMain.width-lbX*2;
    CGFloat contentY = 0;
    if (IsIPhone4) {
        lbX = 20;
        lbW = self.viewMain.width-lbX*2;
        CGFloat imageSize = 50;
        CGFloat imageY = 20;
        CGFloat imgSize = 32;
        [self.viewType setFrame:(CGRectMake(lbX, imageY, imageSize, imageSize))];
        [self.imgType setFrame:(CGRectMake(self.viewType.width/2-imgSize/2, imageSize/2-imgSize/2, imgSize, imgSize))];
        [self.viewType setViewRound:imageSize/2 borderWidth:0 borderColor:CLEARCOLOR];
        
        CGFloat titleX = self.viewType.x+self.viewType.width+10;
        CGFloat titleW = self.viewMain.width-titleX-lbX;
        CGFloat titleY = imageY+imageSize/2-10;
        [self.lbTitle setFrame:(CGRectMake(titleX, titleY, titleW, 20))];
        [self.lbTitle setTextAlignment:(NSTextAlignmentLeft)];
        
        contentY = self.viewType.y+self.viewType.height+15;
    } else {
        CGFloat imageSize = 60;
        CGFloat imageY = 40*kViewSace;
        CGFloat imgSize = 32;
        [self.viewType setFrame:(CGRectMake(self.viewMain.width/2-imageSize/2, imageY, imageSize, imageSize))];
        [self.imgType setFrame:(CGRectMake(self.viewType.width/2-imgSize/2, imageSize/2-imgSize/2, imgSize, imgSize))];
        
        CGFloat titleY = self.viewType.y+self.viewType.height+20*kViewSace;
        [self.lbTitle setFrame:(CGRectMake(lbX, titleY, lbW, 20))];
        
        contentY = self.lbTitle.y+self.lbTitle.height+25*kViewSace;
    }
    CGFloat playH = 36;
    CGFloat playY = self.viewMain.height-playH-30*kViewSace;
    if (IsIPhone4) {
        playY = self.viewMain.height-playH-20;
    }
    CGFloat contentH = playY-contentY-10;
    [self.viewContent setFrame:(CGRectMake(0, contentY, self.viewMain.width, contentH))];
    
    CGFloat lbH = 18;
    [self.lbPractice1 setFrame:(CGRectMake(lbX, 0, lbW, lbH))];
    [self.lbPractice2 setFrame:(CGRectMake(lbX, self.lbPractice1.y+self.lbPractice1.height+8, lbW, lbH))];
    [self.lbPractice3 setFrame:(CGRectMake(lbX, self.lbPractice2.y+self.lbPractice2.height+8, lbW, lbH))];
    
    CGFloat playW = 120;
    [self.viewPlay setFrame:(CGRectMake(self.viewMain.width/2-playW/2, playY, playW, playH))];
    [self.btnPlay setFrame:self.viewPlay.bounds];
    [self.btnPlay.layer setMasksToBounds:YES];
    [self.btnPlay setViewRound:playH/2 borderWidth:0 borderColor:WHITECOLOR];
    [self.imagePlay setFrame:(CGRectMake(25, self.viewPlay.height/2-6, 12, 12))];
}
///设置数据对象
-(void)setViewDataWithModel:(ModelPracticeType *)model
{
    [self setModel:model];
    
    [self.imgType setImageURLStr:model.spe_img placeImage: [SkinManager getImageWithName:@"default_class"]];
    [self.lbTitle setText:model.type];
    
    [self.lbPractice1 setHidden:YES];
    [self.lbPractice2 setHidden:YES];
    [self.lbPractice3 setHidden:YES];
    if (model.arrPractice.count == 2) {
        ModelPractice *modelP1 = [model.arrPractice firstObject];
        ModelPractice *modelP2 = [model.arrPractice lastObject];
        if (modelP1) {
            [self.lbPractice1 setHidden:NO];
            [self.lbPractice1 setText:[NSString stringWithFormat:@"1.%@", modelP1.title]];
        }
        if (modelP2) {
            [self.lbPractice2 setHidden:NO];
            [self.lbPractice2 setText:[NSString stringWithFormat:@"2.%@", modelP2.title]];
        }
    } else if (model.arrPractice.count == 1) {
        ModelPractice *modelP = [model.arrPractice firstObject];
        if (modelP) {
            [self.lbPractice1 setHidden:NO];
            [self.lbPractice1 setText:[NSString stringWithFormat:@"1.%@", modelP.title]];
        }
    } else if (model.arrPractice.count >= 3) {
        ModelPractice *modelP1 = [model.arrPractice firstObject];
        ModelPractice *modelP2 = [model.arrPractice objectAtIndex:1];
        ModelPractice *modelP3 = [model.arrPractice lastObject];
        if (modelP1) {
            [self.lbPractice1 setHidden:NO];
            [self.lbPractice1 setText:[NSString stringWithFormat:@"1.%@", modelP1.title]];
        }
        if (modelP2) {
            [self.lbPractice2 setHidden:NO];
            [self.lbPractice2 setText:[NSString stringWithFormat:@"2.%@", modelP2.title]];
        }
        if (modelP3) {
            [self.lbPractice3 setHidden:NO];
            [self.lbPractice3 setText:[NSString stringWithFormat:@"3.%@", modelP3.title]];
        }
    }
    
    [self setViewChangeFrame];
}
-(void)btnPlayerUpInside
{
    if (self.isDowning) {
        [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            [self.btnPlay setFrame:self.viewPlay.bounds];
            [[self.btnPlay titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
            [self.btnPlay setViewRound:self.btnPlay.height/2 borderWidth:0 borderColor:CLEARCOLOR];
            [self.imagePlay setFrame:(CGRectMake(25, self.viewPlay.height/2-6, 12, 12))];
        } completion:^(BOOL finished) {
            self.isDowning = false;
            if (self.onStartPlayEvent) {
                self.onStartPlayEvent(self.model);
            }
        }];
    } else {
        if (self.onStartPlayEvent) {
            self.onStartPlayEvent(self.model);
        }
    }
}
-(void)btnPlayerUpOutside
{
    if (!self.isDowning) {
        return;
    }
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [self.btnPlay setFrame:self.viewPlay.bounds];
        [[self.btnPlay titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnPlay setViewRound:self.btnPlay.height/2 borderWidth:0 borderColor:CLEARCOLOR];
        [self.imagePlay setFrame:(CGRectMake(25, self.viewPlay.height/2-6, 12, 12))];
    } completion:^(BOOL finished) {
        self.isDowning = false;
    }];
}
-(void)btnPlayerDown
{
    self.isDowning = true;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        CGFloat itemX = (self.viewPlay.width - self.viewPlay.width*0.9)/2;
        CGFloat itemY = (self.viewPlay.height - self.viewPlay.height*0.9)/2;
        self.btnPlay.frame = CGRectMake(itemX, itemY, self.viewPlay.width*0.9, self.viewPlay.height*0.9);
        [[self.btnPlay titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size*0.9]];
        [self.btnPlay setViewRound:self.btnPlay.height/2 borderWidth:0 borderColor:CLEARCOLOR];
        CGFloat imageItemSize = 12*0.9;
        self.imagePlay.frame = CGRectMake(25*0.9, self.btnPlay.height/2-imageItemSize/2, imageItemSize, imageItemSize);
    } completion:^(BOOL finished) {
        
    }];
}
+(CGFloat)getW
{
    if (IsIPadDevice) {
        return APP_FRAME_WIDTH-200;
    }
    return 335*kViewSace;
}
+(CGFloat)getH
{
    CGFloat height = 350*kViewSace;
    if (IsIPadDevice) {
        return 610;
    } else {
        if (IsIPhone4) {
            height = 230;
        } else {
            CGFloat scale = [UIScreen mainScreen].scale;
            if (scale==3 && !IsIPadDevice) {
                height = height + 28;
            }
        }
    }
    return height;
}

@end
