//
//  ZShadowButtonView.m
//  PlaneLive
//
//  Created by WT on 20/03/2018.
//  Copyright © 2018 WT. All rights reserved.
//

#import "ZShadowButtonView.h"
#import "ZButton.h"

@interface ZShadowButtonView()

@property (strong, nonatomic) ZButton *btnItem;
@property (assign, nonatomic) BOOL isDowning;

@end

@implementation ZShadowButtonView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        [self innerInitItem];
    }
    return self;
}
-(void)innerInitItem
{
    [self setButtonShadowColorWithRadius:self.height/2];
    
    self.btnItem = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [self.btnItem setFrame:self.bounds];
    [self.btnItem setBackgroundImage:[SkinManager getImageWithName:@"btn_gra3"] forState:(UIControlStateNormal)];
    [self.btnItem setBackgroundImage:[SkinManager getImageWithName:@"btn_gra3"] forState:(UIControlStateHighlighted)];
    [self.btnItem setTitleColor:WHITECOLOR forState:(UIControlStateNormal)];
    [[self.btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [[self.btnItem layer] setMasksToBounds:true];
    [self.btnItem setTitle:kDetermine forState:(UIControlStateNormal)];
    [self.btnItem setTitle:kDetermine forState:(UIControlStateHighlighted)];
    [self.btnItem setViewRound:self.height/2 borderWidth:0 borderColor:CLEARCOLOR];
    [self.btnItem addTarget:self action:@selector(btnItemUpInside) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btnItem addTarget:self action:@selector(btnItemDown) forControlEvents:(UIControlEventTouchDown)];
    [self.btnItem addTarget:self action:@selector(btnItemUpOutside) forControlEvents:(UIControlEventTouchUpOutside)];
    [self addSubview:self.btnItem];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.btnItem setFrame:self.bounds];
    [self setButtonShadowColorWithRadius:self.height/2];
    [self.btnItem setViewRound:self.height/2 borderWidth:0 borderColor:CLEARCOLOR];
}
-(void)btnItemUpInside
{
    if (self.isDowning) {
        [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            [self.btnItem setFrame:self.bounds];
            [[self.btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
            [self.btnItem setViewRound:self.btnItem.height/2 borderWidth:0 borderColor:CLEARCOLOR];
        } completion:^(BOOL finished) {
            self.isDowning = false;
            if (self.onButtonClick) {
                self.onButtonClick();
            }
        }];
    } else {
        if (self.onButtonClick) {
            self.onButtonClick();
        }
    }
}
-(void)btnItemUpOutside
{
    if (!self.isDowning) {
        return;
    }
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        [self.btnItem setFrame:self.bounds];
        [[self.btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnItem setViewRound:self.btnItem.height/2 borderWidth:0 borderColor:CLEARCOLOR];
    } completion:^(BOOL finished) {
        self.isDowning = false;
    }];
}
-(void)btnItemDown
{
    self.isDowning = true;
    [UIView animateWithDuration:kANIMATION_TIME delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        CGFloat itemX = (self.width - self.width*0.9)/2;
        CGFloat itemY = (self.height - self.height*0.9)/2;
        self.btnItem.frame = CGRectMake(itemX, itemY, self.width*0.9, self.height*0.9);
        [[self.btnItem titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size*0.9]];
        [self.btnItem setViewRound:self.btnItem.height/2 borderWidth:0 borderColor:CLEARCOLOR];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)setButtonBGImage:(NSString *)imageName
{
    [self.btnItem setBackgroundImage:[SkinManager getImageWithName:imageName] forState:(UIControlStateNormal)];
    [self.btnItem setBackgroundImage:[SkinManager getImageWithName:imageName] forState:(UIControlStateHighlighted)];
    if ([imageName isEqualToString:@"btn_gra3"]) {
        [self setButtonShadowColorWithRadius:self.height/2];
    } else {
        [self setButtonShadowColorWithRadius:self.height/2 color:RGBCOLORA(249, 153, 118, 0.2)];
    }
}
-(void)setButtonTitle:(NSString *)title
{
    [self.btnItem setTitle:title forState:(UIControlStateNormal)];
    [self.btnItem setTitle:title forState:(UIControlStateHighlighted)];
}

@end
