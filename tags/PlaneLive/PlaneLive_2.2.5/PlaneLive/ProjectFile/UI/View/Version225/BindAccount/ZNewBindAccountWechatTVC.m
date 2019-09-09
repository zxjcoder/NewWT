//
//  ZNewBindAccountWechatTVC.m
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZNewBindAccountWechatTVC.h"

@interface ZNewBindAccountWechatTVC()

@property (strong, nonatomic) ZLabel *lbTitle;
@property (strong, nonatomic) ZLabel *lbAccountType;
@property (strong, nonatomic) ZLabel *lbAccountTypeDesc;
@property (strong, nonatomic) ZImageView *imageIcon;

@property (strong, nonatomic) ZButton *btnBind;
@property (strong, nonatomic) ModelUser *model;

@end

@implementation ZNewBindAccountWechatTVC

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
    
    self.cellH = [ZNewBindAccountWechatTVC getH];
    self.space = 20;
    for (UIView *view in self.viewMain.subviews) {
        [view removeFromSuperview];
    }
    if (!self.lbTitle) {
        self.lbTitle = [[ZLabel alloc] initWithFrame:(CGRectMake(self.space, 13, 280, self.lbMinH))];
        [self.lbTitle setTextColor:COLORTEXT2];
        [self.lbTitle setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.viewMain addSubview:self.lbTitle];
    }
    if (!self.imageIcon) {
        self.imageIcon = [[ZImageView alloc] initWithFrame:(CGRectMake(self.space, self.lbTitle.y+self.lbTitle.height+18, 24, 24))];
        [self.viewMain addSubview:self.imageIcon];
    }
    CGFloat lbX = self.imageIcon.x+self.imageIcon.width+10;
    if (!self.lbAccountType) {
        self.lbAccountType = [[ZLabel alloc] initWithFrame:(CGRectMake(lbX, self.imageIcon.y-5, 85, self.lbMinH))];
        [self.lbAccountType setTextColor:COLORTEXT1];
        [self.lbAccountType setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.viewMain addSubview:self.lbAccountType];
    }
    if (!self.lbAccountTypeDesc) {
        self.lbAccountTypeDesc = [[ZLabel alloc] initWithFrame:(CGRectMake(lbX, self.lbAccountType.y+self.lbAccountType.height, 280, self.lbMinH))];
        [self.lbAccountTypeDesc setTextColor:COLORTEXT3];
        [self.lbAccountTypeDesc setFont:[ZFont systemFontOfSize:kFont_Min_Size]];
        [self.viewMain addSubview:self.lbAccountTypeDesc];
    }
    if (!self.btnBind) {
        self.btnBind = [ZButton buttonWithType:(UIButtonTypeCustom)];
        [self.btnBind setTitle:kBind forState:(UIControlStateNormal)];
        [self.btnBind setTitle:@"已绑定" forState:(UIControlStateSelected)];
        [self.btnBind setTitleColor:COLORCONTENT1 forState:(UIControlStateNormal)];
        [self.btnBind setTitleColor:COLORTEXT3 forState:(UIControlStateSelected)];
        [[self.btnBind titleLabel] setFont:[ZFont systemFontOfSize:kFont_Small_Size]];
        [self.btnBind addTarget:self action:@selector(btnBindClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnBind setUserInteractionEnabled:true];
        [self.viewMain addSubview:self.btnBind];
    }
}
-(void)btnBindClick
{
    if (self.onBindClick) {
        self.onBindClick(self.model);
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.btnBind setFrame:(CGRectMake(self.cellW-self.space-60, self.imageIcon.y-2, 60, 28))];
}
-(CGFloat)setCellDataWithModel:(ModelUser *)model
{
    self.model = model;
    [self.lbTitle setText:@"可绑定其他账号直接登录"];
    switch (model.loginType) {
        case WTAccountTypeWeChat:
            self.imageIcon.image = [SkinManager getImageWithName:@"phone"];
            if (model.phone.length > 0) {
                self.btnBind.selected = true;
                [self.btnBind setBackgroundImage:nil forState:(UIControlStateNormal)];
                self.lbAccountTypeDesc.text = model.phone;
            } else {
                self.btnBind.selected = false;
                [self.btnBind setBackgroundImage:[SkinManager getImageWithName:@"btn_line_gra1"] forState:(UIControlStateNormal)];
                self.lbAccountTypeDesc.text = @"绑定后,将合并账号已购课程及余额";
            }
            self.lbAccountType.text = @"手机号";
            break;
        default:
            self.imageIcon.image = [SkinManager getImageWithName:@"weixin_a"];
            if (model.wechat_id.length > 0) {
                self.btnBind.selected = true;
                [self.btnBind setBackgroundImage:nil forState:(UIControlStateNormal)];
                self.lbAccountTypeDesc.text = model.nickname;
            } else {
                self.btnBind.selected = false;
                [self.btnBind setBackgroundImage:[SkinManager getImageWithName:@"btn_line_gra1"] forState:(UIControlStateNormal)];
                self.lbAccountTypeDesc.text = @"绑定后,将合并账号已购课程及余额";
            }
            self.lbAccountType.text = @"微信";
            break;
    }
    return self.cellH;
}
-(void)setViewNil
{
    [super setViewNil];
}

-(void)dealloc
{
    [self setViewNil];
}

+(CGFloat)getH
{
    return 100;
}

@end
