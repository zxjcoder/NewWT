//
//  ZPurchaseBindAccountTVC.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZPurchaseBindAccountTVC.h"
#import "ZShadowButtonView.h"

@interface ZPurchaseBindAccountTVC()

@end

@implementation ZPurchaseBindAccountTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInitItem];
    }
    return self;
}

-(void)innerInitItem
{
    [super innerInit];
    
    self.cellH = [ZPurchaseBindAccountTVC getH];
    self.space = 20;
    CGFloat contentH = 74;
    CGFloat contentW = self.cellW - self.space * 2;
   
    UIView *viewContent = [[UIView alloc] initWithFrame:(CGRectMake(self.space, 15, contentW, contentH))];
    //[viewContent setAllShadowColorWithRadius:kVIEW_ROUND_SIZE];
    [viewContent setBackgroundColor:COLORVIEWBACKCOLOR3];
    [viewContent setViewRound:16 borderWidth:0 borderColor:CLEARCOLOR];
    [viewContent setUserInteractionEnabled:true];
    [self.viewMain addSubview:viewContent];
    
    CGFloat btnW = 60;
    CGFloat btnX = contentW-btnW-20;
    CGFloat lbW = btnX-22;
    ZLabel *lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(20, 17, lbW, 22))];
    [lbTitle setText:@"绑定手机号"];
    [lbTitle setTextColor:COLORTEXT1];
    [lbTitle setFont:[ZFont systemFontOfSize:kFont_Default_Size]];
    [viewContent addSubview:lbTitle];
    
    ZLabel *lbDesc = [[ZLabel alloc] initWithFrame:(CGRectMake(20, contentH-18-17, lbW, 18))];
    [lbDesc setText:@"合并账号已购课程及余额~"];
    [lbDesc setTextColor:COLORTEXT3];
    [lbDesc setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [viewContent addSubview:lbDesc];
    
    CGFloat btnH = 30;
    ZShadowButtonView *btnBind = [[ZShadowButtonView alloc] initWithFrame:(CGRectMake(btnX, contentH/2-btnH/2, btnW, btnH))];
    [btnBind setButtonTitle:@"绑定"];
    ZWEAKSELF
    [btnBind setOnButtonClick:^{
        [weakSelf btnBindClick];
    }];
    [viewContent addSubview:btnBind];
    
//    [btnBind setTitle:kBind forState:(UIControlStateNormal)];
//    [btnBind setTitleColor:COLORCONTENT1 forState:(UIControlStateNormal)];
//    [[btnBind titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
//    [btnBind setBackgroundImage:[SkinManager getImageWithName:@"btn_line_gra1"] forState:(UIControlStateNormal)];
//    [btnBind setBackgroundImage:[SkinManager getImageWithName:@"btn_line_gra1_c"] forState:(UIControlStateHighlighted)];
//    [btnBind setFrame:(CGRectMake(btnX, contentH/2-btnH/2, btnW, btnH))];
//    [btnBind addTarget:self action:@selector(btnBindClick) forControlEvents:(UIControlEventTouchUpInside)];
//    [btnBind setUserInteractionEnabled:true];
//    [viewContent addSubview:btnBind];
    
    [self.viewMain setFrame:(CGRectMake(0, 0, self.cellW, self.cellH))];
}
-(void)btnBindClick
{
    if (self.onBindEvent) {
        self.onBindEvent();
    }
}
+(CGFloat)getH
{
    return 104;
}

@end
