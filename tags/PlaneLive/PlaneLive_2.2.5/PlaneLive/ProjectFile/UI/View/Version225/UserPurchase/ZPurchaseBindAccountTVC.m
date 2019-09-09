//
//  ZPurchaseBindAccountTVC.m
//  PlaneLive
//
//  Created by Daniel on 23/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZPurchaseBindAccountTVC.h"

@interface ZPurchaseBindAccountTVC()

@end

@implementation ZPurchaseBindAccountTVC

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(void)innerInit
{
    [super innerInit];
    
    self.cellH = [ZPurchaseBindAccountTVC getH];
    self.space = 20;
    CGFloat contentH = 90;
    CGFloat contentW = self.cellW - self.space * 2;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    UIView *viewContent = [[UIView alloc] initWithFrame:(CGRectMake(self.space, self.space, contentW, contentH))];
    [viewContent setAllShadowColorWithRadius:kVIEW_ROUND_SIZE];
    [viewContent setUserInteractionEnabled:true];
    [self.viewMain addSubview:viewContent];
    
    CGFloat btnW = 60;
    CGFloat btnX = contentW-btnW-20;
    CGFloat lbW = btnX-22;
    ZLabel *lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(20, 20, lbW, self.lbH))];
    [lbTitle setText:@"绑定手机号"];
    [lbTitle setTextColor:COLORTEXT1];
    [lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [viewContent addSubview:lbTitle];
    
    ZLabel *lbDesc = [[ZLabel alloc] initWithFrame:(CGRectMake(20, lbTitle.y+lbTitle.height+3, lbW, self.lbMinH))];
    [lbDesc setText:@"绑定手机号,才能看到自己有的课程哦~"];
    [lbDesc setTextColor:COLORTEXT3];
    [lbDesc setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
    [viewContent addSubview:lbDesc];
    
    CGFloat btnH = 30;
    ZButton *btnBind = [ZButton buttonWithType:(UIButtonTypeCustom)];
    [btnBind setTitle:kBind forState:(UIControlStateNormal)];
    [btnBind setTitleColor:COLORCONTENT1 forState:(UIControlStateNormal)];
    [[btnBind titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
    [btnBind setBackgroundImage:[SkinManager getImageWithName:@"btn_line_gra1"] forState:(UIControlStateNormal)];
    [btnBind setBackgroundImage:[SkinManager getImageWithName:@"btn_line_gra1_c"] forState:(UIControlStateHighlighted)];
    [btnBind setFrame:(CGRectMake(btnX, contentH/2-btnH/2, btnW, btnH))];
    [btnBind addTarget:self action:@selector(btnBindClick) forControlEvents:(UIControlEventTouchUpInside)];
    [btnBind setUserInteractionEnabled:true];
    [viewContent addSubview:btnBind];
    
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
    return 150;
}

@end
